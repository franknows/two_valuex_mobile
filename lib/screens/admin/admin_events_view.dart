import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';
import 'admin_single_press_view.dart';

class AdminEventsView extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminEventsView(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminEventsView> createState() => _AdminEventsViewState();
}

class _AdminEventsViewState extends State<AdminEventsView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('XEvents')
          .where('event_visibility', isEqualTo: true)
          .orderBy('event_posted_time', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: size.height - 300,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: TAppTheme.primaryColor.withOpacity(.4),
                backgroundColor: Colors.white,
              ),
            ),
          );
        } else {
          if (snapshot.data!.docs.isEmpty) {
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
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => AdminSinglePressView(
                          userId: widget.userId,
                          userData: widget.userData,
                          pressData: doc,
                        ),
                      ),
                    );
                  },
                  child: eventPublicItem(doc, widget.userId),
                );
              },
            );
          }
        }
      },
    );
  }
}
