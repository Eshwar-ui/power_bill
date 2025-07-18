// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_bill/pages/latest_bill_details_page.dart';
import 'package:power_bill/provider/account_provider.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  late FirestoreProvider firestoreProvider;
  @override
  void initState() {
    super.initState();
    firestoreProvider = Provider.of<FirestoreProvider>(context, listen: false);
  }

  final List<Color> gradientColors = [
    Color(0xff423BA4).withOpacity(0.8),
    Color(0xff3BA447),
    Colors.red,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Spacer(
                flex: 1,
              ),
              Text('Accounts',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 20.w,
              ),
              Spacer(flex: 1),
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            const Color(0xff272627)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: firestoreProvider.getAccountReferences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No account references found.'));
              }

              final accounts = snapshot.data!;

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];

                  // Access docId from the account data
                  final usc = account['USC'] ?? 'No USC';

                  final gradientColor =
                      gradientColors[index % gradientColors.length];

                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        gradient: LinearGradient(
                            colors: [
                              gradientColor,
                              Color.fromARGB(255, 37, 37, 37)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)),
                    margin: EdgeInsets.only(bottom: 10).h,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                        tileColor: Colors.white10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r)),

                        trailing: Text(
                          " ${account['name']}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        title: Text(
                          usc,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold),
                        ), // Display the docId correctly
                        subtitle: Text('Tap to view bill details',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        onTap: () {
                          print('Navigating to account details for USC: $usc');

                          // When navigating to BillPage, use:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BillPage(arguments: usc),
                              settings: RouteSettings(arguments: usc),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
