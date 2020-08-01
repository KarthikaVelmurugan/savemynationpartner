import 'package:flutter/material.dart';

import 'constants.dart';
class PreventCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width/2.55,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width/2.2,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 8),
                  blurRadius: 24,
                  color: kShadowColor,
                ),
              ],
            ),
          ),
          Image.asset(image,width: MediaQuery.of(context).size.width/2.5,height: MediaQuery.of(context).size.width,alignment: Alignment.center,),
          Positioned(
            left: MediaQuery.of(context).size.width/3.5,
            top: MediaQuery.of(context).size.width/20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              height: 136,
              width: MediaQuery.of(context).size.width/1.7 ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: kTitleTextstyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right:10.0),
                      child: Text(
                        text,
                        maxLines: 5,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
