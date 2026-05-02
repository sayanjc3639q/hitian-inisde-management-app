import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_detail_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(_user?.uid).snapshots(),
      builder: (context, snapshot) {
        String initials = "H";
        if (snapshot.hasData && snapshot.data!.exists) {
          String name = snapshot.data!.get('name') ?? "";
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEEE), // Light pink/peach
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey[600]),
                        hintText: 'Search conversations...',
                        hintStyle: GoogleFonts.outfit(color: Colors.grey[600]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Group Categories
                  _buildCategorySection(context, 'Domain Groups', [
                    'Public Relation Management', 'Content Writer', 'Graphic Designer', 'Photographer', 'Web/App Developer', 'Video Editor'
                  ]),
                  _buildCategorySection(context, 'Year Groups', [
                    'Year 1', 'Year 2', 'Year 3', 'Year 4'
                  ]),
                  _buildCategorySection(context, 'Combined Groups', [
                    'Combined 1+2', 'Combined 1+2+3', 'Combined All'
                  ]),
                  _buildCategorySection(context, 'Special Groups', [
                    'Common', 'Alumni'
                  ]),
                  
                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color(0xFF4A0404),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.edit_outlined, color: Colors.white),
          ),
        );
      },
    );
  }



  Widget _buildCategorySection(BuildContext context, String title, List<String> groupIds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A0404),
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: groupIds.asMap().entries.map((entry) {
              int idx = entry.key;
              String id = entry.value;
              bool isLast = idx == groupIds.length - 1;
              
              Query query;
              final now = DateTime.now();
              final academicYear = now.month >= 8 ? now.year : now.year - 1;

              if (title == 'Domain Groups') {
                query = FirebaseFirestore.instance.collection('users').where('domain', isEqualTo: id);
              } else if (title == 'Year Groups') {
                int year = int.parse(id.split(' ')[1]);
                int targetBatch = academicYear - year + 1;
                query = FirebaseFirestore.instance.collection('users').where('batch', isEqualTo: targetBatch);
              } else if (title == 'Combined Groups') {
                if (id == 'Combined 1+2') {
                  query = FirebaseFirestore.instance.collection('users').where('batch', whereIn: [academicYear, academicYear - 1]);
                } else if (id == 'Combined 1+2+3') {
                  query = FirebaseFirestore.instance.collection('users').where('batch', whereIn: [academicYear, academicYear - 1, academicYear - 2]);
                } else {
                  query = FirebaseFirestore.instance.collection('users');
                }
              } else if (id == 'Alumni') {
                query = FirebaseFirestore.instance.collection('users').where('batch', isLessThan: academicYear - 3);
              } else {
                query = FirebaseFirestore.instance.collection('users');
              }

              return Column(
                children: [
                  _buildGroupTile(context, id, query),
                  if (!isLast) const Divider(height: 1, indent: 70),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupTile(BuildContext context, String label, Query query) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFDE8E8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.groups_outlined, color: Color(0xFF4A0404), size: 24),
      ),
      title: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: FutureBuilder<AggregateQuerySnapshot>(
        future: query.count().get(),
        builder: (context, snapshot) {
          String memberText = snapshot.hasData ? '${snapshot.data!.count} members' : 'Loading members...';
          return Text(
            memberText,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          );
        },
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: () async {
        final countSnapshot = await query.count().get();
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailPage(
              title: label,
              subtitle: '${countSnapshot.count} Members',
              chatId: label.replaceAll('/', '_'),
              membersQuery: query,
              icon: Icons.groups_outlined,
            ),
          ),
        );
      },
    );
  }

}
