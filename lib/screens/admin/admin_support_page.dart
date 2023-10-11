import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:two_value/screens/admin/admin_support_engage_page.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class AdminSupportPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminSupportPage(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminSupportPage> createState() => _AdminSupportPageState();
}

class _AdminSupportPageState extends State<AdminSupportPage> {
  String language = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      language = widget.userData['user_language'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('XHelpDesk')
          .doc('ChatSessions')
          .collection('ChatHeads')
          .orderBy('session_last_sync', descending: true)
          .limit(100)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.size == 0) {
          return Column(
            children: [
              addVerticalSpace(200),
              const Center(
                child: Image(
                  height: 200,
                  image: AssetImage('assets/images/empty_list.png'),
                ),
              ),
            ],
          );
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
          .where('user_id', isEqualTo: mySessions['session_user_id'])
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
                    builder: (_) => AdminSupportEngagePage(
                      userId: widget.userId,
                      userData: widget.userData,
                      customerId: mySessions['session_user_id'],
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
                                      mySessions['session_last_sync'] == null
                                          ? '-'
                                          : DateFormat('HH:mm').format(
                                              DateTime.parse(
                                                mySessions['session_last_sync']
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
                                    readIndicator(
                                        mySessions['session_need_human']),
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

  Widget readIndicator(var needed) {
    if (!needed) {
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
    return Flexible(
      child: Text(
        mySessions['session_last_message'],
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
