import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moments/views/screens/profile_screen.dart';

import '../../constants.dart';

class UserListScreen extends StatefulWidget {
  UserListScreen({Key? key, required this.title, required this.uidList})
      : super(key: key);

  final String title;
  final List<dynamic> uidList;

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          child: ListView.builder(
              itemCount: widget.uidList.length,
              itemBuilder: (context, index) {
                final uid = widget.uidList[index];
                return FutureBuilder(
                    future: firebaseFirestore
                        .collection('users')
                        .where('uid', isEqualTo: uid)
                        .get(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (!snapshot.hasData) {
                        return const ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primaryColor,
                            backgroundImage: NetworkImage(initialProfilePic),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primaryColor,
                            backgroundImage: NetworkImage(initialProfilePic),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        var docs = snapshot.data!.docs;
                        var user = docs[0].data();
                        return InkWell(
                          onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(uid: user['uid']),
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: primaryColor,
                              backgroundImage: NetworkImage(user['profilePic']),
                            ),
                            title: Text('${user['username']}'),
                          ),
                        );
                      }
                      return const ListTile();
                    });
              }),
        ),
      ),
    );
  }
}
