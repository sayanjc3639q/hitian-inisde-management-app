import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'privacy_policy_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _auth = AuthService();
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
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
          'Settings',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildSectionHeader('Account'),
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your login security',
              onTap: _showChangePasswordDialog,
            ),
            _buildSettingItem(
              icon: Icons.logout,
              title: 'Log Out',
              subtitle: 'Sign out of your account',
              textColor: const Color(0xFF4A0404),
              onTap: () async {
                await _auth.signOut();
                if (mounted) Navigator.pop(context);
              },
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Preferences'),
            _buildSettingToggle(
              icon: Icons.notifications_none_outlined,
              title: 'Push Notifications',
              subtitle: 'Stay updated on group activity',
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('About'),
            _buildSettingItem(
              icon: Icons.info_outline,
              title: 'App Version',
              subtitle: '1.0.0 (Stable)',
              onTap: () => _showAboutDialog(),
            ),
            _buildSettingItem(
              icon: Icons.description_outlined,
              title: 'Privacy Policy',
              subtitle: 'How we handle your data',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyPage())),
            ),
            const SizedBox(height: 48),
            Center(
              child: Text(
                'HITian INSIDE',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
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

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
            color: textColor ?? Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[500]),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSettingToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFDE8E8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.notifications_none_outlined, color: Color(0xFF4A0404), size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[500]),
        ),
        activeColor: const Color(0xFF4A0404),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _showChangePasswordDialog() {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your new password below. You will be logged out after updating.',
              style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              style: GoogleFonts.outfit(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.outfit(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.currentUser?.updatePassword(passwordController.text);
                await _auth.signOut();
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A0404)),
            child: Text('Update', style: GoogleFonts.outfit(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'HITian INSIDE',
      applicationVersion: '1.0.0',
      applicationIcon: Image.asset('assets/images/logo.png', width: 50, height: 50, errorBuilder: (c, e, s) => const Icon(Icons.school, size: 50)),
      children: [
        Text(
          'A premium collaboration tool for HITians to pitch ideas, track tasks, and stay updated on college events.',
          style: GoogleFonts.outfit(),
        ),
      ],
    );
  }
}
