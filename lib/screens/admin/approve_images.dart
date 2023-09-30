import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ApproveImages extends StatefulWidget {
  const ApproveImages({Key? key}) : super(key: key);

  @override
  State<ApproveImages> createState() => _ApproveImagesState();
}

class _ApproveImagesState extends State<ApproveImages> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xff184a45),
          elevation: 4,
          title: Text(
            'New users',
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('XUsers')
              .where('images_verification_status', isEqualTo: 'Pending')
              .limit(200)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return Container();
              } else {
                return PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  allowImplicitScrolling: false,
                  // onPageChanged: (val) {
                  //   print(val);
                  // },
                  itemBuilder: (context, index) {
                    DocumentSnapshot singlePerson = snapshot.data!.docs[index];
                    return personItem(
                      index,
                      singlePerson,
                      snapshot.data!.docs.length,
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget personItem(int index, DocumentSnapshot singlePerson, int count) {
    return Stack(
      children: [
        PageView(
          scrollDirection: Axis.horizontal,
          pageSnapping: true,
          children: <Widget>[
            Stack(
              children: [
                CachedNetworkImage(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  imageUrl: singlePerson['user_slide_one'],
                  placeholder: (context, url) => const Image(
                    image: AssetImage(
                      'assets/images/vertical_placeholder.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Image(
                    image: AssetImage(
                      'assets/images/vertical_placeholder.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: const <Widget>[
                            Text(
                              '1',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '/3',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                CachedNetworkImage(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  imageUrl: singlePerson['user_slide_two'],
                  placeholder: (context, url) => const Image(
                    image: AssetImage('assets/images/vertical_placeholder.png'),
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Image(
                    image: AssetImage('assets/images/vertical_placeholder.png'),
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: const <Widget>[
                            Text(
                              '2',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '/3',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                CachedNetworkImage(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  imageUrl: singlePerson['user_slide_three'],
                  placeholder: (context, url) => const Image(
                    image: AssetImage('assets/images/vertical_placeholder.png'),
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Image(
                    image: AssetImage('assets/images/vertical_placeholder.png'),
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: const <Widget>[
                            Text(
                              '3',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '/3',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        ///Info layer
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      stops: const [
                        0.3,
                        0.9,
                      ],
                      colors: [
                        Colors.black.withOpacity(.9),
                        Colors.black.withOpacity(.5),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      singlePerson['user_name'],
                                      style: GoogleFonts.quicksand(
                                        textStyle: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    (singlePerson['user_verification']) ==
                                            'Verified'
                                        ? const Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: Icon(
                                              CupertinoIcons
                                                  .checkmark_seal_fill,
                                              color: Colors.blue,
                                              size: 12,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                approveButtonClicked(singlePerson);
                              },
                              child: Container(
                                height: 30,
                                width: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Approve',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                denyButtonClicked(singlePerson);
                              },
                              child: Container(
                                height: 30,
                                width: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Deny',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(
                              CupertinoIcons.calendar,
                              color: Colors.white54,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              '${singlePerson['user_age'].toString()} Years (${singlePerson['account_gender']})',
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white54,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 28,
                            ),
                            const Icon(
                              CupertinoIcons.map_pin_ellipse,
                              color: Colors.white54,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              singlePerson['user_location_name'],
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white54,
                                  letterSpacing: .5,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Text(
                            singlePerson['about_user'],
                            style: TextStyle(
                                color: Colors.white.withOpacity(.7),
                                height: 1.2,
                                fontSize: 14),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ///Button layer
              Positioned(
                top: 0,
                left: 10,
                child: Container(
                  //color: Colors.grey,
                  //width: 200,
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          openProfileDialog(singlePerson['user_image']);
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.red,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 19,
                            backgroundImage: CachedNetworkImageProvider(
                                singlePerson['user_image']),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  openProfileDialog(String url) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)), //this right here
          child: Image.network(
            url,
            width: double.infinity,
          ),
        );
      },
    );
  }

  void denyButtonClicked(DocumentSnapshot singlePerson) async {
    final userDocRef = FirebaseFirestore.instance
        .collection('XUsers')
        .doc(singlePerson['user_id']);
    await userDocRef.update({
      'images_verification_status': 'Rejected',
      'notification_count': FieldValue.increment(1),
    });

    final notyRef = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('system')
        .collection(singlePerson['user_id'])
        .doc();
    final notyTask = {
      'notification_tittle_eng': 'Images rejected!',
      'notification_tittle_sw': 'Picha zimekataliwa!',
      'notification_body_eng':
          'Please update your pictures to real photos of yourself in order to continue using the My wangu Application.',
      'notification_body_sw':
          'Tafadhali wasilisha picha zako halisi kwenye wasifu wako ili kuendelea kutumia Programu ya My wangu.',
      'notification_time': FieldValue.serverTimestamp(),
      'notification_sender': 'My wangu',
      'action_title': 'images-rejected',
      'action_destination': 'UpdateImages',
      'notification_read': false,
      'action_destination_id': singlePerson['user_id'],
      'notification_id': notyRef.id,
    };
    await notyRef.set(notyTask);
  }

  void approveButtonClicked(DocumentSnapshot singlePerson) async {
    final userDocRef = FirebaseFirestore.instance
        .collection('XUsers')
        .doc(singlePerson['user_id']);
    await userDocRef.update({
      'images_verification_status': 'Approved',
      'notification_count': FieldValue.increment(1),
    });

    final approveRef = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('system')
        .collection(singlePerson['user_id'])
        .doc(singlePerson['user_id'] + '_imagesApproved');
    final approveTask = {
      'notification_tittle_eng': 'Images approved!',
      'notification_tittle_sw': 'Picha zimekubaliwa!',
      'notification_body_eng':
          'Good news! Your images have passed our scanning tools and are deemed appropriate.',
      'notification_body_sw':
          'Habari njema! Picha zako zimepitia zana zetu za uchunguzi na zimeonekana kuwa sahihi.',
      'notification_time': FieldValue.serverTimestamp(),
      'notification_sender': 'My wangu',
      'action_title': 'images-approved',
      'action_destination': 'UpdateImages',
      'notification_read': true,
      'action_destination_id': singlePerson['user_id'],
      'notification_id': approveRef.id,
    };
    await approveRef.set(approveTask);
  }
}
