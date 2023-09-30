import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:two_value/screens/company/company_add_page.dart';
import 'package:two_value/src/theme.dart';

import '../company/company_home_view.dart';
import '../company/company_profile_page.dart';
import '../company/company_support_page.dart';
import '../messaging/messaging_page.dart';

class CompanyHomePage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const CompanyHomePage(
      {super.key, required this.userId, required this.userData});

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: TAppTheme.primaryColor,
          elevation: 8,
          title: const Row(
            children: [
              Image(
                height: 18,
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/nav_logo.png',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            _counter(widget.userData),
            _notificationMessage(
                (widget.userData['notification_count']), widget.userData),
            _myProfile(),
          ],
        ),
        body: decider(),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: Image(
                image: const AssetImage('assets/icons/home-dark.png'),
                height: 20,
                width: 20,
                color: _currentIndex == 0 ? Colors.teal : Colors.black,
              ),
              title: Text(
                widget.userData['user_language'] == 'ro' ? 'Acasă' : 'Home',
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                    fontSize: 14.0,
                    letterSpacing: .5,
                  ),
                ),
              ),
              selectedColor: Colors.teal,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: Image(
                image: const AssetImage('assets/icons/from_dark.png'),
                height: 20,
                width: 20,
                color: _currentIndex == 1 ? Colors.teal : Colors.black,
              ),
              title: Text(
                widget.userData['user_language'] == 'ro' ? 'Știri' : 'News',
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                    fontSize: 14.0,
                    letterSpacing: .5,
                  ),
                ),
              ),
              selectedColor: Colors.teal,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: Image(
                image: const AssetImage('assets/icons/add.png'),
                height: 20,
                width: 20,
                color: _currentIndex == 2 ? Colors.teal : Colors.black,
              ),
              title: Text(
                widget.userData['user_language'] == 'ro' ? 'Adăuga' : 'Add',
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                    fontSize: 14.0,
                    letterSpacing: .5,
                  ),
                ),
              ),
              selectedColor: Colors.teal,
            ),

            /// Search
            SalomonBottomBarItem(
              icon: Image(
                image: const AssetImage('assets/icons/edit_dark.png'),
                height: 20,
                width: 20,
                color: _currentIndex == 3 ? Colors.teal : Colors.black,
              ),
              title: Text(
                widget.userData['user_language'] == 'ro' ? 'Sarcini' : 'Tasks',
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                    fontSize: 14.0,
                    letterSpacing: .5,
                  ),
                ),
              ),
              selectedColor: Colors.teal,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: Image(
                image: const AssetImage('assets/icons/chat.png'),
                height: 20,
                width: 20,
                color: _currentIndex == 4 ? Colors.teal : Colors.black,
              ),
              title: Text(
                widget.userData['user_language'] == 'ro' ? 'Suport' : 'Support',
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                    fontSize: 14.0,
                    letterSpacing: .5,
                  ),
                ),
              ),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget decider() {
    if (_currentIndex == 0) {
      return CompanyHomeView(
        userId: widget.userId,
        userData: widget.userData,
      );
    } else if (_currentIndex == 1) {
      return Container(
        color: Colors.black26,
      );
    } else if (_currentIndex == 2) {
      return CompanyAddPage(
        userId: widget.userId,
        userData: widget.userData,
      );
    } else if (_currentIndex == 3) {
      return Container(
        color: Colors.black26,
      );
    } else if (_currentIndex == 4) {
      return CompanySupportPage(
        userId: widget.userId,
        userData: widget.userData,
      );
    } else {
      return Container(
        color: Colors.black26,
      );
    }
  }

  Widget _counter(DocumentSnapshot myRealtimeInfo) {
    return Center(
      child: InkWell(
        onTap: () {
          // addCoinsDialog(myRealtimeInfo);
        },
        child: Container(
          height: 26,
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(.1),
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 4.0,
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.star_circle_fill,
                  color: Colors.white,
                  size: 13,
                ),
                const SizedBox(
                  width: 4.0,
                ),
                AnimatedFlipCounter(
                  duration: const Duration(milliseconds: 500),
                  value: myRealtimeInfo['notification_count'],
                  textStyle: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: .5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _notificationMessage(int count, DocumentSnapshot myRealtimeInfo) {
    if (count > 0) {
      return Center(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                  icon: const Icon(
                    CupertinoIcons.bell_fill,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => MessagingPage(
                          userId: widget.userId,
                          myUserInfo: myRealtimeInfo,
                        ),
                      ),
                    );
                  }),
            ),
            Positioned(
              right: 9,
              top: 6,
              child: Container(
                height: 14,
                width: 14,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: const Color(0xfffd1d1d),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: Text(
                    count > 9 ? '9+' : count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 7,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: IconButton(
          icon: const Icon(
            CupertinoIcons.bell_fill,
            size: 28,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => MessagingPage(
                  userId: widget.userId,
                  myUserInfo: myRealtimeInfo,
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _myProfile() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: IconButton(
          icon: const Icon(
            CupertinoIcons.person_alt_circle_fill,
            size: 28,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CompanyProfilePage(
                  userId: widget.userId,
                  userData: widget.userData,
                ),
              ),
            );
            // await _firebaseAuth.signOut().then(
            //   (res) {
            //     Navigator.of(context).pushAndRemoveUntil(
            //         CupertinoPageRoute(
            //           builder: (context) => const LoginScreen(),
            //         ),
            //         (r) => false);
            //   },
            // );
          }),
    );
  }
}
