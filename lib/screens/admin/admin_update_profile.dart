import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../../../src/helper_widgets.dart';
import '../../../src/theme.dart';

class AdminUpdateProfile extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminUpdateProfile(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminUpdateProfile> createState() => _AdminUpdateProfileState();
}

class _AdminUpdateProfileState extends State<AdminUpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone = '';
  String location = '';
  bool _loading = false;
  String language = '';
  String biography = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      language = widget.userData['user_language'];
      name = widget.userData['user_name'];
      // location = widget.userData['user_location_name'];
      biography = widget.userData['about_user'];
      phone = widget.userData['user_phone'];
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
        appIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: TAppTheme.primaryColor,
              border: Border.all(
                color: TAppTheme.primaryColor,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(6.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/no_bg_logo.png',
              ),
            ),
          ),
        ),
        appIconSize: 50,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 4,
            centerTitle: false,
            backgroundColor: TAppTheme.primaryColor,
            title: appBarWhiteText(
                language == 'ro' ? 'Actualizare profil' : 'Update profile'),
          ),
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SizedBox(
                width: double.infinity,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.minHeight,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Opacity(
                              opacity: 0.5,
                              child: ClipPath(
                                clipper: WaveClipper(),
                                child: Container(
                                  color: TAppTheme.primaryColor,
                                  height: 200,
                                ),
                              ),
                            ),
                            ClipPath(
                              clipper: WaveClipper(),
                              child: Container(
                                color: TAppTheme.primaryColor,
                                height: 180,
                              ),
                            ),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.always,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  initialValue: widget.userData['user_name'],
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.text,
                                  style: textFieldStyle(),
                                  decoration: inputDecorationWithIcon(
                                      language == 'ro' ? 'Nume' : 'Name',
                                      CupertinoIcons.person),
                                  onChanged: (val) {
                                    setState(() {
                                      name = val.trim();
                                    });
                                  },
                                  validator: (val) => val!.length > 3
                                      ? null
                                      : (language == 'ro'
                                          ? 'Introduceți un nume'
                                          : 'Enter a name'),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  initialValue: widget.userData['user_phone'],
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.text,
                                  style: textFieldStyle(),
                                  decoration: inputDecorationWithIcon(
                                    language == 'ro'
                                        ? 'Număr de telefon'
                                        : 'Phone number',
                                    CupertinoIcons.phone,
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      phone = val.trim();
                                    });
                                  },
                                  validator: (val) => val!.length > 9
                                      ? null
                                      : (language == 'ro'
                                          ? 'Introduceți un număr de telefon valid'
                                          : 'Enter a valid phone number'),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  initialValue: location,
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.text,
                                  style: textFieldStyle(),
                                  decoration: inputDecorationWithIcon(
                                    language == 'ro'
                                        ? 'Introduceți locația'
                                        : 'Enter location',
                                    CupertinoIcons.map_pin_ellipse,
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      location = val.trim();
                                    });
                                  },
                                  validator: (val) => val!.length > 3
                                      ? null
                                      : (language == 'ro'
                                          ? 'Introdu o locație validă'
                                          : 'Enter a valid location'),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  initialValue: widget.userData['about_user'],
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                  style: GoogleFonts.quicksand(
                                    textStyle: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                  decoration: inputDecoration('Bio'),
                                  onChanged: (val) {
                                    setState(() => biography = val.trim());
                                  },
                                  validator: (value) => value!.length < 30
                                      ? (language == 'ro'
                                          ? 'Bio prea scurt'
                                          : 'Bio too short')
                                      : value.length > 500
                                          ? (language == 'ro'
                                              ? 'Bio prea lungă'
                                              : 'Bio too long')
                                          : null,
                                ),
                                const SizedBox(
                                  height: 40.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    onSubmitButtonPressed(name, context);
                                  },
                                  child: simpleButton(
                                      language == 'ro' ? 'Trimite' : 'Submit'),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void onSubmitButtonPressed(String username, BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _loading = false;
      });
      snackError(
        language == 'ro'
            ? 'Vă rugăm să completați totul!'
            : 'Please fill in everything!',
        context,
      );
      return;
    }
    setState(() {
      _loading = true;
    });
    saveData();
  }

  void saveData() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Users').doc(widget.userId);

    Map<String, dynamic> tasks = {
      'user_name': name,
      'user_phone': phone,
      'user_location_name': location,
      'user_last_interaction': DateTime.now().millisecondsSinceEpoch,
      'user_last_timestamp': FieldValue.serverTimestamp(),
      'about_user': biography,
    };

    ds.update(tasks).whenComplete(() {
      setState(() {
        _loading = false;
      });
      Navigator.pop(context);
    });
  }
}
