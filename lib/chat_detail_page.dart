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

  // Selection & Action State
  Set<String> _selectedMessageIds = {};
  Map<String, Map<String, dynamic>> _selectedMessagesData = {};
  bool _isSelectionMode = false;

  Timestamp? _userJoinDate;

  @override
  void initState() {
    super.initState();
    _selectedMessageIds = {};
    _selectedMessagesData = {};
    _markAsRead();
    _fetchUserJoinDate();
  }

  void _fetchUserJoinDate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()!.containsKey('createdAt')) {
        setState(() {
          _userJoinDate = doc.get('createdAt') as Timestamp?;
        });
      }
    }
  }

  void _markAsRead() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('last_reads')
          .doc(widget.chatId)
          .set({'timestamp': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    }
  }

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
      'groupId': widget.chatId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageStream = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.chatId)
        .collection('messages')
        .where('timestamp', isGreaterThanOrEqualTo: _userJoinDate ?? Timestamp.fromMillisecondsSinceEpoch(0))
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: AppBar(
        backgroundColor: _isSelectionMode ? const Color(0xFF4A0404) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: _clearSelection,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
        title: _isSelectionMode
            ? Text(
                '${_selectedMessageIds.length} selected',
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
              )
            : GestureDetector(
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
        actions: _isSelectionMode
            ? [
                if (_canEditSelected())
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                    onPressed: _showEditDialog,
                  ),
                if (_canDeleteSelected())
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    onPressed: _deleteSelectedMessages,
                  ),
                const SizedBox(width: 8),
              ]
            : [
                IconButton(icon: const Icon(Icons.call_outlined, color: Colors.black87), onPressed: () {}),
                IconButton(icon: const Icon(Icons.videocam_outlined, color: Colors.black87), onPressed: () {}),
                const SizedBox(width: 8),
              ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messageStream,
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

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final doc = messages[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == _user?.uid;
                    final timestamp = data['timestamp'] as Timestamp?;
                    final timeStr = timestamp != null ? DateFormat('hh:mm a').format(timestamp.toDate()) : '...';
                    final String type = data['type']?.toString() ?? 'text';

                    Widget messageContent;
                    if (type == 'poll') {
                      messageContent = _buildPollMessage(doc, data, isMe, type != 'text');
                    } else if (type == 'task') {
                      messageContent = _buildTaskMessage(doc, data, isMe, type != 'text');
                    } else if (type == 'meeting') {
                      messageContent = _buildMeetingMessage(data, isMe, type != 'text');
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

                    final reactions = data['reactions'] as Map<String, dynamic>? ?? {};
                    final isEdited = data['isEdited'] ?? false;

                    Widget messageBubble;
                    if (isMe) {
                      messageBubble = _buildSentMessage(
                        content: messageContent,
                        time: timeStr,
                        isCustomType: type != 'text',
                        reactions: reactions,
                        isEdited: isEdited,
                        isSelected: _selectedMessageIds.contains(doc.id),
                      );
                    } else {
                      messageBubble = _buildReceivedMessage(
                        senderName: data['senderName']?.toString() ?? 'Unknown',
                        content: messageContent,
                        time: timeStr,
                        initials: (data['senderName']?.toString() ?? '').trim().isNotEmpty 
                            ? (data['senderName']!.toString().trim().split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).take(2).join().toUpperCase())
                            : '?',
                        isCustomType: type != 'text',
                        reactions: reactions,
                        isEdited: isEdited,
                        isSelected: _selectedMessageIds.contains(doc.id),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: [
                          GestureDetector(
                            onLongPress: () => _toggleSelection(doc.id, data),
                            onSecondaryTap: () => _toggleSelection(doc.id, data),
                            onTap: () {
                              if (_isSelectionMode) {
                                _toggleSelection(doc.id, data);
                              }
                            },
                            child: messageBubble,
                          ),
                          if (_isSelectionMode && 
                              _selectedMessageIds.length == 1 && 
                              _selectedMessageIds.contains(doc.id))
                            _buildReactionPicker(doc.id),
                        ],
                      ),
                    );
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
                  'groupId': widget.chatId,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A0404),
                foregroundColor: const Color(0xFFFFF5E1),
              ),
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
                    initialValue: selectedMemberId,
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
                  'groupId': widget.chatId,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A0404),
                foregroundColor: const Color(0xFFFFF5E1),
              ),
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
                    if (d != null && context.mounted) {
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
                  'groupId': widget.chatId,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A0404),
                foregroundColor: const Color(0xFFFFF5E1),
              ),
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
            ListView.builder(
              shrinkWrap: true,
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
                                  Text(name, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
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
            ],
          ),
        ),
      );
    }

  Widget _buildPollMessage(DocumentSnapshot doc, Map<String, dynamic> data, bool isMe, bool isCustomType) {
    final List options = data['options'] ?? [];
    final Map votes = data['votes'] ?? {};
    final String question = data['text'] ?? '';
    final myVote = votes[_user?.uid];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(question, style: GoogleFonts.outfit(
          fontWeight: FontWeight.bold, 
          color: isMe ? Colors.white : Colors.black87
        )),
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
                      Expanded(
                        child: Row(
                          children: [
                            if (isMyVote) ...[
                              Icon(
                                Icons.check_circle, 
                                size: 14, 
                                color: isMe ? Colors.white : Colors.blue
                              ),
                              const SizedBox(width: 6),
                            ],
                            Text(option, style: GoogleFonts.outfit(
                              fontSize: 13, 
                              fontWeight: isMyVote ? FontWeight.bold : FontWeight.normal,
                              color: isMe ? Colors.white : Colors.black87
                            )),
                          ],
                        ),
                      ),
                      Text('${(percent * 100).toInt()}%', style: GoogleFonts.outfit(
                        fontSize: 12, 
                        fontWeight: FontWeight.bold, 
                        color: isMe ? Colors.white70 : Colors.grey[600]
                      )),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percent,
                      backgroundColor: isMe 
                        ? Colors.white.withValues(alpha: 0.1) 
                        : Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isMyVote 
                          ? (isMe ? Colors.white : const Color(0xFF4A0404))
                          : (isMe ? Colors.white70 : Colors.grey[400]!)
                      ),
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
          child: Text('View Results', style: GoogleFonts.outfit(
            fontSize: 12, 
            color: isMe ? Colors.white70 : const Color(0xFF4A0404), 
            fontWeight: FontWeight.bold
          )),
        ),
      ],
    );
  }

  Widget _buildTaskMessage(DocumentSnapshot doc, Map<String, dynamic> data, bool isMe, bool isCustomType) {
    final deadline = (data['deadline'] as Timestamp?)?.toDate();
    final assigneeName = data['assigneeName'] ?? 'Anyone';
    final assigneeId = data['assigneeId'];
    final status = data['status'] ?? 'Pending';
    final bool isAssignee = assigneeId == _user?.uid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.assignment_outlined, size: 16, color: isMe ? Colors.white70 : const Color(0xFF4A0404)),
                const SizedBox(width: 8),
                Text('TASK ASSIGNED', style: GoogleFonts.outfit(
                  fontSize: 10, 
                  fontWeight: FontWeight.bold, 
                  color: isMe ? Colors.white70 : const Color(0xFF4A0404), 
                  letterSpacing: 1
                )),
              ],
            ),
            if (status == 'Completed')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                child: Text('DONE', style: GoogleFonts.outfit(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(data['text'] ?? '', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: isMe ? Colors.white : Colors.black87)),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.person_outline, size: 12, color: isMe ? (isCustomType ? Colors.grey[700] : Colors.white70) : Colors.grey[600]),
            const SizedBox(width: 4),
            Text('To: $assigneeName', style: GoogleFonts.outfit(
              fontSize: 12, 
              color: isMe ? Colors.white70 : Colors.grey[600]
            )),
          ],
        ),
        if (deadline != null)
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: isMe ? Colors.white70 : Colors.grey[600]),
              const SizedBox(width: 4),
              Text('Due: ${DateFormat('MMM d, yyyy').format(deadline)}', style: GoogleFonts.outfit(
                fontSize: 12, 
                color: isMe ? Colors.white70 : Colors.grey[600]
              )),
            ],
          ),
        if (isAssignee && status == 'Pending') ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                doc.reference.update({'status': 'Completed'});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isMe ? Colors.white : const Color(0xFF4A0404),
                foregroundColor: isMe ? const Color(0xFF4A0404) : Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 36),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Mark as Completed', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMeetingMessage(Map<String, dynamic> data, bool isMe, bool isCustomType) {
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
            Icon(Icons.calendar_today_outlined, size: 16, color: isMe ? Colors.white70 : const Color(0xFF4A0404)),
            const SizedBox(width: 8),
            Text('MEETING SCHEDULED', style: GoogleFonts.outfit(
              fontSize: 10, 
              fontWeight: FontWeight.bold, 
              color: isMe ? Colors.white70 : const Color(0xFF4A0404), 
              letterSpacing: 1
            )),
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
              Text(DateFormat('MMM d, h:mm a').format(time), style: GoogleFonts.outfit(
                fontSize: 12, 
                color: isMe ? Colors.white70 : Colors.grey[600]
              )),
            ],
          ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(isOnline ? Icons.videocam_outlined : Icons.location_on_outlined, size: 12, color: isMe ? (isCustomType ? Colors.grey[700] : Colors.white70) : Colors.grey[600]),
            const SizedBox(width: 4),
            Text(data['location'] ?? 'Online', style: GoogleFonts.outfit(
              fontSize: 12, 
              color: isMe ? Colors.white70 : Colors.grey[600]
            )),
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
                backgroundColor: isMe ? Colors.white : (isNow ? const Color(0xFF4A0404) : Colors.grey[200]),
                foregroundColor: isMe ? const Color(0xFF4A0404) : (isNow ? const Color(0xFFFFF5E1) : const Color(0xFF4A0404)),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                isNow ? 'Join Now' : (time != null ? 'Join at ${DateFormat('h:mm a').format(time)}' : 'Join Meeting'),
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
    Map<String, dynamic> reactions = const {},
    bool isEdited = false,
    bool isSelected = false,
  }) {
    return Container(
      color: isSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.transparent,
      child: Row(
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
                    fontSize: 13,
                    color: const Color(0xFF4A0404),
                    fontWeight: FontWeight.bold,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      content,
                      if (reactions.isNotEmpty)
                        _buildReactionRow(reactions),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                    if (isEdited) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(edited)',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: Colors.grey[400],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentMessage({
    required Widget content,
    required String time,
    bool isCustomType = false,
    Map<String, dynamic> reactions = const {},
    bool isEdited = false,
    bool isSelected = false,
  }) {
    return Container(
      color: isSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A0404),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      content,
                      if (reactions.isNotEmpty)
                        _buildReactionRow(reactions),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isEdited) ...[
                      Text(
                        '(edited)',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: Colors.grey[400],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      time,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.done_all, size: 14, color: Colors.blue[400]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionRow(Map<String, dynamic> reactions) {
    final counts = <String, int>{};
    for (var r in reactions.values) {
      counts[r.toString()] = (counts[r.toString()] ?? 0) + 1;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 4,
        children: counts.entries.map((e) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('${e.key} ${e.value}', style: const TextStyle(fontSize: 10)),
        )).toList(),
      ),
    );
  }

  Widget _buildReactionPicker(String messageId) {
    final emojis = ['👍', '👎', '❤️', '😂', '😮', '😢'];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: emojis.map((e) => GestureDetector(
          onTap: () => _addReaction(messageId, e),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(e, style: const TextStyle(fontSize: 20)),
          ),
        )).toList(),
      ),
    );
  }

  void _toggleSelection(String id, Map<String, dynamic> data) {
    setState(() {
      if (_selectedMessageIds.contains(id)) {
        _selectedMessageIds.remove(id);
        _selectedMessagesData.remove(id);
        if (_selectedMessageIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _isSelectionMode = true;
        _selectedMessageIds.add(id);
        _selectedMessagesData[id] = data;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _isSelectionMode = false;
      _selectedMessageIds.clear();
      _selectedMessagesData.clear();
    });
  }

  bool _canEditSelected() {
    if (_selectedMessageIds.length != 1) return false;
    final data = _selectedMessagesData[_selectedMessageIds.first]!;
    
    if (data['senderId'] != _user?.uid) return false;
    if (data['type'] != null && data['type'] != 'text') return false;
    
    final timestamp = data['timestamp'] as Timestamp?;
    if (timestamp == null) return false;

    final diff = DateTime.now().difference(timestamp.toDate());
    return diff.inMinutes < 15;
  }

  bool _canDeleteSelected() {
    if (_selectedMessageIds.isEmpty) return false;
    // User can only delete messages they sent
    return _selectedMessageIds.every((id) => _selectedMessagesData[id]?['senderId'] == _user?.uid);
  }

  void _deleteSelectedMessages() async {
    if (_selectedMessageIds.isEmpty) return;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${_selectedMessageIds.length} message(s)?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final batch = FirebaseFirestore.instance.batch();
      final messagesRef = FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.chatId)
          .collection('messages');
      
      for (final id in _selectedMessageIds) {
        batch.delete(messagesRef.doc(id));
      }
      
      await batch.commit();
      _clearSelection();
    }
  }

  void _showEditDialog() {
    if (_selectedMessageIds.length != 1) return;
    final id = _selectedMessageIds.first;
    final data = _selectedMessagesData[id]!;
    final controller = TextEditingController(text: data['text']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Edit your message...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              await FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.chatId)
                  .collection('messages')
                  .doc(id)
                  .update({
                'text': controller.text.trim(),
                'isEdited': true,
              });
              if (context.mounted) {
                Navigator.pop(context);
                _clearSelection();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addReaction(String messageId, String emoji) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.chatId)
        .collection('messages')
        .doc(messageId)
        .update({
          'reactions.${_user?.uid}': emoji,
        });
    
    _clearSelection();
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
