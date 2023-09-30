import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:two_value/src/theme.dart';

import '../../src/helper_widgets.dart';

class CompanyProfilePage extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const CompanyProfilePage(
      {super.key, required this.userId, required this.userData});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  String language = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      language = widget.userData['user_language'];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: TAppTheme.primaryColor,
            elevation: 4,
            title: Text(
              language == 'ro' ? 'Profil' : 'Profile',
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
          body: SingleChildScrollView(
            child: Container(
              color: Colors.blueGrey.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 48.0),
                        child: Image(
                          width: double.infinity,
                          image: AssetImage('assets/images/profile_bg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: size.width / 2.4,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // getImage();
                              },
                              child: CircleAvatar(
                                radius: 48,
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: ClipOval(
                                    // Wrap with ClipOval to make the image circular
                                    child: CachedNetworkImage(
                                      imageUrl: widget.userData['user_image'],
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        'assets/images/vertical_placeholder.png',
                                        fit: BoxFit.cover,
                                        width: 90,
                                        height: 90,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/vertical_placeholder.png',
                                        fit: BoxFit.cover,
                                        width: 90,
                                        height: 90,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            addVerticalSpace(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      blackBoldTextWithSize(
                                          widget.userData['user_name'], 18),
                                      addVerticalSpace(6.0),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.location_solid,
                                            size: 14,
                                          ),
                                          addHorizontalSpace(10),
                                          Flexible(
                                            child: blackNormalText(widget
                                                .userData['user_address']),
                                          )
                                        ],
                                      ),
                                      addVerticalSpace(10.0),
                                      blackBoldTextWithSize(
                                          language == 'ro'
                                              ? 'Biografie'
                                              : 'Biography',
                                          18),
                                      blackNormalText(
                                          widget.userData['about_user'])
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   CupertinoPageRoute(
                                    //     builder: (_) => AdminUpdateProfile(
                                    //       userId: widget.userId,
                                    //       userData: widget.userData,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor:
                                        TAppTheme.primaryColor.withOpacity(.4),
                                    child: const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: TAppTheme.primaryColor,
                                      child: Icon(
                                        CupertinoIcons.pencil,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                          addVerticalSpace(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  blackBoldText(widget
                                      .userData['user_categories'].length
                                      .toString()),
                                  widget.userData['user_language'] == 'sw'
                                      ? blackNormalText('Kozi zangu')
                                      : blackNormalText('My courses'),
                                ],
                              ),
                              Container(
                                height: 20,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Column(
                                children: [
                                  blackBoldText(widget
                                      .userData['user_categories'].length
                                      .toString()),
                                  widget.userData['user_language'] == 'sw'
                                      ? blackNormalText('Makala zangu')
                                      : blackNormalText('My blogs'),
                                ],
                              ),
                              Container(
                                height: 20,
                                width: 1,
                                color: Colors.grey,
                              ),
                              Column(
                                children: [
                                  blackBoldText(widget
                                      .userData['user_categories'].length
                                      .toString()),
                                  widget.userData['user_language'] == 'sw'
                                      ? blackNormalText('Bidhaa')
                                      : blackNormalText('Products'),
                                ],
                              ),
                            ],
                          ),
                          addVerticalSpace(20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
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
                          addVerticalSpace(20),
                          profileTiles(
                            widget.userData['user_language'] == 'sw'
                                ? 'Lugha (${widget.userData['user_language']})'
                                : 'Language (${widget.userData['user_language']})',
                            widget.userData['user_language'] == 'sw'
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
                                      widget.userData['user_language']),
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
                                      DocumentReference ds = FirebaseFirestore
                                          .instance
                                          .collection('XUsers')
                                          .doc(widget.userId);
                                      Map<String, dynamic> updateTasks = {
                                        'user_language': 'eng',
                                      };
                                      ds.update(updateTasks);
                                    });
                                  },
                                  child: engToggleBox(
                                      widget.userData['user_language']),
                                ),
                              ),
                            ],
                          ),
                          addVerticalSpace(4.0),
                          Divider(
                            color: Colors.grey.withOpacity(.4),
                          ),
                          addVerticalSpace(2.0),
                          Row(
                            children: [
                              black54BoldText(
                                widget.userData['user_language'] == 'sw'
                                    ? 'Mipangilio ya kiuongozi'
                                    : 'Admin settings',
                              ),
                            ],
                          ),
                          GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              childAspectRatio: 1,
                            ),
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 10, bottom: 16),
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (_) => AdminManageUsersPage(
                                  //       userId: widget.userId,
                                  //       userData: widget.userData,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 2.0,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.people_alt_rounded,
                                          size: 24,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      addVerticalSpace(10),
                                      blackBoldText(
                                        widget.userData['user_language'] == 'sw'
                                            ? 'Watumiaji'
                                            : 'XUsers',
                                      ),
                                      addVerticalSpace(2.0),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (_) => AdminManageCoursesPage(
                                  //       userId: widget.userId,
                                  //       userData: widget.userData,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 2.0,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          CupertinoIcons.film_fill,
                                          size: 24,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      addVerticalSpace(10),
                                      blackBoldText(
                                        widget.userData['user_language'] == 'sw'
                                            ? 'Kozi'
                                            : 'Courses',
                                      ),
                                      addVerticalSpace(2.0),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (_) => AdminManageBlogsPage(
                                  //       userId: widget.userId,
                                  //       userData: widget.userData,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 2.0,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          CupertinoIcons.doc_richtext,
                                          size: 24,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      addVerticalSpace(10),
                                      blackBoldText(
                                        widget.userData['user_language'] == 'sw'
                                            ? 'Makala'
                                            : 'Blogs',
                                      ),
                                      addVerticalSpace(2.0),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (_) => AdminManageStorePage(
                                  //       userId: widget.userId,
                                  //       userData: widget.userData,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 2.0,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.storefront_outlined,
                                          size: 24,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      addVerticalSpace(10),
                                      blackBoldText(
                                        widget.userData['user_language'] == 'sw'
                                            ? 'Duka'
                                            : 'Store',
                                      ),
                                      addVerticalSpace(2.0),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (_) => AdminManageSalesPage(
                                  //       userId: widget.userId,
                                  //       userData: widget.userData,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 2.0,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.handshake_outlined,
                                          size: 24,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      addVerticalSpace(10),
                                      blackBoldText(
                                        widget.userData['user_language'] == 'sw'
                                            ? 'Mauzo'
                                            : 'Sales',
                                      ),
                                      addVerticalSpace(2.0),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (_) => AdminAddBannerPage(
                                  //       userId: widget.userId,
                                  //       userData: widget.userData,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 2.0,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.ad_units_rounded,
                                          size: 24,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      addVerticalSpace(10),
                                      blackBoldText(
                                        widget.userData['user_language'] == 'sw'
                                            ? 'Matangazo'
                                            : 'Ads',
                                      ),
                                      addVerticalSpace(2.0),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        // openLogoutDialog(widget.userData['user_language']);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 6.0),
                        child: blackBoldText(
                            widget.userData['user_language'] == 'sw'
                                ? 'Ondoka'
                                : 'Log out'),
                      ),
                    ),
                  ),
                  addVerticalSpace(90),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       'Product of Akilikubwa Co Ltd',
                  //       style: GoogleFonts.quicksand(
                  //         fontSize: 14,
                  //         color: Colors.grey,
                  //         letterSpacing: .5,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  addVerticalSpace(20),
                ],
              ),
            ),
          )),
    );
  }
}
