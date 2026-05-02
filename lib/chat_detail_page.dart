import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'group_details_page.dart';

class ChatDetailPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final IconData? icon;
  final String initials;
  final Color avatarBg;
  final String chatId;
  final Query membersQuery;

  const ChatDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.chatId,
    required this.membersQuery,
    this.imagePath = '',
    this.icon,
    this.initials = '',
    this.avatarBg = Colors.grey,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final User? _user = FirebaseAuth.instance.currentUser;

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final text = _messageController.text.trim();
    _messageController.clear();

    // Fetch user name for the message
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
    final senderName = userDoc.exists ? (userDoc.get('name') ?? 'Unknown') : 'Unknown';

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': _user?.uid,
      'senderName': senderName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupDetailsPage(
                  title: widget.title,
                  chatId: widget.chatId,
                  membersQuery: widget.membersQuery,
                  initials: widget.initials,
                  avatarBg: widget.avatarBg,
                  icon: widget.icon,
                ),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: widget.imagePath.isNotEmpty ? Colors.transparent : widget.avatarBg,
                backgroundImage: widget.imagePath.isNotEmpty ? AssetImage(widget.imagePath) : null,
                child: widget.imagePath.isEmpty
                    ? (widget.icon != null
                        ? Icon(widget.icon, color: Colors.white, size: 20)
                        : Text(
                            widget.initials.isNotEmpty 
                              ? widget.initials 
                              : widget.title.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase(),
                            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
                          ))
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.outfit(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call_outlined, color: Colors.black87), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam_outlined, color: Colors.black87), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet.\nStart the conversation!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                final messages = snapshot.data!.docs;
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final doc = messages[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == _user?.uid;
                    final timestamp = data['timestamp'] as Timestamp?;
                    final timeStr = timestamp != null ? DateFormat('hh:mm a').format(timestamp.toDate()) : '...';
                    final String type = data['type'] ?? 'text';

                    Widget messageContent;
                    if (type == 'poll') {
                      messageContent = _buildPollMessage(doc, data, isMe);
                    } else if (type == 'task') {
                      messageContent = _buildTaskMessage(data, isMe);
                    } else if (type == 'meeting') {
                      messageContent = _buildMeetingMessage(data, isMe);
                    } else {
                      messageContent = Text(
                        data['text'] ?? '',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: isMe ? Colors.white : Colors.black87,
                          height: 1.4,
                        ),
                      );
                    }

                    if (isMe) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildSentMessage(
                          content: messageContent,
                          time: timeStr,
                          isCustomType: type != 'text',
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildReceivedMessage(
                          senderName: data['senderName'] ?? 'Unknown',
                          content: messageContent,
                          time: timeStr,
                          initials: (data['senderName'] as String?)?.split(' ').map((e) => e[0]).take(2).join().toUpperCase() ?? '?',
                          isCustomType: type != 'text',
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Collaborate', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachmentOption(Icons.poll_outlined, 'Poll', Colors.orange, _showCreatePollDialog),
                _buildAttachmentOption(Icons.assignment_outlined, 'Task', Colors.blue, _showAssignTaskDialog),
                _buildAttachmentOption(Icons.calendar_today_outlined, 'Meeting', Colors.green, _showScheduleMeetingDialog),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showCreatePollDialog() {
    final questionController = TextEditingController();
    final List<TextEditingController> optionControllers = [TextEditingController(), TextEditingController()];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Create Poll', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: questionController, decoration: const InputDecoration(hintText: 'Question')),
                const SizedBox(height: 16),
                ...optionControllers.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(controller: c, decoration: const InputDecoration(hintText: 'Option')),
                )),
                TextButton.icon(
                  onPressed: () => setState(() => optionControllers.add(TextEditingController())),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Option'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final options = optionControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList();
                if (questionController.text.isEmpty || options.length < 2) return;

                final userDoc = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
                final senderName = userDoc.get('name') ?? 'Unknown';

                await FirebaseFirestore.instance.collection('groups').doc(widget.chatId).collection('messages').add({
                  'type': 'poll',
                  'text': questionController.text,
                  'options': options,
                  'votes': {}, // uid: optionIndex
                  'senderId': _user?.uid,
                  'senderName': senderName,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignTaskDialog() {
    final titleController = TextEditingController();
    String? selectedMemberId;
    String? selectedMemberName;
    DateTime deadline = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Assign Task', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(hintText: 'Task Title')),
              const SizedBox(height: 16),
              FutureBuilder<QuerySnapshot>(
                future: widget.membersQuery.get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final members = snapshot.data!.docs;
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(hintText: 'Select Member'),
                    value: selectedMemberId,
                    items: members.map((m) {
                      final data = m.data() as Map<String, dynamic>;
                      return DropdownMenuItem(
                        value: m.id,
                        child: Text(data['name'] ?? 'Unknown'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedMemberId = val;
                        selectedMemberName = (members.firstWhere((m) => m.id == val).data() as Map<String, dynamic>)['name'];
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Deadline'),
                subtitle: Text(DateFormat('MMM d, yyyy').format(deadline)),
                onTap: () async {
                  final picked = await showDatePicker(context: context, initialDate: deadline, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
                  if (picked != null) setState(() => deadline = picked);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty || selectedMemberId == null) return;
                final userDoc = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
                final senderName = userDoc.get('name') ?? 'Unknown';

                await FirebaseFirestore.instance.collection('groups').doc(widget.chatId).collection('messages').add({
                  'type': 'task',
                  'text': titleController.text,
                  'assigneeId': selectedMemberId,
                  'assigneeName': selectedMemberName,
                  'deadline': Timestamp.fromDate(deadline),
                  'status': 'Pending',
                  'senderId': _user?.uid,
                  'senderName': senderName,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Assign'),
            ),
          ],
        ),
      ),
    );
  }

  void _showScheduleMeetingDialog() {
    final titleController = TextEditingController();
    final locController = TextEditingController();
    final linkController = TextEditingController();
    bool isOnline = true;
    DateTime meetingTime = DateTime.now().add(const Duration(hours: 1));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Schedule Meeting', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(hintText: 'Meeting Title')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Type:', style: GoogleFonts.outfit()),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      label: const Text('Online'),
                      selected: isOnline,
                      onSelected: (val) => setState(() => isOnline = val),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Offline'),
                      selected: !isOnline,
                      onSelected: (val) => setState(() => isOnline = !val),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (isOnline)
                  TextField(controller: linkController, decoration: const InputDecoration(hintText: 'Google Meet Link'))
                else
                  TextField(controller: locController, decoration: const InputDecoration(hintText: 'Location')),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Time'),
                  subtitle: Text(DateFormat('MMM d, h:mm a').format(meetingTime)),
                  contentPadding: EdgeInsets.zero,
                  onTap: () async {
                    final d = await showDatePicker(context: context, initialDate: meetingTime, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)));
                    if (d != null) {
                      final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(meetingTime));
                      if (t != null) setState(() => meetingTime = DateTime(d.year, d.month, d.day, t.hour, t.minute));
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty) return;
                final userDoc = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
                final senderName = userDoc.get('name') ?? 'Unknown';

                // Add to events collection
                await FirebaseFirestore.instance.collection('events').add({
                  'title': titleController.text,
                  'category': 'Meeting',
                  'dateTime': Timestamp.fromDate(meetingTime),
                  'location': isOnline ? 'Online' : locController.text,
                  'link': isOnline ? linkController.text : '',
                  'attendees': [],
                  'organizerId': _user?.uid,
                });

                await FirebaseFirestore.instance.collection('groups').doc(widget.chatId).collection('messages').add({
                  'type': 'meeting',
                  'text': titleController.text,
                  'isOnline': isOnline,
                  'location': isOnline ? 'Online' : locController.text,
                  'link': isOnline ? linkController.text : '',
                  'time': Timestamp.fromDate(meetingTime),
                  'senderId': _user?.uid,
                  'senderName': senderName,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Schedule'),
            ),
          ],
        ),
      ),
    );
  }

  void _showVotersBottomSheet(Map<String, dynamic> data) {
    final List options = data['options'] ?? [];
    final Map votes = data['votes'] ?? {};

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Poll Results', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final List voters = votes.entries.where((e) => e.value == index).map((e) => e.key).toList();
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(option, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16)),
                      ),
                      if (voters.isEmpty)
                        Text('No votes yet', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13))
                      else
                        ...voters.map((uid) => FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const SizedBox.shrink();
                            final name = snapshot.data!.get('name') ?? 'Unknown';
                            return Padding(
                              padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(name, style: GoogleFonts.outfit(fontSize: 14)),
                                ],
                              ),
                            );
                          },
                        )),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollMessage(DocumentSnapshot doc, Map<String, dynamic> data, bool isMe) {
    final List options = data['options'] ?? [];
    final Map votes = data['votes'] ?? {};
    final String question = data['text'] ?? '';
    final myVote = votes[_user?.uid];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: isMe ? Colors.white : Colors.black87)),
        const SizedBox(height: 12),
        ...options.asMap().entries.map((entry) {
          int idx = entry.key;
          String option = entry.value;
          int voteCount = votes.values.where((v) => v == idx).length;
          double percent = votes.isEmpty ? 0 : voteCount / votes.length;
          bool isMyVote = myVote == idx;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () {
                doc.reference.update({'votes.${_user?.uid}': idx});
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(option, style: GoogleFonts.outfit(fontSize: 13, color: isMe ? Colors.white : Colors.black87))),
                      Text('${(percent * 100).toInt()}%', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: isMe ? Colors.white70 : Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percent,
                      backgroundColor: isMe ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(isMyVote ? (isMe ? Colors.white : Colors.blue) : (isMe ? Colors.white70 : Colors.grey[400]!)),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => _showVotersBottomSheet(data),
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 30)),
          child: Text('View Results', style: GoogleFonts.outfit(fontSize: 12, color: isMe ? Colors.white70 : Colors.blue, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildTaskMessage(Map<String, dynamic> data, bool isMe) {
    final deadline = (data['deadline'] as Timestamp?)?.toDate();
    final assigneeName = data['assigneeName'] ?? 'Anyone';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.assignment_outlined, size: 16, color: isMe ? Colors.white70 : Colors.blue),
            const SizedBox(width: 8),
            Text('TASK ASSIGNED', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: isMe ? Colors.white70 : Colors.blue, letterSpacing: 1)),
          ],
        ),
        const SizedBox(height: 8),
        Text(data['text'] ?? '', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: isMe ? Colors.white : Colors.black87)),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.person_outline, size: 12, color: isMe ? Colors.white70 : Colors.grey[600]),
            const SizedBox(width: 4),
            Text('To: $assigneeName', style: GoogleFonts.outfit(fontSize: 12, color: isMe ? Colors.white70 : Colors.grey[600])),
          ],
        ),
        if (deadline != null)
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: isMe ? Colors.white70 : Colors.grey[600]),
              const SizedBox(width: 4),
              Text('Due: ${DateFormat('MMM d, yyyy').format(deadline)}', style: GoogleFonts.outfit(fontSize: 12, color: isMe ? Colors.white70 : Colors.grey[600])),
            ],
          ),
      ],
    );
  }

  Widget _buildMeetingMessage(Map<String, dynamic> data, bool isMe) {
    final time = (data['time'] as Timestamp?)?.toDate();
    final String link = data['link'] ?? '';
    final bool isOnline = data['isOnline'] ?? false;
    
    bool isNow = false;
    if (time != null) {
      isNow = DateTime.now().isAfter(time.subtract(const Duration(minutes: 5)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 16, color: isMe ? Colors.white70 : Colors.green),
            const SizedBox(width: 8),
            Text('MEETING SCHEDULED', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: isMe ? Colors.white70 : Colors.green, letterSpacing: 1)),
          ],
        ),
        const SizedBox(height: 8),
        Text(data['text'] ?? '', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: isMe ? Colors.white : Colors.black87)),
        const SizedBox(height: 4),
        if (time != null)
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: isMe ? Colors.white70 : Colors.grey[600]),
              const SizedBox(width: 4),
              Text(DateFormat('MMM d, h:mm a').format(time), style: GoogleFonts.outfit(fontSize: 12, color: isMe ? Colors.white70 : Colors.grey[600])),
            ],
          ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(isOnline ? Icons.videocam_outlined : Icons.location_on_outlined, size: 12, color: isMe ? Colors.white70 : Colors.grey[600]),
            const SizedBox(width: 4),
            Text(data['location'] ?? 'Online', style: GoogleFonts.outfit(fontSize: 12, color: isMe ? Colors.white70 : Colors.grey[600])),
          ],
        ),
        if (isOnline && link.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Here you would use url_launcher
                // launchUrlString(link);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isNow ? Colors.green : (isMe ? Colors.white.withValues(alpha: 0.2) : Colors.grey[200]),
                foregroundColor: isNow ? Colors.white : (isMe ? Colors.white : Colors.green),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                isNow ? 'Join Now' : 'Join at ${DateFormat('h:mm a').format(time!)}',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildReceivedMessage({
    required String senderName,
    required Widget content,
    required String time,
    required String initials,
    bool isCustomType = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFF4A0404).withValues(alpha: 0.1),
          child: Text(initials, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF4A0404))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                senderName,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFDE8E8),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: content,
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildSentMessage({required Widget content, required String time, bool isCustomType = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 40),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF4A0404),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: content,
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFDE8E8),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.grey),
              onPressed: _showAttachmentMenu,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: GoogleFonts.outfit(color: Colors.grey[500]),
                    border: InputBorder.none,
                    suffixIcon: const Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.grey),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF4A0404),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
