import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:two_value/src/helper_widgets.dart';

import 'company_single_press_view.dart';

class CompanyNewsPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const CompanyNewsPage(
      {super.key, required this.userId, required this.userData});

  @override
  State<CompanyNewsPage> createState() => _CompanyNewsPageState();
}

class _CompanyNewsPageState extends State<CompanyNewsPage> {
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
    return Container(
      color: Colors.grey.withOpacity(.1),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              addVerticalSpace(20),
              Row(
                children: [
                  blueBodyTextLarge(
                    language == 'ro' ? 'ȘTIRI' : 'NEWS',
                  ),
                ],
              ),
              addVerticalSpace(20),
              StreamBuilder<QuerySnapshot>(
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
                    return const SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.blueGrey,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
