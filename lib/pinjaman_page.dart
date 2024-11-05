import 'package:flutter/material.dart';

enum LoanStatus { dipinjam, kembali }

class PinjamanPage extends StatefulWidget {
  const PinjamanPage({super.key});

  @override
  _PinjamanPageState createState() => _PinjamanPageState();
}

class _PinjamanPageState extends State<PinjamanPage> {
  final List<Map<String, dynamic>> _loans = []; // List to hold loan items
  final TextEditingController _idPinjamanController = TextEditingController();
  final TextEditingController _idMemberController = TextEditingController();
  final TextEditingController _idPustakawanController = TextEditingController();
  final TextEditingController _kodeBukuController = TextEditingController();
  DateTime? _tglPinjam; // Changed to DateTime
  DateTime? _tglKembali; // Changed to DateTime
  LoanStatus? _status; // Variable to hold loan status

  void _addLoan() {
    setState(() {
      _loans.add({
        'id_pinjaman': _idPinjamanController.text,
        'id_member': _idMemberController.text,
        'id_pustakawan': _idPustakawanController.text,
        'kode_buku': _kodeBukuController.text,
        'tgl_pinjam': _tglPinjam,
        'tgl_kembali': _tglKembali,
        'status': _status?.name,
      });
      _clearFields(); // Clear fields after adding
    });
  }

  void _clearFields() {
    _idPinjamanController.clear();
    _idMemberController.clear();
    _idPustakawanController.clear();
    _kodeBukuController.clear();
    _tglPinjam = null; // Reset date
    _tglKembali = null; // Reset date
    _status = null; // Reset status
  }

  void _deleteLoan(int index) {
    setState(() {
      _loans.removeAt(index);
    });
  }

  Future<void> _showDialog({Map<String, dynamic>? loan, int? index}) async {
    if (loan != null) {
      _idPinjamanController.text = loan['id_pinjaman'];
      _idMemberController.text = loan['id_member'];
      _idPustakawanController.text = loan['id_pustakawan'];
      _kodeBukuController.text = loan['kode_buku'];
      _tglPinjam = loan['tgl_pinjam'];
      _tglKembali = loan['tgl_kembali'];
      _status = loan['status'] == LoanStatus.dipinjam.name ? LoanStatus.dipinjam : LoanStatus.kembali;
    } else {
      _clearFields(); // Clear fields for new loan
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? "Add Loan" : "Edit Loan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _idPinjamanController,
                decoration: const InputDecoration(labelText: "ID Pinjaman"),
              ),
              TextField(
                controller: _idMemberController,
                decoration: const InputDecoration(labelText: "ID Member"),
              ),
              TextField(
                controller: _idPustakawanController,
                decoration: const InputDecoration(labelText: "ID Pustakawan"),
              ),
              TextField(
                controller: _kodeBukuController,
                decoration: const InputDecoration(labelText: "Kode Buku"),
              ),
              GestureDetector(
                onTap: () => _selectDate(context, true), // for tgl_pinjam
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                      text: _tglPinjam != null ? "${_tglPinjam!.day}/${_tglPinjam!.month}/${_tglPinjam!.year}" : '',
                    ),
                    decoration: const InputDecoration(labelText: "Tanggal Pinjam"),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context, false), // for tgl_kembali
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                      text: _tglKembali != null ? "${_tglKembali!.day}/${_tglKembali!.month}/${_tglKembali!.year}" : '',
                    ),
                    decoration: const InputDecoration(labelText: "Tanggal Kembali"),
                  ),
                ),
              ),
              DropdownButton<LoanStatus>(
                value: _status,
                hint: const Text('Select Status'),
                items: LoanStatus.values.map((LoanStatus status) {
                  return DropdownMenuItem<LoanStatus>(
                    value: status,
                    child: Text(status.name),
                  );
                }).toList(),
                onChanged: (LoanStatus? newValue) {
                  setState(() {
                    _status = newValue;
                  });
                },
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
                  _addLoan();
                } else {
                  _editLoan(index); // You can implement edit functionality
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

  Future<void> _selectDate(BuildContext context, bool isPinjam) async {
    DateTime initialDate = DateTime.now();
    if (isPinjam && _tglPinjam != null) {
      initialDate = _tglPinjam!;
    } else if (!isPinjam && _tglKembali != null) {
      initialDate = _tglKembali!;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        if (isPinjam) {
          _tglPinjam = picked;
        } else {
          _tglKembali = picked;
        }
      });
    }
  }

  void _editLoan(int index) {
    // Function to handle loan editing
    // This can be implemented as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loans"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: _loans.length,
        itemBuilder: (context, index) {
          final loan = _loans[index];
          return ListTile(
            title: Text('ID Pinjaman: ${loan['id_pinjaman']}'),
            subtitle: Text('Kode Buku: ${loan['kode_buku']}, Status: ${loan['status']}, Tgl Pinjam: ${loan['tgl_pinjam']?.day}/${loan['tgl_pinjam']?.month}/${loan['tgl_pinjam']?.year}, Tgl Kembali: ${loan['tgl_kembali']?.day}/${loan['tgl_kembali']?.month}/${loan['tgl_kembali']?.year}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteLoan(index),
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
