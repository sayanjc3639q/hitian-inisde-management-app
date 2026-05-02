import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  final User? _user = FirebaseAuth.instance.currentUser;

  String _calculateYear(int startYear) {
    DateTime now = DateTime.now();
    int yearDiff = now.year - startYear;
    int year;
    if (now.month >= 8) { // Academic year starts in August
      year = yearDiff + 1;
    } else {
      year = yearDiff;
    }
    
    if (year <= 0) return 'Incoming';
    if (year == 1) return '1st Year';
    if (year == 2) return '2nd Year';
    if (year == 3) return '3rd Year';
    if (year == 4) return '4th Year';
    return 'Alumni';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(_user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Scaffold(body: Center(child: Text('Something went wrong')));
        if (snapshot.connectionState == ConnectionState.waiting) return const Scaffold(body: Center(child: CircularProgressIndicator()));

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        String name = data['name'] ?? 'No Name';
        String domain = data['domain'] ?? 'No Domain';
        String rollNumber = data['rollNumber'] ?? 'No Roll #';
        String email = data['email'] ?? 'No Email';
        int batch = data['batch'] ?? 2025;
        
        String yearString = _calculateYear(batch);
        
        int ideasCount = data['ideasCount'] ?? 0;
        int tasksCount = data['tasksCount'] ?? 0;
        int eventsCount = data['eventsCount'] ?? 0;

        return Scaffold(
          backgroundColor: const Color(0xFFFBFBFB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Profile',
              style: GoogleFonts.outfit(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.black),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // User Header
                _buildProfileHeader(name, '$yearString • $domain'),
                const SizedBox(height: 32),
                
                // Stats Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem('Ideas', ideasCount.toString()),
                      _buildStatItem('Tasks', tasksCount.toString()),
                      _buildStatItem('Events', eventsCount.toString()),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Menu Options
                _buildMenuSection(
                  title: 'Personal Information',
                  items: [
                    _buildMenuItem(
                      Icons.person_outline, 
                      'Account Details', 
                      'Edit your profile',
                      onTap: () => _showEditDialog(name, rollNumber, domain, batch),
                    ),
                    _buildMenuItem(Icons.badge_outlined, 'Roll Number', rollNumber),
                    _buildMenuItem(Icons.calendar_today_outlined, 'Batch', 'Batch $batch-${batch + 1}'),
                    _buildMenuItem(Icons.email_outlined, 'Email Address', email),
                  ],
                ),
                const SizedBox(height: 16),
                _buildMenuSection(
                  title: 'My Activity',
                  items: [
                    _buildMenuItem(Icons.lightbulb_outline, 'My Submitted Ideas', 'Track your pitches'),
                    _buildMenuItem(Icons.assignment_outlined, 'Completed Tasks', 'View history'),
                    _buildMenuItem(Icons.calendar_today_outlined, 'Past Events', 'Member history'),
                  ],
                ),
                
                const SizedBox(height: 32),
                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextButton(
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: const Color(0xFFFFEEEE),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      'Log Out',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF4A0404),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(String currentName, String currentRoll, String currentDomain, int currentBatch) {
    final nameController = TextEditingController(text: currentName);
    final rollController = TextEditingController(text: currentRoll);
    String selectedDomain = currentDomain;
    int selectedBatch = currentBatch;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit Profile', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  style: GoogleFonts.outfit(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: rollController,
                  decoration: const InputDecoration(labelText: 'Roll Number'),
                  style: GoogleFonts.outfit(),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedDomain,
                  decoration: const InputDecoration(labelText: 'Domain'),
                  items: [
                    'Public Relation Management',
                    'Content Writer',
                    'Graphic Designer',
                    'Photographer',
                    'Web/App Developer',
                    'Video Editor',
                  ].map((d) => DropdownMenuItem(value: d, child: Text(d, style: GoogleFonts.outfit(fontSize: 14)))).toList(),
                  onChanged: (val) => setDialogState(() => selectedDomain = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: selectedBatch,
                  decoration: const InputDecoration(labelText: 'Batch'),
                  items: [2022, 2023, 2024, 2025, 2026].map((y) => DropdownMenuItem(value: y, child: Text('Batch $y-${y + 1}', style: GoogleFonts.outfit(fontSize: 14)))).toList(),
                  onChanged: (val) => setDialogState(() => selectedBatch = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.outfit(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                await _auth.updateUserDetails(
                  uid: _user!.uid,
                  name: nameController.text,
                  rollNumber: rollController.text,
                  domain: selectedDomain,
                  batch: selectedBatch,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A0404)),
              child: Text('Save', style: GoogleFonts.outfit(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String domain) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF4A0404), width: 3),
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/user_avatar.png'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF4A0404),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          domain,
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A0404),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection({required String title, required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: items,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFDE8E8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF4A0404), size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.outfit(
          fontSize: 13,
          color: Colors.grey[500],
        ),
      ),
      trailing: onTap != null ? const Icon(Icons.chevron_right, color: Colors.grey, size: 20) : null,
      onTap: onTap,
    );
  }
}
