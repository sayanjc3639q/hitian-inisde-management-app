import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class IdeaFeedbackPage extends StatefulWidget {
  final String ideaId;
  final String ideaTitle;

  const IdeaFeedbackPage({super.key, required this.ideaId, required this.ideaTitle});

  @override
  State<IdeaFeedbackPage> createState() => _IdeaFeedbackPageState();
}

class _IdeaFeedbackPageState extends State<IdeaFeedbackPage> {
  final TextEditingController _commentController = TextEditingController();
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Feedback & Criticism',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              widget.ideaTitle,
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        foregroundColor: Colors.black,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ideas')
                  .doc(widget.ideaId)
                  .collection('criticisms')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF4A0404)));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No feedback yet.',
                          style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 16),
                        ),
                        Text(
                          'Be the first to share your thoughts!',
                          style: GoogleFonts.outfit(color: Colors.grey[400], fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    final timestamp = data['timestamp'] as Timestamp?;
                    final timeStr = timestamp != null 
                        ? DateFormat('MMM d, h:mm a').format(timestamp.toDate()) 
                        : 'Just now';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
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
                        border: Border.all(color: Colors.grey[100]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: const Color(0xFFFDE8E8),
                                    child: Text(
                                      (data['authorName'] ?? 'U')[0].toUpperCase(),
                                      style: GoogleFonts.outfit(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF4A0404),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    data['authorName'] ?? 'Unknown',
                                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                              Text(timeStr, style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data['text'] ?? '',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: const Color(0xFF2D2D2D),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 16,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: GoogleFonts.outfit(fontSize: 14),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Share your feedback...',
                        hintStyle: GoogleFonts.outfit(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Color(0xFF4A0404)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: const Color(0xFF4A0404),
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      onPressed: _submitFeedback,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitFeedback() async {
    if (_commentController.text.trim().isEmpty) return;
    final text = _commentController.text.trim();
    _commentController.clear();

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
      final name = userDoc.data()?['name'] ?? 'Unknown Member';

      await FirebaseFirestore.instance
          .collection('ideas')
          .doc(widget.ideaId)
          .collection('criticisms')
          .add({
        'text': text,
        'authorId': _user?.uid,
        'authorName': name,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update status to pending if it was submitted
      final ideaDoc = await FirebaseFirestore.instance.collection('ideas').doc(widget.ideaId).get();
      if (ideaDoc.data()?['status'] == 'submitted') {
        await FirebaseFirestore.instance.collection('ideas').doc(widget.ideaId).update({'status': 'pending'});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error posting feedback: $e')),
        );
      }
    }
  }
}
