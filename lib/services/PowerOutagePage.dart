// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PowerOutagePage extends StatefulWidget {
  const PowerOutagePage({super.key});

  @override
  State<PowerOutagePage> createState() => _PowerOutagePageState();
}

class _PowerOutagePageState extends State<PowerOutagePage> {
  String? _selectedUSC;
  String _problem = '';
  bool _isIndividual = true; // To toggle between individual and total area
  List<String> uscNumbers =
      []; // This will hold USC numbers fetched from Firestore

  @override
  void initState() {
    super.initState();
    _fetchUSCNumbers();
  }

  // Fetch USC numbers from Firestore (replace with your collection path)
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
    if (_selectedUSC == null || _problem.isEmpty) {
      // Show an error message if USC or problem is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Submit to Firestore (You can customize the collection and data)
    await FirebaseFirestore.instance.collection('power_outages').add({
      'usc_number': _selectedUSC,
      'problem': _problem,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Show success message
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted successfully')),
    );

    // Reset the form
    setState(() {
      _problem = '';
      _selectedUSC = uscNumbers.isNotEmpty ? uscNumbers[0] : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Power Outage Report'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle between Individual or Total Area
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Individual'),
                    leading: Radio<bool>(
                      activeColor: Theme.of(context).colorScheme.inversePrimary,
                      value: true,
                      groupValue: _isIndividual,
                      onChanged: (bool? value) {
                        setState(() {
                          _isIndividual = value!;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Total Area'),
                    leading: Radio<bool>(
                      activeColor: Theme.of(context).colorScheme.inversePrimary,
                      value: false,
                      groupValue: _isIndividual,
                      onChanged: (bool? value) {
                        setState(() {
                          _isIndividual = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // USC Number Dropdown
            DropdownButtonFormField<String>(
              value: _selectedUSC,
              decoration: InputDecoration(
                labelText: 'Select USC Number',
                border: OutlineInputBorder(),
              ),
              items: uscNumbers.map((usc) {
                return DropdownMenuItem<String>(
                  value: usc,
                  child: Text(usc),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUSC = newValue;
                });
              },
            ),
            SizedBox(height: 20.h),

            // Problem Description TextField
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Describe the problem or issue',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _problem = value;
                });
              },
            ),
            SizedBox(height: 20.h),

            // Submit Button
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary)),
              onPressed: _submitReport,
              child: Text(
                'Submit Report',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
