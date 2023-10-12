import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class AdminJournalistsView extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminJournalistsView(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminJournalistsView> createState() => _AdminJournalistsViewState();
}

class _AdminJournalistsViewState extends State<AdminJournalistsView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('XUsers')
          .where('account_type', isEqualTo: 'Journalist')
          .orderBy('creation_date', descending: true)
          .limit(100)
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
            return Flexible(
              child: GridView.builder(
                padding: const EdgeInsets.only(
                  bottom: 40,
                  left: 16,
                  right: 16,
                  top: 10,
                ),
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.0, // Spacing between items in a row
                  mainAxisSpacing: 14.0, // Spacing between rows
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   CupertinoPageRoute(
                      //     builder: (_) => AdminSinglePressView(
                      //       userId: widget.userId,
                      //       userData: widget.userData,
                      //       pressData: doc,
                      //     ),
                      //   ),
                      // );
                    },
                    child: journalistPublicItem(doc),
                  );
                },
              ),
            );
          }
        }
      },
    );
  }
}
