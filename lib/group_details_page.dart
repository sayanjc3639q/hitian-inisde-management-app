import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupDetailsPage extends StatefulWidget {
  final String title;
  final String chatId;
  final Query membersQuery;
  final String initials;
  final Color avatarBg;
  final IconData? icon;

  const GroupDetailsPage({
    super.key,
    required this.title,
    required this.chatId,
    required this.membersQuery,
    required this.initials,
    required this.avatarBg,
    this.icon,
  });

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Group Info',
          style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Group Profile Header
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: widget.avatarBg,
                        child: widget.icon != null
                            ? Icon(widget.icon, color: Colors.white, size: 50)
                            : Text(
                                widget.initials.isNotEmpty 
                                  ? widget.initials 
                                  : widget.title.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            // Logic to change group icon
                            _showIconPicker();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4A0404),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<AggregateQuerySnapshot>(
                    future: widget.membersQuery.count().get(),
                    builder: (context, snapshot) {
                      return Text(
                        '${snapshot.data?.count ?? "..."} Members',
                        style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 16),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Members List Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Members',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4A0404),
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: widget.membersQuery.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final members = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final data = members[index].data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'User';
                    final domain = data['domain'] ?? 'Member';
                    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[100]!),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF4A0404).withOpacity(0.1),
                            child: Text(
                              initial,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4A0404),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  domain,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.more_vert, color: Colors.grey),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showIconPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Group Icon',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconOption(Icons.groups),
                  _buildIconOption(Icons.campaign),
                  _buildIconOption(Icons.event),
                  _buildIconOption(Icons.lightbulb),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconOption(IconData icon) {
    return GestureDetector(
      onTap: () {
        // In a real app, we'd update this in Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group icon updated successfully!')),
        );
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFDE8E8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF4A0404), size: 32),
      ),
    );
  }
}
