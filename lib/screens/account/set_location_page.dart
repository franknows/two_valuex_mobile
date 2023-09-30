import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

import '../../src/helper_widgets.dart';
import '../../src/theme.dart';

class SetLocationPage extends StatefulWidget {
  final String userId;
  const SetLocationPage({super.key, required this.userId});

  @override
  State<SetLocationPage> createState() => _SetLocationPageState();
}

class _SetLocationPageState extends State<SetLocationPage> {
  bool loadingLocation = false;
  String selectedRegionValue = 'Unknown';
  Map<String, int> regionPeopleCount = {};
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // Generate random people counts and store them in the map
    for (final region in regions) {
      regionPeopleCount[region] =
          Random().nextInt(1000); // Adjust the range as needed
    }
  }

  final regions = [
    "Arusha",
    "Dar es Salaam",
    "Dodoma",
    "Geita",
    "Iringa",
    "Kagera",
    "Katavi",
    "Kigoma",
    "Kilimanjaro",
    "Lindi",
    "Manyara",
    "Mara",
    "Mbeya",
    "Morogoro",
    "Mtwara",
    "Mwanza",
    "Njombe",
    "Pemba",
    "Pwani",
    "Rukwa",
    "Ruvuma",
    "Shinyanga",
    "Simiyu",
    "Singida",
    "Tabora",
    "Tanga",
    "Zanzibar",
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: TAppTheme.primaryColor,
      ),
      child: OverlayLoaderWithAppIcon(
        isLoading: loading,
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('XUsers')
              .where('user_id', isEqualTo: widget.userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xff184a45),
                  elevation: 4,
                  centerTitle: false,
                  title: appBarWhiteText('Set location'),
                ),
                body: Container(
                  color: Colors.white,
                ),
              );
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
                              ? 'Chagua eneo uliopo'
                              : 'Choose region',
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
                              ? 'Programu inahitaji kufahamu mkoa uliopo ili iweze kukutengenezea stori kulingana na mkoa wako.'
                              : 'The app needs to know your current region in order to create stories based on your location.',
                          style: GoogleFonts.quicksand(
                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        selectedRegionValue == 'Unknown'
                            ? Container()
                            : Column(
                                children: [
                                  addVerticalSpace(20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      blackBoldText(
                                        myRealtimeInfo['user_language'] == 'sw'
                                            ? 'Mkoa: '
                                            : 'Region: ',
                                      ),
                                      blackNormalText(
                                        selectedRegionValue,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                        const SizedBox(
                          height: 120,
                        ),
                        selectedRegionValue == 'Unknown'
                            ? InkWell(
                                onTap: () {
                                  _showRegionSelectionBottomSheet(
                                      myRealtimeInfo['user_language']);
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
                                      const Icon(
                                        CupertinoIcons.map_pin_ellipse,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      whiteBoldText(
                                        myRealtimeInfo['user_language'] == 'sw'
                                            ? 'Chagua Mkoa'
                                            : 'Choose Region',
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  saveData();
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
                                      whiteBoldText(
                                        myRealtimeInfo['user_language'] == 'sw'
                                            ? "Endelea na '$selectedRegionValue'"
                                            : "Continue with '$selectedRegionValue'",
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
          },
        ),
      ),
    );
  }

  void _showRegionSelectionBottomSheet(String language) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: blackBoldText(
                language == 'sw' ? 'Chagua Mkoa' : 'Choose Region',
              ),
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: regions.length,
                itemBuilder: (context, index) {
                  final region = regions[index];
                  final peopleCount = regionPeopleCount[region] ?? 0;

                  return Column(
                    children: [
                      ListTile(
                        title: blackBoldText(region),
                        subtitle: greyNormalText(
                          language == 'sw'
                              ? "Watu $peopleCount"
                              : "$peopleCount People",
                        ),
                        leading: Icon(
                          selectedRegionValue == region
                              ? CupertinoIcons.checkmark_alt_circle_fill
                              : CupertinoIcons.circle,
                          color: TAppTheme.primaryColor,
                        ),
                        onTap: () {
                          setState(() {
                            selectedRegionValue = region;
                          });
                          Navigator.pop(context); // Close the bottom sheet
                        },
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void saveData() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('XUsers').doc(widget.userId);

    Map<String, dynamic> tasks = {
      'user_location_name': selectedRegionValue,
    };

    ds.update(tasks).whenComplete(() {
      setState(() {
        loading = false;
      });

      // Navigator.of(context).pushAndRemoveUntil(
      //   CupertinoPageRoute(
      //     builder: (context) => HomePage(userId: widget.userId),
      //   ),
      //   (r) => false,
      // );
    });
  }
}
