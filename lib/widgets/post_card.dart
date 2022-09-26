import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moments/utils/colors.dart';

class PostCard extends StatelessWidget {
  final snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
          children: [
      //Header section
      Container(
      padding:
      EdgeInsets.symmetric(vertical: 4, horizontal: 8).copyWith(right: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  snap['profImage'],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    snap['username'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                      barrierColor: blackTransparent,
                      context: context,
                      builder: (context) =>
                          Dialog(
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shrinkWrap: true,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text('Hide'),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text('Delete'),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text('Report'),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text('Make profile picture'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    );
                  },
                  icon: Icon(Icons.more_vert)),
            ],
          ),
          //Description
          Container(
            width: double.infinity,
            child: Center(
              child: Text(
                'descrição das fotos ou videos de até no máximo 100 caracteres, acho que assim fica bom, aqui deu 100',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ),

    //Post section
    SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.35,
      width: double.infinity,
      child: Image.network(
        snap['postUrl'],
        fit: BoxFit.cover,
      ),
    )
    ,

    //Comment/like section
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    InkWell(
    onTap: () {},
    child: Row(
    children: [
    Icon(
    Icons.favorite,
    color: Colors.pink,
    size: 30,
    ),
    Text(
    '55',
    style: TextStyle(color: Colors.pink),
    ),
    ],
    ),
    ),
    //Datetime
    Container(
    child: Text(
    '26/09/22 - 13:29',
    style: TextStyle(
    fontSize: 10,
    color: Colors.black,
    fontStyle: FontStyle.italic),
    ),
    ),
    InkWell(
    onTap: () {},
    child: Row(
    children: [
    Icon(
    Icons.insert_comment,
    color: secondaryColor,
    size: 30,
    ),
    Text(
    '137',
    style: TextStyle(color: secondaryColor),
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    );
    }
}

