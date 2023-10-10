import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:linkwell/linkwell.dart';
import 'package:two_value/screens/auth/verify_email_page.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class RegisterCompanyPage extends StatefulWidget {
  final Function(bool) onLoadingChanged;
  final bool loading;
  final String language;
  const RegisterCompanyPage(
      {super.key,
      required this.onLoadingChanged,
      required this.loading,
      required this.language});

  @override
  State<RegisterCompanyPage> createState() => _RegisterCompanyPageState();
}

class _RegisterCompanyPageState extends State<RegisterCompanyPage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _errorVisibility = false;
  String email = '';
  String deviceToken = '';
  String password = '';
  String cui = '';
  bool _passwordVisible = false;
  String error = '';

  ///Termene
  String tUsername = 'OlivianaBijoux';
  String tPassword = '7j!ZVsNq^S';
  String basicAuth = '';
  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messaging.getToken().then((token) {
      setState(() {
        deviceToken = token!;
      });
    });
  }

  Future<bool> getData() async {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$tUsername:$tPassword'))}';

    try {
      var response = await http.get(
        Uri.parse("https://termene.ro/api/dateFirmaSumar.php?cui=$cui"),
        headers: <String, String>{
          "Accept": "application/json",
          "authorization": basicAuth,
        },
      );

      if (response.statusCode == 200) {
        data = json.decode(response.body);
        return true;
      } else {
        handleErrorBasedOnStatusCode(response.statusCode);
        return false;
      }
    } catch (e) {
      // Network or other unforeseen errors
      handleUnexpectedError();
      return false;
    }
  }

  void handleErrorBasedOnStatusCode(int statusCode) {
    if (statusCode == 400) {
      //Bad request
      setErrorState(widget.language == 'Romanian'
          ? 'CUI pe care l-ați introdus este incorect formatat. Verificați și încercați din nou sau contactați asistența 2value.'
          : 'The CUI you have entered is incorrectly formatted. Check and try again or contact 2value support.');
    } else {
      //unauthorized access or other errors
      setErrorState(widget.language == 'Romanian'
          ? 'Ne confruntăm cu o eroare de sistem, te rugăm să contactezi echipa de suport 2value.'
          : 'We are experiencing a system error, please contact the 2value support team.');
    }
  }

  void handleUnexpectedError() {
    setErrorState(widget.language == 'ro'
        ? 'Hopa! A apărut o eroare, te rugăm să verifici și să încerci din nou.'
        : 'Oops! Something went wrong, please check and try again.');
  }

  void setErrorState(String errorMessage) {
    setState(() {
      widget.onLoadingChanged(false);
      _errorVisibility = true;
      error = errorMessage;
    });
  }

  Future<void> registerCompanyWithEmailAndPassword(
      String cui, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();

      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;
        saveData(userId);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        widget.onLoadingChanged(false);
        _errorVisibility = true;
        error = getFirebaseErrorMessage(e.code);
      });
    }
  }

  String getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return widget.language == 'ro'
            ? 'Vă rugăm să alegeți o parolă mai puternică pentru o securitate sporită.'
            : 'Please choose a stronger password for enhanced security.';
      case 'email-already-in-use':
        return widget.language == 'ro'
            ? 'Un cont asociat cu această adresă de e-mail există deja.'
            : 'An account associated with this email address already exists.';
      default:
        return widget.language == 'ro'
            ? 'Hopa! A apărut o eroare, te rugăm să verifici și să încerci din nou.'
            : 'Oops! Something went wrong, please check and try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            blackBoldTextWithSize(
                widget.language == 'ro' ? 'ÎNREGISTREAZĂ-TE' : 'REGISTER', 16),
            addVerticalSpace(4.0),
            blackNormalText(widget.language == 'ro'
                ? 'Introduceți informațiile dvs. pentru a crea un cont.'
                : 'Enter your information to create an account.'),
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
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp('[ROro0-9]'),
                ),
              ],
              decoration: inputDecorationWithIcon(
                widget.language == 'ro' ? 'Compania CUI' : 'Company CUI',
                CupertinoIcons.building_2_fill,
              ),
              onChanged: (val) {
                setState(() {
                  _errorVisibility = false;
                  cui = val.trim();
                });
              },
              validator: (value) {
                if (isValidLength(value!)) {
                  return null; // valid
                } else {
                  return widget.language == 'ro'
                      ? 'CUI nevalid'
                      : 'Invalid CUI';
                }
              },
            ),
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
                widget.language == 'ro' ? 'E-mail' : 'E-mail',
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
                      ? (widget.language == 'ro'
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
                labelText: widget.language == 'ro' ? 'Parola' : 'Password',
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
                  borderSide:
                      const BorderSide(width: 1.5, color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1.5, color: Colors.red),
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
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
              validator: (val) => passwordValidator(password, widget.language),
            ),
            addVerticalSpace(30),
            widget.language == 'ro'
                ? LinkWell(
                    "Prin înregistrare sunteți de acord cu https://2value.ro/terms și https://2value.ro/gdpr",
                    listOfNames: {
                      'https://2value.ro/terms': 'termeni',
                      'https://2value.ro/gdpr': 'confidențialitate'
                    },
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                        letterSpacing: .5,
                      ),
                    ),
                    linkStyle: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.blueAccent,
                        letterSpacing: .5,
                      ),
                    ),
                  )
                : LinkWell(
                    "By registering you agree to our https://2value.ro/terms and https://2value.ro/gdpr",
                    listOfNames: {
                      'https://2value.ro/terms': 'terms',
                      'https://2value.ro/gdpr': 'privacy Policy'
                    },
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                        letterSpacing: .5,
                      ),
                    ),
                    linkStyle: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.blueAccent,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
            addVerticalSpace(30),
            InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _errorVisibility = false;
                    widget.onLoadingChanged(true);
                  });
                  getData().then((success) {
                    if (success) {
                      registerCompanyWithEmailAndPassword(cui, email, password);
                    }
                  });
                } else {
                  setState(
                    () {
                      _errorVisibility = true;
                      widget.onLoadingChanged(false);
                      error = (widget.language == 'ro'
                          ? 'Te rugăm să completezi toate câmpurile!'
                          : 'Please fill everything');
                    },
                  );
                }
              },
              child: simpleRoundedButton(
                widget.language == 'ro' ? 'ÎNREGISTREAZĂ-TE' : 'REGISTER',
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
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      child: Text(
                        widget.language == 'ro' ? 'Autentificare' : 'Login',
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
          ],
        ),
      ),
    );
  }

  bool isValidLength(String value) {
    // Remove initial 'RO' or 'ro' if present
    String processedValue = value;
    if (processedValue.toUpperCase().startsWith('RO')) {
      processedValue = processedValue.substring(2);
    }

    // Check length constraints: not less than 6 and not greater than 10
    return processedValue.length >= 6 && processedValue.length <= 10;
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

  saveData(String userId) {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('XUsers').doc(userId);
    Map<String, dynamic> tasks = {
      'user_name': data['nume'],
      'nick_name': '-',
      'account_type': 'Company',
      'email_verification': false,
      'profile_completed': false,
      'user_authority': '-',
      'user_email': email,
      'user_id': userId,
      'user_image':
          'https://firebasestorage.googleapis.com/v0/b/twovaluex.appspot.com/o/Defaults%2FImages%2Fcompany_profile.png?alt=media&token=8f6af082-1003-4e51-b998-114964557687',
      'user_phone': data['telefon'],
      'user_city': data['localitate'],
      'bank_name': '-',
      'link1': '-',
      'link2': '-',
      'link3': '-',
      'id_image': '-',
      'badge_image': '-',
      'personal_name_in_company': '-',
      'personal_position_in_company': '-',
      'user_plan': '-',
      'mention_left_count': 0,
      'interviews_count': 0,
      'package_purchased_time': FieldValue.serverTimestamp(),
      'package_expiry_time': FieldValue.serverTimestamp(),
      'user_last_interaction': DateTime.now().millisecondsSinceEpoch,
      'user_last_timestamp': FieldValue.serverTimestamp(),
      'press_left_count': 0,
      'event_left_count': 0,
      'interview_left_count': 0,
      'press_event_left_count': 0,
      'link_left_count': 0,
      'notified_on_expiry': false,
      'user_power': '-',
      'registration_number': data['cod_inmatriculare'],
      'user_locality': 'Romania',
      'user_address': data['adresa'],
      'about_user': '',
      'external_link': '',
      'user_verification': false,
      'subscriptions_count': 0,
      'presses_count': 0,
      'events_count': 0,
      'action_title': '-',
      'user_cui_code': cui,
      'user_extra': '-',
      'notification_count': 1,
      'user_wallet': 0,
      'press_credits': 0,
      'interview_credits': 0,
      'make_money': '-',
      'personal_email_in_company': '-',
      'personal_phone_in_company': '-',
      'personal_facebook_profile': '-',
      'personal_linked_in_profile': '-',
      'personal_twitter_profile': '-',
      'device_token': deviceToken,
      'creation_date': FieldValue.serverTimestamp(),
      'last_feedback_date': 0,
      'feedback_consent': true,
      'rated_on_stores': false,
      'watched_initial_videos': false,
      'edited_presses_count': 0,
      'edited_interviews_count': 0,
      'facebook_profile': '',
      'linked_in_profile': '',
      'notified_on_deletion': false,
      'last_online': FieldValue.serverTimestamp(),
      'show_dialog': true,
      'bank_account_name': '-',
      'bank_account_number': '-',
      'twitter_profile': '',
      'topic_subscriptions': FieldValue.arrayUnion(['2value']),
      'edited_events_count': 0,
      'searchKeywords': FieldValue.arrayUnion([]),
      'user_categories': FieldValue.arrayUnion(['2value']),
      'user_language': widget.language,
      'user_has_task': false,
    };
    ds.set(tasks).whenComplete(() {
      ///subscribe to topics
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => VerifyEmailPage(
              userId: userId,
            ),
          ),
          (r) => false);
    });
  }
}
