import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [

                  //Profile pic
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/moments-a47d4.appspot.com/o/posts%2Fh4vKe4Je6NecCkP1K9ARG9clHVM2%2F16605d30-3e60-11ed-879a-5599bceda250?alt=media&token=d9039393-db3e-4c57-8230-be14e942438f'),
                  ),

                  //Username
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'username',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              //Datetime
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text('22/09/2022 - 13:54'),
              ),
            ],
          ),
          Container(
            // color: Colors.pink,
            height: 50,
            alignment: Alignment.centerLeft,
            child: Text(
                'photo comment até 100 caracteres tbm pra nao perder a vibe pode ser? ainda nao deu 100, opa ta quase'),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.favorite_border,
                  size: 15,
                ),
              ),
              Text(' 15'),
              SizedBox(
                width: 15,
              ),
              Icon(
                Icons.mode_comment_outlined,
                size: 15,
              ),
              Text(' 20'),
            ],
          ),
        ],
      ),
    );
  }
}
