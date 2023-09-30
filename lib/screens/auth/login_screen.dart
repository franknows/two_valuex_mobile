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
import 'register_page.dart';
import 'reset_password.dart';
import 'setup_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userRef = FirebaseFirestore.instance.collection('XUsers');
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _errorVisibility = false;
  String email = '';
  String password = '';
  bool _passwordVisible = false;
  String error = '';
  String language = 'ro';

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;
        if (mounted) {
          checkUserStatus(userId, context);
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
      });
      print(e.code);
      print(e.message);
      setState(() {
        _errorVisibility = true;
      });
      if (e.code == 'user-not-found') {
        setState(
          () {
            error = (language == 'ro'
                ? 'Contul de utilizator nu a fost găsit, e nevoie să te înregistrezi mai întâi.'
                : 'User account was not found, you might need to sign up first.');
          },
        );
      } else if (e.code == 'network-request-failed') {
        setState(
          () {
            error = (language == 'ro'
                ? 'Ceva este în neregulă cu conexiunea la rețea, te rugăm să verifici și să încerci din nou.'
                : 'Something is wrong with your network connection, please check and try again.');
          },
        );
      } else if (e.code == 'user-disabled') {
        setState(
          () {
            error = (language == 'ro'
                ? 'Contul tău a fost dezactivat, nu ezita să ne contactezi.'
                : 'Your account has been disabled, feel free to contact us.');
          },
        );
      } else if (e.code == 'wrong-password') {
        setState(() {
          error = (language == 'ro'
              ? 'Parola introdusă nu este validă, te rugăm să verifici și să încerci din nou.'
              : 'The password you entered is invalid, please check and try again.');
        });
      } else {
        setState(
          () {
            error = (language == 'ro'
                ? 'Hopa! A apărut o eroare, te rugăm să verifici și să încerci din nou.'
                : 'Oops! Something went wrong, please check and try again.');
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
                          'assets/images/login_image.png',
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
                              language == 'ro' ? 'AUTENTIFICARE' : 'LOGIN', 16),
                          addVerticalSpace(4.0),
                          blackNormalText(language == 'ro'
                              ? 'Ai cel puțin trei apariții media garantate, la câteva click-uri distanță.'
                              : 'You have at least three media appearances guaranteed, just a few clicks away.'),
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
                          addVerticalSpace(20.0),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: !_passwordVisible,
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black54,
                                letterSpacing: .5,
                              ),
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              labelText:
                                  language == 'ro' ? 'Parola' : 'Password',
                              labelStyle: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5,
                                ),
                              ),
                              helperStyle: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                  letterSpacing: .5,
                                ),
                              ),
                              errorStyle: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  fontSize: 12.0,
                                  color: TAppTheme.errorColor,
                                  letterSpacing: .5,
                                ),
                              ),
                              prefixIconColor: Colors.blueGrey,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0.0,
                                horizontal: 4.0,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1.5,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.red),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              prefixIcon: const Icon(
                                CupertinoIcons.lock,
                                color: Colors.blueGrey,
                                size: 18,
                                // size: 18,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _errorVisibility = false;
                                password = val.trim();
                              });
                            },
                            validator: (val) =>
                                passwordValidator(password, language),
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
                                signInWithEmailAndPassword(email, password);
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
                              language == 'ro' ? 'AUTENTIFICARE' : 'LOGIN',
                            ),
                          ),
                          addVerticalSpace(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => const ResetPassword(),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: 160,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      language == 'ro'
                                          ? 'Resetează parola'
                                          : 'Reset password',
                                      style: GoogleFonts.quicksand(
                                        textStyle: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 14,
                                width: 1,
                                color: Colors.grey,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => const RegisterPage(),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: 160,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      language == 'ro'
                                          ? 'Înregistrează-te'
                                          : 'Register',
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
                                ),
                              )
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

  String? passwordValidator(String? val, String lang) {
    if (val == null || val.isEmpty) {
      return lang == 'ro' ? 'Parola este necesară' : 'Password is required';
    } else if (val.length > 18) {
      return lang == 'ro' ? 'Parola prea lungă' : 'Password too long';
    } else if (val.length < 6) {
      return lang == 'ro' ? 'Parola prea scurtă' : 'Password too short';
    }
    return null; // means no error
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
