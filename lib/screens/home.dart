import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/services/auth.dart';
import 'package:messenger_clone/services/database.dart';
import './signin.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    bool isSearching = true;
    late Stream<QuerySnapshot> usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    onSearchButtonClick() async {
      setState(() {
        isSearching = true;
      });
      usersStream =
          await DatabaseMethods().getUserByUserName(_searchController.text);
      setState(() {});
    }

    Widget searchListUserTile(String profileUrl, String name, String email) {
      return Row(
        children: [
          Image.network(
            profileUrl,
            height: 30.0,
            width: 30.0,
          ),
        ],
      );
    }

    Widget searchUsersList() {
      return StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return searchListUserTile(
                        ds["imgUrl"], ds["name"], ds["email"]);
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      );
    }

    Widget chatRoomsList() {
      return Container();
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://yt3.ggpht.com/ytc/AKedOLRRPwXiDiQ9sZieuwVgMTZTCz5RI05xz3BezhVx=s176-c-k-c0x00ffffff-no-rj-mo"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    "Chats",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      AuthMethods().signOut().then((s) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignIn(),
                            ));
                      });
                    },
                    child: Icon(Icons.exit_to_app),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Color(0xFFe9eaec),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: TextField(
                  cursorColor: Color(0xFF000000),
                  controller: _searchController,
                  decoration: InputDecoration(
                      prefixIcon: GestureDetector(
                        onTap: () {
                          if (_searchController.text != "") {
                            onSearchButtonClick();
                          }
                        },
                        child: Icon(
                          Icons.search,
                          color: Color(0xFF000000).withOpacity(0.5),
                        ),
                      ),
                      hintText: "Search for people",
                      border: InputBorder.none),
                ),
              ),
              isSearching ? searchUsersList() : chatRoomsList(),
            ],
          ),
        ),
      ),
    );
  }
}
