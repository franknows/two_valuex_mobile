import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class SearchPlanPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot myUserInfo;
  const SearchPlanPage(
      {super.key, required this.userId, required this.myUserInfo});

  @override
  State<SearchPlanPage> createState() => _SearchPlanPageState();
}

class _SearchPlanPageState extends State<SearchPlanPage> {
  String mySearch = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySearch = widget.myUserInfo['user_plan'] ?? 'Entire country';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
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
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.withOpacity(.5),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Cities')
                .where('country', isEqualTo: widget.myUserInfo['user_country'])
                .orderBy('city_order', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                if (snapshot.data!.docs.isEmpty) {
                  return Container();
                } else {
                  return Flexible(
                    child: ListView.builder(
                      //shrinkWrap: true,
                      reverse: false,
                      // physics: NeverScrollableScrollPhysics(),
                      // primary: false,
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot citiesSnapshot =
                            snapshot.data!.docs[index];

                        return cityItem(
                            citiesSnapshot, index, snapshot.data!.docs.length);
                      },
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  cityItem(DocumentSnapshot citiesSnapshot, int index, int length) {
    return InkWell(
      onTap: () {
        setState(() {
          mySearch = citiesSnapshot['city'];
        });

        ///update search plan
        DocumentReference citiesRef =
            FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);
        Map<String, dynamic> updateCities = {
          'user_plan': citiesSnapshot['city'] == 'Entire country'
              ? null
              : citiesSnapshot['city'],
        };
        citiesRef.update(updateCities);
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dialogTitleText(citiesSnapshot['city']),
                    dialogBodyText(
                        '${citiesSnapshot['users_count'].length} people'),
                  ],
                ),
                mySearch == citiesSnapshot['city']
                    ? const Icon(
                        CupertinoIcons.checkmark_square_fill,
                        color: TAppTheme.primaryColor,
                      )
                    : Container(),
              ],
            ),
          ),
          (length - 1 == index)
              ? const SizedBox(
                  height: 8.0,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.withOpacity(.3),
                  ),
                ),
        ],
      ),
    );
  }
}
