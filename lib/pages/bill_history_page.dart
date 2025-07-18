import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BillHistoryPage extends StatelessWidget {
  final String uscNumber; // Unique Service Code

  const BillHistoryPage({super.key, required this.uscNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill History'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.primary,
          const Color(0xff272627)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('customers')
              .doc(uscNumber)
              .collection('bill history')
              .orderBy('bill date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No bill history found.'));
            }

            final bills = snapshot.data!.docs;

            return ListView.builder(
              itemCount: bills.length,
              itemBuilder: (context, index) {
                final bill = bills[index];
                final billDateString = (bill['bill date'] as String).trim();
                final dueDateString = (bill['due date'] as String).trim();
                final units = bill['units'];
                final adcAmount = bill['adcamount'];
                final paid = bill['paid'];

                try {
                  // Parse string dates into DateTime
                  final billDate =
                      DateFormat('dd/MM/yyyy').parse(billDateString);
                  final dueDate = DateFormat('dd/MM/yyyy').parse(dueDateString);

                  // Calculate final amount
                  final rawAmount = units * 10;
                  final finalAmount = rawAmount + adcAmount;

                  return Card(
                    margin: EdgeInsets.all(8.w),
                    child: ListTile(
                      minTileHeight: 100.h,
                      title: Text(
                        DateFormat('MM-yyyy').format(billDate),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Units: $units'),
                              Text('Final Amount: ₹$finalAmount'),
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
                              color: paid ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp),
                        ),
                        !paid
                            ? Icon(Icons.cancel, color: Colors.red)
                            : Icon(Icons.check_circle, color: Colors.green),
                      ]),
                    ),
                  );
                } catch (e) {
                  // Handle parse error
                  return ListTile(
                    title: Text('Error parsing date for bill.'),
                    subtitle: Text('Check the date format in Firestore.'),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
