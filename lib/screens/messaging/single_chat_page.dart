import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../src/helper_widgets.dart';
import '../profile/single_person_profile.dart';

class SingleChatPage extends StatefulWidget {
  final DocumentSnapshot myUserInfo;
  final DocumentSnapshot theirUserInfo;
  const SingleChatPage(
      {super.key, required this.myUserInfo, required this.theirUserInfo});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  _SingleChatPageState();

  final TextEditingController _textController = TextEditingController();
  String _sessionId = '-';
  int mSeconds = DateTime.now().millisecondsSinceEpoch;
  Timestamp timestampNow = Timestamp.fromDate(DateTime.now());
  bool themBlocked = false;

  @override
  void initState() {
    getSessionId();
    updateMessagesAsSeen();
    checkIfThemBlocked();
    super.initState();
  }

  checkIfThemBlocked() async {
    bool isBlocked = await isThemBlocked(
        widget.myUserInfo['user_id'], widget.theirUserInfo['user_id']);
    if (isBlocked) {
      // The user is blocked
      setState(() {
        themBlocked = true;
      });
    } else {
      // The user is not blocked
      setState(() {
        themBlocked = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void getSessionId() {
    if (widget.myUserInfo['user_id']
            .compareTo(widget.theirUserInfo['user_id']) >
        0) {
      setState(() {
        _sessionId =
            '${widget.myUserInfo['user_id']}_${widget.theirUserInfo['user_id']}';
      });
    } else {
      setState(() {
        _sessionId =
            '${widget.theirUserInfo['user_id']}_${widget.myUserInfo['user_id']}';
      });
    }
  }

  Future<void> updateMessagesAsSeen() async {
    final query = await FirebaseFirestore.instance
        .collection('Chats')
        .doc('SingleChats')
        .collection(_sessionId)
        .where('message_receiver', isEqualTo: widget.myUserInfo['user_id'])
        .where('message_seen', isEqualTo: false)
        .get();

    for (var doc in query.docs) {
      doc.reference.update(
        {
          'message_seen': true,
        },
      );
    }

    // check if it exist
    DocumentReference myChatHead = FirebaseFirestore.instance
        .collection('Chats')
        .doc('ChatSessions')
        .collection('AllSessions')
        .doc(_sessionId);

    myChatHead.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        // Document exists, update it
        Map<String, dynamic> headsTask = {
          'text_seen_by': FieldValue.arrayUnion([widget.myUserInfo['user_id']]),
        };
        myChatHead.update(headsTask);
      } else {
        // Document does not exist
        // print('Document does not exist');
      }
    }).catchError((error) {
      // Handle any errors
      // print('Error checking if document exists: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xffd3d3d3),
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          image: const DecorationImage(
              image: AssetImage("assets/images/chat_pattern.png"),
              fit: BoxFit.cover,
              opacity: .06),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: const Color(0xff184a45),
            elevation: 4,
            centerTitle: false,
            titleSpacing: 0,
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
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('XUsers')
                    .where('user_id', isEqualTo: widget.myUserInfo['user_id'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    DocumentSnapshot myRealtimeInfo = snapshot.data!.docs[0];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          if (myRealtimeInfo['blocked_users']
                              .contains(widget.theirUserInfo['user_id'])) {
                            openUnblockDialog(
                                widget.myUserInfo, widget.theirUserInfo);
                          } else {
                            openBlockDialog(
                                widget.myUserInfo, widget.theirUserInfo);
                          }
                        },
                        child: const Icon(
                          CupertinoIcons.info_circle,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    ///go to single user profile
                    _openBottomSheet(context);
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFE8E8EE),
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white.withOpacity(.5),
                      backgroundImage: CachedNetworkImageProvider(
                        widget.theirUserInfo['user_image'],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.theirUserInfo['user_name'],
                          style: GoogleFonts.quicksand(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        (widget.theirUserInfo['user_verification']) ==
                                'Verified'
                            ? const Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Icon(
                                  CupertinoIcons.checkmark_seal_fill,
                                  color: Colors.blue,
                                  size: 12,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    miniWhiteText(widget.theirUserInfo['user_location_name'])
                  ],
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Chats')
                    .doc('SingleChats')
                    .collection(_sessionId)
                    .orderBy('message_time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Flexible(
                      child: ListView.builder(
                        //shrinkWrap: true,
                        reverse: true,
                        // physics: NeverScrollableScrollPhysics(),
                        // primary: false,
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot myMessages =
                              snapshot.data!.docs[index];

                          ///my chat bubble
                          if (myMessages['message_sender'] ==
                              widget.myUserInfo['user_id']) {
                            return newSenderChatBubble(myMessages, index,
                                MediaQuery.of(context).size.width);
                          }

                          ///their chat bubble
                          if (myMessages['message_sender'] ==
                              widget.theirUserInfo['user_id']) {
                            if (myMessages['message_seen'] != true) {
                              updateMessagesAsSeen();
                            }
                            return newReceiverChatBubble(myMessages, index,
                                MediaQuery.of(context).size.width);
                          }

                          ///time group bubble
                          if (myMessages['message_sender'] ==
                              'my_daytime_${widget.myUserInfo['user_id']}') {
                            return timeChatBubble(myMessages, index,
                                MediaQuery.of(context).size.width);
                          }

                          ///you blocked bubble
                          if (myMessages['message_sender'] ==
                              '${widget.myUserInfo['user_id']}_blocking') {
                            return youBlockedBubble(
                                myMessages,
                                index,
                                MediaQuery.of(context).size.width,
                                widget.theirUserInfo['user_name']);
                          }

                          ///you unblocked bubble
                          if (myMessages['message_sender'] ==
                              '${widget.myUserInfo['user_id']}_unblocking') {
                            return youUnblockedBubble(
                                myMessages,
                                index,
                                MediaQuery.of(context).size.width,
                                widget.theirUserInfo['user_name']);
                          }

                          ///I'm blocked bubble
                          if (myMessages['message_sender'] ==
                              '${widget.myUserInfo['user_id']}_bluff') {
                            return newSenderChatBubble(myMessages, index,
                                MediaQuery.of(context).size.width);
                          } else {
                            return Container();
                          }
                        },
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Container(),
                    );
                  }
                },
              ),
              const Divider(
                height: 1.0,
                color: Colors.grey,
              ),
              textSenderBox(),
            ],
          ),
        ),
      ),
    );
  }
  //
  // Widget chatBubble(DocumentSnapshot message) {
  //   if (message['message_sender'] == widget.myUserInfo['user_id']) {
  //     return ChatBubble(
  //       clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
  //       alignment: Alignment.topRight,
  //       backGroundColor: const Color(0xffE7E7ED),
  //       margin: const EdgeInsets.only(top: 10),
  //       child: Container(
  //         constraints: BoxConstraints(
  //           maxWidth: MediaQuery.of(context).size.width * 0.7,
  //         ),
  //         child: Text(
  //           message['message_body'],
  //           style: const TextStyle(color: Colors.black),
  //         ),
  //       ),
  //     );
  //   } else {
  //     return ChatBubble(
  //       clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
  //       backGroundColor: const Color(0xffE7E7ED),
  //       alignment: Alignment.topLeft,
  //       margin: const EdgeInsets.only(top: 10),
  //       child: Container(
  //         constraints: BoxConstraints(
  //           maxWidth: MediaQuery.of(context).size.width * 0.7,
  //         ),
  //         child: Text(
  //           message['message_body'],
  //           style: const TextStyle(color: Colors.black),
  //         ),
  //       ),
  //     );
  //   }
  // }

  Widget textSenderBox() {
    return Container(
      color: const Color(0xffd3d3d3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const SizedBox(width: 14),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 120),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  controller: _textController,
                  style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      letterSpacing: .5,
                    ),
                  ),
                  decoration: chatInputDecoration('Message'),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              ///check blocked
              if (_textController.text.isNotEmpty) {
                bool meBlocked = await isMeBlocked(widget.myUserInfo['user_id'],
                    widget.theirUserInfo['user_id']);
                if (meBlocked || themBlocked) {
                  // The user is blocked
                  handleBluffTxtSubmitted(_textController.text);
                } else {
                  // The user is not blocked
                  handleTxtSubmitted(_textController.text);
                }
              }
            },
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: const CircleAvatar(
                radius: 16.0,
                backgroundColor: Colors.white,
                child: Icon(
                  CupertinoIcons.paperplane_fill,
                  color: Color(0xff184a45),
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  Future<bool> isMeBlocked(String loggedInUserId, String chatPartnerId) async {
    try {
      // Get a reference to the user document of the chat partner
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('XUsers').doc(chatPartnerId);

      // Fetch the user document
      DocumentSnapshot userDoc = await userRef.get();

      // Check if the logged-in user is blocked by the chat partner
      List<dynamic> blockedUsers = userDoc['blocked_users'];
      if (blockedUsers.contains(loggedInUserId)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any errors
      // print('Error checking if user is blocked: $e');
      return false;
    }
  }

  Future<bool> isThemBlocked(
      String loggedInUserId, String chatPartnerId) async {
    try {
      // Get a reference to the user document of the chat partner
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('XUsers').doc(loggedInUserId);

      // Fetch the user document
      DocumentSnapshot userDoc = await userRef.get();

      // Check if the logged-in user is blocked by the chat partner
      List<dynamic> blockedUsers = userDoc['blocked_users'];
      if (blockedUsers.contains(chatPartnerId)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any errors
      // print('Error checking if user is blocked: $e');
      return false;
    }
  }

  void handleTxtSubmitted(text) async {
    String dayToday = DateFormat('dd_MM_yyyy').format(DateTime.now());
    if (kDebugMode) {
      print(text);
    }

    _textController.clear();

    ///create chat head
    DocumentReference myChatHead = FirebaseFirestore.instance
        .collection('Chats')
        .doc('ChatSessions')
        .collection('AllSessions')
        .doc(_sessionId);
    Map<String, dynamic> headsTask = {
      'session_last_time': FieldValue.serverTimestamp(),
      'session_last_text': text,
      'text_seen_by': FieldValue.arrayUnion([widget.myUserInfo['user_id']]),
      'session_id': _sessionId,
      'session_participants': FieldValue.arrayUnion(
          [widget.myUserInfo['user_id'], widget.theirUserInfo['user_id']]),
    };
    myChatHead.set(headsTask);

    ///check if time group exists and add
    FirebaseFirestore.instance
        .collection('Chats')
        .doc('SingleChats')
        .collection(_sessionId)
        .doc('${dayToday}_time_group_${widget.myUserInfo['user_id']}')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        ///create a single text
        DocumentReference singleTxt = FirebaseFirestore.instance
            .collection('Chats')
            .doc('SingleChats')
            .collection(_sessionId)
            .doc();
        Map<String, dynamic> msgTask = {
          'message_body': text,
          'message_id': singleTxt.id,
          'message_time': FieldValue.serverTimestamp(),
          'message_sender': widget.myUserInfo['user_id'],
          'message_receiver': widget.theirUserInfo['user_id'],
          'message_seen': false,
          'message_image': '-',
          'is_image': false,
          'message_visibility': true,
          'message_quoted_id': '-',
        };
        singleTxt.set(msgTask);
      } else {
        ///create a time to group messages
        DocumentReference groupRef = FirebaseFirestore.instance
            .collection('Chats')
            .doc('SingleChats')
            .collection(_sessionId)
            .doc('${dayToday}_time_group_${widget.myUserInfo['user_id']}');
        Map<String, dynamic> timeTask = {
          'message_body': '-',
          'message_id': groupRef.id,
          'message_time': FieldValue.serverTimestamp(),
          'message_sender': 'my_daytime_${widget.myUserInfo['user_id']}',
          'message_receiver': '-',
          'message_seen': true,
          'message_image': '-',
          'is_image': false,
          'message_visibility': true,
          'message_quoted_id': '-',
        };
        groupRef.set(timeTask);

        ///create a single text
        DocumentReference singleTxt = FirebaseFirestore.instance
            .collection('Chats')
            .doc('SingleChats')
            .collection(_sessionId)
            .doc();
        Map<String, dynamic> msgTask = {
          'message_body': text,
          'message_id': singleTxt.id,
          'message_time': FieldValue.serverTimestamp(),
          'message_sender': widget.myUserInfo['user_id'],
          'message_receiver': widget.theirUserInfo['user_id'],
          'message_seen': false,
          'message_image': '-',
          'is_image': false,
          'message_visibility': true,
          'message_quoted_id': '-',
        };
        singleTxt.set(msgTask);
      }
    });

    ///update message count
    DocumentReference ds = FirebaseFirestore.instance
        .collection('XUsers')
        .doc(widget.theirUserInfo['user_id']);
    Map<String, dynamic> tasks = {
      'user_new_messages': FieldValue.increment(1),
    };
    ds.update(tasks);

    ///send notification about message
    DocumentReference notyMessage = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('chats')
        .collection(widget.theirUserInfo['user_id'])
        .doc();
    Map<String, dynamic> messageNotyTasks = {
      'notification_tittle_eng': widget.myUserInfo['user_name'],
      'notification_tittle_sw': widget.myUserInfo['user_name'],
      'notification_body_eng':
          '${text.length > 80 ? text.substring(0, 80) + '...' : text}',
      'notification_body_sw':
          '${text.length > 80 ? text.substring(0, 80) + '...' : text}',
      'notification_time': FieldValue.serverTimestamp(),
      'notification_sender': 'My wangu',
      'action_title': 'new-message',
      'action_destination': 'Chat',
      'notification_read': false,
      'action_destination_id': widget.myUserInfo['user_id'],
      'notification_id': ds.id,
    };
    notyMessage.set(messageNotyTasks);
  }

  void handleBluffTxtSubmitted(text) async {
    String dayToday = DateFormat('dd_MM_yyyy').format(DateTime.now());
    if (kDebugMode) {
      print(text);
    }

    _textController.clear();

    ///check if time group exists and add
    FirebaseFirestore.instance
        .collection('Chats')
        .doc('SingleChats')
        .collection(_sessionId)
        .doc('${dayToday}_time_group_${widget.myUserInfo['user_id']}')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        ///create a single text
        DocumentReference singleTxt = FirebaseFirestore.instance
            .collection('Chats')
            .doc('SingleChats')
            .collection(_sessionId)
            .doc();
        Map<String, dynamic> msgTask = {
          'message_body': text,
          'message_id': singleTxt.id,
          'message_time': FieldValue.serverTimestamp(),
          'message_sender': '${widget.myUserInfo['user_id']}_bluff',
          'message_receiver': '-',
          'message_seen': false,
          'message_image': '-',
          'is_image': false,
          'message_visibility': true,
          'message_quoted_id': '-',
        };
        singleTxt.set(msgTask);
      } else {
        ///create a time to group messages
        DocumentReference groupRef = FirebaseFirestore.instance
            .collection('Chats')
            .doc('SingleChats')
            .collection(_sessionId)
            .doc('${dayToday}_time_group_${widget.myUserInfo['user_id']}');
        Map<String, dynamic> timeTask = {
          'message_body': '-',
          'message_id': groupRef.id,
          'message_time': FieldValue.serverTimestamp(),
          'message_sender': 'my_daytime_${widget.myUserInfo['user_id']}',
          'message_receiver': '-',
          'message_seen': true,
          'message_image': '-',
          'is_image': false,
          'message_visibility': true,
          'message_quoted_id': '-',
        };
        groupRef.set(timeTask);

        ///create a single text
        DocumentReference singleTxt = FirebaseFirestore.instance
            .collection('Chats')
            .doc('SingleChats')
            .collection(_sessionId)
            .doc();
        Map<String, dynamic> msgTask = {
          'message_body': text,
          'message_id': singleTxt.id,
          'message_time': FieldValue.serverTimestamp(),
          'message_sender': '${widget.myUserInfo['user_id']}_bluff',
          'message_receiver': '-',
          'message_seen': false,
          'message_image': '-',
          'is_image': false,
          'message_visibility': true,
          'message_quoted_id': '-',
        };
        singleTxt.set(msgTask);
      }
    });
  }

  openBlockDialog(
      DocumentSnapshot myRealtimeInfo, DocumentSnapshot theirUserInfo) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    dialogTitleText(myRealtimeInfo['user_language'] == 'sw'
                        ? 'Mzuie ${theirUserInfo['user_name']}'
                        : 'Block ${theirUserInfo['user_name']}'),
                    const SizedBox(
                      height: 2,
                    ),
                    dialogBodyText(
                      myRealtimeInfo['user_language'] == 'sw'
                          ? 'Ukimzuia ${theirUserInfo['user_name']} hataweza kukutumia ujumbe.'
                          : 'If you block "${theirUserInfo['user_name']}", they will not be able to message you.',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: laterButton(
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Badae'
                                    : 'Later'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              Navigator.of(context).pop();

                              ///update blocked users
                              DocumentReference ds = FirebaseFirestore.instance
                                  .collection('XUsers')
                                  .doc(widget.myUserInfo['user_id']);
                              Map<String, dynamic> tasks = {
                                'blocked_users': FieldValue.arrayUnion([
                                  theirUserInfo['user_id'],
                                ]),
                              };
                              ds.update(tasks);
                              checkIfThemBlocked();

                              ///snack message
                              if (mounted) {
                                snackSuccess(
                                    myRealtimeInfo['user_language'] == 'sw'
                                        ? 'umemzuia "${theirUserInfo['user_name']}"'
                                        : 'You blocked "${theirUserInfo['user_name']}"',
                                    context);
                              }

                              ///add blocked to the messages list
                              ///create a single text
                              DocumentReference singleTxt = FirebaseFirestore
                                  .instance
                                  .collection('Chats')
                                  .doc('SingleChats')
                                  .collection(_sessionId)
                                  .doc();
                              Map<String, dynamic> msgTask = {
                                'message_body': '-',
                                'message_id': singleTxt.id,
                                'message_time': FieldValue.serverTimestamp(),
                                'message_sender':
                                    '${widget.myUserInfo['user_id']}_blocking',
                                'message_receiver':
                                    widget.myUserInfo['user_id'],
                                'message_seen': false,
                                'message_image': '-',
                                'is_image': false,
                                'message_visibility': true,
                                'message_quoted_id': '-',
                              };
                              singleTxt.set(msgTask);
                            },
                            child: dangerButton(
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Mzuie'
                                    : 'Block'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  openUnblockDialog(
      DocumentSnapshot myRealtimeInfo, DocumentSnapshot theirUserInfo) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    dialogTitleText(myRealtimeInfo['user_language'] == 'sw'
                        ? 'Mruhusu ${theirUserInfo['user_name']}'
                        : 'Unblock ${theirUserInfo['user_name']}'),
                    const SizedBox(
                      height: 2,
                    ),
                    dialogBodyText(
                      myRealtimeInfo['user_language'] == 'sw'
                          ? 'Muwezesha "${theirUserInfo['user_name']}", ukimuwezesha utaweza kupokea ujumbe kutoka kwake'
                          : 'When you unblock "${theirUserInfo['user_name']}", you will be able to receive their messages.',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: laterButton(
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Badae'
                                    : 'Later'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              Navigator.of(context).pop();

                              ///update blocked users
                              DocumentReference ds = FirebaseFirestore.instance
                                  .collection('XUsers')
                                  .doc(widget.myUserInfo['user_id']);
                              Map<String, dynamic> tasks = {
                                'blocked_users': FieldValue.arrayRemove([
                                  theirUserInfo['user_id'],
                                ]),
                              };
                              ds.update(tasks);
                              checkIfThemBlocked();

                              ///snack message
                              if (mounted) {
                                snackSuccess(
                                    myRealtimeInfo['user_language'] == 'sw'
                                        ? 'Umemruhusu "${theirUserInfo['user_name']}"'
                                        : 'You unblocked "${theirUserInfo['user_name']}"',
                                    context);
                              }

                              ///add blocked to the messages list
                              ///create a single text
                              DocumentReference singleTxt = FirebaseFirestore
                                  .instance
                                  .collection('Chats')
                                  .doc('SingleChats')
                                  .collection(_sessionId)
                                  .doc();
                              Map<String, dynamic> msgTask = {
                                'message_body': '-',
                                'message_id': singleTxt.id,
                                'message_time': FieldValue.serverTimestamp(),
                                'message_sender':
                                    '${widget.myUserInfo['user_id']}_unblocking',
                                'message_receiver':
                                    widget.myUserInfo['user_id'],
                                'message_seen': false,
                                'message_image': '-',
                                'is_image': false,
                                'message_visibility': true,
                                'message_quoted_id': '-',
                              };
                              singleTxt.set(msgTask);
                            },
                            child: watchButton(
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Wezesha'
                                    : 'Unblock'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      elevation: 4,
      backgroundColor: Colors.white,
      barrierColor: Colors.black87.withOpacity(.8),
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 120,
          // color: Colors.white,
          child: Stack(
            children: [
              SinglePersonProfile(
                myUserInfo: widget.myUserInfo,
                theirUserInfo: widget.theirUserInfo,
              ),
              Positioned(
                top: 10,
                left: (MediaQuery.of(context).size.width / 2) - 30,
                child: Container(
                  height: 8,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.6),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
