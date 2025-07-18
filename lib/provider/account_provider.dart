// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Gets the current user's phone number
  String? get currentUserPhoneNumber => _auth.currentUser?.phoneNumber;

  /// Adds a reference to a document in the user's `accounts` subcollection
  Future<void> addDocumentReferenceToAccount(String docId) async {
    try {
      String? userId = currentUserPhoneNumber;

      if (userId == null) {
        throw Exception("User is not signed in.");
      }

      // Reference to the main document
      DocumentReference mainDocRef = _db.collection('customers').doc(docId);
      DocumentSnapshot mainDocSnapshot = await mainDocRef.get();

      if (mainDocSnapshot.exists) {
        // Reference to the user's accounts subcollection
        DocumentReference userAccountRef = _db
            .collection('users')
            .doc(userId)
            .collection('accounts')
            .doc(docId);

        // Add the reference
        await userAccountRef.set({
          'USC': docId, // Store the document ID
          'reference': mainDocRef, // Store the main document reference
          'addedAt': FieldValue.serverTimestamp(),
        });

        notifyListeners();
      } else {
        throw Exception(
            'Document with ID $docId does not exist in customers collection');
      }
    } catch (e) {
      throw Exception('Failed to add document reference: $e');
    }
  }

  /// Fetches all account references for the current user
  // Stream to fetch account references and main document data
  Stream<List<Map<String, dynamic>>> getAccountReferences() {
    String? userId = currentUserPhoneNumber;

    if (userId == null) {
      throw Exception("User is not signed in.");
    }

    // Stream that listens to 'accounts' collection for the current user
    return _db
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> accounts = [];

      for (var doc in snapshot.docs) {
        // Get the reference from the account document
        DocumentReference mainDocRef = doc['reference'];

        // Fetch the referenced document from the 'customers' collection
        DocumentSnapshot mainDocSnapshot = await mainDocRef.get();

        if (mainDocSnapshot.exists) {
          Map<String, dynamic> mainDocData =
              mainDocSnapshot.data() as Map<String, dynamic>;

          // Add docId to the main document data
          String docId = mainDocSnapshot.id;
          mainDocData['docId'] = docId;

          // Fetch the latest bill history for this customer
          Map<String, dynamic>? latestBillData;
          try {
            latestBillData = await fetchLatestBillHistoryData(docId);
          } catch (e) {
            latestBillData = {
              'error': e.toString()
            }; // Handle errors gracefully
          }

          // Add the latest bill history data to the main document data
          mainDocData['latestBill'] = latestBillData;

          accounts.add(mainDocData);
        }
      }

      return accounts;
    });
  }

// Fetch the latest document in the 'bill history' subcollection
  Future<Map<String, dynamic>> fetchLatestBillHistoryData(String docId) async {
    try {
      // Reference to the 'bill history' subcollection
      DocumentReference mainDocRef = _db.collection('customers').doc(docId);
      CollectionReference billHistoryCollection =
          mainDocRef.collection('bill history');

      // Query for the latest document based on a timestamp field
      QuerySnapshot billHistorySnapshot = await billHistoryCollection
          .orderBy('bill date', descending: true) // Order by bill date
          .limit(1) // Get the latest document only
          .get();

      if (billHistorySnapshot.docs.isNotEmpty) {
        DocumentSnapshot latestDoc = billHistorySnapshot.docs.first;
        Map<String, dynamic> billData =
            latestDoc.data() as Map<String, dynamic>;

        // Ensure 'units' is included
        if (!billData.containsKey('units')) {
          billData['units'] = 0; // Default to 0 if units aren't available
        }

        return billData;
      } else {
        throw Exception('No documents found in bill history.');
      }
    } catch (e) {
      throw Exception('Failed to fetch latest BillHistory data: $e');
    }
  }

  /// Updates a document in the `database_collection`
  Future<void> updateDatabaseCollection(
      String docId, Map<String, dynamic> updatedData) async {
    try {
      await _db
          .collection('database_collection')
          .doc(docId)
          .update(updatedData);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  /// Removes a document reference from the user's `accounts` subcollection
  Future<void> removeDocumentReferenceFromAccount(
      String userId, String docId) async {
    try {
      // Print debug logs
      print(
          'Attempting to delete document with docId: $docId for userId: $userId');

      // Reference to the user's accounts subcollection
      DocumentReference userAccountRef =
          _db.collection('users').doc(userId).collection('accounts').doc(docId);

      // Check if the document exists before attempting deletion
      final docSnapshot = await userAccountRef.get();
      if (!docSnapshot.exists) {
        print(
            'Document with docId: $docId does not exist in accounts subcollection.');
        throw Exception('Document not found');
      }

      // Delete the document
      await userAccountRef.delete();
      print('Document with docId: $docId deleted successfully.');

      notifyListeners();
    } catch (e) {
      print('Failed to delete document: $e');
      throw Exception('Failed to delete document reference: $e');
    }
  }

  // Inside FirestoreProvider class
  Future<Map<String, dynamic>?> fetchLatestBillHistoryData1(
      String docId) async {
    try {
      String? userId = currentUserPhoneNumber;

      if (userId == null) {
        throw Exception("User is not signed in.");
      }

      // Reference to the user's accounts subcollection
      DocumentReference userAccountRef =
          _db.collection('users').doc(userId).collection('accounts').doc(docId);

      // Get the 'bill history' subcollection of the referenced document
      QuerySnapshot billHistorySnapshot = await userAccountRef
          .collection('bill history')
          .orderBy('timestamp',
              descending:
                  true) // Assuming you have a timestamp field to order by
          .limit(1) // Get the latest document
          .get();

      // Check if we have any document in the 'bill history'
      if (billHistorySnapshot.docs.isEmpty) {
        return null; // No bill history found
      }

      // Extract data from the latest document
      DocumentSnapshot latestBillDoc = billHistorySnapshot.docs.first;
      Map<String, dynamic> billHistoryData =
          latestBillDoc.data() as Map<String, dynamic>;

      return billHistoryData; // Return the latest bill history data
    } catch (e) {
      throw Exception('Failed to fetch latest bill history data: $e');
    }
  }

  // get details of a user page
  Future<Map<String, dynamic>> fetchUserPageDetails(String usc) async {
    try {
      print('Fetching details for USC: $usc');
      DocumentReference userDocRef = _db.collection('customers').doc(usc);

      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        print('Document data: ${userDocSnapshot.data()}');
        return userDocSnapshot.data() as Map<String, dynamic>;
      } else {
        print('No document found for USC: $usc');
        throw Exception('User not found.');
      }
    } catch (e) {
      print('Error fetching user details: $e');
      throw Exception('Failed to fetch user details: $e');
    }
  }
}
