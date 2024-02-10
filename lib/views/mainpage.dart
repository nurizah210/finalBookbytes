import 'package:bookbytes/models/user.dart';
import 'package:bookbytes/views/cartpage.dart';
import 'package:bookbytes/views/profilepage.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final User userdata;
  const MainPage({super.key, required this.userdata});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  String mainTitle = "";
  late List<Widget> tab_childs;
  @override
  void initState() {
    super.initState();
    print(widget.userdata.username);
    tab_childs = [
      MainPage(userdata: widget.userdata,),
      CartPage(user: widget.userdata,),
      ProfilePage(user: widget.userdata,),
    ];
  }
  Widget build(BuildContext context) {
    
    
    return Scaffold(

      body: tab_childs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        mainTitle = "Home";
      }
      if (_currentIndex == 1) {
        mainTitle = "Cart";
      }
      if (_currentIndex == 2) {
        mainTitle = "Profile";
        
        
      }
    });
  }
}