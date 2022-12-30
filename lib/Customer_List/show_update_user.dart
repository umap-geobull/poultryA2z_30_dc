import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:poultry_a2z/Customer_List/CustomerList_Model.dart';

typedef OnSaveCallback = void Function(Color color);

class ShowStatus extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  GetCustomerLists customer;

  ShowStatus(this.onSaveCallback,this.customer);

  @override
  _ShowStatus createState() => _ShowStatus();
}

class _ShowStatus extends State<ShowStatus> {

  PaletteType _paletteType = PaletteType.hsl;
  bool _enableAlpha = true;
  bool _displayThumbColor = true;
  final List<ColorLabelType> _labelTypes = [ColorLabelType.hsl, ColorLabelType.hsv];
  bool _displayHexInputBar = true;
  Color pickerColor = const Color(0xff443a49);
  List<Color> colorHistory = [];


  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                  colorPickerWidth: 200,
                  hexInputBar: true,
                  pickerAreaHeightPercent: 0.7,
                  enableAlpha: _enableAlpha,
                  labelTypes: _labelTypes,
                  displayThumbColor: _displayThumbColor,
                  paletteType: _paletteType,
                  pickerAreaBorderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                  ),
                  colorHistory: colorHistory,
                  onHistoryChanged: (List<Color> colors) => colorHistory = colors,
                )
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Got it'),
                onPressed: () {
                  widget.onSaveCallback(pickerColor) ;
                },
              ),
            ],
          );
        }
    );

  }

  onBackPressed() {
    Navigator.of(context).pop();
  }
}

