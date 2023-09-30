import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:two_value/src/theme.dart';

import '../auth/login_screen.dart';
import '../messaging/messaging_page.dart';

class AdminHomePage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminHomePage(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
        systemNavigationBarColor: Colors.black,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: TAppTheme.primaryColor,
          elevation: 8,
          title: Row(
            children: [
              const Image(
                height: 18,
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/nav_logo.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                ),
                child: Container(
                  height: 20,
                  width: 1,
                  color: Colors.white,
                ),
              ),
              Text(
                'Company',
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    letterSpacing: .5,
                  ),
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
        body: Container(),
      ),
    );
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
                    CupertinoIcons.chat_bubble_2_fill,
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
            CupertinoIcons.chat_bubble_2_fill,
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => ProfilePage(userId: widget.userId),
            //   ),
            // );
            await _firebaseAuth.signOut().then(
              (res) {
                Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (r) => false);
              },
            );
          }),
    );
  }
}
