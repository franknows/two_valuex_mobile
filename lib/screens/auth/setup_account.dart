import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:number_selector/number_selector.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:two_value/screens/auth/setup_company_page.dart';
import 'package:two_value/screens/auth/setup_journalist_page.dart';
import 'package:two_value/screens/auth/setup_unknown_page.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';
import '../home/home_page.dart';
import 'login_screen.dart';

class SetUpAccountPage extends StatefulWidget {
  final String userId;

  const SetUpAccountPage({super.key, required this.userId});

  @override
  State<SetUpAccountPage> createState() => _SetUpAccountPageState();
}

class _SetUpAccountPageState extends State<SetUpAccountPage> {
  final userRef = FirebaseFirestore.instance.collection('XUsers');
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _errorVisibility = false;
  String name = '';
  String cui = '';
  String registrationNo = '';
  String userTown = '';
  String userAddress = '';
  String userPhone = '';
  String email = '';
  String password = '';
  bool _passwordVisible = false;
  String error = '';
  String language = 'ro';

  final StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  DocumentSnapshot? _userData;

  @override
  void initState() {
    super.initState();

    _getUserData(widget.userId);
  }

  @override
  void dispose() {
    // Close the stream controller when the widget is disposed
    _streamController.close();
    super.dispose();
  }

