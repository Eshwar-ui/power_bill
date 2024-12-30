import 'package:flutter/material.dart';
import 'package:power_bill/components/account_card.dart';
import 'package:power_bill/components/button.dart';
import 'package:power_bill/pages/profile.dart';
import 'package:power_bill/pages/service_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;

  List<Widget> body = [const Profile(), const Home(), const ServicePage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primary,
                const Color.fromARGB(255, 54, 54, 54)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: SearchBar(
                          hintText: "search for service..",
                          hintStyle: WidgetStatePropertyAll(TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.secondary)),
                          elevation: const WidgetStatePropertyAll(1),
                          leading: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(
                              Icons.search_outlined,
                              size: 25,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.onPrimary,
                          )),
                    ),

                    // account card

                    const AccountCard(),

                    // services text
                    const Padding(
                      padding: EdgeInsets.only(top: 30, left: 10),
                      child: Text(
                        "Services / సేవలు",
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // service buttons

                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ServiceButton(
                              title: "Pay bill / బిల్లు చెల్లించండి",
                              logoPath:
                                  "lib/assets/service_logos/bill icon.png",
                              onPressed: () {}),
                          const SizedBox(
                            height: 20,
                          ),
                          ServiceButton(
                              title: "Bill History /బిల్ చరిత్ర",
                              logoPath:
                                  "lib/assets/service_logos/bill history icon.png",
                              onPressed: () {}),
                          const SizedBox(
                            height: 20,
                          ),
                          ServiceButton(
                              title: "Payments/చెల్లింపులు",
                              logoPath:
                                  "lib/assets/service_logos/payment icon.png",
                              onPressed: () {}),
                          const SizedBox(
                            height: 20,
                          ),
                          ServiceButton(
                              title: "Get status/హోదా పొందండి",
                              logoPath:
                                  "lib/assets/service_logos/status icon.png",
                              onPressed: () {}),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 750),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: SizedBox(
                  height: 90,
                  width: double.infinity,
                  child: BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'profile',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.cell_tower),
                        label: 'services',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.white,
                    onTap: _onItemTapped,
                    enableFeedback: false,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                  ),
                ),
              ),
            )
          ],
        ),
      ),

      // bottom nav bar
    );
  }
}
