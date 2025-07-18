import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:power_bill/pages/router/usc_management_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:power_bill/services/contactuspage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload the image to Firebase Storage and update Firestore with the URL
      final storageRef = FirebaseStorage.instance.ref().child(
          'profile_pictures/${FirebaseAuth.instance.currentUser!.uid}.jpg');
      await storageRef.putFile(_imageFile!);
      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'profilePicture': downloadUrl});
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('No user logged in'),
        ),
      );
    }
    Future<String> getUserName(String phoneNumber) async {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(phoneNumber) // Use the phone number as the document ID
            .get();

        // Check if the document exists
        if (snapshot.exists) {
          return snapshot
              .get('name'); // Retrieve the 'name' field from the document
        } else {
          return 'User not found';
        }
      } catch (e) {
        print("Error getting user name: $e");
        return 'Error fetching name';
      }
    }

    String phonenumber = user.phoneNumber ?? 'Phone number not available';
    Future<String> nameFuture = getUserName(phonenumber);
    print(nameFuture); // Prints the user's name
    if (phonenumber.startsWith('+91')) {
      phonenumber = phonenumber.substring(3);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10.sp),
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.r,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 40.w, left: 20.w, bottom: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.hasData) {
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>?;
                        final profilePictureUrl = data?['profilePicture'];

                        return CircleAvatar(
                          maxRadius: 60,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!) as ImageProvider
                              : (profilePictureUrl != null
                                  ? NetworkImage(profilePictureUrl)
                                  : NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtjc1qljA6XR_Fc4srlhbKQDLFaJqIaNUhzw&s",
                                      scale: 2)),
                          child: Stack(
                            children: [
                              // Edit Icon
                              Positioned(
                                bottom: 0.sp,
                                right: 0.sp,
                                child: GestureDetector(
                                  onTap:
                                      _pickImage, // Call function to pick an image
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(6.w),
                                    child: Icon(
                                      Icons.edit,
                                      size: 20.sp,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Center(child: Text('No data available.'));
                    },
                  ),
                  SizedBox(height: 10.h),
                  FutureBuilder<String>(
                    future: nameFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(
                          snapshot.data ?? 'Name not available',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40.sp,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            child: Column(
              children: [
                ProfileButton(
                    text: "Themes",
                    icon: Icons.palette_outlined,
                    onTap: () {
                      Navigator.pushNamed(context, '/themeswitch');
                    }),
                ProfileButton(
                  icon: Icons.supervisor_account,
                  text: 'USC MANAGEMENT',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UscManagementPage()));
                  },
                ),
                ProfileButton(
                  text: "contact us",
                  icon: Icons.call,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactUsPage()));
                  },
                ),
                ProfileButton(
                  text: "Sign out",
                  icon: Icons.logout,
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileButton(
      {super.key, required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Padding(
        padding: EdgeInsets.all(20.w),
        child: Icon(icon, color: Theme.of(context).colorScheme.inversePrimary),
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 20.sp,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