  void _getUserData(String userId) {
    FirebaseFirestore.instance
        .collection('XUsers')
        .doc(userId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          _userData = snapshot;
          name = snapshot['user_name'];
          registrationNo = snapshot['registration_number'];
          userTown = snapshot['user_city'];
          userAddress = snapshot['user_address'];
          email = snapshot['user_email'];
          userPhone = snapshot['user_phone'];
          cui = snapshot['user_cui_code'];
        });
      } else {
        ///do nothing
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          body: _userData == null
              ? Column(
                  children: [
                    addVerticalSpace(120),
                  ],
                )
              : decider(_userData!),
        ),
      ),
    );
  }

  decider(DocumentSnapshot userData) {
    if (userData['account_type'] == 'Company') {
      return SetupCompanyPage(
        userId: widget.userId,
        userData: userData,
      );
    } else if (userData['account_type'] == 'Journalist') {
      return SetupJournalistPage(
        userId: widget.userId,
        userData: userData,
      );
    } else {
      return SetupUnknownPage(
        userId: widget.userId,
        userData: userData,
      );
    }
  }

  Widget companyBody(DocumentSnapshot userData) {
    var size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () async {
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
                    icon: const Icon(CupertinoIcons.arrow_left_square)),
              ],
            ),
            addVerticalSpace(80),
            blackBoldTextWithSize(
                userData['user_language'] == 'ro'
                    ? 'Verificați-vă profilul'
                    : 'Verify your profile',
                20),
            addVerticalSpace(4.0),
            blackNormalText(userData['user_language'] == 'ro'
                ? 'Vă rugăm să vă verificați profilul pentru informații incorecte.'
                : 'Please verify your profile for incorrect information.'),
            addVerticalSpace(10),
            const Divider(),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    addVerticalSpace(20.0),
                    TextFormField(
                      initialValue: name,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecorationWithIcon(
                        userData['user_language'] == 'ro'
                            ? 'Numele companiei'
                            : 'Company name',
                        CupertinoIcons.building_2_fill,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _errorVisibility = false;
                          name = val.trim();
                        });
                      },
                      validator: (val) => val!.length < 3
                          ? (language == 'ro'
                              ? 'Introduceți un nume valid'
                              : 'Enter a valid name')
                          : null,
                    ),
                    addVerticalSpace(20.0),
                    TextFormField(
                      initialValue: registrationNo,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecorationWithIcon(
                        userData['user_language'] == 'ro'
                            ? 'Cod de înregistrare'
                            : 'Registration code',
                        CupertinoIcons.number_circle,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _errorVisibility = false;
                          registrationNo = val.trim();
                        });
                      },
                      validator: (val) => val!.length < 3
                          ? (userData['user_language'] == 'ro'
                              ? 'Introduceți un cod de înregistrare valid'
                              : 'Enter a valid registration code')
                          : null,
                    ),
                    addVerticalSpace(20.0),
                    TextFormField(
                      initialValue: userAddress,
                      enabled: true,
                      maxLines: null,
                      keyboardType: TextInputType.text,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecorationWithIcon(
                        userData['user_language'] == 'ro'
                            ? 'Adresa firmei'
                            : 'Firm address',
                        CupertinoIcons.map_pin_ellipse,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _errorVisibility = false;
                          userAddress = val.trim();
                        });
                      },
                      validator: (val) => val!.length < 3
                          ? (userData['user_language'] == 'ro'
                              ? 'Introdu o adresă validă'
                              : 'Enter a valid address')
                          : null,
                    ),
                    addVerticalSpace(20.0),
                    TextFormField(
                      initialValue: userPhone,
                      enabled: true,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecorationWithIcon(
                        language == 'ro' ? 'Număr de telefon' : 'Phone number',
                        CupertinoIcons.phone,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _errorVisibility = false;
                          userPhone = val.trim();
                        });
                      },
                      validator: (val) => val!.length < 3
                          ? (language == 'ro'
                              ? 'Introduceți un număr de telefon valid'
                              : 'Enter a valid phone number')
                          : null,
                    ),
                    addVerticalSpace(20.0),
                    TextFormField(
                      initialValue: email,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecorationWithIcon(
                        language == 'Romanian' ? 'E-mail' : 'E-mail',
                        CupertinoIcons.envelope,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _errorVisibility = false;
                          email = val.trim();
                        });
                      },
                      validator: (val) => val!.length < 3
                          ? (language == 'Romanian'
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
                            _loading = true;
                          });
                          saveCompanyData();
                        } else {
                          setState(
                            () {
                              _loading = false;
                              snackError(
                                  userData['user_language'] == 'ro'
                                      ? 'Te rugăm să completezi toate câmpurile!'
                                      : 'Please fill everything',
                                  context);
                            },
                          );
                        }
                      },
                      child: simpleRoundedButton(
                        language == 'Romanian' ? 'CONTINUA' : 'CONTINUE',
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveCompanyData() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);
    Map<String, dynamic> tasks = {
      'user_name': name,
      'profile_completed': true,
      'user_email': email,
      'user_phone': userPhone,
      'personal_name_in_company': '-',
      'personal_position_in_company': '-',
      'registration_number': registrationNo,
      'user_address': userAddress,
      'about_user': '',
      'external_link': '',
      'user_verification': false,
      'subscriptions_count': 0,
      'presses_count': 0,
      'events_count': 0,
      'action_title': 'profile-completed',
      'user_cui_code': cui,
      'personal_email_in_company': '-',
      'personal_phone_in_company': '-',
      'personal_facebook_profile': '-',
      'personal_linked_in_profile': '-',
      'personal_twitter_profile': '-',
      'facebook_profile': '',
      'linked_in_profile': '',
      'twitter_profile': '',
    };
    ds.update(tasks).whenComplete(() {
      setState(() {
        _loading = false;
      });

      ///subscribe to topics
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => HomePage(
              userId: widget.userId,
            ),
          ),
          (r) => false);
    });
  }

  Widget journalistBody(DocumentSnapshot userData) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          child: Column(
            children: [
              addVerticalSpace(60),
              SizedBox(
                height: size.width,
                width: size.width,
                child: Center(
                  child: Image(
                    height: size.width / 1.2,
                    width: size.width / 1.2,
                    image: const AssetImage(
                      'assets/images/login_image.png',
                    ),
                    fit: BoxFit.cover,
                  ),
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
                  offset: const Offset(0, 3), // changes position of shadow
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
                        language == 'Romanian' ? 'AUTENTIFICARE' : 'LOGIN', 20),
                    addVerticalSpace(4.0),
                    blackNormalText(
                        'You have at least three media appearances guaranteed, just a few clicks away.'),
                    addVerticalSpace(20.0),
                    TextFormField(
                      initialValue: userPhone,
                      enabled: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp('[0-9]'),
                        ),
                      ],
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecorationWithIcon(
                        language == 'ro' ? 'Număr de telefon' : 'Phone number',
                        CupertinoIcons.phone,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _errorVisibility = false;
                          userPhone = val.trim();
                        });
                      },
                      validator: (val) => val!.length < 10
                          ? (language == 'ro'
                              ? 'Introduceți un număr de telefon valid'
                              : 'Enter a valid phone number')
                          : null,
                    ),
                    addVerticalSpace(20.0),
                    TextFormField(
                      initialValue: email,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                          letterSpacing: .5,
                        ),
                      ),
                      decoration: inputDecorationWithIcon(
                        language == 'Romanian' ? 'E-mail' : 'E-mail',
                        CupertinoIcons.envelope,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _errorVisibility = false;
                          email = val.trim();
                        });
                      },
                      validator: (val) => val!.length < 3
                          ? (language == 'Romanian'
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
                            language == 'Romanian' ? 'Parola' : 'Password',
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
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.red),
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
                      validator: (val) => val!.length > 18
                          ? (language == 'Romanian'
                              ? 'Parola prea lungă'
                              : 'Password too long')
                          : null,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                              builder: (context) =>
                                  HomePage(userId: widget.userId),
                            ),
                            (r) => false);
                      },
                      child: simpleRoundedButton(
                        language == 'Romanian' ? 'AUTENTIFICARE' : 'LOGIN',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          language == 'Romanian'
                              ? 'Ați uitat parola?'
                              : 'Forgot password?',
                          style: GoogleFonts.quicksand(
                            textStyle: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (_) => ResetPasswordPage(),
                            //   ),
                            // );
                          },
                          child: Text(
                            language == 'Romanian'
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
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
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
    );
  }
}
