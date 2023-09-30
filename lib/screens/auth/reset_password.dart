import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';
import '../home/home_page.dart';
import 'setup_account.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final userRef = FirebaseFirestore.instance.collection('XUsers');
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _errorVisibility = false;
  bool _successVisibility = false;
  String email = '';
  String password = '';
  String error = '';
  String success = '';
  String language = 'ro';

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        setState(() {
          _loading = false;
          _errorVisibility = false;
          _successVisibility = true;
          error = '';
          success = language == 'Romanian'
              ? 'Un link de resetare a parolei a fost trimis la adresa dvs. de e-mail cu succes.'
              : 'A password reset link has been sent to your email successfully.';
        });
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
        _errorVisibility = true;
      });
      if (e.code == 'auth/user-not-found') {
        setState(
          () {
            error = (language == 'ro'
                ? 'Contul de utilizator nu a fost găsit, e nevoie să te înregistrezi mai întâi.'
                : 'User account was not found, you might need to sign up first.');
          },
        );
      } else {
        setState(
          () {
            error = (language == 'ro'
                ? 'Ceva este în neregulă cu conexiunea la rețea, te rugăm să verifici și să încerci din nou.'
                : 'Something is wrong with your network connection, please check and try again.');
          },
        );
      }
    }
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
          body: Stack(
            children: [
              SizedBox(
                height: double.infinity,
                child: Column(
                  children: [
                    addVerticalSpace(60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              CupertinoIcons.back,
                              color: Colors.black87,
                            ),
                          ),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(2.0))),
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
                        image: const AssetImage(
                          'assets/images/reset_password.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 4,
                        blurRadius: 6,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          addVerticalSpace(20),
                          blackBoldTextWithSize(
                              language == 'ro'
                                  ? 'RESETEAZĂ PAROLA'
                                  : 'RESET PASSWORD',
                              16),
                          addVerticalSpace(4.0),
                          blackNormalText(language == 'ro'
                              ? 'Introduceți adresa de e-mail pentru a vă reseta parola.'
                              : 'Enter your email address to reset your password.'),
                          addVerticalSpace(20.0),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black54,
                                letterSpacing: .5,
                              ),
                            ),
                            decoration: inputDecorationWithIcon(
                              language == 'ro' ? 'E-mail' : 'E-mail',
                              CupertinoIcons.envelope,
                            ),
                            onChanged: (val) {
                              setState(() {
                                _errorVisibility = false;
                                email = val.trim();
                              });
                            },
                            validator: (val) =>
                                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                        .hasMatch(val!)
                                    ? (language == 'ro'
                                        ? 'Introdu o adresă de e-mail validă'
                                        : 'Enter a valid e-mail address')
                                    : null,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _errorVisibility = false;
                                  _loading = true;
                                });
                                resetPassword(email);
                              } else {
                                setState(
                                  () {
                                    _errorVisibility = true;
                                    _loading = false;
                                    error = (language == 'ro'
                                        ? 'Te rugăm să completezi toate câmpurile!'
                                        : 'Please fill everything');
                                  },
                                );
                              }
                            },
                            child: simpleRoundedButton(
                              language == 'ro' ? 'TRIMITE' : 'SUBMIT',
                            ),
                          ),
                          addVerticalSpace(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                CupertinoIcons.back,
                                color: Colors.black87,
                                size: 18,
                              ),
                              addHorizontalSpace(10),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  language == 'ro' ? 'Autentificare' : 'Login',
                                  style: GoogleFonts.quicksand(
                                    textStyle: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                          addVerticalSpace(20),
                          Visibility(
                            visible: _errorVisibility,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: errorBox(error),
                            ),
                          ),
                          Visibility(
                            visible: _successVisibility,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: successBox(success),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> doesUserExist(String userId) async {
    final userRef = FirebaseFirestore.instance.collection('XUsers').doc(userId);
    final userDoc = await userRef.get();
    return userDoc.exists;
  }

  Future<void> checkUserStatus(String uid, BuildContext context) async {
    bool userExists = await doesUserExist(uid);
    if (userExists) {
      ///update device token
      // final fcmToken = await messaging.getToken();
      messaging.getToken().then((token) {
        userRef.doc(uid).update({
          'device_token': token,
          'user_last_interaction': DateTime.now().millisecondsSinceEpoch,
          'user_last_timestamp': FieldValue.serverTimestamp(),
        }).then((value) {
          // print("Token updated successfully!");
        }).catchError((error) {
          // print("Failed to update token: $error");
        });
      }).catchError((error) {
        // print('Failed to get token: $error');
      });

      ///check if profile is completed
      userRef.doc(uid).get().then((docSnapshot) {
        if (docSnapshot.exists) {
          var data = docSnapshot.data();
          var profileCompleted = data!['profile_completed'];

          if (profileCompleted) {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => HomePage(userId: uid),
              ),
              (r) => false,
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => SetUpAccountPage(userId: uid),
              ),
              (r) => false,
            );
          }
        }
      });
    } else {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => SetUpAccountPage(userId: uid),
          ),
          (r) => false,
        );
      }
    }
  }
}
