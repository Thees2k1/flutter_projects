import 'package:flutter/material.dart';

class DrawerSheet extends StatefulWidget {
  const DrawerSheet({super.key});
  @override
  State<DrawerSheet> createState() => _DrawerSheetState();
}

class _DrawerSheetState extends State<DrawerSheet> {
  Map<String, bool?> checkboxes = {};

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Text('Filters'),
          ),
          CheckboxListTile(
            title: Text('Brand1'),
            value: checkboxes['New'] ?? false,
            onChanged: (value) => setState(() => checkboxes['New'] = value),
          ),
        ],
      ),
    );
  }
}
