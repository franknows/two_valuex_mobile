import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:two_value/screens/auth/register_company_page.dart';
import 'package:two_value/screens/auth/register_journalist_page.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userRef = FirebaseFirestore.instance.collection('XUsers');
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool _loading = false;
  String language = 'ro';
  String _selectedType = 'Company';
  final _controller = ValueNotifier('Company');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      setState(() {
        _selectedType = _controller.value;
      });
    });
  }

  void _updateLoading(bool value) {
    setState(() {
      _loading = value;
    });
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
                    addVerticalSpace(0),
                    Center(
                      child: Image(
                        height: size.width / 1.5,
                        width: size.width / 1.5,
                        image: const AssetImage(
                          'assets/images/login_image_one.png',
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
                  child: Column(
                    children: [
                      addVerticalSpace(20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AdvancedSegment(
                            controller: _controller,
                            segments: const {
                              'Company': 'Company',
                              'Journalist': 'Journalist',
                            },
                            activeStyle: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                            ),
                            inactiveStyle: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                            ),
                            backgroundColor: Colors.black26, // Color
                            sliderColor: Colors.white, // Color
                            sliderOffset: 2.0, // Double
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8.0)), // BorderRadius
                            itemPadding: const EdgeInsets.symmetric(
                              // EdgeInsets
                              horizontal: 15,
                              vertical: 10,
                            ),
                            animationDuration:
                                const Duration(milliseconds: 250), // Duration
                            shadow: const <BoxShadow>[
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                      addVerticalSpace(20),
                      _selectedType == 'Company'
                          ? RegisterCompanyPage(
                              onLoadingChanged: _updateLoading,
                              loading: _loading,
                              language: language,
                            )
                          : RegisterJournalistPage(
                              onLoadingChanged: _updateLoading,
                              loading: _loading,
                              language: language,
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
