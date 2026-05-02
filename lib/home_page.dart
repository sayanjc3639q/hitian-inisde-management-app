import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(_user?.uid).snapshots(),
      builder: (context, snapshot) {
        String name = "Hitian";
        String domain = "Member";
        String yearText = "";
        
        if (snapshot.hasData && snapshot.data!.exists) {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          name = data['name'] ?? "Hitian";
          domain = data['domain'] ?? "Member";
          int batch = data['batch'] ?? DateTime.now().year;
          yearText = _calculateYear(batch);
        }

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
              // Greeting Section
              Text(
                '$greeting, $name',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B4513), // Maroon/Brownish dot
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$domain${yearText.isNotEmpty ? " • $yearText" : ""}',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Announcements Header
              _buildSectionHeader('LATEST ANNOUNCEMENTS', 'View All'),
              const SizedBox(height: 16),

              // Featured Announcement Card
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/theater_announcement.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Important',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Annual Strategy Summit\nDates Announced',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Small Announcement Cards
              Row(
                children: [
                  Expanded(
                    child: _buildSmallCard(
                      icon: Icons.campaign_outlined,
                      iconColor: const Color(0xFFFFD700),
                      iconBg: const Color(0xFFFFF9E6),
                      title: 'New Brand Assets',
                      subtitle: 'Updated logos available in the portal.',
                      cardBg: const Color(0xFFFFF2F2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSmallCard(
                      icon: Icons.lightbulb_outline,
                      iconColor: Colors.white,
                      iconBg: const Color(0xFF0033CC),
                      title: 'Idea Campaign',
                      subtitle: 'Submit Q3 marketing ideas.',
                      cardBg: const Color(0xFFFFF2F2),
                      borderLeft: const BorderSide(color: Color(0xFF0033CC), width: 4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Quick Tasks Section
              _buildSectionHeader('QUICK TASKS', ''),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildTaskItem('Review draft press release', 'Due Today', false),
                    const Divider(height: 1, indent: 50),
                    _buildTaskItem('Approve vendor invoice for catering', 'Tomorrow', false),
                    const Divider(height: 1, indent: 50),
                    _buildTaskItem('Update team roster', '', true),
                  ],
                ),
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
    );
      },
    );
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

  Widget _buildTaskItem(String title, String dueDate, bool isDone) {
    return Padding(
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
