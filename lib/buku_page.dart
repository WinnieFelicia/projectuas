import 'package:flutter/material.dart';

class BukuPage extends StatefulWidget {
  const BukuPage({super.key});

  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  final List<Map<String, String>> _books = []; // List to hold book items
  final TextEditingController _kodeBukuController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _penulisController = TextEditingController();
  final TextEditingController _penerbitController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  Future<void> _showDialog({Map<String, String>? book, int? index}) async {
    if (book != null) {
      _kodeBukuController.text = book['kode']!;
      _judulController.text = book['judul']!;
      _penulisController.text = book['penulis']!;
      _penerbitController.text = book['penerbit']!;
      _tahunController.text = book['tahun']!;
      _stokController.text = book['stok']!;
    } else {
      _clearFields(); // Clear fields for new book
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? "Add Book" : "Edit Book"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _kodeBukuController,
                decoration: const InputDecoration(labelText: "Kode Buku"),
              ),
              TextField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: "Judul"),
              ),
              TextField(
                controller: _penulisController,
                decoration: const InputDecoration(labelText: "Penulis"),
              ),
              TextField(
                controller: _penerbitController,
                decoration: const InputDecoration(labelText: "Penerbit"),
              ),
              TextField(
                controller: _tahunController,
                decoration: const InputDecoration(labelText: "Tahun"),
              ),
              TextField(
                controller: _stokController,
                decoration: const InputDecoration(labelText: "Stok"),
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
                  _addBook();
                } else {
                  _editBook(index);
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

  void _addBook() {
    setState(() {
      _books.add({
        'kode': _kodeBukuController.text,
        'judul': _judulController.text,
        'penulis': _penulisController.text,
        'penerbit': _penerbitController.text,
        'tahun': _tahunController.text,
        'stok': _stokController.text,
      });
      _clearFields(); // Clear fields after adding
    });
  }

  void _editBook(int index) {
    setState(() {
      _books[index] = {
        'kode': _kodeBukuController.text,
        'judul': _judulController.text,
        'penulis': _penulisController.text,
        'penerbit': _penerbitController.text,
        'tahun': _tahunController.text,
        'stok': _stokController.text,
      };
      _clearFields(); // Clear fields after editing
    });
  }

  void _clearFields() {
    _kodeBukuController.clear();
    _judulController.clear();
    _penulisController.clear();
    _penerbitController.clear();
    _tahunController.clear();
    _stokController.clear();
  }

  void _deleteBook(int index) {
    setState(() {
      _books.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Books"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return ListTile(
            title: Text(book['judul']!),
            subtitle: Text(
              'Kode: ${book['kode']}, Penulis: ${book['penulis']}, Penerbit: ${book['penerbit']}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showDialog(book: book, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteBook(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
