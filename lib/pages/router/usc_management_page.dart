// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:power_bill/provider/account_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UscManagementPage extends StatefulWidget {
  const UscManagementPage({super.key});

  @override
  State<UscManagementPage> createState() => _UscManagementPageState();
}

class _UscManagementPageState extends State<UscManagementPage> {
  final TextEditingController docIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firestoreProvider =
        Provider.of<FirestoreProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(title: const Text('USC Management')),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: TextField(
                controller: docIdController,
                decoration: InputDecoration(
                    hintText: 'Enter USC',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r))),
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.inversePrimary)),
              onPressed: () async {
                String docId = docIdController.text.trim();

                try {
                  await firestoreProvider.addDocumentReferenceToAccount(docId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reference added successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
                // remove key board
                FocusScope.of(context).unfocus();
                //clear text field
                docIdController.clear();
              },
              child: Text(
                'Add USC',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Expanded(
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
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];

                    // Access docId from the account data
                    final usc = account['USC'] ?? 'No USC';

                    return Container(
                      decoration: BoxDecoration(),
                      margin: EdgeInsets.only(bottom: 10).h,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10.w),
                        tileColor: Colors.white10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r)),
                        leading: Padding(
                          padding: EdgeInsets.only(left: 10.0.w),
                          child: Icon(
                            Icons.account_box,
                            size: 40.sp,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            try {
                              await firestoreProvider
                                  .removeDocumentReferenceFromAccount(
                                      firestoreProvider
                                              .currentUserPhoneNumber ??
                                          '',
                                      usc);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('USC deleted successfully')),
                              );
                            } catch (e) {
                              // Inside your async function or callback
                              if (!mounted) {
                                return; // If widget is no longer mounted, return early
                              }

                              // Your code here, e.g., showing a snackbar or using context
                              // ScaffoldMessenger.of(context)
                              //     .showSnackBar(SnackBar(content: Text('Done!')));
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        title: Text(
                          usc,
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ), // Display the docId correctly
                        subtitle: Text('Tap to view details'),
                        onTap: () {
                          print('Navigating to account details for USC: $usc');

                          Navigator.pushNamed(
                            context,
                            '/account_detail',
                            arguments: usc,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            )),
          ],
        ));
  }
}
