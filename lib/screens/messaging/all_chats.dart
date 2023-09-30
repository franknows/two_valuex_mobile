import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';
import 'single_chat_page.dart';

class AllChats extends StatefulWidget {
  final String userId;
  final DocumentSnapshot myUserInfo;
  const AllChats({super.key, required this.userId, required this.myUserInfo});

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  String language = '';
  @override
  void initState() {
    super.initState();
    DocumentReference ds =
        FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);
    Map<String, dynamic> tasks = {
      'user_new_messages': 0,
    };
    ds.update(tasks);
    language = widget.myUserInfo['user_language'];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Chats')
          .doc('ChatSessions')
          .collection('AllSessions')
          .where('session_participants', arrayContains: widget.userId)
          .orderBy('session_last_time', descending: true)
          .limit(100)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.size == 0) {
          return emptyPlaceholder();
        } else {
          return Container(
            color: Colors.grey.withOpacity(.2),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot mySessions = snapshot.data!.docs[index];
                return loadSessions(
                    index, mySessions, snapshot.data!.docs.length);
              },
            ),
          );
        }
      },
    );
  }

  Widget loadSessions(int index, DocumentSnapshot mySessions, int length) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('XUsers')
          .where('user_id',
              isEqualTo: mySessions['session_participants'][0] == widget.userId
                  ? mySessions['session_participants'][1]
                  : mySessions['session_participants'][0])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot otherUserInfo = snapshot.data!.docs[0];
          return Padding(
            padding: index == 0
                ? const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 10)
                : const EdgeInsets.only(
                    top: 0, left: 10, right: 10, bottom: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => SingleChatPage(
                      myUserInfo: widget.myUserInfo,
                      theirUserInfo: otherUserInfo,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 24,
                                backgroundImage: CachedNetworkImageProvider(
                                    otherUserInfo['user_image']),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    blackBoldText(otherUserInfo['user_name']),
                                    Text(
                                      mySessions['session_last_time'] == null
                                          ? '-'
                                          : DateFormat('HH:mm').format(
                                              DateTime.parse(
                                                mySessions['session_last_time']
                                                    .toDate()
                                                    .toString(),
                                              ),
                                            ),
                                      style: GoogleFonts.quicksand(
                                        textStyle: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    handleLastMessage(mySessions),
                                    readIndicator(mySessions['text_seen_by']),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget emptyPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.envelope_open,
              size: 24,
              color: Colors.blueGrey,
            ),
            const SizedBox(
              height: 10,
            ),
            dialogTitleText(
              language == 'sw' ? 'Hakuna ujumbe' : 'No messages',
            ),
            const SizedBox(
              height: 10,
            ),
            dialogBodyText(
              language == 'sw'
                  ? 'Inaonekana hujaanzisha mazungumzo na mtu yeyote kwa sasa'
                  : 'Looks like you haven\'t initiated a conversation with anyone.',
            ),
            const SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
    );
  }

  Widget readIndicator(var reads) {
    if (reads.contains(widget.userId)) {
      return Container();
    } else {
      return Row(
        children: const [
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 4,
            backgroundColor: TAppTheme.primaryColor,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      );
    }
  }

  Widget handleLastMessage(DocumentSnapshot mySessions) {
    if (widget.myUserInfo['blocked_users']
            .contains(mySessions['session_participants'][0]) ||
        widget.myUserInfo['blocked_users']
            .contains(mySessions['session_participants'][1])) {
      return Flexible(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(.5),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(2.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: miniBlackText('Blocked'),
          ),
        ),
      );
    } else {
      return Flexible(
        child: Text(
          mySessions['session_last_text'],
          style: GoogleFonts.quicksand(
            textStyle: const TextStyle(
              fontSize: 12.0,
              // fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }
}
