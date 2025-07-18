// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class metterissuesPage extends StatefulWidget {
  const metterissuesPage({super.key});

  @override
  State<metterissuesPage> createState() => _metterissuesPageState();
}

class _metterissuesPageState extends State<metterissuesPage> {
  String? _selectedUSC;
  String? _selectedIssue;
  final TextEditingController _problemController = TextEditingController();

  List<String> uscNumbers = []; // USC numbers fetched from Firestore
  final List<String> issueTypes = [
    "Meter Burnt",
    "Meter Stuck/Defect",
    "Meter Challenge Test"
  ];

  double? serviceCharges;

  @override
  void initState() {
    super.initState();
    _fetchUSCNumbers();
  }

  // Fetch USC numbers from Firestore
  Future<void> _fetchUSCNumbers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('customers') // Replace with your Firestore collection
        .get();

    setState(() {
      uscNumbers = snapshot.docs
          .map((doc) => doc.id) // Assuming USC number is the document ID
          .toList();
      _selectedUSC = uscNumbers.isNotEmpty ? uscNumbers[0] : null;
    });
  }

  // Function to submit the report
  Future<void> _submitReport() async {
    if (_selectedUSC == null ||
        _selectedIssue == null ||
        (_selectedIssue != "Meter Stuck/Defect" &&
            serviceCharges == null &&
            _problemController.text.isEmpty)) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Submit to Firestore (You can customize the collection and data)
    await FirebaseFirestore.instance.collection('meter issues').add({
      'usc_number': _selectedUSC,
      'issue': _selectedIssue,
      'problem':
          _problemController.text.isNotEmpty ? _problemController.text : null,
      'service_charges': serviceCharges,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Show success message
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meter Issue reported successfully')),
    );

    // Reset the form
    setState(() {
      _problemController.clear();
      _selectedUSC = uscNumbers.isNotEmpty ? uscNumbers[0] : null;
      _selectedIssue = null;
      serviceCharges = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meter Issues'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // USC Dropdown
            const Text('Select USC Number', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedUSC,
              hint: const Text('Select USC'),
              isExpanded: true,
              items: uscNumbers.map((usc) {
                return DropdownMenuItem<String>(
                  value: usc,
                  child: Text(usc),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUSC = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Issue Dropdown
            const Text('Select Issue Type', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedIssue,
              hint: const Text('Select Issue Type'),
              isExpanded: true,
              items: issueTypes.map((issue) {
                return DropdownMenuItem<String>(
                  value: issue,
                  child: Text(issue),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedIssue = value;
                  _updateServiceCharges();
                });
              },
            ),
            const SizedBox(height: 20),

            // Conditional UI for different issues
            if (_selectedIssue == "Meter Burnt") ...[
              Text(
                'Service Charges: 1100 Rs',
                style: TextStyle(fontSize: 18.sp),
              ),
              const SizedBox(height: 10),
            ] else if (_selectedIssue == "Meter Stuck/Defect") ...[
              Text('Describe the Problem:', style: TextStyle(fontSize: 18.sp)),
              TextField(
                controller: _problemController,
                decoration: InputDecoration(
                  hintText: 'Enter your problem here...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
                maxLines: 4,
              ),
            ] else if (_selectedIssue == "Meter Challenge Test") ...[
              Text(
                'Service Charges: 100 Rs',
                style: TextStyle(fontSize: 18.sp),
              ),
              const SizedBox(height: 10),
            ],

            SizedBox(height: 20.h),

            // Submit Button
            ElevatedButton(
              onPressed: _submitReport,
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.inversePrimary),
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              child: const Text('Submit Issue'),
            ),
          ],
        ),
      ),
    );
  }

  // Update service charges based on selected issue
  void _updateServiceCharges() {
    if (_selectedIssue == "Meter Burnt") {
      serviceCharges = 1100.0;
    } else if (_selectedIssue == "Meter Stuck/Defect") {
      serviceCharges = null; // No predefined charges for this
    } else if (_selectedIssue == "Meter Challenge Test") {
      serviceCharges = 100.0;
    }
  }
}
