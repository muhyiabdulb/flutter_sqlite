class UserModel {
  late int id;
  late String nama_depan;
  late String nama_belakang;
  late String email;
  late String tanggal_lahir;
  late String jenis_kelamin;
  late String password;
  late String foto;

  UserModel({
    required this.id,
    required this.nama_depan,
    required this.nama_belakang,
    required this.email,
    required this.tanggal_lahir,
    required this.jenis_kelamin,
    required this.password,
    required this.foto,
  });

  UserModel.fromMap(Map<String, Object?> first);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama_depan'] = nama_depan;
    data['nama_belakang'] = nama_belakang;
    data['email'] = email;
    data['tanggal_lahir'] = tanggal_lahir;
    data['jenis_kelamin'] = jenis_kelamin;
    data['password'] = password;
    data['foto'] = foto;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_depan': nama_depan,
      'nama_belakang': nama_belakang,
      'email': email,
      'tanggal_lahir': tanggal_lahir,
      'jenis_kelamin': jenis_kelamin,
      'password': password,
      'foto': foto,
    };
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama_depan = json['nama_depan'];
    nama_belakang = json['nama_belakang'];
    email = json['email'];
    tanggal_lahir = json['tanggal_lahir'];
    jenis_kelamin = json['jenis_kelamin'];
    password = json['password'];
    foto = json['foto'];
  }
}
