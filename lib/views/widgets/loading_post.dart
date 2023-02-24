import 'package:flutter/material.dart';

import '../../constants.dart';

class LoadingPost extends StatelessWidget {
  const LoadingPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //Header section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8)
                .copyWith(right: 0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          initialProfilePic,
                        ),
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: Text(
                            '...',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.more_vert)),
                    ],
                  ),
                ),
                //Description
                const SizedBox(
                  width: double.infinity,
                  child: Center(),
                ),
              ],
            ),
          ),

          //Post section
          GestureDetector(
            onTap: () {},
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                  ))),
            ]),
          ),

          //Comment/like section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                //Datetime
                const Text('...'),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: const [
                      Icon(
                        Icons.mode_comment_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '.',
                        style: TextStyle(color: Colors.black),
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
