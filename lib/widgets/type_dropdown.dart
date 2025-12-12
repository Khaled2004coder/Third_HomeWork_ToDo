// lib/widgets/type_dropdown.dart
import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class TypeDropdown extends StatefulWidget {
  final int? initialTypeId;
  final void Function(int?) onChanged;
  const TypeDropdown({this.initialTypeId, required this.onChanged, Key? key})
    : super(key: key);

  @override
  State<TypeDropdown> createState() => _TypeDropdownState();
}

class _TypeDropdownState extends State<TypeDropdown> {
  List<Map<String, dynamic>> types = [];
  int? selectedId;

  @override
  void initState() {
    super.initState();
    selectedId = widget.initialTypeId;
    _loadTypes();
  }

  Future _loadTypes() async {
    final rows = await DBHelper.instance.getAllTypes();
    // Keep only types that do not contain Arabic characters (show English only)
    final engOnly = rows.where((t) {
      final name = (t['name'] ?? '') as String;
      return !RegExp(r'[\u0600-\u06FF]').hasMatch(name);
    }).toList();
    setState(() => types = engOnly);
  }

  Future _showAddTypeDialog() async {
    final controller = TextEditingController();
    final res = await showDialog<String?>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Add new type'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Type name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (res != null && res.isNotEmpty) {
      await DBHelper.instance.insertType(res);
      await _loadTypes();
      final added = types.firstWhere((t) => t['name'] == res, orElse: () => {});
      if (added.isNotEmpty) {
        setState(() {
          selectedId = added['id'] as int?;
          widget.onChanged(selectedId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: selectedId,
            decoration: const InputDecoration(labelText: 'Type of task'),
            items: types.map((t) {
              return DropdownMenuItem<int>(
                value: t['id'] as int,
                child: Text(t['name'] as String),
              );
            }).toList(),
            onChanged: (v) {
              setState(() => selectedId = v);
              widget.onChanged(v);
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Add a new type',
          onPressed: _showAddTypeDialog,
        ),
      ],
    );
  }
}
