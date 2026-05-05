import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MultiStreamBuilder extends StatelessWidget {
  final String uid;
  final Widget Function(BuildContext context, int ideas, int tasks, int events) builder;

  const MultiStreamBuilder({super.key, required this.uid, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ideas').where('authorId', isEqualTo: uid).snapshots(),
      builder: (context, ideasSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collectionGroup('messages')
              .where('type', isEqualTo: 'task')
              .where('assigneeId', isEqualTo: uid)
              .where('status', isEqualTo: 'Completed')
              .snapshots(),
          builder: (context, tasksSnapshot) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('events')
                  .where('attendees', arrayContains: uid)
                  .snapshots(),
              builder: (context, eventsSnapshot) {
                int ideasCount = ideasSnapshot.hasData ? ideasSnapshot.data!.docs.length : 0;
                int tasksCount = tasksSnapshot.hasData ? tasksSnapshot.data!.docs.length : 0;
                
                int pastEventsCount = 0;
                if (eventsSnapshot.hasData) {
                  final now = DateTime.now();
                  pastEventsCount = eventsSnapshot.data!.docs.where((doc) {
                    final dt = (doc.get('dateTime') as Timestamp).toDate();
                    return dt.isBefore(now);
                  }).length;
                }

                return builder(context, ideasCount, tasksCount, pastEventsCount);
              },
            );
          },
        );
      },
    );
  }
}

class ActivityDetailPage extends StatelessWidget {
  final String type;
  final String uid;

  const ActivityDetailPage({super.key, required this.type, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text(
          type == 'Ideas' ? 'My Submitted Ideas' : (type == 'Tasks' ? 'Completed Tasks' : 'Past Events'),
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: _buildList(uid),
    );
  }

  Widget _buildList(String uid) {
    if (type == 'Ideas') {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ideas')
            .where('authorId', isEqualTo: uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // If orderBy fails (likely missing index), fall back to simple query
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('ideas')
                  .where('authorId', isEqualTo: uid)
                  .snapshots(),
              builder: (context, fallbackSnapshot) {
                if (fallbackSnapshot.hasError) return _buildErrorState(fallbackSnapshot.error.toString());
                if (fallbackSnapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!fallbackSnapshot.hasData || fallbackSnapshot.data!.docs.isEmpty) return _buildEmptyState('No ideas submitted yet');
                
                final docs = fallbackSnapshot.data!.docs.toList();
                // Manual sort if possible
                docs.sort((a, b) {
                  final tsA = (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
                  final tsB = (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
                  if (tsA == null || tsB == null) return 0;
                  return tsB.compareTo(tsA);
                });

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: docs.length,
                  itemBuilder: (context, index) => _buildIdeaCard(docs[index]),
                );
              },
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState('No ideas submitted yet');

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => _buildIdeaCard(snapshot.data!.docs[index]),
          );
        },
      );
    } else if (type == 'Tasks') {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collectionGroup('messages')
            .where('type', isEqualTo: 'task')
            .where('assigneeId', isEqualTo: uid)
            .where('status', isEqualTo: 'Completed')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return _buildErrorState(snapshot.error.toString());
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState('No completed tasks yet');

          final tasks = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tasks.length,
            itemBuilder: (context, index) => _buildTaskCard(tasks[index]),
          );
        },
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events')
            .where('attendees', arrayContains: uid)
            .orderBy('dateTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Fallback for events too
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('events')
                  .where('attendees', arrayContains: uid)
                  .snapshots(),
              builder: (context, fallbackSnapshot) {
                if (fallbackSnapshot.hasError) return _buildErrorState(fallbackSnapshot.error.toString());
                if (fallbackSnapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                
                final now = DateTime.now();
                final docs = fallbackSnapshot.data?.docs ?? [];
                final pastEvents = docs.where((doc) {
                  final dt = (doc.get('dateTime') as Timestamp).toDate();
                  return dt.isBefore(now);
                }).toList();

                if (pastEvents.isEmpty) return _buildEmptyState('No past events attended');
                
                pastEvents.sort((a, b) {
                  final dtA = (a.get('dateTime') as Timestamp).toDate();
                  final dtB = (b.get('dateTime') as Timestamp).toDate();
                  return dtB.compareTo(dtA);
                });

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: pastEvents.length,
                  itemBuilder: (context, index) => _buildEventCard(pastEvents[index]),
                );
              },
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState('No events attended yet');

          final now = DateTime.now();
          final pastEvents = snapshot.data!.docs.where((doc) {
            final dt = (doc.get('dateTime') as Timestamp).toDate();
            return dt.isBefore(now);
          }).toList();

          if (pastEvents.isEmpty) return _buildEmptyState('No past events attended');

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: pastEvents.length,
            itemBuilder: (context, index) => _buildEventCard(pastEvents[index]),
          );
        },
      );
    }
  }

  Widget _buildErrorState(String error) {
    bool isIndexError = error.contains('index') || error.contains('FAILED_PRECONDITION');
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isIndexError ? Icons.settings_outlined : Icons.error_outline, 
                 size: 48, 
                 color: isIndexError ? const Color(0xFF4A0404) : Colors.red),
            const SizedBox(height: 16),
            Text(
              isIndexError ? 'Database Index Required' : 'Error loading list',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              isIndexError 
                ? 'This list requires a combined index in Firestore. To fix this:\n1. Go to Firebase Console > Firestore > Indexes\n2. Add a Single Field or Composite index as suggested by the error details.'
                : error,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 14),
            ),
            if (isIndexError) ...[
              const SizedBox(height: 24),
              SelectableText(
                'Query Detail: $error',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(color: Colors.grey[400], fontSize: 10),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(message, style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildIdeaCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final status = data['status'] ?? 'pending';
    final color = status == 'approved' ? Colors.green : (status == 'rejected' ? Colors.red : Colors.orange);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['category'] ?? 'General', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF4A0404))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(status.toUpperCase(), style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(data['title'] ?? '', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(data['description'] ?? '', style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildTaskCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final timestamp = data['timestamp'] as Timestamp?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Color(0xFFE8F5E9), child: Icon(Icons.check, color: Colors.green)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['text'] ?? '', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                if (timestamp != null)
                  Text('Completed on ${DateFormat('MMM d, yyyy').format(timestamp.toDate())}', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final dateTime = (data['dateTime'] as Timestamp).toDate();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(DateFormat('dd').format(dateTime), style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF4A0404))),
              Text(DateFormat('MMM').format(dateTime).toUpperCase(), style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['title'] ?? '', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(data['location'] ?? 'No Location', style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
