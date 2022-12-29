// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sqlite/model/user.dart';
import 'package:flutter_sqlite/pages/user/login.dart';
import 'package:flutter_sqlite/pages/user/profile.dart';
import 'package:flutter_sqlite/theme.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:localstorage/localstorage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  AppUpdateInfo? _updateInfo;
  final LocalStorage storage = LocalStorage('users');
  UserModel? user;

  @override
  void initState() {
    super.initState();
    cekLogin();
  }

  cekLogin() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      var test2 = storage.getItem('user');
      print("test2 ${test2}");

      if (test2 != null) {
        print("user sudah login ada");

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Profile(),
          ),
          (route) => false,
        );
      } else {
        print("user belum login");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      print("error cek login $e");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Aplikasi Data Admin',
              style: blueTextStyle.copyWith(
                fontSize: 30,
                fontWeight: semiBold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
