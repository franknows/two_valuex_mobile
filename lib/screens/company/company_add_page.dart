import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:two_value/screens/company/company_add_press_release_page.dart';

import '../../src/helper_widgets.dart';

class CompanyAddPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const CompanyAddPage(
      {super.key, required this.userId, required this.userData});

  @override
  State<CompanyAddPage> createState() => _CompanyAddPageState();
}

class _CompanyAddPageState extends State<CompanyAddPage> {
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
    return Container(
      color: Colors.grey.withOpacity(.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(120),
            blackBoldTextWithSize(
              language == 'ro' ? 'Adăuga' : 'Add',
              20,
            ),
            addVerticalSpace(10),
            blackNormalText(
              language == 'ro'
                  ? 'Faceți clic pe opțiunea pe care doriți să o adăugați.'
                  : 'Click the option you would like to add.',
            ),
            addVerticalSpace(20),
            GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 1.3,
              ),
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10, bottom: 16),
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => CompanyAddPressReleasePage(
                          userId: widget.userId,
                          userData: widget.userData,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: .5,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black12,
                          child: Image(
                            image: AssetImage('assets/icons/edit_dark.png'),
                            height: 24,
                            width: 24,
                          ),
                        ),
                        addVerticalSpace(10),
                        dialogTitleText(
                          language == 'ro'
                              ? 'Comunicat de presă'
                              : 'Press release',
                        ),
                        addVerticalSpace(2.0),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   CupertinoPageRoute(
                    //     builder: (_) => AdminManageCoursesPage(
                    //       userId: widget.userId,
                    //       myUserInfo: widget.myUserInfo,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: .5,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black12,
                          child: Image(
                            image: AssetImage('assets/icons/mic.png'),
                            height: 24,
                            width: 24,
                          ),
                        ),
                        addVerticalSpace(10),
                        blackBoldText(
                          language == 'ro' ? 'Interviu' : 'Interview',
                        ),
                        addVerticalSpace(2.0),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   CupertinoPageRoute(
                    //     builder: (_) => AdminManageBlogsPage(
                    //       userId: widget.userId,
                    //       myUserInfo: widget.myUserInfo,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: .5,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black12,
                          child: Image(
                            image: AssetImage('assets/icons/add_calendar.png'),
                            height: 24,
                            width: 24,
                          ),
                        ),
                        addVerticalSpace(10),
                        blackBoldText(
                          language == 'ro'
                              ? 'Agenda evenimentului'
                              : 'Event Agenda',
                        ),
                        addVerticalSpace(2.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
