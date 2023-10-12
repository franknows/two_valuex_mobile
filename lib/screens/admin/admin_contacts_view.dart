import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class AdminContactsView extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminContactsView(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminContactsView> createState() => _AdminContactsViewState();
}

class _AdminContactsViewState extends State<AdminContactsView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Contacts')
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
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  bottom: 40,
                  left: 16,
                  right: 16,
                  top: 10,
                ),
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
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
                    child: contactPublicItem(doc),
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
