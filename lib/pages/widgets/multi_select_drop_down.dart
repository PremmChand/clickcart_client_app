import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

List<String> selectedItems = [];
class MultiSelectDropDown extends StatelessWidget {
  final List<String> items;
  final Function(List<String>) onSelectionChanged;
  const MultiSelectDropDown({super.key, required this.items, required this.onSelectionChanged});



  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Center(
      child: DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
      isExpanded: true,
      hint: Text(
      'Select Items',
      style: TextStyle(
      fontSize: 14,
      color: Theme.of(context).hintColor,
      ),
      ),
      items: items.map((item) {
      return DropdownMenuItem(
      value: item,
      enabled: false,
      child: StatefulBuilder(
      builder: (context, menuSetState) {
      final isSelected = selectedItems.contains(item);
      return InkWell(
      onTap: () {
      isSelected ? selectedItems.remove(item) : selectedItems.add(item);
      onSelectionChanged(selectedItems);
      menuSetState(() {});
      },
      child: Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
      children: [
      if (isSelected)
      const Icon(Icons.check_box_outlined)
      else
      const Icon(Icons.check_box_outline_blank),
      const SizedBox(width: 16),
      Expanded(
      child: Text(
      item,
      style: const TextStyle(
      fontSize: 14,
      ),
      ),
      ),
      ],
      ),
      ),
      );
      },
      ),
      );
      }).toList(),
      value: selectedItems.isEmpty ? null : selectedItems.last,
      onChanged: (value) {},
      selectedItemBuilder: (context) {
      return items.map(
      (item) {
      return Container(
      alignment: AlignmentDirectional.center,
      child: Text(
      selectedItems.join(', '),
      style: const TextStyle(
      fontSize: 14,
      overflow: TextOverflow.ellipsis,
      ),
      maxLines: 1,
      ),
      );
      },
      ).toList();
      },
      buttonStyleData: const ButtonStyleData(
      padding: EdgeInsets.only(left: 16, right: 8),
      height: 40,
      width: 140,
      ),
      menuItemStyleData: const MenuItemStyleData(
      height: 40,
      padding: EdgeInsets.zero,
      ),
      ),
      ),
      ),
    );
  }
}
