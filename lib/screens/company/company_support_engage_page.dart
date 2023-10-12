import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:two_value/src/theme.dart';

import '../../src/helper_widgets.dart';

class CompanySupportEngagePage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const CompanySupportEngagePage(
      {super.key, required this.userId, required this.userData});

  @override
  State<CompanySupportEngagePage> createState() =>
      _CompanySupportEngagePageState();
}

class _CompanySupportEngagePageState extends State<CompanySupportEngagePage> {
  String language = '';
  String origin = 'user_assistant';
  final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('chatGPT');
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
        .doc(userId)
        .collection('Chats')
        .where('session_time_identifier', isEqualTo: mills)
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
                : MessageType.bot;

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
                  if (origin == 'user_assistant') {
                    setState(() {
                      origin = 'user_user';
                    });
                    _waitingResponse(
                        language == 'ro'
                            ? 'Vă mulțumim că ne-ați contactat. Vă rugăm să aveți răbdare în timp ce vă conectăm la un asistent în direct care vă va ajuta în curând. Apreciem înțelegerea dvs. Vă rugăm să rețineți că închiderea chatului vă va obliga să începeți procesul de la început. Suntem angajați să vă ajutăm cât mai curând posibil.'
                            : 'Thank you for reaching out to us. Please be patient as we connect you to a live assistant who will assist you shortly. We appreciate your understanding. Kindly note that closing the chat will require you to start the process over again. We are committed to helping you as soon as possible.',
                        'user_user');
                  } else {
                    setState(() {
                      origin = 'user_assistant';
                    });
                  }
                },
                child: origin == 'user_assistant'
                    ? Container(
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
                                CupertinoIcons.person,
                                size: 14,
                              ),
                              addHorizontalSpace(10),
                              whiteNormalText('Chat with human')
                            ],
                          ),
                        ),
                      )
                    : Container(
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
                                CupertinoIcons.captions_bubble,
                                size: 14,
                              ),
                              addHorizontalSpace(10),
                              whiteNormalText('Chat with bot')
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
                      padding: const EdgeInsets.all(8.0),
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (_, int index) => _messages[index],
                    ),
                  ),
            const Divider(height: 1.0),
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
                onSubmitted: (text) => _handleSubmitted(text, origin),
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
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _handleSubmitted(_textController.text, origin);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text, String origin) async {
    _textController.clear();

    DocumentReference headsDs1 = FirebaseFirestore.instance
        .collection('XHelpDesk')
        .doc('ChatSessions')
        .collection('ChatHeads')
        .doc(widget.userId);
    Map<String, dynamic> _headsTask = {
      'session_start_time': FieldValue.serverTimestamp(),
      'session_user_type': 'Company',
      'session_user_id': widget.userId,
      'session_assistant_id': '-',
      'session_need_human': origin == 'user_user',
      'session_last_message': text,
      'session_last_sync': FieldValue.serverTimestamp(),
      'session_id': headsDs1.id,
    };
    headsDs1.set(_headsTask, SetOptions(merge: true)).whenComplete(
      () {
        print('Chat head created');
      },
    );

    //send customers message to database
    DocumentReference customerMsgRef = FirebaseFirestore.instance
        .collection('XHelpDesk')
        .doc(widget.userId)
        .collection('Chats')
        .doc();
    Map<String, dynamic> _msgTask = {
      'message_body': text,
      'message_id': customerMsgRef.id,
      'message_time': FieldValue.serverTimestamp(),
      'message_sender': widget.userId,
      'session_time_identifier': mills,
      'message_origin': origin,
      'message_extra': '-',
    };
    customerMsgRef.set(_msgTask);
  }

  void _waitingResponse(String text, String origin) async {
    _textController.clear();

    DocumentReference headsDs1 = FirebaseFirestore.instance
        .collection('XHelpDesk')
        .doc('ChatSessions')
        .collection('ChatHeads')
        .doc(widget.userId);
    Map<String, dynamic> _headsTask = {
      'session_start_time': FieldValue.serverTimestamp(),
      'session_user_type': 'Company',
      'session_user_id': widget.userId,
      'session_assistant_id': '-',
      'session_need_human': true,
      'session_last_message': text,
      'session_last_sync': FieldValue.serverTimestamp(),
      'session_id': headsDs1.id,
    };
    headsDs1.set(_headsTask, SetOptions(merge: true)).whenComplete(
      () {
        print('Chat head created');
      },
    );

    //send customers message to database
    DocumentReference customerMsgRef = FirebaseFirestore.instance
        .collection('XHelpDesk')
        .doc(widget.userId)
        .collection('Chats')
        .doc();
    Map<String, dynamic> _msgTask = {
      'message_body': text,
      'message_id': customerMsgRef.id,
      'message_time': FieldValue.serverTimestamp(),
      'message_sender': 'assistant',
      'session_time_identifier': mills,
      'message_origin': origin,
      'message_extra': '-',
    };
    customerMsgRef.set(_msgTask);
  }
}

enum MessageType { user, bot }

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
              color: const Color(0xFF1B97F3),
              tail: true,
              isSender: true,
              textStyle: GoogleFonts.quicksand(
                color: Colors.white,
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
