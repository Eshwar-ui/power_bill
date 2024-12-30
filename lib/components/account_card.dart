// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class AccountCard extends StatefulWidget {
  const AccountCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  Map<String, dynamic>? _data;

  // Function to fetch data based on USC (id)
  Future<void> fetchDataByUSC(String usc) async {
    if (usc.isEmpty) {
      // If no USC is provided, do nothing
      return;
    }
  }

  // Function to show the dialog to enter USC
  void _showUSCDialog() {
    final TextEditingController uscController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter USC'),
          content: TextField(
            autofocus: true,
            controller: uscController,
            decoration: InputDecoration(
              focusColor: Theme.of(context).colorScheme.inversePrimary,
              enabled: true,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary)),
              labelText: 'USC',
              floatingLabelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary)),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
            TextButton(
              onPressed: () {
                final usc = uscController.text.trim();
                if (usc.isNotEmpty) {
                  fetchDataByUSC(usc);
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'Submit',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          // Show the empty card with the plus sign if no data is fetched
          if (_data == null)
            GestureDetector(
              onTap: _showUSCDialog, // Show dialog when clicked
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  // image: const DecorationImage(
                  //   image: AssetImage("lib/assets/images/meter bg.jpg"),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                height: 200,
                width: 350,
                child: Container(
                  height: 200,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      tileMode: TileMode.clamp,
                      stops: const [0.0, 0.99999],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xff423BA4).withOpacity(0.7),
                        Colors.black..withOpacity(0.7)
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      decoration: ShapeDecoration(
                          shape: const CircleBorder(),
                          color: Theme.of(context).colorScheme.secondary),
                      child: Icon(
                        Icons.add,
                        size: 60,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ),
              ),
            )
          // Show the custom card with fetched data when available
          else
            GestureDetector(
              onTap: _showUSCDialog, // Show dialog when clicked (optional)
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                        image: AssetImage("lib/assets/images/meter bg.jpg"),
                        fit: BoxFit.cover)),
                child: Container(
                  height: 200,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      tileMode: TileMode.clamp,
                      stops: const [0.0, 0.99999],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xff423BA4).withOpacity(0.7),
                        Colors.black..withOpacity(0.7)
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'uscno: ${_data!['usc']}',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          Text('units: ${_data!['units']}',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white)),
                          Text('date: ${_data!['date']}',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('amount: \$${_data!['amount']}',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
