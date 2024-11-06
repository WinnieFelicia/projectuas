import 'package:flutter/material.dart';

class PustakawanPage extends StatefulWidget {
  const PustakawanPage({super.key});

  @override
  _PustakawanPageState createState() => _PustakawanPageState();
}

class _PustakawanPageState extends State<PustakawanPage> {
  final List<Map<String, String>> _librarians = [];
  final TextEditingController _idLibrarianController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _addLibrarian() {
    setState(() {
      _librarians.add({
        'id_pustakawan': _idLibrarianController.text,
        'nama': _nameController.text,
        'alamat': _addressController.text,
        'email': _emailController.text,
        'no_hp': _phoneController.text,
      });
      _clearFields();
    });
  }

  void _clearFields() {
    _idLibrarianController.clear();
    _nameController.clear();
    _addressController.clear();
    _emailController.clear();
    _phoneController.clear();
  }

  void _deleteLibrarian(int index) {
    setState(() {
      _librarians.removeAt(index);
    });
  }

  Future<void> _showDialog({Map<String, String>? librarian, int? index}) async {
    if (librarian != null) {
      _idLibrarianController.text = librarian['id_pustakawan']!;
      _nameController.text = librarian['nama']!;
      _addressController.text = librarian['alamat']!;
      _emailController.text = librarian['email']!;
      _phoneController.text = librarian['no_hp']!;
    } else {
      _clearFields();
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? "Add Librarian" : "Edit Librarian"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _idLibrarianController,
                decoration: const InputDecoration(labelText: "ID Pustakawan"),
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
                  _addLibrarian();
                } else {
                  _editLibrarian(index);
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

  void _editLibrarian(int index) {
    setState(() {
      _librarians[index] = {
        'id_pustakawan': _idLibrarianController.text,
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
        title: const Text("Librarians"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: _librarians.length,
        itemBuilder: (context, index) {
          final librarian = _librarians[index];
          return ListTile(
            title: Text(librarian['nama']!),
            subtitle: Text(
                'ID: ${librarian['id_pustakawan']}, Email: ${librarian['email']}, No HP: ${librarian['no_hp']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      _showDialog(librarian: librarian, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteLibrarian(index),
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
