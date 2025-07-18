import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalBillHistoryPage extends StatelessWidget {
  const GlobalBillHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Bill History (Paid Bills)'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('customers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No paid bills found.'));
          }

          // Extract customers and their bill histories
          final customers = snapshot.data!.docs;

          List<Map<String, dynamic>> paidBills = [];

          for (var customer in customers) {
            final uscNumber = customer.id;
            final billHistory = customer.reference.collection('bill history');
            billHistory.get().then((billsSnapshot) {
              for (var bill in billsSnapshot.docs) {
                if (bill['paid'] == true) {
                  paidBills.add({
                    'uscNumber': uscNumber,
                    'billDate': bill['bill date'],
                    'dueDate': bill['due date'],
                    'finalAmount': bill['units'] * 20 + bill['adcamount'],
                  });
                }
              }
            });
          }

          if (paidBills.isEmpty) {
            return Center(child: Text('No paid bills available.'));
          }

          return ListView.builder(
            itemCount: paidBills.length,
            itemBuilder: (context, index) {
              final bill = paidBills[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text('USC: ${bill['uscNumber']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bill Date: ${bill['billDate']}'),
                      Text('Due Date: ${bill['dueDate']}'),
                      Text('Final Amount: ₹${bill['finalAmount']}'),
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
