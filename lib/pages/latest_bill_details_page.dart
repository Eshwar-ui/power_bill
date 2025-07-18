// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_bill/pages/bill_history_page.dart';
import 'package:power_bill/pages/payment_page.dart';
import 'package:provider/provider.dart';
import 'package:power_bill/provider/account_provider.dart';

class BillPage extends StatefulWidget {
  final String arguments;
  const BillPage({super.key, required this.arguments});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  Map<String, dynamic>? accountDetails;
  bool isLoading = true;
  String errorMessage = '';
  late String usc;

  @override
  void initState() {
    super.initState();
    usc = widget.arguments;
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
    final FirestoreProvider firestoreProvider = FirestoreProvider();
    return Scaffold(
      appBar: AppBar(title: Text('bill Details')),
      body: isLoading
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 600.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10.r,
                              offset: Offset(0, 5),
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                          gradient: LinearGradient(
                              colors: [
                                Color(0xff423BA4).withOpacity(0.8),
                                Color(0xff000000)
                              ],
                              begin: AlignmentDirectional.centerStart,
                              end: AlignmentDirectional.centerEnd),
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("USC no.",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.sp)),
                                        Text(usc,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30.sp)),
                                      ],
                                    ),
                                    Text(
                                      " ${accountDetails!['name'] ?? 'N/A'}",
                                      style: TextStyle(
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                padding: EdgeInsets.all(20.0.w),
                                child: accountDetails == null
                                    ? Center(
                                        child: Text(
                                          'No details available.',
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0.w,
                                            vertical: 20.0.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Service number:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16.sp,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inversePrimary),
                                                ),
                                                Text(
                                                  " ${accountDetails!['service code'] ?? 'N/A'}",
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inversePrimary),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Address: ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16.sp,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inversePrimary),
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    "${accountDetails!['address'] ?? 'N/A'}",
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .inversePrimary),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            FutureBuilder<Map<String, dynamic>>(
                                              future: firestoreProvider
                                                  .fetchLatestBillHistoryData(
                                                      usc),
                                              builder: (context,
                                                  billHistorySnapshot) {
                                                if (billHistorySnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inversePrimary,
                                                    ),
                                                  );
                                                }

                                                if (billHistorySnapshot
                                                    .hasError) {
                                                  return Text(
                                                    'Error fetching bill history.',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                                    ),
                                                  );
                                                }

                                                if (!billHistorySnapshot
                                                    .hasData) {
                                                  return const Text(
                                                    'No bill history available.',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  );
                                                }

                                                final billHistoryData =
                                                    billHistorySnapshot.data!;

                                                return Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'UNITS:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${billHistoryData['units'] ?? 'N/A'}',
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Bill date:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${billHistoryData['bill date'] ?? 'N/A'}',
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Due date:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${billHistoryData['due date'] ?? 'N/A'}',
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'ADC ammount:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${billHistoryData['adcamount'] ?? 'N/A'}',
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'charge Ammount:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${(billHistoryData['units'] ?? 0) * 10}',
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Divider(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inversePrimary,
                                                      height: 1.h,
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Total Ammount:',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                        Text(
                                                          '₹${(billHistoryData['adcamount'] ?? 0) + (billHistoryData['units'] ?? 0) * 10}/-',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16.sp,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20.h),
                                                    if (billHistoryData[
                                                            'paid'] ==
                                                        false)
                                                      ElevatedButton(
                                                          autofocus: true,
                                                          style: ButtonStyle(
                                                            elevation:
                                                                WidgetStatePropertyAll(
                                                                    5),
                                                            minimumSize:
                                                                WidgetStatePropertyAll(
                                                                    Size(
                                                                        double
                                                                            .infinity,
                                                                        50.h)),
                                                            foregroundColor:
                                                                WidgetStatePropertyAll(
                                                                    Colors
                                                                        .black),
                                                            backgroundColor:
                                                                WidgetStatePropertyAll(
                                                                    Colors
                                                                        .white),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PaymentPage(
                                                                  USC: usc,
                                                                  amountToPay: ((billHistoryData['adcamount'] ??
                                                                              0) +
                                                                          (billHistoryData['units'] ?? 0) *
                                                                              10)
                                                                      .toDouble(),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Text(
                                                            'Pay now',
                                                            style: TextStyle(
                                                                fontSize: 18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ))
                                                    else
                                                      Text(
                                                        'PAID',
                                                        style: TextStyle(
                                                          fontSize: 25.sp,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    SizedBox(height: 10.h),
                                                    ElevatedButton(
                                                        autofocus: true,
                                                        style: ButtonStyle(
                                                          elevation:
                                                              WidgetStatePropertyAll(
                                                                  5),
                                                          minimumSize:
                                                              WidgetStatePropertyAll(
                                                                  Size(
                                                                      double
                                                                          .infinity,
                                                                      50.h)),
                                                          foregroundColor:
                                                              WidgetStatePropertyAll(
                                                                  Colors.black),
                                                          backgroundColor:
                                                              WidgetStatePropertyAll(
                                                                  Colors.white),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BillHistoryPage(
                                                                      uscNumber:
                                                                          usc),
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                          'bill history',
                                                          style: TextStyle(
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ))
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
