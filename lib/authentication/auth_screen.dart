import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.cyan),
          ),
          title: const Text(
            'KatDeli',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontFamily: 'Bea',
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(
                text: 'Đăng nhập',
              ),
              Tab(
                text: 'Đăng kí',
              ),
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 8,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: const TabBarView(children: [
            LoginScreen(),
            RegisterScreen(),
          ]),
        ),
      ),
    );
  }
}
