import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:two_value/screens/auth/login_screen.dart';
import 'package:two_value/screens/auth/setup_account.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class VerifyEmailPage extends StatefulWidget {
  final String userId;
  const VerifyEmailPage({super.key, required this.userId});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final bool _loading = false;
  bool _emailVerified = false;
  String language = 'ro';
  String _userEmail = '';

  bool resendingEmail = false;
  bool resendInAction = false;
  String _userId = 'null';
  int _icon = 0;
  int _counter = 0;
  Timer? _timer;
  int _start = 0;

  @override
  void initState() {
    super.initState();
    _getUser();
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer t) => _reloadUser(),
    );
  }

  _reloadUser() async {
    var user = _firebaseAuth.currentUser;
    await user!.reload().then((value) {});
    if (user.emailVerified) {
      if (this.mounted) {
        setState(() {
          _emailVerified = true;
          print('email verified');
          _timer!.cancel();
        });
      }
      DocumentReference ds =
          FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);
      Map<String, dynamic> tasks = {
        'email_verification': true,
      };
      ds.update(tasks);
    } else {
      if (this.mounted) {
        setState(() {
          _emailVerified = false;
          print('Email not verified');
        });
      }
    }
  }

  _getUser() {
    final User? user = _firebaseAuth.currentUser;
    setState(() {
      _userEmail = user!.email!;
      _userId = user.uid;
    });
  }

  Future _sendVerificationEmail() async {
    var user = _firebaseAuth.currentUser;
    try {
      await user!.sendEmailVerification().then((value) {
        snackSuccess(
            language == 'ro'
                ? "Trimis! Înregistrați și spam-ul."
                : 'Sent! Check in spam too.',
            context);
      });

      print('email sent');
      return user.uid;
    } catch (e) {
      snackError(
          language == 'ro'
              ? "Eroare! Trimiterea e-mailului de resetare a eșuat."
              : 'Error! Failed to send reset email.',
          context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: OverlayLoaderWithAppIcon(
        isLoading: _loading,
        overlayBackgroundColor: TAppTheme.primaryColor,
        circularProgressColor: TAppTheme.accentColor,
        borderRadius: 15,
        appIcon: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            CupertinoIcons.hourglass,
            size: 28,
            color: TAppTheme.primaryColor,
          ),
        ),
        appIconSize: 50,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              addVerticalSpace(60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (language == 'ro') {
                          setState(() {
                            language = 'eng';
                          });
                        } else {
                          setState(() {
                            language = 'ro';
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(2.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Image(
                            height: 20,
                            width: 34,
                            image: AssetImage(language == 'eng'
                                ? 'assets/images/uk_flag.png'
                                : 'assets/images/romania_flag.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              addVerticalSpace(30),
              Center(
                child: Image(
                  height: size.width / 1.5,
                  width: size.width / 1.5,
                  image: AssetImage(
                    _emailVerified
                        ? 'assets/images/verified_email.png'
                        : 'assets/images/unverified_email.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(child: Container()),
              SizedBox(
                height: 300,
                child: _emailVerified ? verifiedView() : unverifiedWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget verifiedView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(20),
            blackBoldTextWithSize(
                language == 'ro' ? 'FELICITĂRI!' : 'CONGRATULATIONS', 16),
            addVerticalSpace(4.0),
            blackNormalText(
              language == 'ro'
                  ? 'Adresa de e-mail "$_userEmail" a fost verificată cu succes. Alege tipul de utilizator și continuă configurarea contului tău!'
                  : 'The email address "$_userEmail" was successfully verified. Choose the type of user and continue setting up your account!',
            ),
            addVerticalSpace(20.0),
            InkWell(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(
                      builder: (context) => SetUpAccountPage(
                        userId: widget.userId,
                      ),
                    ),
                    (r) => false);
              },
              child: simpleRoundedButton(
                language == 'ro' ? 'Continua!' : 'Continue',
              ),
            ),
            // addVerticalSpace(10.0),
            // InkWell(
            //   onTap: () async {
            //     final firestore = FirebaseFirestore.instance;
            //     final users = await firestore.collection('XUsers').get();
            //
            //     for (final user in users.docs) {
            //       final docRef = firestore.collection('XUsers').doc(user.id);
            //       await docRef.update({
            //         'profile_completed': false,
            //         'email_verification':
            //             false, // Updated the field name to 'profile_verified'.
            //       });
            //     }
            //
            //     // After updating is complete, show a SnackBar
            //     print('completed');
            //   },
            //   child: simpleRoundedButton(
            //     'Add fields',
            //   ),
            // ),
            //
            // addVerticalSpace(10.0),
            // InkWell(
            //     onTap: () async {
            //       final firestore = FirebaseFirestore.instance;
            //       final accounts = await firestore.collection('Accounts').get();
            //
            //       for (final account in accounts.docs) {
            //         final docRef =
            //             firestore.collection('XUsers').doc(account.id);
            //         await docRef.set(account.data() as Map<String, dynamic>);
            //         // Optionally, delete the original document in 'Accounts' collection
            //         // await xxx account.reference.delete();
            //       }
            //
            //       // After migration is complete, show a SnackBar
            //       print('Users have been moved successfully!');
            //     },
            //     child: simpleRoundedButton('Move users')),

            ///resend and refresh
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await _firebaseAuth.signOut().then(
                      (res) {
                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (r) => false);
                      },
                    );
                  },
                  child: Text(
                    language == 'Romanian' ? "Deconectează-te" : 'Log out',
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff1287c3),
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            addVerticalSpace(40),
          ],
        ),
      ),
    );
  }

  unverifiedWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(20),
            blackBoldTextWithSize(
                language == 'ro'
                    ? "CONFIRMARE ADRESĂ DE EMAIL"
                    : 'CONFIRM EMAIL ADDRESS',
                16),
            addVerticalSpace(4.0),
            blackNormalText(
              language == 'ro'
                  ? 'Ți-am trimis un link de verificare pe adresa de e-mail "$_userEmail". Fă click pe link-ul de confirmare pentru a activa contul.'
                  : 'We have sent a verification link to the email address "$_userEmail". Please check your inbox to verify your email.',
            ),
            addVerticalSpace(20.0),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xff33b5e5),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 14,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 2.0,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    language == 'Romanian'
                                        ? 'Dacă nu ați primit linkul de verificare, puteți retrimite din nou.'
                                        : 'If you haven\'t received the verification link, you can resend again.',
                                    style: GoogleFonts.quicksand(
                                      textStyle: const TextStyle(
                                          fontSize: 14.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            _sendVerificationEmail();
                          },
                          child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
                                child: Center(
                                  child: whiteNormalText(
                                    language == 'ro' ? 'Retrimite' : 'Resend',
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            ///resend and refresh
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await _firebaseAuth.signOut().then(
                      (res) {
                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (r) => false);
                      },
                    );
                  },
                  child: Text(
                    language == 'Romanian' ? "Deconectează-te" : 'Log out',
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff1287c3),
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            addVerticalSpace(40),
          ],
        ),
      ),
    );
  }
}
