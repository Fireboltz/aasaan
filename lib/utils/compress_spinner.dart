import 'package:flutter/material.dart';

class CompressSpinner extends StatefulWidget {
  @override
  _CompressSpinnerState createState() => _CompressSpinnerState();
  static String _dropVal = '<100KB';
}

class _CompressSpinnerState extends State<CompressSpinner> {
  var treesList = ['<500KB', '<1MB', '<3MB', '<5MB'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DropdownButton<String>(
        value: CompressSpinner._dropVal,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        underline: Container(
          height: 1,
          color: Colors.grey,
        ),
        onChanged: (String newValue) {
          setState(() {
            CompressSpinner._dropVal = newValue;
          });
        },
        items: treesList
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
