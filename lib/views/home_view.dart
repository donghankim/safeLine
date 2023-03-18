// home page widgets
import 'package:flutter/material.dart';
import 'package:safe_line/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int navBarIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Safe Line",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthService.firebase().logout();
              if (context.mounted) {
                Navigator.of(context)
                .pushNamedAndRemoveUntil('/login/', (route) => false);
              }
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Text("Home Page!")],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Subway Line")
          ],
          currentIndex: navBarIdx,
          onTap: (int index) {
            setState(() {
              navBarIdx = index;
              // need to update screen here
            });
          }),
    );
  }
}
