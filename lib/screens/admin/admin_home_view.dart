import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:two_value/src/helper_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'admin_analytics_view.dart';
import 'admin_purchases_view.dart';

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
  String category = 'ANALYTICS';
  final Map<String, Map<String, String>> categoryLabels = {
    'ro': {
      'ANALYTICS': 'ANALITĂ',
      'SUBSCRIPTIONS': 'ABONAMENTE',
    },
    'eng': {
      'ANALYTICS': 'ANALYTICS',
      'SUBSCRIPTIONS': 'SUBSCRIPTIONS',
    },
  };

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
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChipsChoice<String>.single(
                      value: category,
                      onChanged: (val) {
                        setState(() {
                          category = val;
                        });
                      },
                      choiceItems: C2Choice.listFrom<String, String>(
                        source: categoryLabels[language]!.keys.toList(),
                        value: (i, v) => v,
                        label: (i, v) => categoryLabels[language]![v]!,
                      ),
                      choiceBuilder: (item, index) {
                        return ChoiceChip(
                          label: category == item.value
                              ? whiteChipText(item.label)
                              : blackChipText(item.label),
                          selected: category == item.value,
                          onSelected: (selected) {
                            setState(() {
                              category = item.value;
                            });
                          },
                          selectedColor: Colors
                              .blueGrey, // The background color for selected items
                          backgroundColor: Colors.grey[
                              300], // The background color for non-selected items
                          padding: EdgeInsets.symmetric(horizontal: 10),
                        );
                      },
                      wrapped: true,
                      wrapCrossAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      padding: EdgeInsets.zero,
                      spacing: 10,
                      runSpacing: 0,
                    ),
                  ],
                ),
              ),
            ),
            decideView(),
            addVerticalSpace(40),
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

  Widget decideView() {
    if (category == 'ANALYTICS') {
      return AdminAnalyticsView(
        userId: widget.userId,
        userData: widget.userData,
      );
    } else if (category == 'SUBSCRIPTIONS') {
      return AdminPurchasesView(
        userId: widget.userId,
        userData: widget.userData,
      );
    } else {
      return AdminAnalyticsView(
        userId: widget.userId,
        userData: widget.userData,
      );
    }
  }
}
