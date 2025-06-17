import 'package:flutter/material.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/Logo_White.png",
            height: 10,
            width: 10,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          "Selamat Datang Admin",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(89, 255, 0, 1),
        elevation: 4,
      ),
    );
  }
}
