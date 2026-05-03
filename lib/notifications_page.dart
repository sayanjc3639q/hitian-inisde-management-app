import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'user_service.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  List<String> _getUserGroupIds(Map<String, dynamic> userData) {
    List<String> ids = ['Common'];
    
    if (userData['domain'] != null) {
      ids.add(userData['domain'].toString().replaceAll('/', '_'));
    }
    
    if (userData['batch'] != null) {
      try {
        int batch = userData['batch'] is int ? userData['batch'] : int.parse(userData['batch'].toString());
        final now = DateTime.now();
        final academicYear = now.month >= 8 ? now.year : now.year - 1;
        int year = academicYear - batch + 1;
        
        if (year >= 1 && year <= 4) {
          ids.add('Year $year');
          if (year <= 2) ids.add('Combined 1+2');
          if (year <= 3) ids.add('Combined 1+2+3');
          ids.add('Combined All');
        }
      } catch (e) {
        debugPrint('Error parsing batch: $e');
      }
    }
    return ids;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Clear All',
              style: GoogleFonts.outfit(color: const Color(0xFF4A0404), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: user == null 
        ? const Center(child: Text('Please log in'))
        : ValueListenableBuilder<Map<String, dynamic>?>(
            valueListenable: UserService().userDataNotifier,
            builder: (context, userData, _) {
              if (userData == null) return const Center(child: CircularProgressIndicator());
              
              final groupIds = _getUserGroupIds(userData);
              
              // Prepare streams
              List<Stream<QuerySnapshot>> streams = [];
              
              // 1. Tasks assigned to user
              streams.add(FirebaseFirestore.instance.collectionGroup('messages')
                  .where('type', isEqualTo: 'task')
                  .where('assigneeId', isEqualTo: user.uid)
                  .where('status', isEqualTo: 'Pending')
                  .snapshots());
                  
              // 2. Polls and Meetings in user's groups
              // Note: For now we only query the first 3 groups to avoid too many listeners
              // In a production app, we'd use a single collectionGroup query with groupId filters
              for (var gid in groupIds.take(5)) {
                streams.add(FirebaseFirestore.instance
                    .collection('groups')
                    .doc(gid)
                    .collection('messages')
                    .where('type', whereIn: ['poll', 'meeting'])
                    .orderBy('timestamp', descending: true)
                    .limit(5)
                    .snapshots());
              }

              return MultiStreamBuilder(
                streams: streams,
                builder: (context, snapshots) {
                  List<QueryDocumentSnapshot> allItems = [];
                  for (var snap in snapshots) {
                    if (snap.hasData) {
                      allItems.addAll(snap.data!.docs);
                    }
                  }
                  
                  // Sort all by timestamp
                  allItems.sort((a, b) {
                    final tA = (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
                    final tB = (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
                    return (tB?.millisecondsSinceEpoch ?? 0).compareTo(tA?.millisecondsSinceEpoch ?? 0);
                  });

                  // Static announcements
                  final staticAnnouncements = [
                    {
                      'title': 'Welcome to HITian INSIDE',
                      'message': 'Explore domain groups, pitch your ideas, and collaborate with your team efficiently.',
                      'time': DateTime.now().subtract(const Duration(hours: 5)),
                      'icon': Icons.campaign_outlined,
                      'color': const Color(0xFF4A0404),
                    },
                    {
                      'title': 'System Update',
                      'message': 'We\'ve added a new "My Activity" section to your profile. Track your contributions now!',
                      'time': DateTime.now().subtract(const Duration(days: 1)),
                      'icon': Icons.info_outline,
                      'color': Colors.blue,
                    }
                  ];

                  if (allItems.isEmpty) {
                    return ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        _buildSectionHeader('System Announcements'),
                        ...staticAnnouncements.map((a) => _buildNotificationCard(
                          icon: a['icon'] as IconData,
                          color: a['color'] as Color,
                          title: a['title'] as String,
                          message: a['message'] as String,
                          time: a['time'] as DateTime,
                        )),
                        const SizedBox(height: 32),
                        Center(
                          child: Text(
                            'No new notifications for your groups.',
                            style: GoogleFonts.outfit(color: Colors.grey[400], fontSize: 14),
                          ),
                        ),
                      ],
                    );
                  }

                  // Separate into categories for display
                  final tasks = allItems.where((d) => (d.data() as Map)['type'] == 'task').toList();
                  final meetings = allItems.where((d) => (d.data() as Map)['type'] == 'meeting').toList();
                  final polls = allItems.where((d) => (d.data() as Map)['type'] == 'poll').toList();

                  return ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      if (tasks.isNotEmpty) ...[
                        _buildSectionHeader('Pending Tasks'),
                        ...tasks.map((doc) => _buildNotificationCard(
                          icon: Icons.assignment_late_outlined,
                          color: Colors.orange,
                          title: 'Task Assigned',
                          message: (doc.data() as Map)['text'] ?? '',
                          time: ((doc.data() as Map)['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
                          onTap: () {},
                        )),
                        const SizedBox(height: 24),
                      ],
                      if (meetings.isNotEmpty) ...[
                        _buildSectionHeader('Upcoming Meetings'),
                        ...meetings.map((doc) => _buildNotificationCard(
                          icon: Icons.calendar_today_outlined,
                          color: Colors.green,
                          title: 'New Meeting Scheduled',
                          message: '${(doc.data() as Map)['text']}\nLocation: ${(doc.data() as Map)['location'] ?? 'Not specified'}',
                          time: ((doc.data() as Map)['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
                        )),
                        const SizedBox(height: 24),
                      ],
                      if (polls.isNotEmpty) ...[
                        _buildSectionHeader('New Polls'),
                        ...polls.map((doc) => _buildNotificationCard(
                          icon: Icons.poll_outlined,
                          color: Colors.purple,
                          title: 'Active Poll',
                          message: (doc.data() as Map)['text'] ?? '',
                          time: ((doc.data() as Map)['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
                        )),
                        const SizedBox(height: 24),
                      ],
                      _buildSectionHeader('System Announcements'),
                      ...staticAnnouncements.map((a) => _buildNotificationCard(
                        icon: a['icon'] as IconData,
                        color: a['color'] as Color,
                        title: a['title'] as String,
                        message: a['message'] as String,
                        time: a['time'] as DateTime,
                      )),
                    ],
                  );
                },
              );
            },
          ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[400],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
    required DateTime time,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        DateFormat('MMM d, hh:mm a').format(time),
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiStreamBuilder extends StatelessWidget {
  final List<Stream<QuerySnapshot>> streams;
  final Widget Function(BuildContext, List<AsyncSnapshot<QuerySnapshot>>) builder;

  const MultiStreamBuilder({
    super.key,
    required this.streams,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return _buildRecursive(context, 0, []);
  }

  Widget _buildRecursive(BuildContext context, int index, List<AsyncSnapshot<QuerySnapshot>> snapshots) {
    if (index == streams.length) {
      return builder(context, snapshots);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: streams[index],
      builder: (context, snapshot) {
        return _buildRecursive(context, index + 1, [...snapshots, snapshot]);
      },
    );
  }
}
