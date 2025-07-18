// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:power_bill/provider/account_provider.dart';

class AccountDetailPage extends StatefulWidget {
  const AccountDetailPage({super.key});

  @override
  State<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> {
  Map<String, dynamic>? accountDetails;
  bool isLoading = true;
  String errorMessage = '';
  late String usc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve USC from the ModalRoute arguments
    usc = ModalRoute.of(context)!.settings.arguments as String;

    print('Navigating to account details for USC: $usc');

    _fetchAccountDetails();
  }

  Future<void> _fetchAccountDetails() async {
    try {
      if (usc.isEmpty) {
        setState(() {
          errorMessage = 'Invalid USC provided';
          isLoading = false;
        });
        return;
      }

      final firestoreProvider =
          Provider.of<FirestoreProvider>(context, listen: false);
      final details = await firestoreProvider.fetchUserPageDetails(usc);

      setState(() {
        accountDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load account details: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Account Details')),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            const Color(0xff272627)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                )
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : Padding(
                      padding: EdgeInsets.all(20.0.w),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0.r),
                                color: Theme.of(context).colorScheme.primary),
                            padding: EdgeInsets.all(20.0.w),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(usc, style: TextStyle(fontSize: 30.sp)),
                                  Text(
                                    " ${accountDetails!['name'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 30.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Address: ",
                                      style: TextStyle(fontSize: 16.sp)),
                                  Text("${accountDetails!['address'] ?? 'N/A'}",
                                      style: TextStyle(fontSize: 16.sp)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("district: ",
                                      style: TextStyle(fontSize: 16.sp)),
                                  Text(
                                      "${accountDetails!['district'] ?? 'N/A'}",
                                      style: TextStyle(fontSize: 16.sp)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("pin code: ",
                                      style: TextStyle(fontSize: 16.sp)),
                                  Text(
                                      "${accountDetails!['pin code'] ?? 'N/A'}",
                                      style: TextStyle(fontSize: 16.sp)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("phone number: ",
                                      style: TextStyle(fontSize: 16.sp)),
                                  Text(
                                      "${accountDetails!['phone number'] ?? 'N/A'}",
                                      style: TextStyle(fontSize: 16.sp)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("service code: ",
                                      style: TextStyle(fontSize: 16.sp)),
                                  Text(
                                      "${accountDetails!['service code'] ?? 'N/A'}",
                                      style: TextStyle(fontSize: 16.sp)),
                                ],
                              ),
                            ]),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0.r),
                                color: Theme.of(context).colorScheme.primary),
                            padding: EdgeInsets.all(20.0.w),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('customers')
                                  .doc(usc)
                                  .collection('bill history')
                                  .orderBy('bill date', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Center(
                                      child: Text('No bill history found.'));
                                }

                                final bills = snapshot.data!.docs;

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: bills.length,
                                  itemBuilder: (context, index) {
                                    final bill = bills[index];
                                    final billDateString =
                                        (bill['bill date'] as String).trim();
                                    final dueDateString =
                                        (bill['due date'] as String).trim();
                                    final units = bill['units'];
                                    final adcAmount = bill['adcamount'];
                                    final paid = bill['paid'];

                                    try {
                                      // Parse string dates into DateTime
                                      final billDate = DateFormat('dd/MM/yyyy')
                                          .parse(billDateString);
                                      final dueDate = DateFormat('dd/MM/yyyy')
                                          .parse(dueDateString);

                                      // Calculate final amount
                                      final rawAmount = units * 10;
                                      final finalAmount = rawAmount + adcAmount;

                                      return Column(
                                        children: [
                                          Card(
                                            margin: EdgeInsets.all(8.w),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  minTileHeight: 100.h,
                                                  title: Text(
                                                    DateFormat('MM-yyyy')
                                                        .format(billDate),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('Units: $units'),
                                                          Text(
                                                              'Final Amount: ₹$finalAmount'),
                                                          Text(
                                                              'Due Date: ${DateFormat('dd-MM-yyyy').format(dueDate)}'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: Column(children: [
                                                    Text(
                                                      paid ? 'Paid' : 'Unpaid',
                                                      style: TextStyle(
                                                          color: paid
                                                              ? Colors.green
                                                              : Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.sp),
                                                    ),
                                                    !paid
                                                        ? Icon(Icons.cancel,
                                                            color: Colors.red)
                                                        : Icon(
                                                            Icons.check_circle,
                                                            color:
                                                                Colors.green),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                          ),
                                        ],
                                      );
                                    } catch (e) {
                                      // Handle parse error
                                      return ListTile(
                                        title: Text(
                                            'Error parsing date for bill.'),
                                        subtitle: Text(
                                            'Check the date format in Firestore.'),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
        ));
  }
}
