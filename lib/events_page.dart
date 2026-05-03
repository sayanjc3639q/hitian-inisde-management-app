import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'notifications_page.dart';
import 'user_service.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String _selectedFilter = 'All Events';
  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isAdmin = false;
  Stream<QuerySnapshot>? _eventsStream;

  @override
  void initState() {
    super.initState();
    _updateStream();
  }

  void _updateStream() {
    setState(() {
      var query = FirebaseFirestore.instance.collection('events').orderBy('dateTime', descending: false);
      if (_selectedFilter == 'Shoots') {
        query = query.where('category', isEqualTo: 'Shoot');
      } else if (_selectedFilter == 'Meetings') {
        query = query.where('category', isEqualTo: 'Meeting');
      } else if (_selectedFilter == 'Deadlines') {
        query = query.where('category', isEqualTo: 'Deadline');
      }
      _eventsStream = query.snapshots();
    });
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<Map<String, dynamic>?>(
      valueListenable: UserService().userDataNotifier,
      builder: (context, data, _) {
        String initials = "H";
        String name = data?['name'] ?? "";
        bool isAdmin = data?['isAdmin'] ?? false;
        if (name.isNotEmpty) {
          initials = name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();
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
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage())),
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
                      'Schedule',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All Events'),
                          const SizedBox(width: 12),
                          _buildFilterChip('Shoots'),
                          const SizedBox(width: 12),
                          _buildFilterChip('Meetings'),
                          const SizedBox(width: 12),
                          _buildFilterChip('Deadlines'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Events List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _eventsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Fetching error: ${snapshot.error}', textAlign: TextAlign.center, style: GoogleFonts.outfit(color: Colors.red)),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_available, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text('No upcoming events found.', style: GoogleFonts.outfit(color: Colors.grey)),
                          ],
                        ),
                      );
                    }

                    final events = snapshot.data!.docs;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildEventCard(events[index]),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: _isAdmin 
            ? FloatingActionButton.extended(
                heroTag: 'events_fab_unique',
                onPressed: _showAddEventDialog,
                backgroundColor: const Color(0xFF4A0404),
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Add Event',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )
            : null,
        );
      },
    );
  }

  Stream<QuerySnapshot> _getEventsStream() {
    var query = FirebaseFirestore.instance.collection('events').orderBy('dateTime', descending: false);
    
    if (_selectedFilter == 'Shoots') {
      query = query.where('category', isEqualTo: 'Shoot');
    } else if (_selectedFilter == 'Meetings') {
      query = query.where('category', isEqualTo: 'Meeting');
    } else if (_selectedFilter == 'Deadlines') {
      query = query.where('category', isEqualTo: 'Deadline');
    }
    
    return query.snapshots();
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final locController = TextEditingController();
    String category = 'Shoot';
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create New Event', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Event Title', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: InputDecoration(hintText: 'Description', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locController,
                decoration: InputDecoration(hintText: 'Location', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                        if (picked != null) {
                          final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                          if (time != null) {
                            setModalState(() {
                              selectedDate = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
                            });
                          }
                        }
                      },
                      icon: const Icon(Icons.calendar_month, size: 18),
                      label: Text(DateFormat('MMM d, h:mm a').format(selectedDate)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], foregroundColor: Colors.black87, elevation: 0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                decoration: InputDecoration(filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                items: ['Shoot', 'Meeting', 'Deadline'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setModalState(() => category = v!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty) return;
                  await FirebaseFirestore.instance.collection('events').add({
                    'title': titleController.text,
                    'description': descController.text,
                    'location': locController.text,
                    'dateTime': Timestamp.fromDate(selectedDate),
                    'category': category,
                    'organizerId': _user?.uid,
                    'attendees': [],
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  if (context.mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A0404), minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text('Create Event', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        setState(() {
          _selectedFilter = label;
        });
        _updateStream();
      },
      selectedColor: const Color(0xFF4A0404),
      backgroundColor: const Color(0xFFFDE8E8),
      labelStyle: GoogleFonts.outfit(
        color: isSelected ? Colors.white : const Color(0xFF4A0404),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    );
  }

  Widget _buildEventCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final category = data['category'] ?? 'Event';
    final dateTime = (data['dateTime'] as Timestamp).toDate();
    final List attendees = data['attendees'] ?? [];
    final bool isAttending = attendees.contains(_user?.uid);

    if (category == 'Deadline') {
      return _buildDeadlineCard(doc, dateTime, data['title'] ?? '', DateFormat('h:mm a').format(dateTime));
    }

    if (category == 'Meeting') {
      return _buildMeetingCard(doc, data['title'] ?? '', data['description'] ?? '', DateFormat('MMM d').format(dateTime), DateFormat('h:mm a').format(dateTime), data['location'] ?? 'No Location', Icons.groups, const Color(0xFF1A237E));
    }

    // Default: Promoted/Shoot style
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFFFD56B), borderRadius: BorderRadius.circular(8)),
                      child: Text(category.toUpperCase(), style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF4A0404))),
                    ),
                    if (_isAdmin)
                      IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), onPressed: () => doc.reference.delete(), visualDensity: VisualDensity.compact),
                  ],
                ),
                const SizedBox(height: 12),
                Text(data['title'] ?? '', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A))),
                const SizedBox(height: 8),
                Text(data['description'] ?? '', style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(DateFormat('MMM d, yyyy • h:mm a').format(dateTime), style: GoogleFonts.outfit(color: Colors.grey[700], fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(data['location'] ?? 'Online', style: GoogleFonts.outfit(color: Colors.grey[700], fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${attendees.length} Attending', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF4A0404))),
                    ElevatedButton(
                      onPressed: () => _toggleRSVP(doc.id, attendees),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAttending ? Colors.grey[200] : const Color(0xFF4A0404),
                        foregroundColor: isAttending ? Colors.black : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(isAttending ? 'Joined' : 'Join Event'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineCard(DocumentSnapshot doc, DateTime dateTime, String title, String time) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFFFEEEE), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Column(
            children: [
              Text(dateTime.day.toString(), style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF4A0404))),
              Text(DateFormat('MMM').format(dateTime).toUpperCase(), style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF4A0404))),
            ],
          ),
          const SizedBox(width: 20),
          Container(width: 1, height: 40, color: const Color(0xFF4A0404).withOpacity(0.2)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF4A0404))),
                const SizedBox(height: 4),
                Text('Deadline: $time', style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF4A0404).withOpacity(0.7))),
              ],
            ),
          ),
          if (_isAdmin)
            IconButton(icon: const Icon(Icons.delete_outline, color: Color(0xFF4A0404), size: 20), onPressed: () => doc.reference.delete()),
        ],
      ),
    );
  }

  Widget _buildMeetingCard(DocumentSnapshot doc, String title, String team, String date, String time, String location, IconData icon, Color iconBg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.white, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(team, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              if (_isAdmin)
                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), onPressed: () => doc.reference.delete()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text('$date • $time', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[700])),
              const SizedBox(width: 16),
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(child: Text(location, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[700]), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleRSVP(String eventId, List attendees) async {
    final uid = _user?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('events').doc(eventId);
    if (attendees.contains(uid)) {
      await docRef.update({'attendees': FieldValue.arrayRemove([uid])});
    } else {
      await docRef.update({'attendees': FieldValue.arrayUnion([uid])});
    }
  }
}
