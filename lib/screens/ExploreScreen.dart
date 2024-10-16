import 'package:flutter/material.dart';

class Explore{

}

class Explorescreen extends StatefulWidget {
  const Explorescreen({super.key});

  @override
  State<Explorescreen> createState() => _ExplorescreenState();
}

class _ExplorescreenState extends State<Explorescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore',
      style: TextStyle(color: Colors.white,
      fontSize: 18),
      ),
      backgroundColor: const Color(0xFF2B2B2B),
       iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      
    );
  }
}