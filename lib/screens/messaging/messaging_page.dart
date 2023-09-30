import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../src/local_notification_service.dart';
import 'all_chats.dart';
import 'notification_page.dart';

class MessagingPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot myUserInfo;
  const MessagingPage(
      {super.key, required this.userId, required this.myUserInfo});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 4,
                  title: InkWell(
                    onTap: () {
                      LocalNotificationService()
                          .showDefaultNotification('title', 'body');
                    },
                    child: Text(
                      'Notifications & Chats',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                  ),
                  backgroundColor: const Color(0xff184a45),
                  pinned: true,
                  floating: true,
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
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    isScrollable: false,
                    tabs: [
                      Tab(
                        icon: Stack(
                          children: [
                            const Icon(
                              CupertinoIcons.bell_fill,
                              color: Colors.white,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('XUsers')
                                    .where('user_id', isEqualTo: widget.userId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  } else {
                                    if (snapshot.data!.docs.isEmpty) {
                                      return Container();
                                    } else {
                                      DocumentSnapshot realtimeInfo =
                                          snapshot.data!.docs[0];
                                      if (realtimeInfo['notification_count'] >
                                          0) {
                                        return const CircleAvatar(
                                          radius: 3,
                                          backgroundColor: Colors.red,
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        icon: Stack(
                          children: [
                            const Icon(
                              CupertinoIcons.chat_bubble_2_fill,
                              color: Colors.white,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('XUsers')
                                    .where('user_id', isEqualTo: widget.userId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  } else {
                                    if (snapshot.data!.docs.isEmpty) {
                                      return Container();
                                    } else {
                                      DocumentSnapshot realtimeInfo =
                                          snapshot.data!.docs[0];
                                      if (realtimeInfo['user_new_messages'] >
                                          0) {
                                        return const CircleAvatar(
                                          radius: 3,
                                          backgroundColor: Colors.red,
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: NotificationsPage(
                    userId: widget.userId,
                    myUserInfo: widget.myUserInfo,
                  ),
                ),
                MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: AllChats(
                    userId: widget.userId,
                    myUserInfo: widget.myUserInfo,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
