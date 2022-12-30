import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    alignment: Alignment.center,

    child: ElevatedButton(
        onPressed: onClicked,
        style: ElevatedButton.styleFrom(
          primary: Colors.orange, // background
          // foreground
        ),
        child:  SizedBox(
            width: 350,child: Center(child: Text(text)))),
  );
}
