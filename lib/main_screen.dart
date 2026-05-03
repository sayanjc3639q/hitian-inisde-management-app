import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_service.dart';
import 'home_page.dart';
import 'chat_page.dart';
import 'ideas_page.dart';
import 'events_page.dart';
import 'profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ChatPage(),
    IdeasPage(),
    EventsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<String?>(
        valueListenable: UserService().fetchingErrorNotifier,
        builder: (context, error, _) {
          if (error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_outlined, color: Color(0xFF4A0404), size: 64),
                    const SizedBox(height: 24),
                    Text(
                      'Connection Issue',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A0404),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Sign Out & Retry',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return IndexedStack(
            index: _selectedIndex,
            children: _pages,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4A0404),
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'CHAT'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), activeIcon: Icon(Icons.lightbulb), label: 'IDEAS'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'EVENTS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'PROFILE'),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          '$title Page coming soon...',
          style: GoogleFonts.outfit(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
