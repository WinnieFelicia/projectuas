import 'package:flutter/material.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final List<Map<String, String>> _members = []; // List to hold member items
  final TextEditingController _idMemberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _addMember() {
    setState(() {
      _members.add({
        'id_member': _idMemberController.text,
        'nama': _nameController.text,
        'alamat': _addressController.text,
        'email': _emailController.text,
        'no_hp': _phoneController.text,
      });
      _clearFields();
    });
  }

  void _clearFields() {
    _idMemberController.clear();
    _nameController.clear();
    _addressController.clear();
    _emailController.clear();
    _phoneController.clear();
  }

  void _deleteMember(int index) {
    setState(() {
      _members.removeAt(index);
    });
  }

  Future<void> _showDialog({Map<String, String>? member, int? index}) async {
    if (member != null) {
      _idMemberController.text = member['id_member']!;
      _nameController.text = member['nama']!;
      _addressController.text = member['alamat']!;
      _emailController.text = member['email']!;
      _phoneController.text = member['no_hp']!;
    } else {
      _clearFields(); 
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? "Add Member" : "Edit Member"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _idMemberController,
                decoration: const InputDecoration(labelText: "ID Member"),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama"),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Alamat"),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "No HP"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (index == null) {
                  _addMember();
                } else {
                  _editMember(index); // You can implement edit functionality
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _editMember(int index) {
    setState(() {
      _members[index] = {
        'id_member': _idMemberController.text,
        'nama': _nameController.text,
        'alamat': _addressController.text,
        'email': _emailController.text,
        'no_hp': _phoneController.text,
      };
      _clearFields(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          return ListTile(
            title: Text(member['nama']!),
            subtitle: Text(
                'ID: ${member['id_member']}, Email: ${member['email']}, No HP: ${member['no_hp']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showDialog(member: member, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteMember(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
