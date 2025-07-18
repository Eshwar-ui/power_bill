// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class roofTopSolarpage extends StatefulWidget {
  const roofTopSolarpage({super.key});

  @override
  State<roofTopSolarpage> createState() => _roofTopSolarpageState();
}

class _roofTopSolarpageState extends State<roofTopSolarpage> {
  String? _selectedUSC;
  String _proposedCapacity = '';
  String? _selectedType;
  String? _isGstinAvailable;
  String _gstin = '';
  String _confirmGstin = '';
  String _pincode = '';

  List<String> uscNumbers = []; // To store USC numbers fetched from Firestore

  @override
  void initState() {
    super.initState();
    _fetchUSCNumbers();
  }

  // Fetch USC numbers from Firestore
  Future<void> _fetchUSCNumbers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('customers').get();
    setState(() {
      uscNumbers = snapshot.docs
          .map((doc) => doc.id) // Assuming USC number is document ID
          .toList();
    });
  }

  // Submit function to save the data to Firestore
  Future<void> _submitApplication() async {
    if (_selectedUSC == null ||
        _proposedCapacity.isEmpty ||
        _selectedType == null ||
        _isGstinAvailable == null ||
        (_isGstinAvailable == "Yes" &&
            (_gstin.isEmpty || _gstin != _confirmGstin)) ||
        _pincode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    // Save to Firestore
    await FirebaseFirestore.instance
        .collection('rooftop_solar_applications')
        .add({
      'usc_number': _selectedUSC,
      'proposed_capacity': _proposedCapacity,
      'connection_type': _selectedType,
      'gstin_available': _isGstinAvailable,
      if (_isGstinAvailable == "Yes") 'gstin': _gstin,
      'pincode': _pincode,
      'application_fee': 2500,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application submitted successfully')),
    );

    // Reset form
    setState(() {
      _selectedUSC = null;
      _proposedCapacity = '';
      _selectedType = null;
      _isGstinAvailable = null;
      _gstin = '';
      _confirmGstin = '';
      _pincode = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooftop Solar Application'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
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

              // Details based on USC selection
              if (_selectedUSC != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Proposed Solar Capacity
                    const Text('Proposed Solar Capacity (in kWp)',
                        style: TextStyle(fontSize: 18)),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter capacity...',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _proposedCapacity = value,
                    ),
                    const SizedBox(height: 20),

                    // Connection Type Dropdown
                    const Text('Connection Type',
                        style: TextStyle(fontSize: 18)),
                    DropdownButton<String>(
                      value: _selectedType,
                      hint: const Text('Select Type'),
                      isExpanded: true,
                      items: ['Domestic', 'Commercial'].map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // GSTIN Available Dropdown
                    const Text('Is GSTIN Available?',
                        style: TextStyle(fontSize: 18)),
                    DropdownButton<String>(
                      value: _isGstinAvailable,
                      hint: const Text('Select Option'),
                      isExpanded: true,
                      items: ['Yes', 'No'].map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _isGstinAvailable = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // GSTIN Fields if Available
                    if (_isGstinAvailable == 'Yes') ...[
                      const Text('Enter GSTIN Number',
                          style: TextStyle(fontSize: 18)),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Enter GSTIN...',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _gstin = value,
                      ),
                      const SizedBox(height: 20),
                      const Text('Confirm GSTIN Number',
                          style: TextStyle(fontSize: 18)),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Confirm GSTIN...',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _confirmGstin = value,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Pincode Field
                    const Text('Pincode', style: TextStyle(fontSize: 18)),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter Pincode...',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _pincode = value,
                    ),
                    const SizedBox(height: 30),

                    // Application Fee Container
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Application Fee',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          const Text(
                            '₹2500',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _submitApplication,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ),
                      child: const Text('Submit Application'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
