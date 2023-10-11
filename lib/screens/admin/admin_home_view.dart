import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:two_value/src/helper_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../src/theme.dart';
import 'admin_single_press_view.dart';

class AdminHomeView extends StatefulWidget {
  final String userId;
  final DocumentSnapshot userData;
  const AdminHomeView(
      {super.key, required this.userId, required this.userData});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey.withOpacity(.1),
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(20),
            blackNormalText(widget.userData['user_language'] == 'sw'
                ? 'Sponsored Ad'
                : 'Sponsored Ad'),
            addVerticalSpace(10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('XAds')
                  .where('ad_visibility', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    height: (MediaQuery.of(context).size.width - 32) * 9 / 16,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                List<DocumentSnapshot> ads = snapshot.data!.docs;

                return Container(
                  color: Colors.transparent,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height:
                          ((MediaQuery.of(context).size.width - 32) * 9 / 16) +
                              90,
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: ads.map((ad) {
                      String adImage = ad['ad_image'];
                      String adLink = ad['ad_link'];
                      String adCta = ad['ad_cta'];
                      String adDescription = ad['ad_description'];

                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14.0),
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: adImage,
                                  placeholder: (context, url) => Image.asset(
                                    'assets/images/vertical_placeholder.png',
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/vertical_placeholder.png',
                                    fit: BoxFit.cover,
                                  ),
                                  width: MediaQuery.of(context).size.width - 32,
                                  height:
                                      (MediaQuery.of(context).size.width - 32) *
                                          9 /
                                          16,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  // width: 200,
                                  height:
                                      (MediaQuery.of(context).size.width - 32) *
                                          9 /
                                          16,
                                  decoration: const BoxDecoration(
                                    // borderRadius: BorderRadius.circular(20.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black,
                                        Colors.transparent
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: whiteNormalText(adDescription),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: Container()),
                          GestureDetector(
                              onTap: () {
                                // Implement the logic to handle ad click
                                // For example, you can open the ad link.
                                _launchUrl(adLink);
                              },
                              child: ctaButton(adCta, context)),
                          Expanded(child: Container()),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  addVerticalSpace(20),
                  Row(
                    children: [
                      blueBodyTextLarge(
                          language == 'ro' ? 'ACTIVITATE' : 'ACTIVITY'),
                    ],
                  ),
                  addVerticalSpace(20),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('XArticles')
                        .doc('Presses')
                        .collection('Dominant')
                        .where('press_poster', isEqualTo: widget.userId)
                        .orderBy('press_time', descending: true)
                        .limit(10)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(
                          height: size.height - 300,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              color: TAppTheme.primaryColor.withOpacity(.4),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.data!.docs.isEmpty) {
                          return Column(
                            children: [
                              addVerticalSpace(200),
                              const Center(
                                child: Image(
                                  height: 200,
                                  image: AssetImage(
                                      'assets/images/empty_list.png'),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = snapshot.data!.docs[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => AdminSinglePressView(
                                        userId: widget.userId,
                                        userData: widget.userData,
                                        pressData: doc,
                                      ),
                                    ),
                                  );
                                },
                                child: pressItem(doc),
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
