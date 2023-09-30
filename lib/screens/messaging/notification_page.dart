import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../src/helper_widgets.dart';
import '../../src/time_ago_eng.dart';
import '../profile/update_images.dart';
import 'single_chat_page.dart';

class NotificationsPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot myUserInfo;
  const NotificationsPage(
      {super.key, required this.userId, required this.myUserInfo});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int currentMills = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DocumentReference ds =
        FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);
    Map<String, dynamic> tasks = {
      'notification_count': 0,
    };
    ds.update(tasks);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Notifications')
          .doc('system')
          .collection(widget.userId)
          .orderBy('notification_time', descending: true)
          .limit(100)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            color: Colors.grey.withOpacity(.2),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot myNotifications = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _displayNotifications(index, myNotifications,
                      widget.myUserInfo, snapshot.data!.docs.length),
                );
              },
            ),
          );
        } else {
          return Container(
            color: Colors.grey.withOpacity(.2),
          );
        }
      },
    );
  }

  Widget _displayNotifications(index, DocumentSnapshot myNotifications,
      DocumentSnapshot myRealtimeInfo, int length) {
    if (myNotifications['action_title'] == 'new-like') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: InkWell(
          onTap: () {
            getUserSnapshot(myNotifications['action_destination_id'])
                .then((DocumentSnapshot<Object?> userSnapshot) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleChatPage(
                    myUserInfo: myRealtimeInfo,
                    theirUserInfo: userSnapshot,
                  ),
                ),
              );
            }).catchError((error) {
              // Handle errors
            });

            ///update read
            DocumentReference ds = FirebaseFirestore.instance
                .collection('Notifications')
                .doc('system')
                .collection(widget.userId)
                .doc(myNotifications['notification_id']);
            Map<String, dynamic> tasks = {
              'notification_read': true,
            };
            ds.update(tasks);
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      myNotifications['notification_read']
                          ? Container()
                          : const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 4,
                              ),
                            ),
                      blackBoldText(
                        myRealtimeInfo['user_language'] == 'sw'
                            ? myNotifications['notification_tittle_sw']
                            : myNotifications['notification_tittle_eng'],
                      ),
                    ],
                  ),
                  blackNormalText(
                    myRealtimeInfo['user_language'] == 'sw'
                        ? myNotifications['notification_body_sw']
                        : myNotifications['notification_body_eng'],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      miniBlackText(
                        _handleTime(myNotifications['notification_time'],
                            myRealtimeInfo['user_language']),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (myNotifications['action_title'] == 'images-rejected') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => UpdateImages(
                  userId: widget.userId,
                ),
              ),
            );

            ///update read
            DocumentReference ds = FirebaseFirestore.instance
                .collection('Notifications')
                .doc('system')
                .collection(widget.userId)
                .doc(myNotifications['notification_id']);
            Map<String, dynamic> tasks = {
              'notification_read': true,
            };
            ds.update(tasks);
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      myNotifications['notification_read']
                          ? Container()
                          : const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 4,
                              ),
                            ),
                      blackBoldText(
                        myRealtimeInfo['user_language'] == 'sw'
                            ? myNotifications['notification_tittle_sw']
                            : myNotifications['notification_tittle_eng'],
                      ),
                    ],
                  ),
                  blackNormalText(
                    myRealtimeInfo['user_language'] == 'sw'
                        ? myNotifications['notification_body_sw']
                        : myNotifications['notification_body_eng'],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      miniBlackText(
                        _handleTime(myNotifications['notification_time'],
                            myRealtimeInfo['user_language']),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                blackBoldText(myRealtimeInfo['user_language'] == 'sw'
                    ? myNotifications['notification_tittle_sw']
                    : myNotifications['notification_tittle_eng']),
                blackNormalText(
                  myRealtimeInfo['user_language'] == 'sw'
                      ? myNotifications['notification_body_sw']
                      : myNotifications['notification_body_eng'],
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    miniBlackText(
                      _handleTime(myNotifications['notification_time'],
                          myRealtimeInfo['user_language']),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<DocumentSnapshot<Object?>> getUserSnapshot(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('XUsers').doc(userId).get();
    return snapshot;
  }

  String _handleTime(Timestamp timestamp, String language) {
    int mills =
        DateTime.parse(timestamp.toDate().toString()).millisecondsSinceEpoch;

    if (currentMills - mills > 172800000) {
      //172800000
      final theFormat = DateFormat('dd MMM, HH:mm');
      return theFormat.format(DateTime.fromMillisecondsSinceEpoch(mills));
    } else {
      return (timeAgoEn(mills));
    }
  }
}
