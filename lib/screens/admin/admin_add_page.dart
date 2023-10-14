import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:two_value/screens/company/company_add_event_page.dart';
import 'package:two_value/screens/company/company_add_press_release_page.dart';

import '../../src/helper_widgets.dart';
import 'admin_add_ad_page.dart';
import 'admin_add_interview_page.dart';
import 'admin_add_job_page.dart';
import 'admin_approve_ads_page.dart';
import 'admin_approve_events_page.dart';

class AdminAddPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminAddPage({super.key, required this.userId, required this.userData});

  @override
  State<AdminAddPage> createState() => _AdminAddPageState();
}

class _AdminAddPageState extends State<AdminAddPage> {
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
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpace(20),
              Stack(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image(
                        height: 140,
                        image: AssetImage(
                          'assets/images/welcome.png',
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    bottom: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        blackBoldTextWithSize(
                          language == 'ro' ? 'Adăuga' : 'Add',
                          20,
                        ),
                        addVerticalSpace(10),
                        SizedBox(
                          width: 200,
                          child: blackNormalText(
                            language == 'ro'
                                ? 'Faceți clic pe opțiunea pe care doriți să o adăugați.'
                                : 'Click the option you would like to add.',
                          ),
                        )
                      ],
                    ),
                  )
                ],
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
                          blackNormalCenteredText(
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
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => AdminAddInterviewPage(
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
                              image: AssetImage('assets/icons/mic.png'),
                              height: 24,
                              width: 24,
                            ),
                          ),
                          addVerticalSpace(10),
                          blackNormalCenteredText(
                            language == 'ro' ? 'Interviu' : 'Interview',
                          ),
                          addVerticalSpace(2.0),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => CompanyAddEventPage(
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
                              image:
                                  AssetImage('assets/icons/add_calendar.png'),
                              height: 24,
                              width: 24,
                            ),
                          ),
                          addVerticalSpace(10),
                          blackNormalCenteredText(
                            language == 'ro'
                                ? 'Agenda evenimentului'
                                : 'Event Agenda',
                          ),
                          addVerticalSpace(2.0),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => AdminAddAdPage(
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
                              image: AssetImage('assets/icons/power_ad.png'),
                              height: 24,
                              width: 24,
                            ),
                          ),
                          addVerticalSpace(10),
                          blackNormalCenteredText(
                            language == 'ro'
                                ? 'Postați un anunț'
                                : 'Post an Ad',
                          ),
                          addVerticalSpace(2.0),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => AdminAddJobPage(
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.black12,
                              child: Image(
                                image: AssetImage('assets/icons/job.png'),
                                height: 24,
                                width: 24,
                              ),
                            ),
                            addVerticalSpace(10),
                            blackNormalCenteredText(
                              language == 'ro'
                                  ? 'Posteaza un loc de munca'
                                  : 'Post a job',
                            ),
                            addVerticalSpace(2.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
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
                          builder: (_) => AdminApproveEventsPage(
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
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.teal.withOpacity(.1),
                            child: const Image(
                              color: Colors.teal,
                              image: AssetImage(
                                  'assets/icons/approve_calendar.png'),
                              height: 24,
                              width: 24,
                            ),
                          ),
                          addVerticalSpace(10),
                          blackNormalCenteredText(
                            language == 'ro'
                                ? 'Aprobați\nevenimente'
                                : 'Approve Events',
                          ),
                          addVerticalSpace(2.0),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => AdminApproveAdsPage(
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
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.teal.withOpacity(.1),
                            child: const Image(
                              color: Colors.teal,
                              image:
                                  AssetImage('assets/icons/approve_check.png'),
                              height: 24,
                              width: 24,
                            ),
                          ),
                          addVerticalSpace(10),
                          blackNormalCenteredText(
                            language == 'ro'
                                ? 'Aprobați anunțuri'
                                : 'Approve Ads',
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
      ),
    );
  }
}
