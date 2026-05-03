import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Privacy Policy',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: May 2026',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Introduction',
              'Welcome to HITian INSIDE. We value your privacy and are committed to protecting your personal data. This policy explains how we collect, use, and safeguard your information when you use our collaboration platform.',
            ),
            _buildSection(
              '2. Data We Collect',
              'We collect information necessary to provide our services, including:\n\n'
              '• Profile Information: Name, Roll Number, Email, and Batch details.\n'
              '• Content: Ideas pitched, task updates, and messages shared within groups.\n'
              '• Usage Data: Interactions with features like Event RSVPs and Activity tracking.',
            ),
            _buildSection(
              '3. How We Use Data',
              'Your data is used specifically for:\n\n'
              '• Facilitating collaboration between members.\n'
              '• Tracking project progress and task completion.\n'
              '• Verifying member identity within the college community.\n'
              '• Improving the app experience based on user feedback.',
            ),
            _buildSection(
              '4. Data Security',
              'We implement industry-standard security measures provided by Firebase (Google Cloud) to ensure your data is encrypted and protected from unauthorized access.',
            ),
            _buildSection(
              '5. Your Rights',
              'You have the right to:\n\n'
              '• Access and update your personal information through your profile settings.\n'
              '• Request account deletion by contacting the administrator.\n'
              '• Opt-out of non-essential notifications at any time.',
            ),
            _buildSection(
              '6. Contact Us',
              'If you have any questions regarding this Privacy Policy, please reach out to the editorial board or the system administrator.',
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8E8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'HITian INSIDE Editorial Board',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF4A0404),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A0404),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
