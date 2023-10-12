import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:two_value/src/theme.dart';

import '../../src/helper_widgets.dart';

class AdminSupportEngagePage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  final String customerId;
  const AdminSupportEngagePage(
      {super.key,
      required this.userId,
      required this.userData,
      required this.customerId});

  @override
  State<AdminSupportEngagePage> createState() => _AdminSupportEngagePageState();
}

class _AdminSupportEngagePageState extends State<AdminSupportEngagePage> {
  String language = '';
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  int mills = DateTime.now().millisecondsSinceEpoch;

  QuerySnapshot? _chatsData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      language = widget.userData['user_language'];
    });
    _getChatData(widget.userId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getChatData(String userId) {
    FirebaseFirestore.instance
        .collection('XHelpDesk')
        .doc(widget.customerId)
        .collection('Chats')
        // .where('session_time_identifier', isEqualTo: mills)
        .orderBy('message_time', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (mounted) {
        setState(() {
          _chatsData =
              snapshot; // Store all documents in the collection snapshot
          // Clear previous messages
          _messages.clear();

          // Extract message details from each document and add to _messages
          for (var doc in _chatsData!.docs) {
            final messageContent = doc['message_body'];
            final messageSender = doc['message_sender'];
            final messageType = messageSender == widget.userId
                ? MessageType.user
                : messageSender == 'assistant'
                    ? MessageType.bot
                    : MessageType.other;

            _messages.add(Message(text: messageContent, type: messageType));
          }
          print('object');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: TAppTheme.primaryColor,
          elevation: 4,
          title: Text(
            language == 'ro' ? 'Suport' : 'Support',
            style: GoogleFonts.quicksand(
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                letterSpacing: .5,
              ),
            ),
          ),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Center(
              child: InkWell(
                onTap: () {
                  DocumentReference headsDs1 = FirebaseFirestore.instance
                      .collection('XHelpDesk')
                      .doc('ChatSessions')
                      .collection('ChatHeads')
                      .doc(widget.customerId);
                  Map<String, dynamic> headsTask = {
                    'session_need_human': false,
                  };
                  headsDs1.update(headsTask).whenComplete(
                    () {
                      print('Session ended');
                    },
                  );

                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6.0),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.xmark_square,
                          size: 14,
                        ),
                        addHorizontalSpace(10),
                        whiteNormalText('End session')
                      ],
                    ),
                  ),
                ),
              ),
            ),
            addHorizontalSpace(20),
          ],
        ),
        body: Column(
          children: <Widget>[
            (_chatsData == null || _chatsData!.docs.isEmpty)
                ? Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.info,
                            size: 24,
                            color: Colors.grey.withOpacity(.4),
                          ),
                          addVerticalSpace(20),
                          greyBoldTextCenter(
                            language == 'ro'
                                ? 'Rămâneți pe pagină'
                                : 'Stay on the page',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          greyNormalTextCenter(
                            language == 'ro'
                                ? 'Vă rugăm să păstrați această pagină activă.\nRelansarea va începe o nouă sesiune de chat.'
                                : 'Please keep this page active.\nRelaunching will start a new chat session.',
                          ),
                        ],
                      ),
                    ),
                  )
                : Flexible(
                    child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (_, int index) => _messages[index],
                    ),
                  ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: TAppTheme.primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                    letterSpacing: .5,
                  ),
                ),
                decoration: inputDecorationChatBox(
                    language == 'ro' ? 'Trimite un mesaj' : 'Send a message'),
                // decoration: InputDecoration(
                //   hintText: "Send a message",
                //   contentPadding: const EdgeInsets.symmetric(
                //     vertical: 8.0,
                //     horizontal: 4.0,
                //   ),
                // ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _handleSubmitted(_textController.text);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) async {
    _textController.clear();

    DocumentReference headsDs1 = FirebaseFirestore.instance
        .collection('XHelpDesk')
        .doc('ChatSessions')
        .collection('ChatHeads')
        .doc(widget.customerId);
    Map<String, dynamic> headsTask = {
      'session_start_time': FieldValue.serverTimestamp(),
      'session_user_type': 'Company',
      'session_user_id': widget.customerId,
      'session_assistant_id': '-',
      'session_need_human': true,
      'session_last_message': text,
      'session_last_sync': FieldValue.serverTimestamp(),
      'session_id': headsDs1.id,
    };
    headsDs1.set(headsTask, SetOptions(merge: true)).whenComplete(
      () {
        print('Chat head created');
      },
    );

    //send customers message to database
    DocumentReference customerMsgRef = FirebaseFirestore.instance
        .collection('XHelpDesk')
        .doc(widget.customerId)
        .collection('Chats')
        .doc();
    Map<String, dynamic> msgTask = {
      'message_body': text,
      'message_id': customerMsgRef.id,
      'message_time': FieldValue.serverTimestamp(),
      'message_sender': widget.userId,
      'session_time_identifier': mills,
      'message_origin': 'user_user',
      'message_extra': '-',
    };
    customerMsgRef.set(msgTask);
  }
}

enum MessageType { user, bot, other }

class Message extends StatelessWidget {
  final String text;
  final MessageType type;

  Message({required this.text, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: type == MessageType.user
          ? BubbleSpecialThree(
              text: text,
              color: const Color(0xFFb6d7a8),
              tail: true,
              isSender: true,
              textStyle: GoogleFonts.quicksand(
                color: Colors.black87,
                fontSize: 14,
                letterSpacing: .5,
              ),
            )
          : type == MessageType.other
              ? BubbleSpecialThree(
                  text: text,
                  color: const Color(0xFFdaf2fb),
                  tail: true,
                  isSender: false,
                  textStyle: GoogleFonts.quicksand(
                    color: Colors.black87,
                    fontSize: 14,
                    letterSpacing: .5,
                  ),
                )
              : BubbleSpecialThree(
                  text: text,
                  color: const Color(0xFFE8E8EE),
                  tail: true,
                  isSender: false,
                  textStyle: GoogleFonts.quicksand(
                    color: Colors.black87,
                    fontSize: 14,
                    letterSpacing: .5,
                  ),
                ),
    );
  }
}
