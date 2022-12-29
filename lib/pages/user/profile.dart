// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sqlite/model/user.dart';
import 'package:flutter_sqlite/pages/user/login.dart';
import 'package:flutter_sqlite/pages/user/update_data.dart';
import 'package:flutter_sqlite/theme.dart';
import 'package:flutter_sqlite/widgets/ButtonWidget.dart';
import 'package:localstorage/localstorage.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with InputValidationMixin {
  final LocalStorage storage = LocalStorage('users');
  UserModel? user;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    var test2 = storage.getItem('user');

    print("test2 ${test2}");
    var user12 = jsonDecode(test2);

    user = UserModel.fromJson(user12);
    print("user ${user?.email}");
    setState(() {
      isLoading = false;
    });
  }

  logout() async {
    await storage.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingLa,
            vertical: paddingLa,
          ),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                )
              : ListView(
                  children: <Widget>[
                    Container(
                      height: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            minRadius: 60.0,
                            child: user?.foto != ""
                                ? CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage: FileImage(
                                      File(user!.foto),
                                    ),
                                  )
                                : const CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage:
                                        AssetImage("assets/images/user.png")),
                          ),
                          const SizedBox(
                            height: spaceHeight,
                          ),
                          Text(
                            "${user?.nama_depan} ${user?.nama_belakang}",
                            style: blueTextStyle.copyWith(
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            'Flutter Developer',
                            style: blueTextStyle.copyWith(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'Email',
                              style: blueTextStyle.copyWith(
                                fontSize: 21,
                              ),
                            ),
                            subtitle: Text(
                              user?.email ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: Text(
                              'Jenis Kelamin',
                              style: blueTextStyle.copyWith(
                                fontSize: 21,
                              ),
                            ),
                            subtitle: Text(
                              user?.jenis_kelamin ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: Text(
                              'Tanggal Lahir',
                              style: blueTextStyle.copyWith(
                                fontSize: 21,
                              ),
                            ),
                            subtitle: Text(
                              user?.tanggal_lahir ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: ButtonWidget(
                                    textButton: "UPDATE PROFILE",
                                    onTap: () {
                                      print("ubah data");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateProfile(
                                            user: user,
                                          ),
                                        ),
                                      );
                                    },
                                    backgroundColor: primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: spaceWidth,
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: ButtonWidget(
                                    textButton: "LOGOUT",
                                    onTap: () async {
                                      print("Logout");
                                      var result =
                                          await showOkCancelAlertDialog(
                                        // style: AdaptiveStyle.iOS,
                                        context: context,
                                        isDestructiveAction: true,
                                        title: Platform.isIOS ? "Logout" : null,
                                        message: "Apakah anda yakin logout ?",
                                      );

                                      if (result == OkCancelResult.cancel) {
                                        print("cancel");

                                        return;
                                      }
                                      // LOGOUT
                                      print("ya");

                                      await logout();
                                    },
                                    backgroundColor: redColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
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
