// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sqlite/db_test.dart';
import 'package:flutter_sqlite/model/user.dart';
import 'package:flutter_sqlite/pages/user/profile.dart';
import 'package:flutter_sqlite/theme.dart';
import 'package:flutter_sqlite/widgets/ButtonWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

class UpdateProfile extends StatefulWidget {
  UserModel? user;
  UpdateProfile({
    super.key,
    required this.user,
  });

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile>
    with InputValidationMixin {
  final _formKey = GlobalKey<FormState>();
  var items = ['Laki - laki', 'Perempuan'];
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

  File? imageFile;
  final LocalStorage storage = LocalStorage('users');
  String filePath = "";
  TextEditingController namaDepan = TextEditingController();
  TextEditingController namaBelakang = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController tanggalLahir = TextEditingController();
  String jenisKelamin = "";
  TextEditingController foto = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      namaDepan.text = widget.user?.nama_depan ?? "";
      namaBelakang.text = widget.user?.nama_belakang ?? "";
      email.text = widget.user?.email ?? "";
      password.text = widget.user?.password ?? "";
      tanggalLahir.text = widget.user?.tanggal_lahir ?? "";
      jenisKelamin = widget.user?.jenis_kelamin ?? "";
      foto.text = widget.user?.foto ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Update Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
              horizontal: paddingLa,
              vertical: paddingLa,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                        validator: (value) {
                          if (isNameValid(value.toString())) {
                            return 'Nama depan tidak boleh kosong';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        controller: namaDepan,
                        cursorColor: primaryColor,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Nama Depan',
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
                        validator: (value) {
                          if (isNameValid(value.toString())) {
                            return 'Nama belakang tidak boleh kosong';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        controller: namaBelakang,
                        cursorColor: primaryColor,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Nama Belakang',
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
                        validator: (value) {
                          if (isNameValid(value.toString())) {
                            return 'Tanggal lahir tidak boleh kosong';
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
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
                              readOnly: true,
                              validator: (value) {
                                if (isNameValid(value.toString())) {
                                  return 'Tanggal lahir tidak boleh kosong';
                                }
                              },
                              keyboardType: TextInputType.text,
                              controller: tanggalLahir,
                              cursorColor: primaryColor,
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Tanggal Lahir',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: spaceWidth,
                      ),
                      buttonTanggal(context, true),
                    ],
                  ),
                  const SizedBox(
                    height: spaceHeight,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: inputFieldColor,
                    ),
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),

                      hint: const Text(
                        "Jenis Kelamin",
                      ),
                      // Initial Value
                      value: jenisKelamin,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      validator: (value) => value == null
                          ? 'Jenis kelamin tidak boleh kosong'
                          : null,
                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),

                      onChanged: (String? newValue) {
                        print("pilih $newValue");

                        setState(() {
                          jenisKelamin = newValue!;
                        });
                      },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: primaryColor,
                        minRadius: 60.0,
                        child: foto.text != ""
                            ? CircleAvatar(
                                radius: 50.0,
                                backgroundImage: FileImage(
                                  File(foto.text),
                                ),
                              )
                            : const CircleAvatar(
                                radius: 50.0,
                                backgroundImage: AssetImage(
                                  "assets/images/user.png",
                                ),
                              ),
                      ),
                      const SizedBox(
                        width: spaceWidth,
                      ),
                      buttonFile(context),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: ButtonWidget(
                            textButton: "SAVE",
                            onTap: () async {
                              print("SAVE");
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              var user = UserModel(
                                id: 0,
                                nama_depan: namaDepan.text,
                                nama_belakang: namaBelakang.text,
                                email: email.text,
                                jenis_kelamin: jenisKelamin,
                                tanggal_lahir: tanggalLahir.text,
                                password: password.text,
                                foto: foto.text,
                              );
                              var hasil = await SQLHelper.updateUser(user);
                              print("hasil ${hasil}");
                              var test = jsonEncode(user);
                              print("test ${test}");
                              await storage.setItem('user', test);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile(),
                                ),
                                (route) => false,
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
                            textButton: "CANCEL",
                            onTap: () async {
                              print("CANCEL");
                              Navigator.pop(context);
                            },
                            backgroundColor: redColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonTanggal(
    BuildContext context,
    bool dari,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: primaryColor,
      ),
      height: 45,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: InkWell(
        onTap: () async {
          var date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2002),
            lastDate: DateTime(2025),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: primaryColor, // header background color
                    onPrimary: whiteColor, // header text color
                    onSurface: blackColor, // body text color
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor, // button text color
                    ),
                  ),
                ),
                child: child ?? const SizedBox(),
              );
            },
          );

          if (date != null) {
            setState(() {
              tanggalLahir.text = DateFormat('yyyy-MM-dd').format(date);
            });
          }
        },
        child: Center(
          child: Text(
            'PILIH',
            style: whiteTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
        ),
      ),
    );
  }

  pilihFile(String path) {
    filePath = path;

    print("filepath $filePath");
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        foto.text = pickedFile.path.toString();
      });

      print("image ${foto.text}");
    }
  }

  Widget buttonFile(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryColor,
        ),
        height: 45,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: InkWell(
          onTap: () async {
            await _getFromGallery();
          },
          child: Center(
            child: Text(
              'PILIH',
              style: whiteTextStyle.copyWith(
                fontWeight: medium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

mixin InputValidationMixin {
  bool isPasswordValid(String password) => password.length == 8;
  bool isNameValid(String name) => name.isEmpty || name == null;
  bool isEmailValid(String email) {
    Pattern pattern = r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }
}
