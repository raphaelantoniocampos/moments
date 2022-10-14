import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:moments/screens/profile_screen.dart';

import '../utils/colors.dart';
import 'loading_screen.dart';
import 'login_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool showUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        leading: const Icon(Icons.search),
        title: TextFormField(
          onChanged: (text) {
            if (text.isEmpty) {
              setState(() {
                showUsers = false;
              });
            } else {
              setState(() {
                showUsers = true;
              });
            }
          },
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.bottom,
          controller: searchController,
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search for username',
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  barrierColor: blackTransparent,
                  context: context,
                  builder: (context) => Dialog(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shrinkWrap: true,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: const Text('Log out'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: showUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {}
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid']),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ['photoUrl']),
                          ),
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ['username']),
                        ),
                      );
                    });
              })
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const LoadingScreen();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                }
                if (snapshot.connectionState == ConnectionState.none) {
                  return const LoadingScreen();
                }
                return MasonryGridView.count(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      (snapshot.data! as dynamic).docs[index]['postUrl'],
                    ),
                  ),
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                );
              }),
    );
  }
}
