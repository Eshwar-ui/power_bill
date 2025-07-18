import 'package:flutter/material.dart';
import 'package:power_bill/pages/router/home_page.dart';
import 'package:power_bill/pages/router/profile.dart';
import 'package:power_bill/pages/router/service_page.dart';
import 'package:power_bill/provider/bottom_navbarprovider.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const List<Widget> _pages = <Widget>[
    Profile(),
    HomePage(),
    ServicePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BottomNavigationProvider>(
        builder: (context, provider, child) {
          return Center(
            child: _pages.elementAt(provider.selectedIndex),
          );
        },
      ),
      bottomNavigationBar: Consumer<BottomNavigationProvider>(
        builder: (context, provider, child) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cell_tower),
                label: 'Services',
              ),
            ],
            currentIndex: provider.selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
            onTap: provider.updateIndex,
            enableFeedback: true,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
          );
        },
      ),
    );
  }
}
