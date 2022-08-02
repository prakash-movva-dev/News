// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news/web_screen.dart';
import 'package:share_plus/share_plus.dart';

// Project imports:

class BottomBar extends StatelessWidget {
   BottomBar({required this.news,Key? key}) : super(key: key);
   Map news;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebScreen(news: news)),
          )
        },
        child: Container(
          color: Theme.of(context).cardColor,
          // elevation: 0,
          child: Stack(
            children: <Widget>[
              Container(
                  width: double.maxFinite,
                  child: CachedNetworkImage(
                    imageUrl: "https://picsum.photos/200/300",
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )),
              Positioned(
                top: 0,
                left: 0,
                height: double.maxFinite,
                width: double.maxFinite,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                color: Color(0xff000000).withOpacity(0.6),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          news["sub_title"],
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Tap to read more",
                          style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Share.share('check out this link ${news["link"]}',subject: 'Look what I made!');
                      },
                      child: const Icon(
                        Icons.share,
                        color: Color(0xffFFFFFF),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
