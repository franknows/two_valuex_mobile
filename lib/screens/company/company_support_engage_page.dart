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
  final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('chatGPT');
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  int mills = DateTime.now().millisecondsSinceEpoch;

  QuerySnapshot? _chatsData;

  String prompt =
      'Start a conversation with me as a customer and you being a chat bot named Andreea. (This is all You Need to Know About 2Value. '
      '2Value is a platform designed to bridge the gap between businesses, '
      'especially SMEs, and journalists. It facilitates effective communication and '
      'offers valuable business information. The platform operates with the mission of '
      'globally transforming communication and supporting a community of professionals '
      'rooted in valuable informational communication and shared values. Core Objectives '
      'of 2Value: 1. Powering SMEs in their communication efforts. 2. Providing journalists '
      'with valuable business information. 3. Developing communities based on education '
      'and shared values. Platform Features: For Companies:  - They receive relevant and '
      'easily accessible media content.  - They gain access to relevant communities and '
      'multiple tools.  - They benefit from content written by journalists themselves. For Journalists: '
      '- They receive relevant, up-to-date, and correctly written content.  - They can earn additional income. '
      '- They have access to free courses for professional and personal development. Community Initiatives:1.'
      ' Brands that Value: An initiative powered by Tudor Communication, this community brings together all '
      'participants in mass communication – journalists, company managers, PR professionals, and marketers – '
      'under one roof through events.2. 2Value Reporters: This is committed to guaranteeing quality '
      'content from which journalists can easily select their areas of interest. It also creates '
      'opportunities for journalists to be recognized and rewarded for their true worth.3. Journalist '
      'Academy: At the end of each year, the editorial team will award the most meritorious '
      'journalists active on the 2Value platform in categories such as Journalist of the Year,'
      ' Newcomer of the Year, and Civic Journalist of the Year.Pricing and Packages:1. BE A PUBLISHER-'
      ' Price: 467 € (Or 156 EUR/Month for 3 months; SAVE 15%)- Includes 3 basic press releases, 1 mention,'
      ' 3 links.2. PROMOTE YOUR MESSAGE- Price: 878 € (Or 146 EUR/Month for 6 months; SAVE 20%)- Includes:'
      ' 6 basic press releases, 2 mentions, 1 interview, 6 links.3.GET THE BRAND- Price: 1647 €'
      ' (Or 137 EUR/Month for 12 months; SAVE 25%) - Includes 12 basic press releases, 4 mentions, '
      '3 interviews, 1 press event, 12 links.Demo and Testing:Customers interested in experiencing 2Value'
      ' can request a demo. The platform also offers a free trial so that potential clients can test its'
      ' capabilities firsthand.Contact Information:- Mihaela Raluca Tudor: Founder & CEO - mihaela@2value.ro- '
      'Daniela Teodorescu: Editorial Director - daniela@2value.ro- Aura Matei: Operations Director - aura@2value.roRecognition:2Value '
      'has been recognized for its innovative approach. BUSINESS MAGAZIN listed 2VALUE among the Top Innovative Companies in 2019. '
      'Furthermore, Mihaela Raluca Tudor was awarded by BUSINESS ELITES in the Netherlands as one of the youngest and most innovative '
      'entrepreneurs in communication in 2019.Cookie Policy:2Value ensures a user-friendly experience by using cookies. By continuing '
      'to use the site, users provide their consent.)';

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
        .collection('HelpDesk')
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
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
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
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) async {
    _textController.clear();

    DocumentReference headsDs1 = FirebaseFirestore.instance
        .collection('HelpDesk')
        .doc('ChatSessions')
        .collection('ChatHeads')
        .doc(widget.userId);
    Map<String, dynamic> _headsTask = {
      'session_start_time': FieldValue.serverTimestamp(),
      'session_user_type': 'Company',
      'session_user_id': widget.userId,
      'session_assistant_id': '-',
      'session_need_human': false,
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
        .collection('HelpDesk')
        .doc(widget.userId)
        .collection('Chats')
        .doc();
    Map<String, dynamic> _msgTask = {
      'message_body': text,
      'message_id': customerMsgRef.id,
      'message_time': FieldValue.serverTimestamp(),
      'message_sender': widget.userId,
      'session_time_identifier': mills,
      'message_origin': 'customer',
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
