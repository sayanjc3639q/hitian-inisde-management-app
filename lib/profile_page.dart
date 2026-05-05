import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'auth_service.dart';
import 'my_activity_pages.dart';
import 'settings_page.dart';
import 'user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final AuthService _auth = AuthService();
  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isUploading = false;

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

  Future<void> _handleImageAction(String? currentUrl) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
            if (currentUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Profile Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _removeProfilePic();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      // Handle Permissions
      if (source == ImageSource.camera) {
        var status = await Permission.camera.request();
        if (status.isPermanentlyDenied) {
          if (mounted) _showPermissionDialog('Camera');
          return;
        }
        if (!status.isGranted) return;
      } else {
        // For Gallery
        var status = await Permission.photos.request();
        if (status.isPermanentlyDenied) {
          if (mounted) _showPermissionDialog('Photos');
          return;
        }
        // On some Android versions, it might be storage
        if (status.isDenied) {
          await Permission.storage.request();
        }
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image == null) return;

      setState(() => _isUploading = true);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pics')
          .child('${_user!.uid}.jpg');

      // Upload file
      final bytes = await image.readAsBytes();
      await storageRef.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      
      final downloadUrl = await storageRef.getDownloadURL();

      // Update Firestore
      await _auth.updateProfilePicture(_user.uid, downloadUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showPermissionDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$type Permission Required'),
        content: Text('Please enable $type access in settings to upload a profile photo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeProfilePic() async {
    try {
      setState(() => _isUploading = true);
      
      // Delete from storage
      try {
        await FirebaseStorage.instance
            .ref()
            .child('profile_pics')
            .child('${_user!.uid}.jpg')
            .delete();
      } catch (_) {
        // Ignore if file doesn't exist
      }

      // Update Firestore
      await _auth.updateProfilePicture(_user!.uid, null);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture removed.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_user == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    return ValueListenableBuilder<Map<String, dynamic>?>(
      valueListenable: UserService().userDataNotifier,
      builder: (context, data, _) {
        if (data == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final name = data['name'] ?? 'No Name';
        final domain = data['domain'] ?? 'No Domain';
        final rollNumber = data['rollNumber'] ?? 'No Roll #';
        final email = data['email'] ?? 'No Email';
        final profilePic = data['profilePic'];
        final dynamic batchVal = data['batch'];
        final int batch = batchVal is int ? batchVal : int.tryParse(batchVal?.toString() ?? '2025') ?? 2025;

        final yearString = _calculateYear(batch);

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
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildProfileHeader(name, '$yearString • $domain', profilePic),
                const SizedBox(height: 32),
                _StatsRow(uid: _user.uid),
                const SizedBox(height: 32),
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
                    _buildMenuItem(
                      Icons.lightbulb_outline,
                      'My Submitted Ideas',
                      'Track your pitches',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityDetailPage(type: 'Ideas', uid: _user.uid))),
                    ),
                    _buildMenuItem(
                      Icons.assignment_outlined,
                      'Completed Tasks',
                      'View history',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityDetailPage(type: 'Tasks', uid: _user.uid))),
                    ),
                    _buildMenuItem(
                      Icons.calendar_today_outlined,
                      'Past Events',
                      'Member history',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityDetailPage(type: 'Events', uid: _user.uid))),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
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

  Widget _buildProfileHeader(String name, String domain, String? profilePic) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () => _handleImageAction(profilePic),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF4A0404), width: 3),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: profilePic != null ? NetworkImage(profilePic) : null,
                  child: profilePic == null && !_isUploading
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : (_isUploading ? const CircularProgressIndicator(color: Color(0xFF4A0404)) : null),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 4,
              child: GestureDetector(
                onTap: () => _handleImageAction(profilePic),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A0404),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                ),
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

class _StatsRow extends StatelessWidget {
  final String uid;
  const _StatsRow({required this.uid});

  @override
  Widget build(BuildContext context) {
    return MultiStreamBuilder(
      uid: uid,
      builder: (context, ideasCount, tasksCount, eventsCount) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Ideas', ideasCount.toString()),
              _buildStatItem('Tasks', tasksCount.toString()),
              _buildStatItem('Events', eventsCount.toString()),
            ],
          ),
        );
      },
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
}
