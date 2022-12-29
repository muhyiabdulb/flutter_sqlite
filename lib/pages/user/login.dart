// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sqlite/db_test.dart';
import 'package:flutter_sqlite/model/user.dart';
import 'package:flutter_sqlite/pages/user/profile.dart';
import 'package:flutter_sqlite/theme.dart';
import 'package:flutter_sqlite/widgets/DialogWidget.dart';
import 'package:localstorage/localstorage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with InputValidationMixin {
  bool _obscureText = true;
  String eye = "Lihat Password";
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText) {
        eye = "Lihat Password";
      } else {
        eye = "Sembunyikan Password";
      }
    });
  }

  final _formKey = GlobalKey<FormState>();

  bool isloading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  UserModel? user;
  // INIT LOCALSTORAGE
  final LocalStorage storage = LocalStorage('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingLa,
            vertical: paddingLa,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Silahkan masukkan email dan password Anda',
                  style: blueTextStyle.copyWith(
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: spaceHeight,
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: inputFieldColor,
                  ),
                  child: Center(
                    child: TextFormField(
                      validator: (email) {
                        if (isEmailValid(email.toString())) {
                          return null;
                        } else {
                          return 'Enter a valid email address';
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      cursorColor: primaryColor,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: spaceHeight,
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: inputFieldColor,
                  ),
                  child: Center(
                    child: TextFormField(
                      obscureText: _obscureText,
                      keyboardType: TextInputType.visiblePassword,
                      controller: password,
                      validator: (password) {
                        if (isPasswordValid(password.toString())) {
                          return null;
                        } else {
                          return 'Enter a valid password and 8 digit';
                        }
                      },
                      cursorColor: primaryColor,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: _toggle,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, right: 10),
                    child: Text(
                      eye,
                      style: blueTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: spaceHeight,
                ),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      print("login");
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      try {
                        print("email ${email.text}");
                        print("email muhyiabdulbasith660@gmail.com");
                        print("password ${password.text}");
                        print("password 12345678");
                        var data = await SQLHelper.getLogin(
                          email.text,
                          password.text,
                        );

                        print("data 0 ${data}");
                        if (data == null) {
                          print("user ga ada");
                          DialogWidget.getInfoDialog(
                            context,
                            "User tidak ditemukan",
                          );
                        } else {
                          print("data 1 ${data.email}");
                          var test = jsonEncode(data);
                          print("test ${test}");

                          // INI SET DATA USER SIMPAN KE LOCALSTORAGE
                          storage.setItem('user', test);
                          var test2 = storage.getItem('user');
                          print("test2 ${test2.runtimeType}");
                          var user12 = jsonDecode(test2);
                          print("user12 ${user12.runtimeType}");
                          UserModel user = UserModel.fromJson(user12);
                          print("user ${user.email}");

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Profile(),
                            ),
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        print("error guyss $e");
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "LOGIN",
                      style: whiteTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

mixin InputValidationMixin {
  bool isPasswordValid(String password) => password.length == 8;

  bool isEmailValid(String email) {
    Pattern pattern = r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }
}
