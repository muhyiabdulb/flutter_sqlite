import 'package:flutter/material.dart';
import 'package:flutter_sqlite/db_test.dart';
import 'package:flutter_sqlite/model/user.dart';
import 'package:flutter_sqlite/pages/user/splash.dart';

void main() async {
  runApp(MyApp());
  var user = UserModel(
      id: 0,
      nama_depan: "Muhyi",
      nama_belakang: "Abdul Basith",
      email: "muhyiabdulbasith660@gmail.com",
      jenis_kelamin: "Laki - laki",
      tanggal_lahir: "2002-03-11",
      password: "12345678",
      foto: "");
  var hasil = await SQLHelper.createUser(user);
  print("hasil ${hasil}");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localstorage Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
