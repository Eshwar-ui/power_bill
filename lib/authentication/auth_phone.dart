// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_bill/pages/home_router.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneNumberController =
      TextEditingController(text: '+91 ');
  String? _verificationId;
  final TextEditingController _nameController = TextEditingController();
  bool isloading = false;

  void _ensurePlus91Prefix() {
    if (!_phoneNumberController.text.startsWith('+91')) {
      _phoneNumberController.text = '+91';
      _phoneNumberController.selection = TextSelection.fromPosition(
        const TextPosition(offset: 3), // Move cursor to the end of '+91'
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(_ensurePlus91Prefix);
  }

  Future<void> _verifyPhoneNumber() async {
    setState(() {
      isloading = true;
    });
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          createUserCollection(userCredential.user?.phoneNumber,
              _nameController.text); // Pass name here
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Verification Failed: ${e.message}')));
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            isloading = false;
          });

          setState(() {
            _verificationId = verificationId;
          });
          // Navigate to OTP screen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPScreen(
                        verificationId: _verificationId!,
                        phoneNumber: _phoneNumberController.text,
                      )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _phoneNumberController.removeListener(_ensurePlus91Prefix);
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "lib/assets/images/telangana logo.png",
                fit: BoxFit.cover,
                height: 100.h,
                width: 100.w,
              ),
              Text(
                "WELCOME",
                style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                "SIGN IN TO CONTINUE",
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: TextField(
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name ',
                    focusColor: Theme.of(context).colorScheme.inversePrimary,
                    enabled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).colorScheme.inversePrimary)),
                    floatingLabelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).colorScheme.inversePrimary)),
                  ),
                  keyboardType: TextInputType.name,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: TextField(
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number ',
                    focusColor: Theme.of(context).colorScheme.inversePrimary,
                    enabled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).colorScheme.inversePrimary)),
                    floatingLabelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).colorScheme.inversePrimary)),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              isloading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.inversePrimary),
                      ),
                      onPressed: _verifyPhoneNumber,
                      // onPressed: () {
                      //   Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const Home()));
                      // },
                      child: Text(
                        'Verify Phone Number',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const OTPScreen(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool isloading = false;

  Future<void> _verifyOTP() async {
    setState(() {
      isloading = true;
    });
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: _otpController.text);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      createUserCollection(
          userCredential.user?.phoneNumber, _nameController.text);

      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const Home())); // Navigate back after successful login.
    } catch (e) {
      setState(() {
        isloading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid OTP')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Verify ${widget.phoneNumber}",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                hintText: 'Enter OTP',
                focusColor: Theme.of(context).colorScheme.inversePrimary,
                enabled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.inversePrimary)),
                floatingLabelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.inversePrimary)),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 30,
            ),
            isloading
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.inversePrimary),
                    ),
                    onPressed: _verifyOTP,
                    child: const Text("Verify OTP"))
          ],
        ),
      ),
    );
  }
}

Future<void> createUserCollection(String? phoneNumber, String name) async {
  if (phoneNumber == null) return;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Check if the user document already exists
  DocumentSnapshot userDoc = await users.doc(phoneNumber).get();
  if (!userDoc.exists) {
    // Create a new document for the user
    await users.doc(phoneNumber).set({
      'phoneNumber': phoneNumber,
      'name': name, // Add the name field here
      'createdAt': FieldValue.serverTimestamp(),
      'isActive': true,
    });
    print('User document created for $phoneNumber');
  } else {
    print('User document already exists for $phoneNumber');
  }
}
