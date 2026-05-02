import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class IdeasPage extends StatefulWidget {
  const IdeasPage({super.key});

  @override
  State<IdeasPage> createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {
  String _selectedCategory = 'All';
  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  void _checkAdminStatus() async {
    if (_user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
      if (mounted) {
        setState(() {
          _isAdmin = doc.data()?['isAdmin'] ?? false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(_user?.uid).snapshots(),
      builder: (context, userSnapshot) {
        String initials = "H";
        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          String name = userSnapshot.data!.get('name') ?? "";
          if (name.isNotEmpty) {
            initials = name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();
          }
        }

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
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            title: Text(
              'HITIAN INSIDE',
              style: GoogleFonts.outfit(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black, size: 28),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Idea Box',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pitch your next big concept to the Maroon Team.\nTop voted ideas get greenlit.',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Submit Idea Button
                    ElevatedButton.icon(
                      onPressed: _showSubmitIdeaDialog,
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                      label: Text(
                        'Submit Idea',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A0404),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Categories
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryChip('All', _selectedCategory == 'All'),
                          _buildCategoryChip('Social Media', _selectedCategory == 'Social Media'),
                          _buildCategoryChip('Documentary', _selectedCategory == 'Documentary'),
                          _buildCategoryChip('Tech', _selectedCategory == 'Tech'),
                          _buildCategoryChip('Events', _selectedCategory == 'Events'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Idea Cards List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _selectedCategory == 'All' 
                    ? FirebaseFirestore.instance.collection('ideas').orderBy('timestamp', descending: true).snapshots()
                    : FirebaseFirestore.instance.collection('ideas').where('category', isEqualTo: _selectedCategory).orderBy('timestamp', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text('No ideas found for this category.', style: GoogleFonts.outfit(color: Colors.grey)),
                      );
                    }

                    final ideas = snapshot.data!.docs;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: ideas.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildIdeaCard(ideas[index]),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showSubmitIdeaDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String category = 'Social Media';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Submit Your Idea', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Idea Title',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your concept...',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: category,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              items: ['Social Media', 'Documentary', 'Tech', 'Events']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.outfit()))).toList(),
              onChanged: (v) => category = v!,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty || descController.text.isEmpty) return;
                
                final userDoc = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
                final name = userDoc.data()?['name'] ?? 'Unknown';

                await FirebaseFirestore.instance.collection('ideas').add({
                  'title': titleController.text,
                  'description': descController.text,
                  'category': category,
                  'authorId': _user?.uid,
                  'authorName': name,
                  'status': 'submitted',
                  'upvotes': [],
                  'downvotes': [],
                  'timestamp': FieldValue.serverTimestamp(),
                });
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A0404),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Pitch Idea', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = label;
          });
        },
        selectedColor: const Color(0xFFFFD56B),
        backgroundColor: const Color(0xFFF5E6E6),
        labelStyle: GoogleFonts.outfit(
          color: isSelected ? Colors.black : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildIdeaCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final List upvotes = data['upvotes'] ?? [];
    final List downvotes = data['downvotes'] ?? [];
    final int voteCount = upvotes.length - downvotes.length;
    final bool hasUpvoted = upvotes.contains(_user?.uid);
    final bool hasDownvoted = downvotes.contains(_user?.uid);
    final timestamp = data['timestamp'] as Timestamp?;
    final timeStr = timestamp != null ? DateFormat('MMM d, h:mm a').format(timestamp.toDate()) : '...';
    final status = data['status'] ?? 'submitted';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getStatusColor(status).withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(status),
                        ),
                      ),
                    ),
                    if (data['authorId'] == _user?.uid || _isAdmin)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        onPressed: () => _deleteIdea(doc.id),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['category'] ?? '',
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    Text(timeStr, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data['title'] ?? '',
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
                ),
                const SizedBox(height: 8),
                Text(
                  data['description'] ?? '',
                  style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[700], height: 1.5),
                ),
                const SizedBox(height: 16),
                
                // Criticism Section
                _buildCriticismSection(doc.id),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8E8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.expand_less, color: hasUpvoted ? Colors.green : Colors.black),
                        onPressed: () => _vote(doc.id, true),
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(
                        voteCount.toString(),
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: Icon(Icons.expand_more, color: hasDownvoted ? Colors.red : Colors.black),
                        onPressed: () => _vote(doc.id, false),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
                if (_isAdmin)
                  _buildAdminActions(doc.id, status),
                Text(
                  'By ${data['authorName']}',
                  style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminActions(String ideaId, String currentStatus) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.admin_panel_settings, color: Color(0xFF4A0404)),
      onSelected: (newStatus) {
        FirebaseFirestore.instance.collection('ideas').doc(ideaId).update({'status': newStatus});
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'pending', child: Text('Move to Pending')),
        const PopupMenuItem(value: 'approved', child: Text('Approve')),
        const PopupMenuItem(value: 'rejected', child: Text('Reject')),
        const PopupMenuItem(value: 'archived', child: Text('Archive')),
      ],
    );
  }

  Widget _buildCriticismSection(String ideaId) {
    final commentController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Criticism & Feedback', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('ideas').doc(ideaId).collection('criticisms').orderBy('timestamp', descending: true).limit(3).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            return Column(
              children: snapshot.data!.docs.map((d) {
                final cData = d.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Text('${cData['authorName']}: ', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12)),
                      Expanded(child: Text(cData['text'] ?? '', style: GoogleFonts.outfit(fontSize: 12), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Add criticism...',
                  hintStyle: GoogleFonts.outfit(fontSize: 12),
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, size: 20),
              onPressed: () async {
                if (commentController.text.isEmpty) return;
                final userDoc = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
                final name = userDoc.data()?['name'] ?? 'Unknown';
                
                await FirebaseFirestore.instance.collection('ideas').doc(ideaId).collection('criticisms').add({
                  'text': commentController.text,
                  'authorId': _user?.uid,
                  'authorName': name,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                
                // Update status to pending if it was submitted
                final ideaDoc = await FirebaseFirestore.instance.collection('ideas').doc(ideaId).get();
                if (ideaDoc.data()?['status'] == 'submitted') {
                  await FirebaseFirestore.instance.collection('ideas').doc(ideaId).update({'status': 'pending'});
                }
                
                commentController.clear();
              },
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'submitted': return Colors.blue;
      case 'pending': return Colors.orange;
      case 'approved': return Colors.green;
      case 'rejected': return Colors.red;
      case 'archived': return Colors.grey;
      default: return Colors.blue;
    }
  }

  void _vote(String ideaId, bool isUpvote) async {
    final docRef = FirebaseFirestore.instance.collection('ideas').doc(ideaId);
    final doc = await docRef.get();
    final data = doc.data() as Map<String, dynamic>;
    List upvotes = data['upvotes'] ?? [];
    List downvotes = data['downvotes'] ?? [];
    final uid = _user?.uid;

    if (isUpvote) {
      if (upvotes.contains(uid)) {
        upvotes.remove(uid);
      } else {
        upvotes.add(uid);
        downvotes.remove(uid);
      }
    } else {
      if (downvotes.contains(uid)) {
        downvotes.remove(uid);
      } else {
        downvotes.add(uid);
        upvotes.remove(uid);
      }
    }

    await docRef.update({
      'upvotes': upvotes,
      'downvotes': downvotes,
      'status': data['status'] == 'submitted' ? 'pending' : data['status'],
    });
  }

  void _deleteIdea(String ideaId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Idea?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('ideas').doc(ideaId).delete();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
