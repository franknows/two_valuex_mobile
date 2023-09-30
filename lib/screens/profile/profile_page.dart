import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import '../../src/helper_widgets.dart';
import '../../src/theme.dart';
import '../account/delete_account_page.dart';
import '../account/update_location_page.dart';
import '../admin/admin_page.dart';
import '../auth/login_screen.dart';
import 'search_plan_page.dart';
import 'update_images.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _sheetFormKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool nickNameAvailable = false;
  String _username = '-';
  String biography = '-';
  int _age = 0;
  bool canChangeBio = false;
  bool canChangeUsername = false;
  bool canChangeAge = false;
  bool canChangeGender = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('XUsers')
            .where('user_id', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot myRealtimeInfo = snapshot.data!.docs[0];
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: const Color(0xff184a45),
                elevation: 4,
                title: Text(
                  myRealtimeInfo['user_language'] == 'sw'
                      ? 'Wasifu'
                      : 'Profile',
                  style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      letterSpacing: .5,
                    ),
                  ),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      ///show dialog
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      dialogTitleText(
                                          myRealtimeInfo['user_language'] ==
                                                  'sw'
                                              ? 'Kurekebisha taarifa zako'
                                              : 'Updating your information'),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      dialogBodyText(myRealtimeInfo[
                                                  'user_language'] ==
                                              'sw'
                                          ? 'Kurekebisha taarifa zako, bonyeza na kushikilia taarifa unayohitaji kurekebisha.'
                                          : 'To update your profile information, press and hold the field you want to update.'),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: watchButton(myRealtimeInfo[
                                                          'user_language'] ==
                                                      'sw'
                                                  ? 'Sawa'
                                                  : 'Okay'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      CupertinoIcons.info,
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  color: Colors.blueGrey.withOpacity(0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width / 2,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.3),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(0),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width / 2,
                                decoration: const BoxDecoration(
                                  color: Color(0xff184a45),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 90,
                                    ),
                                    whiteBoldText(myRealtimeInfo['user_name']),
                                    const SizedBox(
                                      height: 6.0,
                                    ),
                                    const Icon(
                                      CupertinoIcons.heart,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      height: 2.0,
                                    ),
                                    myRealtimeInfo['user_language'] == 'sw'
                                        ? whiteNormalText(myRealtimeInfo[
                                                    'user_total_hits'] ==
                                                0
                                            ? ''
                                            : myRealtimeInfo[
                                                        'user_total_hits'] ==
                                                    1
                                                ? 'Mtu 1 anakupenda'
                                                : 'Watu ${myRealtimeInfo['user_total_hits']} Wanakupenda')
                                        : whiteNormalText(myRealtimeInfo[
                                                    'user_total_hits'] ==
                                                0
                                            ? ''
                                            : myRealtimeInfo[
                                                        'user_total_hits'] ==
                                                    1
                                                ? '1 person likes you'
                                                : '${myRealtimeInfo['user_total_hits']} people like you'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: (width / 2) - 80,
                            right: (width / 2) - 100,
                            child: InkWell(
                              onTap: () {
                                /// go to profile update page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UpdateImages(
                                      userId: widget.userId,
                                    ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 100,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 97,
                                  backgroundImage: CachedNetworkImageProvider(
                                    myRealtimeInfo['user_image'],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              InkWell(
                                onLongPress: () {
                                  setState(() {
                                    canChangeBio = true;
                                  });
                                },
                                child: profileTiles(
                                  'Bio',
                                  myRealtimeInfo['about_user'],
                                ),
                              ),
                              Visibility(
                                visible: canChangeBio,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Form(
                                      key: _sheetFormKey,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormField(
                                            initialValue:
                                                myRealtimeInfo['about_user'],
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            keyboardType: TextInputType.text,
                                            maxLength: 120,
                                            maxLines: null,
                                            style: GoogleFonts.quicksand(
                                              textStyle: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black54,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor:
                                                  Colors.white.withOpacity(.2),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 8.0,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 1.5,
                                                  color: Colors.blueGrey
                                                      .withOpacity(.4),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  4.0,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1.5,
                                                  color: Colors.red,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  4.0,
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 1.5,
                                                  color: Colors.red,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  4.0,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1.5,
                                                    color: Colors.blueGrey
                                                        .withOpacity(.4)),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                            ),
                                            onChanged: (val) {
                                              setState(
                                                  () => biography = val.trim());
                                            },
                                            validator: (val) => val!.length > 30
                                                ? null
                                                : (myRealtimeInfo[
                                                            'user_language'] ==
                                                        'sw'
                                                    ? 'Fupi sana'
                                                    : 'Too short'),
                                          ),
                                          const SizedBox(
                                            height: 6.0,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      canChangeBio = false;
                                                    });
                                                  },
                                                  child: laterButton(myRealtimeInfo[
                                                              'user_language'] ==
                                                          'sw'
                                                      ? 'Sitisha'
                                                      : 'Cancel'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    if (_sheetFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        canChangeBio = false;
                                                      });

                                                      ///start of user update
                                                      DocumentReference ds =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'XUsers')
                                                              .doc(widget
                                                                  .userId);
                                                      Map<String, dynamic>
                                                          updateTasks = {
                                                        'about_user': biography,
                                                      };
                                                      ds.update(updateTasks);

                                                      ///end of user update
                                                    } else {
                                                      snackError(
                                                          'Please fill in a bio.');
                                                    }
                                                  },
                                                  child: watchButton(myRealtimeInfo[
                                                              'user_language'] ==
                                                          'sw'
                                                      ? 'Badili'
                                                      : 'Update'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              const Divider(),
                              profileTiles(
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Mahali ulipo'
                                    : 'Your location',
                                myRealtimeInfo['user_location_name'] +
                                    ', ' +
                                    myRealtimeInfo['user_country'],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  // getCurrentLocation(
                                  //     myRealtimeInfo['user_language']);

                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => UpdateLocationPage(
                                          userId: widget.userId),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color:
                                        TAppTheme.primaryColor.withOpacity(.8),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(19),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.location_solid,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      whiteBoldText(
                                        myRealtimeInfo['user_language'] == 'sw'
                                            ? 'Weka mahali ulipo'
                                            : 'Update your location',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(),
                              profileTiles(
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Lugha (${myRealtimeInfo['user_language']})'
                                    : 'Language (${myRealtimeInfo['user_language']})',
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Bonyeza kubadili lugha'
                                    : 'Tap to change the language',
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        ///start of user update
                                        DocumentReference ds = FirebaseFirestore
                                            .instance
                                            .collection('XUsers')
                                            .doc(widget.userId);
                                        Map<String, dynamic> updateTasks = {
                                          'user_language': 'sw',
                                        };
                                        ds.update(updateTasks);
                                      },
                                      child: swToggleBox(
                                          myRealtimeInfo['user_language']),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          ///start of user update
                                          DocumentReference ds =
                                              FirebaseFirestore.instance
                                                  .collection('XUsers')
                                                  .doc(widget.userId);
                                          Map<String, dynamic> updateTasks = {
                                            'user_language': 'eng',
                                          };
                                          ds.update(updateTasks);
                                        });
                                      },
                                      child: engToggleBox(
                                          myRealtimeInfo['user_language']),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              // const Divider(),
                              // profileTiles(
                              //   myRealtimeInfo['user_language'] == 'sw'
                              //       ? 'Jinsia ya kuonesha (${myRealtimeInfo['gender_to_show'] == 'FEMALE' ? 'KE' : 'ME'})'
                              //       : 'Gender to show (${myRealtimeInfo['gender_to_show']})',
                              //   myRealtimeInfo['user_language'] == 'sw'
                              //       ? 'Bonyeza kubadili jinsia unayohitaji kuona.'
                              //       : 'Tap to change the gender you need to see.',
                              // ),
                              // const SizedBox(
                              //   height: 6.0,
                              // ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       flex: 1,
                              //       child: InkWell(
                              //         onTap: () {
                              //           ///start of user update
                              //           DocumentReference ds =
                              //               FirebaseFirestore.instance
                              //                   .collection('XUsers')
                              //                   .doc(widget.userId);
                              //           Map<String, dynamic> updateTasks = {
                              //             'gender_to_show': 'MALE',
                              //           };
                              //           ds.update(updateTasks);
                              //         },
                              //         child: genderMaleToggleBox(
                              //             myRealtimeInfo['gender_to_show'],
                              //             myRealtimeInfo['user_language']),
                              //       ),
                              //     ),
                              //     const SizedBox(
                              //       width: 10,
                              //     ),
                              //     Expanded(
                              //       flex: 1,
                              //       child: InkWell(
                              //         onTap: () {
                              //           setState(() {
                              //             ///start of user update
                              //             DocumentReference ds =
                              //                 FirebaseFirestore.instance
                              //                     .collection('XUsers')
                              //                     .doc(widget.userId);
                              //             Map<String, dynamic> updateTasks = {
                              //               'gender_to_show': 'FEMALE',
                              //             };
                              //             ds.update(updateTasks);
                              //           });
                              //         },
                              //         child: genderFemaleToggleBox(
                              //             myRealtimeInfo['gender_to_show'],
                              //             myRealtimeInfo['user_language']),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // const SizedBox(
                              //   height: 2.0,
                              // ),
                              const Divider(),
                              profileTiles(
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Eneo la kutafuta (${myRealtimeInfo['user_plan'] ?? 'Nchi nzima'})'
                                    : 'Area to search (${myRealtimeInfo['user_plan'] ?? 'Entire country'})',
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Bonyeza kuchagua eneo ambalo ungependa kuona watu walioko katika eneo hilo.'
                                    : 'Press to choose an area that you would like to see people from that area.',
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              InkWell(
                                onTap: () {
                                  _openBottomSheet(context, myRealtimeInfo);
                                },
                                child: searchPlanButton(
                                    myRealtimeInfo['user_language'] == 'sw'
                                        ? 'Chagua eneo la kuonesha'
                                        : 'Pick an area to show'),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              const Divider(),
                              profileTiles(
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Uamuzi wa kuonekana'
                                    : 'Profile visibility',
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Ukichagua kutokuonekana, watu hawataweza kukuona kwenye orodha ya watu walipo.'
                                    : 'If you choose to hide your visibility people will not be able to see you from the list',
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  myRealtimeInfo['user_visibility']
                                      ? Text(
                                          myRealtimeInfo['user_language'] ==
                                                  'sw'
                                              ? 'Sasa unaonekana'
                                              : 'Now you are visible',
                                          style: GoogleFonts.quicksand(
                                            textStyle: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.blueGrey,
                                              // fontWeight: FontWeight.bold,
                                              letterSpacing: .5,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          myRealtimeInfo['user_language'] ==
                                                  'sw'
                                              ? 'Sasa huonekani'
                                              : 'Now you are invisible',
                                          style: GoogleFonts.quicksand(
                                            textStyle: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.blueGrey,
                                              // fontWeight: FontWeight.bold,
                                              letterSpacing: .5,
                                            ),
                                          ),
                                        ),
                                  Switch(
                                    value: myRealtimeInfo['user_visibility'],
                                    onChanged: (value) {
                                      DocumentReference ds = FirebaseFirestore
                                          .instance
                                          .collection('XUsers')
                                          .doc(widget.userId);
                                      Map<String, dynamic> updateTasks = {
                                        'user_visibility': value
                                      };
                                      ds.update(updateTasks);
                                    },
                                    activeTrackColor:
                                        const Color(0xff184a45).withOpacity(.4),
                                    activeColor: const Color(0xff184a45),
                                  ),
                                ],
                              ),
                              const Divider(),
                              InkWell(
                                onLongPress: () {
                                  setState(() {
                                    _age = myRealtimeInfo['user_age'];
                                    canChangeAge = true;
                                  });
                                },
                                child: profileTiles(
                                  myRealtimeInfo['user_language'] == 'sw'
                                      ? 'Rekebisha umri (${myRealtimeInfo['user_age']})'
                                      : 'Update age (${myRealtimeInfo['user_age']})',
                                  myRealtimeInfo['user_language'] == 'sw'
                                      ? 'Unapaswa kuwa naumri wa miaka 18 na kuendelea kutumia programu ya My wangu.'
                                      : 'You have to be atleast 18 years of age to use My wangu application.',
                                ),
                              ),
                              Visibility(
                                visible: canChangeAge,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    children: [
                                      // NumberSelector(
                                      //   height: 40,
                                      //   width: double.infinity,
                                      //   current: myRealtimeInfo['user_age'],
                                      //   hasCenteredText: true,
                                      //   showSuffix: false,
                                      //   textStyle: GoogleFonts.quicksand(
                                      //     fontSize: 16,
                                      //     color: Colors.black54,
                                      //     fontWeight: FontWeight.bold,
                                      //     letterSpacing: .5,
                                      //   ),
                                      //   onUpdate: (val) {
                                      //     setState(
                                      //       () {
                                      //         _age = val;
                                      //       },
                                      //     );
                                      //   },
                                      // ),
                                      const SizedBox(
                                        height: 6.0,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  canChangeAge = false;
                                                });
                                              },
                                              child: laterButton(
                                                myRealtimeInfo[
                                                            'user_language'] ==
                                                        'sw'
                                                    ? 'Badae'
                                                    : 'Cancel',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          _age > 17
                                              ? Expanded(
                                                  flex: 1,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        canChangeAge = false;
                                                      });

                                                      ///start of user update
                                                      DocumentReference ds =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'XUsers')
                                                              .doc(widget
                                                                  .userId);
                                                      Map<String, dynamic>
                                                          updateTasks = {
                                                        'user_age': _age,
                                                      };
                                                      ds.update(updateTasks);
                                                    },
                                                    child: watchButton(
                                                      myRealtimeInfo[
                                                                  'user_language'] ==
                                                              'sw'
                                                          ? 'Badili'
                                                          : 'Update',
                                                    ),
                                                  ),
                                                )
                                              : Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    height: 34.0,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              const Divider(),
                              InkWell(
                                onLongPress: () {
                                  warningDesignOnGender(myRealtimeInfo);
                                },
                                child: profileTiles(
                                  myRealtimeInfo['user_language'] == 'sw'
                                      ? 'Rekebisha jinsia (${myRealtimeInfo['account_gender'] == 'FEMALE' ? 'KE' : 'ME'})'
                                      : 'Correct your gender (${myRealtimeInfo['account_gender'] == 'FEMALE' ? 'FEMALE' : 'MALE'})',
                                  myRealtimeInfo['user_language'] == 'sw'
                                      ? 'Tunalichukua kwa uzito sana swala la jinsia. Akaunti yako inaweza kufungwa kwa kudanganya jinsia. Badili tu, kama unaimani jinsia iliyopo sasa sio sahihi.'
                                      : 'We take gender very seriously. You can get your account banned by lying about your gender. Change only if you think the gender here is incorrect.',
                                ),
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xffffe1df),
                                  border: Border.all(
                                    color: const Color(0xffde8c7d),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.hand_raised_fill,
                                        size: 16,
                                        color: Color(0xffde8c7d),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          myRealtimeInfo['user_language'] ==
                                                  'sw'
                                              ? 'Angalizo! Kama utabadili jinsia yako kutoka hii iliyopo sasa, hutaweza kubadili tena ndani ya siku 30 zijazo. Badili tu kama unauhakika.'
                                              : 'Warning! If you change your gender from the current one, you won\'t be able to change again for the next 30 days. Change only if you are sure.',
                                          style: GoogleFonts.quicksand(
                                            textStyle: const TextStyle(
                                              color: Color(0xffde8c7d),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              // letterSpacing: .5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: canChangeGender,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                ///start of user update
                                                DocumentReference ds =
                                                    FirebaseFirestore.instance
                                                        .collection('XUsers')
                                                        .doc(widget.userId);
                                                Map<String, dynamic>
                                                    updateTasks = {
                                                  'account_gender': 'MALE',
                                                  'gender_to_show': 'FEMALE',
                                                  'gender_changed_date': myRealtimeInfo[
                                                              'account_gender'] ==
                                                          'FEMALE'
                                                      ? DateTime.now()
                                                          .millisecondsSinceEpoch
                                                      : FieldValue.increment(1),
                                                };
                                                ds.update(updateTasks);
                                                setState(() {
                                                  canChangeGender = false;
                                                });
                                              },
                                              child: maleToggleBox(
                                                  myRealtimeInfo[
                                                      'user_language'],
                                                  myRealtimeInfo[
                                                      'account_gender']),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                ///start of user update
                                                DocumentReference ds =
                                                    FirebaseFirestore.instance
                                                        .collection('XUsers')
                                                        .doc(widget.userId);
                                                Map<String, dynamic>
                                                    updateTasks = {
                                                  'account_gender': 'FEMALE',
                                                  'gender_to_show': 'MALE',
                                                  'gender_changed_date': myRealtimeInfo[
                                                              'account_gender'] ==
                                                          'MALE'
                                                      ? DateTime.now()
                                                          .millisecondsSinceEpoch
                                                      : FieldValue.increment(1),
                                                };
                                                ds.update(updateTasks);
                                                setState(() {
                                                  canChangeGender = false;
                                                });
                                              },
                                              child: femaleToggleBox(
                                                  myRealtimeInfo[
                                                      'user_language'],
                                                  myRealtimeInfo[
                                                      'account_gender']),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 6.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              const Divider(),
                              InkWell(
                                onLongPress: () {
                                  controlUsernameChange(myRealtimeInfo);
                                  setState(() {
                                    _username = myRealtimeInfo['user_name'];
                                  });
                                },
                                child: profileTiles(
                                  myRealtimeInfo['user_language'] == 'sw'
                                      ? 'Badili jina (${myRealtimeInfo['user_name']})'
                                      : 'Change username (${myRealtimeInfo['user_name']})',
                                  myRealtimeInfo['user_language'] == 'sw'
                                      ? 'Jina lako linaweza kubadilishwa mara moja kwa kipindi cha siku 120. Jina la zamani litakuwa huru kwa watu wengine. Shikilia hapa kubadili jina.'
                                      : 'Username updates can be performed once every 120 days. The old username will be available to the public. Long press here to update your username.',
                                ),
                              ),
                              Visibility(
                                visible: canChangeUsername,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        child: TextFormField(
                                          initialValue:
                                              myRealtimeInfo['user_name'],
                                          textCapitalization:
                                              TextCapitalization.none,
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          maxLength: 20,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp('[0-9a-z._]'),
                                            ),
                                          ],
                                          style: GoogleFonts.quicksand(
                                            textStyle: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: .5,
                                            ),
                                          ),
                                          decoration: InputDecoration(
                                            suffixIcon: nickNameAvailable
                                                ? const Icon(
                                                    CupertinoIcons
                                                        .checkmark_alt_circle_fill,
                                                    color: Colors.green,
                                                  )
                                                : null,
                                            filled: true,
                                            fillColor:
                                                Colors.white.withOpacity(.2),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 0.0,
                                              horizontal: 8.0,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1.5,
                                                color: Colors.blueGrey
                                                    .withOpacity(.4),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                4.0,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.5,
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                4.0,
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.5,
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                4.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.5,
                                                  color: Colors.blueGrey
                                                      .withOpacity(.4)),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                          ),
                                          onChanged: (val) {
                                            setState(
                                                () => _username = val.trim());
                                            checkIfNickNameExists(val.trim());
                                          },
                                          validator: (val) => nickNameAvailable
                                              ? null
                                              : (myRealtimeInfo[
                                                          'user_language'] ==
                                                      'sw'
                                                  ? 'Jina limechukuliwa'
                                                  : 'Username not available'),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6.0,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  canChangeUsername = false;
                                                });
                                              },
                                              child: laterButton(myRealtimeInfo[
                                                          'user_language'] ==
                                                      'sw'
                                                  ? 'Ghairi'
                                                  : 'Cancel'),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          nickNameAvailable
                                              ? Expanded(
                                                  flex: 1,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        canChangeUsername =
                                                            false;
                                                        nickNameAvailable =
                                                            false;
                                                      });

                                                      ///start of username update
                                                      DocumentReference ds =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'XUsers')
                                                              .doc(widget
                                                                  .userId);
                                                      Map<String, dynamic>
                                                          updateTasks = {
                                                        'user_name': _username,
                                                        'username_changed_date':
                                                            DateTime.now()
                                                                .millisecondsSinceEpoch,
                                                      };
                                                      ds.update(updateTasks);
                                                    },
                                                    child: watchButton(
                                                      myRealtimeInfo[
                                                                  'user_language'] ==
                                                              'sw'
                                                          ? 'Badili'
                                                          : 'Update',
                                                    ),
                                                  ),
                                                )
                                              : Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    height: 34.0,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                onTap: () {
                                  openLogoutDialog(
                                      myRealtimeInfo['user_language']);
                                },
                                child: miniProfileTiles(
                                  Colors.teal,
                                  Icons.power_settings_new_outlined,
                                  myRealtimeInfo['user_language'] == 'sw'
                                      ? 'Ondoka'
                                      : 'Log out',
                                ),
                              ),
                              const Divider(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onLongPress: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (_) => DeleteAccountPage(
                                            userId: widget.userId,
                                            myUserInfo: myRealtimeInfo,
                                          ),
                                        ),
                                      );
                                    },
                                    child: profileTiles(
                                      myRealtimeInfo['user_language'] == 'sw'
                                          ? 'Ufutaji wa akaunti'
                                          : 'Account deletion',
                                      myRealtimeInfo['user_language'] == 'sw'
                                          ? 'Kama utafuta akaunti yako, utakuwa na uwezo wa kuirudisha ndani ya siku 30.'
                                          : 'If you delete your account now, you will have the option to recover it within 30 days.',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 14.0,
                                  ),
                                  Visibility(
                                    visible: myRealtimeInfo['account_type'] ==
                                            'Admin'
                                        ? true
                                        : false,
                                    child: Column(
                                      children: [
                                        const Divider(),
                                        InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (_) =>
                                                      const AdminPage(),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: miniProfileTiles(
                                                  Colors.red,
                                                  CupertinoIcons.hammer,
                                                  'Administrator'),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: const Color(0xff184a45),
                elevation: 4,
                title: Text(
                  '',
                  style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      letterSpacing: .5,
                    ),
                  ),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: Container(),
            );
          }
        },
      ),
    );
  }

  snackError(String text) {
    var snackBar = SnackBar(
      backgroundColor: Colors.blueGrey,
      content: Text(
        text,
        style: GoogleFonts.quicksand(
          fontSize: 14,
          color: Colors.white,
          letterSpacing: .5,
        ),
        textAlign: TextAlign.center,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  openLogoutDialog(String language) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ), //this right here
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      language == 'sw' ? 'Ondoka' : 'Log out!',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      language == 'sw'
                          ? 'Hutapokea taarifa za akaunti yako kwa kipindi ambacho hutakuwepo.'
                          : 'You will not receive in-app notifications when you are out.',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          letterSpacing: .5,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: laterButton(
                              language == 'sw' ? 'Sitisha' : 'Cancel',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              _logOut();
                            },
                            child: dangerButton(
                              language == 'sw' ? 'Ondoka' : 'Logout',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  checkIfNickNameExists(String val) async {
    if (val.length < 3) {
      setState(() {
        nickNameAvailable = false;
      });
    } else {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('XUsers')
          .where('user_name', isEqualTo: val.trim())
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        setState(() {
          // nickNameError = (language == 'Romanian'
          //     ? 'Jina hili limechukuliwa'
          //     : 'This username is unavailable');
          nickNameAvailable = false;
        });
      } else {
        if (kDebugMode) {
          print('available');
        }
        setState(() {
          nickNameAvailable = true;
        });
      }
    }
  }

  warningDesignOnGender(DocumentSnapshot myRealtimeInfo) {
    if ((DateTime.now().millisecondsSinceEpoch -
            myRealtimeInfo['gender_changed_date']) >
        2592000000) {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      dialogTitleText(
                        myRealtimeInfo['user_language'] == 'sw'
                            ? 'Una uhakika?'
                            : 'Are you sure?',
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      dialogBodyText(
                        myRealtimeInfo['user_language'] == 'sw'
                            ? 'Kama utabadili jinsia yako kutoka hii iliyopo sasa, hutaweza kubadili tena ndani ya siku 30 zijazo. Badili tu kama unauhakika.'
                            : 'If you change your gender from the current one, you won\'t be able to change again for the next 30 days. Change only if you are sure',
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  canChangeGender = false;
                                });
                              },
                              child: laterButton(
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Sitisha'
                                    : 'Cancel',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  canChangeGender = true;
                                });
                              },
                              child: dangerButton(
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Badili'
                                    : 'Change',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      dialogTitleText(
                        myRealtimeInfo['user_language'] == 'sw'
                            ? 'Umekwisha badili jinsia!'
                            : 'You changed your gender!',
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      dialogBodyText(
                        myRealtimeInfo['user_language'] == 'sw'
                            ? 'Ulibadili jinsia yako tarehe "${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(myRealtimeInfo['gender_changed_date']))}". Itakubidi kusubiri siku 30 ili kuweza kubadili tena. Kama ulibadili kimakosa unaweza kuwasiliana nasi katika barua pepe mywangu.co@gmail.com.'
                            : 'You changed your gender on "${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(myRealtimeInfo['gender_changed_date']))}". You cannot change again within 30 days. If made the change by mistake, contact us at mywangu.co@gmail.com',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  controlUsernameChange(DocumentSnapshot myRealtimeInfo) {
    if ((DateTime.now().millisecondsSinceEpoch -
            myRealtimeInfo['username_changed_date']) >
        10368000000) {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      dialogTitleText(
                        myRealtimeInfo['user_language'] == 'sw'
                            ? 'Una uhakika?'
                            : 'Are you sure?',
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      dialogBodyText(
                        myRealtimeInfo['user_language'] == 'sw'
                            ? 'Kama utabadili jina lako kutoka hili liliyopo sasa, hutaweza kubadili tena ndani ya siku 120 zijazo. Badili tu kama unauhakika.'
                            : 'If you change your username from the current one, you won\'t be able to change again for the next 120 days. Change only if you are sure',
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  canChangeGender = false;
                                });
                              },
                              child: laterButton(
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Sitisha'
                                    : 'Cancel',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  canChangeUsername = true;
                                });
                              },
                              child: dangerButton(
                                myRealtimeInfo['user_language'] == 'sw'
                                    ? 'Badili'
                                    : 'Change',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      dialogTitleText(
                        myRealtimeInfo['user_language'] == 'sw'
                            ? 'Umekwisha badili jina!'
                            : 'You changed username!',
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      dialogBodyText(
                        myRealtimeInfo['user_language'] == 'sw'
                            ? 'Ulibadili jina lako tarehe "${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(myRealtimeInfo['gender_changed_date']))}". Hutaweza kubadili tena ndani ya siku 120.'
                            : 'You changed your username on "${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(myRealtimeInfo['gender_changed_date']))}". You cannot change again within 120 days.',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future _logOut() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (r) => false);
      }
    } catch (e) {
      return null;
    }
  }

  void _openBottomSheet(BuildContext context, DocumentSnapshot myRealtimeInfo) {
    showModalBottomSheet(
      elevation: 4,
      backgroundColor: Colors.white,
      barrierColor: Colors.black87.withOpacity(.8),
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 120,
          // color: Colors.white,
          child: Stack(
            children: [
              SearchPlanPage(
                userId: widget.userId,
                myUserInfo: myRealtimeInfo,
              ),
            ],
          ),
        );
      },
    );
  }
}
