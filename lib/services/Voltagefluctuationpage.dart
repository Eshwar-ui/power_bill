import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Voltagefluctuationpage extends StatefulWidget {
  const Voltagefluctuationpage({super.key});

  @override
  State<Voltagefluctuationpage> createState() => _VoltagefluctuationpageState();
}

class _VoltagefluctuationpageState extends State<Voltagefluctuationpage> {
  String? _selectedUSC;
  final TextEditingController _problemController = TextEditingController();

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
    if (_selectedUSC == null || _problemController.text.isEmpty) {
      // Show an error message if USC or problem is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Submit to Firestore (You can customize the collection and data)
    await FirebaseFirestore.instance.collection('voltage fluctuations').add({
      'usc_number': _selectedUSC,
      'problem': _problemController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Show success message
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted successfully')),
    );

    // Reset the form
    setState(() {
      _problemController.clear();
      _selectedUSC = uscNumbers.isNotEmpty ? uscNumbers[0] : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voltage Fluctuation'),
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

            // Problem Text Field
            Text('Describe the Issue', style: TextStyle(fontSize: 18.sp)),
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
            SizedBox(height: 20.h),

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
