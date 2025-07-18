import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Newservicepage extends StatefulWidget {
  const Newservicepage({super.key});

  @override
  State<Newservicepage> createState() => _NewservicepageState();
}

class _NewservicepageState extends State<Newservicepage> {
  // For LT Service
  String? _ltServiceDistrict;
  String? _ltServiceSection;
  String? _adjacentUSCNumber;
  String? _ltRadioValue;

  // For LTM Service
  String? _ltmRadioValue;
  TextEditingController _noOfConnectionsController = TextEditingController();

  List<String> districts = [
    'District 1',
    'District 2',
    'District 3',
    'District 4',
  ]; // You can update this list with actual districts
  List<String> sections = [
    'Section 1',
    'Section 2',
    'Section 3',
    'Section 4',
  ]; // Update with actual sections

  // LT Service form submission
  void _submitLTService() {
    if (_ltRadioValue == null ||
        _ltServiceDistrict == null ||
        _ltServiceSection == null ||
        _adjacentUSCNumber == null) {
      // Show error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all LT Service fields')),
      );
    } else {
      // Proceed with submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('LT Service application submitted')),
      );
      // Save to Firestore or any backend
    }
  }

  // LTM Service form submission
  void _submitLTMService() {
    if (_ltmRadioValue == null || _noOfConnectionsController.text.isEmpty) {
      // Show error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all LTM Service fields')),
      );
    } else {
      // Proceed with submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('LTM Service application submitted')),
      );
      // Save to Firestore or any backend
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Service Application'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LT Service Option
            const Text(
              'LT Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Are there any service connections existing in the same premises with the same name and address?',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'yes',
                  groupValue: _ltRadioValue,
                  onChanged: (value) {
                    setState(() {
                      _ltRadioValue = value;
                    });
                  },
                ),
                const Text('Yes'),
                Radio<String>(
                  value: 'no',
                  groupValue: _ltRadioValue,
                  onChanged: (value) {
                    setState(() {
                      _ltRadioValue = value;
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            const SizedBox(height: 10),
            // Adjacent USC number text field
            if (_ltRadioValue == 'yes')
              TextField(
                decoration: InputDecoration(
                  labelText: 'Adjacent USC Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _adjacentUSCNumber = value;
                  });
                },
              ),
            const SizedBox(height: 10),
            // District dropdown
            DropdownButton<String>(
              value: _ltServiceDistrict,
              hint: const Text('Select District'),
              isExpanded: true,
              items: districts.map((district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _ltServiceDistrict = value;
                });
              },
            ),
            const SizedBox(height: 10),
            // Section dropdown
            DropdownButton<String>(
              value: _ltServiceSection,
              hint: const Text('Select Section'),
              isExpanded: true,
              items: sections.map((section) {
                return DropdownMenuItem<String>(
                  value: section,
                  child: Text(section),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _ltServiceSection = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // LTM Service Option
            const Text(
              'LTM Service',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Are there any service connections existing in the same premises with the same name and address?',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'yes',
                  groupValue: _ltmRadioValue,
                  onChanged: (value) {
                    setState(() {
                      _ltmRadioValue = value;
                    });
                  },
                ),
                const Text('Yes'),
                Radio<String>(
                  value: 'no',
                  groupValue: _ltmRadioValue,
                  onChanged: (value) {
                    setState(() {
                      _ltmRadioValue = value;
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            const SizedBox(height: 10),
            // No. of Existing Service Connections text field
            if (_ltmRadioValue == 'yes')
              TextField(
                controller: _noOfConnectionsController,
                decoration: InputDecoration(
                  labelText: 'No. of Existing Service Connections',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_ltRadioValue == 'yes') {
                  _submitLTService();
                } else if (_ltmRadioValue == 'yes') {
                  _submitLTMService();
                }
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.inversePrimary),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
