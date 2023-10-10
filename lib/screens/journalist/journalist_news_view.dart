import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';
import 'company_single_press_view.dart';

class JournalistNewsView extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const JournalistNewsView(
      {super.key, required this.userId, required this.userData});

  @override
  State<JournalistNewsView> createState() => _JournalistNewsViewState();
}

class _JournalistNewsViewState extends State<JournalistNewsView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('XArticles')
          .doc('Presses')
          .collection('Dominant')
          .where('press_status', isEqualTo: 'LIVE')
          .orderBy('press_time', descending: true)
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
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => CompanySinglePressView(
                          userId: widget.userId,
                          userData: widget.userData,
                          pressData: doc,
                        ),
                      ),
                    );
                  },
                  child: pressPublicItem(doc),
                );
              },
            );
          }
        }
      },
    );
  }
}
