import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class billingissuesPage extends StatefulWidget {
  const billingissuesPage({super.key});

  @override
  State<billingissuesPage> createState() => _billingissuesPageState();
}

class _billingissuesPageState extends State<billingissuesPage> {
  String? _selectedUSC;
  String? _selectedIssue;
  final TextEditingController _problemController = TextEditingController();
  PlatformFile? _attachedFile; // Store the attached file

  List<String> uscNumbers = []; // USC numbers fetched from Firestore
  final List<String> issueTypes = [
    "Arrears Dispute",
    "Levy Reconnection Charges Without Disconnection",
    "Wrongful Disconnection of Service",
    "Meter Reading Not Taken",
    "Bill Correction",
    "Bill Payment Issues",
    "OSL to Live"
  ];

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
        _problemController.text.isEmpty) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Create a reference to store the file if there is one
    String? fileUrl;
    if (_attachedFile != null) {
      // Upload the file to Firebase Storage or some other server
      // Here, we're just mocking the upload with a file URL
      fileUrl =
          'https://path/to/your/file/${_attachedFile!.name}'; // You should upload it to Firebase Storage
    }

    // Submit the report to Firestore (You can customize the collection and data)
    await FirebaseFirestore.instance.collection('billing issues').add({
      'usc_number': _selectedUSC,
      'issue': _selectedIssue,
      'problem': _problemController.text,
      'file_url': fileUrl, // Store the file URL if there's an attachment
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Billing Issue reported successfully')),
    );

    // Reset the form
    setState(() {
      _problemController.clear();
      _selectedUSC = uscNumbers.isNotEmpty ? uscNumbers[0] : null;
      _selectedIssue = null;
      _attachedFile = null; // Reset the attached file
    });
  }

  // Function to pick a file
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _attachedFile = result.files.single;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing Issues'),
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
                });
              },
            ),
            const SizedBox(height: 20),

            // Problem Description Text Field
            Text('Describe the Problem', style: TextStyle(fontSize: 18.sp)),
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
            const SizedBox(height: 20),

            // Attach File Button
            ElevatedButton(
              onPressed: _pickFile,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.inversePrimary),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              child: const Text('Attach File'),
            ),
            if (_attachedFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text('Attached file: ${_attachedFile!.name}'),
              ),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: _submitReport,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.inversePrimary),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              child: const Text('Submit Issue'),
            ),
          ],
        ),
      ),
    );
  }
}
