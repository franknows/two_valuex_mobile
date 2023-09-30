import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class UpdateLocationPage extends StatefulWidget {
  final String userId;
  const UpdateLocationPage({super.key, required this.userId});

  @override
  State<UpdateLocationPage> createState() => _UpdateLocationPageState();
}

class _UpdateLocationPageState extends State<UpdateLocationPage> {
  bool loadingLocation = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: TAppTheme.primaryColor,
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('XUsers')
            .where('user_id', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return Container();
            } else {
              DocumentSnapshot myRealtimeInfo = snapshot.data!.docs[0];
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: const Color(0xff184a45),
                  elevation: 4,
                  centerTitle: false,
                  title: appBarWhiteText(
                      (myRealtimeInfo['user_language'] == 'sw')
                          ? 'Weka eneo'
                          : 'Set location'),
                  actions: [
                    Center(
                        child: InkWell(
                      onTap: () {
                        if (myRealtimeInfo['user_language'] == 'sw') {
                          ///start of user update
                          DocumentReference ds = FirebaseFirestore.instance
                              .collection('XUsers')
                              .doc(widget.userId);
                          Map<String, dynamic> updateTasks = {
                            'user_language': 'eng',
                          };
                          ds.update(updateTasks);
                        } else {
                          ///start of user update
                          DocumentReference ds = FirebaseFirestore.instance
                              .collection('XUsers')
                              .doc(widget.userId);
                          Map<String, dynamic> updateTasks = {
                            'user_language': 'sw',
                          };
                          ds.update(updateTasks);
                        }
                      },
                      child: miniToggleBox(myRealtimeInfo['user_language']),
                    )),
                    const SizedBox(
                      width: 14,
                    ),
                  ],
                ),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.location_solid,
                          size: 24,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          myRealtimeInfo['user_language'] == 'sw'
                              ? 'Weka eneo ulilopo'
                              : 'Set your location',
                          style: GoogleFonts.quicksand(
                            textStyle: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          myRealtimeInfo['user_language'] == 'sw'
                              ? 'Programu inahitaji kufahamu eneo ulilopo ili iweze kukuonesha watu kutegemea na eneo. Bonyeza kitufe hapa chini kuweka mahali ulipo.'
                              : 'The app needs to know where you are in order to be able to show you people depending on your location. Click the button below to set your location.',
                          style: GoogleFonts.quicksand(
                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 120,
                        ),
                        InkWell(
                          onTap: () {
                            getCurrentLocation(myRealtimeInfo['user_language'],
                                myRealtimeInfo['user_id']);
                          },
                          child: Container(
                            height: 38,
                            decoration: const BoxDecoration(
                              color: TAppTheme.primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(19),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loadingLocation
                                    ? const SizedBox(
                                        height: 18.0,
                                        width: 18.0,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Color(0xffef5480),
                                          valueColor: AlwaysStoppedAnimation(
                                            Colors.white,
                                          ),
                                          strokeWidth: 2.0,
                                        ),
                                      )
                                    : const Icon(
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
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> getCurrentLocation(String language, String userId) async {}

  openLocationSettingsDialog(String language) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0)), //this right here
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
                    dialogTitleText(language == 'sw'
                        ? 'Washa kinasa eneo'
                        : 'Turn on location'),
                    const SizedBox(
                      height: 2,
                    ),
                    dialogBodyText(
                      language == 'sw'
                          ? 'Ili kuiwezesha programu kutambua mahali ulipo unatakiwa kuwasha kinasa eneo'
                          : 'In order for the app to know where you are, you need to turn on your location service.',
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
                                language == 'sw' ? 'Badae' : 'Later'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              Navigator.of(context).pop();
                              // await Geolocator.openLocationSettings();
                            },
                            child: watchButton(
                                language == 'sw' ? 'Fungua' : 'Open'),
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

  openAppSettingsDialog(String language) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)), //this right here
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Icon(
                      CupertinoIcons.location_solid,
                      size: 32,
                      color: CupertinoColors.systemGrey,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      language == 'sw'
                          ? 'Ruhusu kutambua ulipo'
                          : 'Allow location permission',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      language == 'sw'
                          ? 'Ili kuiwezesha programu kutambua mahali ulipo, iruhusu kutambua eneo lako'
                          : 'In order for the app to know where you are, you need to grant it permission to access your location.',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          letterSpacing: .5,
                        ),
                      ),
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
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              height: 34.0,
                              child: Center(
                                child: Text(
                                  language == 'sw' ? 'Badae' : 'Cancel',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              Navigator.of(context).pop();
                              // await Geolocator.openAppSettings();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff184a45),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                                border: Border.all(
                                  color: const Color(0xff184a45),
                                ),
                              ),
                              height: 34.0,
                              child: Center(
                                child: Text(
                                  language == 'sw' ? 'Fungua' : 'Open',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
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
}
