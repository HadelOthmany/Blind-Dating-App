import 'package:flutter/material.dart';
import '../screens/favorite_sent_favorite_received_screen.dart';
import '../screens/like_sent_like_received_screen.dart';
import '../screens/swipping_screen.dart';
import '../screens/user_details_screen.dart';
import 'package:why/screens/chatlist_screen.dart';
import '../screens/login_page.dart';

class HomePage extends StatefulWidget {
  final String userId;

  HomePage({required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int screenIndex = 0;
  List<Widget> tabScreensList = [];

  @override
  void initState() {
    super.initState();

    tabScreensList = [
      SwippingScreen(userId: widget.userId),
      ChatListScreen(userId: widget.userId),
      FavoriteSentFavoriteReceivedScreen(userId: widget.userId),
      LikeSentLikeReceivedScreen(userId: widget.userId),
      UserDetailsScreen(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blind Dating",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (indexNumber) {
          setState(() {
            screenIndex = indexNumber;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.white,
        currentIndex: screenIndex,
        items: const [
          //  SwippingScreen icon button
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: "",
          ),
          //ViewSentViewReceived icon button
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message_sharp,
              size: 30,
            ),
            label: "",
          ),
          //FavoriteSentFavoriteReceived icon button
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
              size: 30,
            ),
            label: "",
          ),
          //LikeSentLikeReceived icon button
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              size: 30,
            ),
            label: "",
          ),
          // userDetailsScreen icon button
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30,
            ),
            label: "",
          ),
        ],
      ),
      body: tabScreensList[screenIndex],
    );
  }
}
