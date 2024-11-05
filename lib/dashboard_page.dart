import 'package:flutter/material.dart';
import 'buku_page.dart';
import 'member_page.dart';
import 'pinjaman_page.dart';
import 'pustakawan_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BukuPage()));
              },
              child: const Text("Buku"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MemberPage()));
              },
              child: const Text("Member"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PinjamanPage()));
              },
              child: const Text("Pinjaman"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PustakawanPage()));
              },
              child: const Text("Pustakawan"),
            ),
          ],
        ),
      ),
    );
  }
}
