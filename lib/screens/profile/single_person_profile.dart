import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SinglePersonProfile extends StatefulWidget {
  final DocumentSnapshot myUserInfo;
  final DocumentSnapshot theirUserInfo;
  const SinglePersonProfile(
      {super.key, required this.myUserInfo, required this.theirUserInfo});

  @override
  State<SinglePersonProfile> createState() => _SinglePersonProfileState();
}

class _SinglePersonProfileState extends State<SinglePersonProfile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          scrollDirection: Axis.horizontal,
          allowImplicitScrolling: true,
          pageSnapping: true,
          children: <Widget>[
            Stack(
              children: [
                CachedNetworkImage(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  imageUrl: widget.theirUserInfo['user_slide_one'],
                  placeholder: (context, url) => const Image(
                      image:
                          AssetImage('assets/images/vertical_placeholder.png'),
                      fit: BoxFit.cover),
                  errorWidget: (context, url, error) => const Image(
                      image:
                          AssetImage('assets/images/vertical_placeholder.png'),
                      fit: BoxFit.cover),
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
                  imageUrl: widget.theirUserInfo['user_slide_two'],
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
                  imageUrl: widget.theirUserInfo['user_slide_three'],
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
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [
                        0.3,
                        0.9,
                      ],
                      colors: [
                        Colors.black.withOpacity(.9),
                        Colors.black.withOpacity(.4),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 10),
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
                                      widget.theirUserInfo['user_name'],
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
                                    (widget.theirUserInfo[
                                                'user_verification']) ==
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
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(
                              CupertinoIcons.calendar_today,
                              color: Colors.white54,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              widget.myUserInfo['user_language'] == 'sw'
                                  ? 'Miaka ${widget.theirUserInfo['user_age'].toString()}'
                                  : '${widget.theirUserInfo['user_age'].toString()} Years',
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white54,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            const Icon(
                              CupertinoIcons.map_pin_ellipse,
                              color: Colors.white54,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Flexible(
                              child: Text(
                                '${widget.theirUserInfo['user_location_name']}, ${widget.theirUserInfo['user_country']}',
                                style: GoogleFonts.quicksand(
                                  textStyle: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white54,
                                    letterSpacing: .5,
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                widget.theirUserInfo['about_user'],
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.7),
                                    height: 1.2,
                                    fontSize: 14),
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
