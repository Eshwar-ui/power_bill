import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_bill/pages/payment_page.dart';
import 'package:power_bill/provider/account_provider.dart';

class MyCard extends StatefulWidget {
  const MyCard({super.key});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  final FirestoreProvider firestoreProvider = FirestoreProvider();

  // Predefined colors for gradient backgrounds
  final List<Color> gradientColors = [
    Color(0xff423BA4).withOpacity(0.8),
    Color(0xff3BA447),
    Colors.red,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      width: double.infinity,
      height: 225,
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreProvider.getAccountReferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No account found.',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/usc_management');
                    },
                    child: Text(
                      'Add Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final accounts = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              String docId = account['docId'] ?? 'Unknown';
              String usc = account['USC'] ?? 'Unknown'; // USC for display

              final gradientColor =
                  gradientColors[index % gradientColors.length];

              return Container(
                height: 225,
                width: 345,
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  gradient: LinearGradient(
                    colors: [gradientColor, const Color(0xff000000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.3, 0.99],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.0.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // USC Title
                      Padding(
                        padding: EdgeInsets.only(left: 10.0.w),
                        child: Text(
                          usc,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // Fetch and display latest bill history
                      FutureBuilder<Map<String, dynamic>>(
                        future:
                            firestoreProvider.fetchLatestBillHistoryData(docId),
                        builder: (context, billHistorySnapshot) {
                          if (billHistorySnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            );
                          }

                          if (billHistorySnapshot.hasError) {
                            return Text(
                              'Error fetching bill history.',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            );
                          }

                          if (!billHistorySnapshot.hasData) {
                            return const Text(
                              'No bill history available.',
                              style: TextStyle(color: Colors.white),
                            );
                          }

                          final billHistoryData = billHistorySnapshot.data!;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0.w),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10.h),

                                      // Display UNITS
                                      Text(
                                        'UNITS:',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: Colors.white38,
                                        ),
                                      ),
                                      Text(
                                        '${billHistoryData['units'] ?? 'N/A'}',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),

                                      // Display due date
                                      Text(
                                        'Due Date: ',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: Colors.white38,
                                        ),
                                      ),

                                      // Display due date
                                      Text(
                                        '${billHistoryData['due date'] ?? 'N/A'}',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 39.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0.w),
                                        child: Text(
                                          '₹${(billHistoryData['adcamount'] ?? 0) + (billHistoryData['units'] ?? 0) * 10}',
                                          style: TextStyle(
                                            fontSize: 25.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 10.h),
                                      // Display pay now button if bill is unpaid
                                      if (billHistoryData['paid'] == false)
                                        ElevatedButton(
                                            style: ButtonStyle(
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
                                                      PaymentPage(
                                                    USC: usc,
                                                    amountToPay: ((billHistoryData[
                                                                    'adcamount'] ??
                                                                0) +
                                                            (billHistoryData[
                                                                        'units'] ??
                                                                    0) *
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
                                                  fontWeight: FontWeight.bold),
                                            ))
                                      else
                                        Text(
                                          'PAID',
                                          style: TextStyle(
                                            fontSize: 25.sp,
                                            color: Colors.green,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
