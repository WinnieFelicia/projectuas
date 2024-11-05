import 'package:flutter/material.dart';
import 'buku_page.dart'; // Import BukuPage
import 'member_page.dart'; // Import MemberPage
import 'pinjaman_page.dart'; // Import PinjamanPage
import 'pustakawan_page.dart'; // Import PustakawanPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0; // To keep track of the selected index
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Create a GlobalKey for Scaffold

  // List of pages for navigation
  final List<Widget> _pages = const [
    BukuPage(),
    MemberPage(),
    PinjamanPage(),
    PustakawanPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
    Navigator.pop(context); // Close the drawer after selecting an item
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
      appBar: AppBar(
        title: const Text('Library Management Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer using the GlobalKey
          },
        ),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Buku'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Member'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Pinjaman'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Pustakawan'),
              onTap: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}
