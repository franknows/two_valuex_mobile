import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';
import '../home/home_page.dart';
import 'login_screen.dart';

class SetupCompanyPage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const SetupCompanyPage(
      {super.key, required this.userId, required this.userData});

  @override
  State<SetupCompanyPage> createState() => _SetupCompanyPageState();
}

class _SetupCompanyPageState extends State<SetupCompanyPage> {
  final userRef = FirebaseFirestore.instance.collection('XUsers');
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

  @override
  void initState() {
    super.initState();
    setState(() {
      name = widget.userData['user_name'];
      registrationNo = widget.userData['registration_number'];
      userTown = widget.userData['user_city'];
      userAddress = widget.userData['user_address'];
      email = widget.userData['user_email'];
      userPhone = widget.userData['user_phone'];
      cui = widget.userData['user_cui_code'];
    });
  }

  @override
  void dispose() {
    super.dispose();
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
          body: companyBody(widget.userData!),
        ),
      ),
    );
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
                      child: simpleDarkRoundedButton(
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
}
