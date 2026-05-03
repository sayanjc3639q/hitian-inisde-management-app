import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'notifications_page.dart';
import 'user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<Map<String, dynamic>?>(
      valueListenable: UserService().userDataNotifier,
      builder: (context, data, _) {
        if (data == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF4A0404)),
            ),
          );
        }

        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return const Scaffold(body: Center(child: Text('Not logged in')));

        String name = data['name'] ?? "Hitian";
        String domain = data['domain'] ?? "Member";
        final dynamic batchVal = data['batch'];
        int batch = batchVal is int ? batchVal : int.tryParse(batchVal?.toString() ?? '2025') ?? 2025;
            String yearText = _calculateYear(batch);

            String greeting = _getGreeting();
            String initials = name.isNotEmpty ? name.split(' ').map((e) => e[0]).take(2).join().toUpperCase() : "H";

            return Scaffold(
              backgroundColor: const Color(0xFFFBFBFB),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                scrolledUnderElevation: 0,
                surfaceTintColor: Colors.transparent,
                leadingWidth: 60,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF4A0404),
                    radius: 18,
                    child: Text(
                      initials,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Image.asset(
                      'assets/images/HitianINSIDElogo.png',
                      height: 32,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'HITIAN INSIDE',
                      style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                actions: [
                  StreamBuilder<int>(
                    stream: _getNotificationCount(user.uid, data),
                    builder: (context, snapshot) {
                      int count = snapshot.data ?? 0;
                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none, color: Colors.black, size: 28),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const NotificationsPage()),
                              );
                            },
                          ),
                          if (count > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  count > 9 ? '9+' : '$count',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    }
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 800));
                },
                child: RepaintBoundary(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          // User Profile Card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4A0404), Color(0xFF8B4513)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4A0404).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          greeting,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          name,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        yearText,
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    _buildInfoItem(Icons.school, domain, 'Department'),
                                    const SizedBox(width: 40),
                                    _buildInfoItem(Icons.calendar_today, batch.toString(), 'Batch'),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Quick Stats or Actions
                          // Quick Stats or Actions
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collectionGroup('messages')
                                .where('type', isEqualTo: 'task')
                                .where('assigneeId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                                .snapshots(),
                            builder: (context, taskSnapshot) {
                              final taskCount = taskSnapshot.hasData ? taskSnapshot.data!.docs.where((d) => d.get('status') == 'Pending').length : 0;
                              
                              return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collectionGroup('messages')
                                    .where('type', isEqualTo: 'meeting')
                                    .snapshots(),
                                builder: (context, meetingSnapshot) {
                                  final meetingCount = meetingSnapshot.hasData ? meetingSnapshot.data!.docs.length : 0;

                                  return Row(
                                    children: [
                                      Expanded(
                                        child: _buildStatCard(
                                          taskCount == 0 ? '0 tasks' : 'My Tasks', 
                                          taskCount.toString().padLeft(2, '0'), 
                                          Icons.assignment_outlined, 
                                          const Color(0xFF4A0404)
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildStatCard('Events', meetingCount.toString().padLeft(2, '0'), Icons.event_note_outlined, const Color(0xFF8B4513)),
                                      ),
                                    ],
                                  );
                                }
                              );
                            }
                          ),

                          const SizedBox(height: 32),

                          // My Tasks Section
                          _buildSectionHeader('MY TASKS', 'View all'),
                          const SizedBox(height: 16),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collectionGroup('messages')
                                .where('type', isEqualTo: 'task')
                                .where('assigneeId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                // Fallback for missing index: query without sorting
                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collectionGroup('messages')
                                      .where('type', isEqualTo: 'task')
                                      .where('assigneeId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                                      .snapshots(),
                                  builder: (context, fallbackSnapshot) {
                                    if (fallbackSnapshot.hasError) return _buildTaskErrorState(fallbackSnapshot.error.toString());
                                    if (fallbackSnapshot.connectionState == ConnectionState.waiting) return _buildTaskLoadingState();
                                    
                                    final docs = fallbackSnapshot.data?.docs ?? [];
                                    if (docs.isEmpty) return _buildNoTaskState();
                                    
                                    // Manual sort
                                    final sortedDocs = docs.toList();
                                    sortedDocs.sort((a, b) {
                                      final tA = (a.data() as Map)['timestamp'] as Timestamp?;
                                      final tB = (b.data() as Map)['timestamp'] as Timestamp?;
                                      if (tA == null || tB == null) return 0;
                                      return tB.compareTo(tA);
                                    });
                                    
                                    return _buildTaskList(sortedDocs);
                                  },
                                );
                              }

                              if (snapshot.connectionState == ConnectionState.waiting) return _buildTaskLoadingState();
                              
                              final tasks = snapshot.data?.docs ?? [];
                              if (tasks.isEmpty) return _buildNoTaskState();

                              return _buildTaskList(tasks);
                            },
                          ),
                          const SizedBox(height: 32),

                          // Upcoming Media Section
                          _buildSectionHeader('UPCOMING MEDIA', ''),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE7E0),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'OCT',
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        '24',
                                        style: GoogleFonts.outfit(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.public, size: 16, color: Color(0xFF8B4513)),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Tech Insider Interview',
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                              color: const Color(0xFF8B4513),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'CEO Discusses Q4 Innovations',
                                        style: GoogleFonts.outfit(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          _buildTag('PRESS', const Color(0xFF0033CC), Colors.white),
                                          const SizedBox(width: 8),
                                          _buildTag('EXTERNAL', const Color(0xFFFFD700), Colors.black),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }

  Widget _buildTaskLoadingState() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: const Center(child: CircularProgressIndicator(color: Color(0xFF4A0404))),
    );
  }

  Widget _buildNoTaskState() {
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'no task now',
            style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskErrorState(String error) {
    bool isIndexError = error.contains('index') || error.contains('FAILED_PRECONDITION');
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[100]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red[400], size: 32),
          const SizedBox(height: 12),
          Text(
            isIndexError ? 'Database Index Required' : 'Error loading tasks',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: Colors.red[800],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isIndexError 
              ? 'To fix this, go to Firebase Console > Firestore > Indexes and add a Collection Group index for "messages" with fields: type (Asc), assigneeId (Asc), and timestamp (Desc).'
              : error,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.red[600],
              fontSize: 13,
            ),
          ),
          if (isIndexError) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {}, // User can read the instruction above
              icon: const Icon(Icons.settings_outlined, size: 18),
              label: const Text('Manual Setup Required'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDE8E8),
                foregroundColor: const Color(0xFF4A0404),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskList(List<QueryDocumentSnapshot> tasks) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final doc = tasks[index];
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = data['timestamp'] as Timestamp?;
        String dueDate = '';
        if (timestamp != null) {
          final date = timestamp.toDate();
          final now = DateTime.now();
          if (date.year == now.year && date.month == now.month && date.day == now.day) {
            dueDate = 'Due Today';
          } else {
            dueDate = DateFormat('MMM d').format(date);
          }
        }

        return _buildTaskItem(
          doc.reference,
          data['text'] ?? '',
          dueDate,
          data['status'] == 'Done' || data['status'] == 'Completed',
        );
      },
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Stream<int> _getNotificationCount(String uid, Map<String, dynamic> userData) {
    return FirebaseFirestore.instance.collectionGroup('messages')
        .where('type', isEqualTo: 'task')
        .where('assigneeId', isEqualTo: uid)
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _calculateYear(int startYear) {
    final now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;

    // Academic year usually starts in August (Month 8)
    int yearsDifference = currentYear - startYear;
    
    // If we haven't reached August yet, we are still in the previous academic year's cycle
    if (currentMonth < 8) {
      yearsDifference--;
    }

    int academicYear = yearsDifference + 1;

    if (academicYear <= 0) return "Incoming";
    if (academicYear > 4) return "Alumni";

    switch (academicYear) {
      case 1:
        return "1st Year";
      case 2:
        return "2nd Year";
      case 3:
        return "3rd Year";
      case 4:
        return "4th Year";
      default:
        return "Student";
    }
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: 1.1,
          ),
        ),
        if (actionText.isNotEmpty)
          Text(
            actionText,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A0404),
            ),
          ),
      ],
    );
  }

  Widget _buildSmallCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required Color cardBg,
    BorderSide? borderLeft,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: borderLeft != null ? Border(left: borderLeft) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(DocumentReference taskRef, String title, String dueDate, bool isDone) {
    return InkWell(
      onTap: () {
        taskRef.update({'status': isDone ? 'Pending' : 'Done'});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              isDone ? Icons.check_box : Icons.check_box_outline_blank,
              color: isDone ? const Color(0xFF4A0404) : Colors.grey[400],
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: isDone ? Colors.grey[400] : Colors.black87,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (dueDate.isNotEmpty)
              Text(
                dueDate,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: dueDate == 'Due Today' ? const Color(0xFF8B4513) : Colors.grey[500],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: textCol,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
