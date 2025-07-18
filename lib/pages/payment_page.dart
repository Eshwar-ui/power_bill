// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatelessWidget {
  final String USC;

  final double amountToPay;

  const PaymentPage({
    super.key,
    required this.USC,
    required this.amountToPay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Make Payment",
          style: TextStyle(fontSize: 22.sp),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Number
            Row(
              children: [
                Text(
                  "USC Number:",
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.normal),
                ),
                Text(
                  " $USC",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // Amount to Pay
            Row(
              children: [
                Text(
                  "Amount to Pay :  ",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                Text(
                  "₹${amountToPay.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ],
            ),
            SizedBox(height: 30.h),

            // Payment Options Title
            Text(
              "Select Payment Method",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),

            // Payment Options List
            Expanded(
              child: ListView(
                children: [
                  PaymentOptionTile(
                    title: "Google Pay",
                    icon: 'lib/assets/util_icons/gpay.png',
                    onTap: () {
                      // Handle Google Pay logic
                      launchGPay(
                        upiId: "yourupi@upi", // Replace with your UPI ID
                        name: "Your Name", // Replace with your name
                        amount: amountToPay.toStringAsFixed(2),
                      );
                    },
                  ),
                  PaymentOptionTile(
                    title: "PhonePe",
                    icon: 'lib/assets/util_icons/phone pe.png',
                    onTap: () {
                      // Handle PhonePe logic
                      print("PhonePe selected");
                    },
                  ),
                  PaymentOptionTile(
                    title: "Paytm",
                    icon: 'lib/assets/util_icons/paytm.png',
                    onTap: () {
                      // Handle Paytm logic
                      print("Paytm selected");
                    },
                  ),
                  PaymentOptionTile(
                    title: "Debit Card",
                    icon: 'lib/assets/util_icons/debit card.png',
                    onTap: () {
                      // Handle Debit Card logic
                      print("Debit Card selected");
                    },
                  ),
                  PaymentOptionTile(
                    title: "Credit Card",
                    icon: 'lib/assets/util_icons/credit card.png',
                    onTap: () {
                      // Handle Credit Card logic
                      print("Credit Card selected");
                    },
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

class PaymentOptionTile extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const PaymentOptionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Image.asset(icon, height: 50.h, width: 50.w),
        title: Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18.sp),
      ),
    );
  }
}

Future<void> launchGPay({
  required String upiId,
  required String name,
  required String amount,
}) async {
  final uri = Uri(
    scheme: "upi",
    path: "pay",
    queryParameters: {
      "pa": upiId, // UPI ID of the payee
      "pn": name, // Payee's name
      "tn": "Payment for Power Bill", // Transaction note
      "am": amount, // Amount to be paid
      "cu": "INR", // Currency
    },
  );

  // Check if Google Pay can be launched
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    print("Google Pay is not installed on this device");
    // Handle the error gracefully, e.g., show a dialog
  }
}
