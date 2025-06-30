
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownBtn extends StatefulWidget {
  final List<String> items;
  final String selectedItemText;
  final String? selectedValue;
  final Function(String?) onSelected;

  const DropdownBtn({
    Key? key,
    required this.items,
    required this.selectedItemText,
    required this.onSelected,
    required this.selectedValue,
  }) : super(key: key);

  @override
  State<DropdownBtn> createState() => _DropdownBtnState();
}

class _DropdownBtnState extends State<DropdownBtn> {
  String? _selectedValue;

  @override
  void didUpdateWidget(covariant DropdownBtn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.contains(widget.selectedValue)) {
      _selectedValue = widget.selectedValue;
    } else {
      _selectedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
        final displayText = (_selectedValue == null && widget.selectedValue != null)
        ? widget.selectedValue!
        : (_selectedValue ?? widget.selectedItemText);

    return Card(
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
             'Sort Item',// displayText,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),

            value: widget.items.contains(_selectedValue) ? _selectedValue : null,
            items: widget.items
                .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            ))
                .toList(),
            // Only bind to a real item; else show null (so hint is used)
            onChanged: (value) {
              setState(() => _selectedValue = value);
              widget.onSelected(value);
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              width: 140,
            ),
            menuItemStyleData: const MenuItemStyleData(height: 40),
          ),
        ),
      ),
    );
  }
}






/*
String? selectedValue;
class DropdownBtn extends StatelessWidget {
  final List<String>items;
  final String selectedItemText;
  final Function(String?) onSelected;
  const DropdownBtn({super.key, required this.items, required this.selectedItemText, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return  Card(
      child:   Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              selectedItemText,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items:items
                .map((String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedValue,
            onChanged: (String? value) {
            onSelected(value);
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              width: 140,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
          ),
        ),
      ),
    );


  }
}
*/
