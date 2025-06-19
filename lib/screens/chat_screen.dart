import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:the_help_loop_master/generated/l10n.dart';
import 'base_scaffold.dart';
import 'font_styles.dart';

class ChatScreen extends StatefulWidget {
  final String bookingId;
  final String toUserId;
  final String? toUserName;
  final String? toUserPhoto;

  const ChatScreen({
    super.key,
    required this.bookingId,
    required this.toUserId,
    this.toUserName,
    this.toUserPhoto,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool _otherUserIsTyping = false;
  int _unreadMessagesCount = 0;
  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;
  Timer? _typingTimer;
  StreamSubscription<QuerySnapshot>? _messagesSubscription;

  String? _toUserName;
  String? _toUserPhoto;
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _typingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _typingAnimationController,
      curve: Curves.easeInOut,
    ));
    _typingAnimationController.repeat(reverse: true);

    _toUserName = widget.toUserName;
    _toUserPhoto = widget.toUserPhoto;
    _currentUserName = currentUser.displayName;

    _fetchUserInformation();

    _listenToTypingStatus();

    _listenToMessages();

    _calculateUnreadMessages();
  }

  Future<void> _fetchUserInformation() async {
    try {
      if (_toUserName == null || _toUserPhoto == null) {
        final toUserDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.toUserId)
            .get();

        if (toUserDoc.exists) {
          final userData = toUserDoc.data() as Map<String, dynamic>;
          setState(() {
            _toUserName = userData['name'] ?? S.of(context).unknown;
            _toUserPhoto = userData['profilePicture'];
          });
        }
      }

      if (_currentUserName == null) {
        final currentUserDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (currentUserDoc.exists) {
          final userData = currentUserDoc.data() as Map<String, dynamic>;
          setState(() {
            _currentUserName = userData['name'] ?? S.of(context).unknown;
          });
        }
      }
    } catch (e) {
      print('Error fetching user information: $e');
    }
  }

  void _listenToMessages() {
    _messagesSubscription = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.bookingId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      _markNewMessagesAsRead(snapshot.docs);
    });
  }

  void _markNewMessagesAsRead(List<QueryDocumentSnapshot> messages) {
    final batch = FirebaseFirestore.instance.batch();
    bool hasUpdates = false;

    for (var doc in messages) {
      final data = doc.data() as Map<String, dynamic>;
      final senderId = data['senderId'] as String?;
      final readBy = List<String>.from(data['readBy'] ?? []);

      if (senderId != currentUser.uid && !readBy.contains(currentUser.uid)) {
        readBy.add(currentUser.uid);
        batch.update(doc.reference, {'readBy': readBy});
        hasUpdates = true;
      }
    }

    if (hasUpdates) {
      batch.commit().catchError((error) {
        print('Error updating read status: $error');
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    _typingTimer?.cancel();
    _messagesSubscription?.cancel();

    _updateTypingStatus(false);
    super.dispose();
  }

  void _listenToTypingStatus() {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.bookingId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          final typingUsers =
              data['typingUsers'] as Map<String, dynamic>? ?? {};
          final otherUserTyping =
              typingUsers[widget.toUserId] as bool? ?? false;

          if (mounted) {
            setState(() {
              _otherUserIsTyping = otherUserTyping;
            });
          }
        }
      }
    });
  }

  void _updateTypingStatus(bool isTyping) {
    FirebaseFirestore.instance.collection('chats').doc(widget.bookingId).set({
      'typingUsers': {
        currentUser.uid: isTyping,
      }
    }, SetOptions(merge: true));
  }

  void _calculateUnreadMessages() {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.bookingId)
        .collection('messages')
        .where('senderId', isEqualTo: widget.toUserId)
        .snapshots()
        .listen((snapshot) {
      int unreadCount = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final readBy = List<String>.from(data['readBy'] ?? []);
        if (!readBy.contains(currentUser.uid)) {
          unreadCount++;
        }
      }

      if (mounted) {
        setState(() {
          _unreadMessagesCount = unreadCount;
        });
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  MessageStatus _getMessageStatus(Map<String, dynamic> data) {
    final deliveredTo = List<String>.from(data['deliveredTo'] ?? []);
    final readBy = List<String>.from(data['readBy'] ?? []);

    if (readBy.contains(widget.toUserId)) {
      return MessageStatus.read;
    } else if (deliveredTo.contains(widget.toUserId)) {
      return MessageStatus.delivered;
    } else {
      return MessageStatus.sent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.bookingId)
        .collection('messages')
        .orderBy('timestamp', descending: false);

    return BaseScaffold(
      title: _toUserName ?? S.of(context).chat,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _toUserName ?? S.of(context).chat,
              style: FontStyles.heading(context,
                  color: Colors.white, fontSize: 18),
            ),
            if (_otherUserIsTyping)
              Text(
                S.of(context).typingNowDots,
                style: FontStyles.body(
                  context,
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: false,
        actions: [
          if (_unreadMessagesCount > 0)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_unreadMessagesCount',
                style: FontStyles.body(
                  context,
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withOpacity(0.3),
              backgroundImage:
              _toUserPhoto != null ? NetworkImage(_toUserPhoto!) : null,
              child: _toUserPhoto == null
                  ? Icon(Icons.person, color: Colors.white, size: 20)
                  : null,
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      S.of(context).errorLoadingMessages,
                      style: FontStyles.body(context, color: Colors.white),
                    ),
                  );
                }

                final messages = snapshot.data?.docs ?? [];

                if (messages.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                }

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).startConversation,
                          style: FontStyles.body(
                            context,
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          S.of(context).sendFirstMessage,
                          style: FontStyles.body(
                            context,
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (_otherUserIsTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length && _otherUserIsTyping) {
                      return _buildTypingIndicator();
                    }

                    final messageDoc = messages[index];
                    final data = messageDoc.data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == currentUser.uid;

                    return _buildMessageBubble(
                      text: data['text'] ?? '',
                      isMe: isMe,
                      senderName: data['senderName'] ??
                          (isMe
                              ? (_currentUserName ?? S.of(context).you)
                              : (_toUserName ?? S.of(context).unknown)),
                      timestamp: data['timestamp'] as Timestamp?,
                      messageStatus: isMe ? _getMessageStatus(data) : null,
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

  Widget _buildMessageBubble({
    required String text,
    required bool isMe,
    required String senderName,
    Timestamp? timestamp,
    MessageStatus? messageStatus,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 50, bottom: 4),
              child: Text(
                senderName,
                style: FontStyles.body(
                  context,
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          Row(
            mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  backgroundImage:
                  _toUserPhoto != null ? NetworkImage(_toUserPhoto!) : null,
                  child: _toUserPhoto == null
                      ? Icon(Icons.person, color: Colors.white, size: 16)
                      : null,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe
                        ? const Color(0xFF075E54)
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 6),
                      bottomRight: Radius.circular(isMe ? 6 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        text,
                        style: FontStyles.body(
                          context,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (timestamp != null)
                            Text(
                              _formatTimestamp(timestamp),
                              style: FontStyles.body(
                                context,
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                          if (isMe && messageStatus != null) ...[
                            const SizedBox(width: 4),
                            _buildMessageStatusIcon(messageStatus),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          color: Colors.white.withOpacity(0.7),
          size: 16,
        );
      case MessageStatus.delivered:
        return Icon(
          Icons.done_all,
          color: Colors.white.withOpacity(0.7),
          size: 16,
        );
      case MessageStatus.read:
        return Icon(
          Icons.done_all,
          color: const Color(0xFF4FC3F7),
          size: 16,
        );
    }
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white.withOpacity(0.3),
            backgroundImage:
            _toUserPhoto != null ? NetworkImage(_toUserPhoto!) : null,
            child: _toUserPhoto == null
                ? Icon(Icons.person, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).typingNow,
                  style: FontStyles.body(
                    context,
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedBuilder(
                  animation: _typingAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _typingAnimation.value,
                      child: Text(
                        '...',
                        style: FontStyles.body(
                          context,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.attach_file,
              color: Colors.white70,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).attachmentsUnderDevelopment),
                  backgroundColor: const Color(0xFF25D366),
                ),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              style: FontStyles.body(context, color: Colors.white),
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: S.of(context).writeYourMessage,
                hintStyle: FontStyles.body(
                  context,
                  color: Colors.white.withOpacity(0.6),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (text) {
                if (text.isNotEmpty) {
                  _updateTypingStatus(true);

                  _typingTimer?.cancel();
                  _typingTimer = Timer(const Duration(seconds: 3), () {
                    _updateTypingStatus(false);
                  });
                } else {
                  _updateTypingStatus(false);
                  _typingTimer?.cancel();
                }
              },
              onSubmitted: (text) => _sendMessage(),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF25D366),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _updateTypingStatus(false);
    _typingTimer?.cancel();

    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.bookingId)
        .collection('messages')
        .add({
      'senderId': currentUser.uid,
      'senderName': _currentUserName ?? currentUser.displayName ?? S.of(context).unknown,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'deliveredTo': [currentUser.uid],
      'readBy': [],
    }).then((docRef) {
      Timer(const Duration(seconds: 1), () {
        docRef.update({
          'deliveredTo': [currentUser.uid, widget.toUserId]
        });
      });
    });

    _controller.clear();

    _scrollToBottom();
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${dateTime.day}/${dateTime.month}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}${S.of(context).hoursAbbreviation}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}${S.of(context).minutesAbbreviation}';
    } else {
      return S.of(context).now;
    }
  }
}

enum MessageStatus {
  sent,
  delivered,
  read,
}