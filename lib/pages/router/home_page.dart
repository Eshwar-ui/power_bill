import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_bill/components/accountcard.dart';

import 'package:power_bill/components/button.dart';
import 'package:power_bill/pages/accounts_page.dart';
import 'package:power_bill/services/bill_history.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<List<Map<String, String>>> filteredServicesNotifier =
      ValueNotifier([]);
  final List<Map<String, String>> services = [
    {'name': 'Pay bill / బిల్లు చెల్లించండి', 'route': '/paybill'},
    {'name': 'Bill History / బిల్ చరిత్ర', 'route': '/billhistory'},
    {'name': 'Payments / చెల్లింపులు', 'route': '/payments'},
    {'name': 'Bill issues', 'route': '/billingissues'},
    {'name': 'contact us', 'route': '/contactus'},
    {'name': 'meterissues', 'route': '/meterissues'},
    {'name': 'supply grievances', 'route': '/supply grievances'},
    {'name': 'green tarif', 'route': '/green tarif'},
    {'name': 'new service', 'route': '/new service'},
    {'name': 'poweroutage', 'route': '/poweroutage'},
    {'name': 'voltagefluctuation', 'route': '/voltagefluctuation'},
    {'name': 'usc_management', 'route': '/usc_management'},
    {'name': 'power outage', 'route': '/poweroutage'},
    {'name': 'roof top solar', 'route': '/roof top solar'},
  ];

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterSearch(searchController.text);
    });
  }

  void filterSearch(String query) {
    if (query.isEmpty) {
      filteredServicesNotifier.value = [];
    } else {
      final results = services
          .where((service) =>
              service['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredServicesNotifier.value = results;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    filteredServicesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  const Color(0xff272627)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // search bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 30),
                        child: SearchBar(
                            controller: searchController,
                            textStyle: WidgetStatePropertyAll(TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary)),
                            textInputAction: TextInputAction.search,
                            hintText: "search for service..",
                            hintStyle: WidgetStatePropertyAll(TextStyle(
                                fontSize: 20.sp,
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                            elevation: const WidgetStatePropertyAll(1),
                            leading: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                              child: Icon(
                                Icons.search_outlined,
                                size: 25.sp,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primary,
                            )),
                      ),
                      // account cards
                      MyCard(),

                      // services text
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.h, left: 10.w),
                          child: Text(
                            "Services / సేవలు",
                            style: TextStyle(fontSize: 28.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),

                      // service buttons

                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0.w, vertical: 10.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ServiceButton(
                                  title: "Pay bill / బిల్లు చెల్లించండి",
                                  logoPath:
                                      "lib/assets/service_logos/bill icon.png",
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AccountsPage()));
                                  }),
                              SizedBox(
                                height: 20.h,
                              ),
                              ServiceButton(
                                  title: "Bill History /బిల్ చరిత్ర",
                                  logoPath:
                                      "lib/assets/service_logos/bill history icon.png",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GlobalBillHistoryPage(),
                                      ),
                                    );
                                  }),
                              SizedBox(
                                height: 20.h,
                              ),
                              ServiceButton(
                                  title: "Payments/చెల్లింపులు",
                                  logoPath:
                                      "lib/assets/service_logos/payment icon.png",
                                  onPressed: () {}),
                              SizedBox(
                                height: 20.h,
                              ),
                              ServiceButton(
                                  title: "Get status/హోదా పొందండి",
                                  logoPath:
                                      "lib/assets/service_logos/status icon.png",
                                  onPressed: () {}),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Floating search result list
              ValueListenableBuilder<List<Map<String, String>>>(
                valueListenable: filteredServicesNotifier,
                builder: (context, filteredServices, child) {
                  if (filteredServices.isEmpty) {
                    return const SizedBox(); // Do not show list if no results
                  }

                  return Positioned(
                    top: 80.h, // Adjust based on search bar position
                    left: 30.w,
                    right: 30.w,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20.sp),
                      color: Theme.of(context).colorScheme.primary,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredServices.length,
                        itemBuilder: (context, index) {
                          final service = filteredServices[index];
                          return ListTile(
                            title: Text(
                              service['name']!,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                            ),
                            onTap: () {
                              // Navigate to service page
                              Navigator.pushNamed(context, service['route']!);
                              filteredServicesNotifier.value = [];
                              searchController.clear();
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
