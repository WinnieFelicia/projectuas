import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BukuPage extends StatefulWidget {
  const BukuPage({super.key});

  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  final List<Map<String, String>> _books = [];
  final List<Map<String, String>> _filteredBooks = [];
  final TextEditingController _kodeBukuController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _penulisController = TextEditingController();
  final TextEditingController _penerbitController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String _searchCategory = 'Kode';

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? booksData = prefs.getString('books');
    if (booksData != null) {
      List<dynamic> booksList = json.decode(booksData);
      setState(() {
        _books.clear();
        _books.addAll(booksList.map((e) => Map<String, String>.from(e)).toList());
        _filteredBooks.clear();
        _filteredBooks.addAll(_books);
      });
    }
  }

  Future<void> _saveBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('books', json.encode(_books));
  }

  Future<void> _showDialog({Map<String, String>? book, int? index}) async {
    if (book != null) {
      _kodeBukuController.text = book['kode']!;
      _judulController.text = book['judul']!;
      _penulisController.text = book['penulis']!;
      _penerbitController.text = book['penerbit']!;
      _tahunController.text = book['tahun']!;
      _stokController.text = book['stok']!;
    } else {
      _clearFields();
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
      final newBook = {
        'kode': _kodeBukuController.text,
        'judul': _judulController.text,
        'penulis': _penulisController.text,
        'penerbit': _penerbitController.text,
        'tahun': _tahunController.text,
        'stok': _stokController.text,
      };
      _books.add(newBook);
      _filteredBooks.clear();
      _filteredBooks.addAll(_books);
      _saveBooks();
      _clearFields();
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
      _saveBooks();
      _clearFields();
      _filterBooks(_searchController.text);
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
      _saveBooks();
      _filterBooks(_searchController.text);
    });
  }

  void _filterBooks(String keyword) {
    setState(() {
      _filteredBooks.clear();
      if (keyword.isEmpty) {
        _filteredBooks.addAll(_books);
      } else {
        _filteredBooks.addAll(
          _books.where((book) => book[_searchCategory.toLowerCase()]!.toLowerCase().contains(keyword.toLowerCase())),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Books"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterBooks,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _searchCategory,
                  onChanged: (value) {
                    setState(() {
                      _searchCategory = value!;
                      _filterBooks(_searchController.text);
                    });
                  },
                  items: const [
                    DropdownMenuItem(value: 'Kode', child: Text('Kode')),
                    DropdownMenuItem(value: 'Judul', child: Text('Judul')),
                    DropdownMenuItem(value: 'Penulis', child: Text('Penulis')),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(color: Colors.grey, width: 1),
                columns: const [
                  DataColumn(label: Text('Kode')),
                  DataColumn(label: Text('Judul')),
                  DataColumn(label: Text('Penulis')),
                  DataColumn(label: Text('Penerbit')),
                  DataColumn(label: Text('Tahun')),
                  DataColumn(label: Text('Stok')),
                  DataColumn(label: Text('Aksi')),
                ],
                rows: _filteredBooks.map((book) {
                  int index = _books.indexOf(book);
                  return DataRow(cells: [
                    DataCell(Text(book['kode']!)),
                    DataCell(Text(book['judul']!)),
                    DataCell(Text(book['penulis']!)),
                    DataCell(Text(book['penerbit']!)),
                    DataCell(Text(book['tahun']!)),
                    DataCell(Text(book['stok']!)),
                    DataCell(Row(
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
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
