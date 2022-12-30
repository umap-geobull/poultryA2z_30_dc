import 'package:flutter/material.dart';

class Select_Payment_Option extends StatefulWidget {
  const Select_Payment_Option({Key? key}) : super(key: key);

  @override
  _Select_Payment_OptionState createState() => _Select_Payment_OptionState();
}

class _Select_Payment_OptionState extends State<Select_Payment_Option> {
  String _selectedGender = 'COD';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Select Payment Option",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),

            ListTile(
              leading: Radio<String>(
                value: 'COD',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              title: Align(
                alignment: const Alignment(-2, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Full Cash On Delivery",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    const Text(
                      "Remaining COD Limit",
                      style: TextStyle(fontSize: 10, color: Colors.orange),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,

                            borderRadius: const BorderRadius.all(Radius.circular(20),
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Wrap(
                            children: const [
                              Text(
                                "Rs.35000 out of Rs.35000",
                                style:
                                    TextStyle(fontSize: 10, color: Colors.orange),
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              Icon(
                                Icons.info,
                                size: 16,
                                color: Colors.orange,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Radio<String>(
                value: 'Semi_COD',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              title:  const Align(
                  alignment: Alignment(-1.4, 0),
                  child: Text('20% Advance | 80% COD')),
            ),
            ListTile(
              leading: Radio<String>(
                value: 'ONLINE',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              title: Align(
                alignment: const Alignment(-1.2, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "100% Advance",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "5% Extra Discount",
                      style: TextStyle(fontSize: 10, color: Colors.orange),
                    ),
                    SizedBox(
                      height: 3,
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
