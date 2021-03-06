import 'dart:convert';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surat/AdminDesa/AgendaAcara/AgendaAcara.dart';
import 'package:surat/AdminDesa/DetailDesa/DetailDesa.dart';
import 'package:surat/AdminDesa/ManajemenPanitia/ManajemenPanitia.dart';
import 'package:surat/AdminDesa/ManajemenStaff/ManajemenPrajuruBanjarAdat/PrajuruBanjarAdat.dart';
import 'package:surat/AdminDesa/ManajemenStaff/ManajemenPrajuruDesaAdat/PrajuruDesaAdat.dart';
import 'package:surat/AdminDesa/ManajemenSurat/PermintaanVerifikasiSuratKeluar.dart';
import 'package:surat/AdminDesa/ManajemenSurat/SuratDiterima/SuratDiterima.dart';
import 'package:surat/AdminDesa/ManajemenSurat/SuratKeluar/SuratKeluarNonPanitia/SuratKeluarNonPanitia.dart';
import 'package:surat/AdminDesa/ManajemenSurat/SuratMasuk/SuratMasuk.dart';
import 'package:surat/AdminDesa/NomorSurat/NomorSurat.dart';
import 'package:surat/AdminDesa/Profile/AdminProfile.dart';
import 'package:surat/WelcomeScreen.dart';
import 'package:surat/LoginAndRegistration/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:surat/main.dart';

class dashboardAdminDesa extends StatefulWidget {
  static var logoDesa;
  static var namaDesaAdat;
  const dashboardAdminDesa({Key key}) : super(key: key);

  @override
  _dashboardAdminDesaState createState() => _dashboardAdminDesaState();
}

class _dashboardAdminDesaState extends State<dashboardAdminDesa> {
  var profilePicture;
  var namaAdmin;
  var namaDesa;
  var countBelumDivalidasi = 0;
  var apiURLGetDataUser = "https://siradaskripsi.my.id/api/data/userdata/${loginPage.userId}";
  var apiURLGetDetailDesaById = "https://siradaskripsi.my.id/api/data/userdata/desa/${loginPage.desaId}";
  var apiURLRemoveFCMToken = "https://siradaskripsi.my.id/api/autentikasi/login/token/remove";
  var apiURLCountBelumDivalidasi = "https://siradaskripsi.my.id/api/data/admin/surat/validasi/prajuru/count/${loginPage.prajuruId}";

  getCountBelumDivalidasi() async {
    http.get(Uri.parse(apiURLCountBelumDivalidasi),
      headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      if(response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          countBelumDivalidasi = data;
        });
      }
    });
  }

  getUserInfo() async {
    http.get(Uri.parse(apiURLGetDataUser),
      headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        setState(() {
          namaAdmin = parsedJson['nama'];
          profilePicture = parsedJson['foto'];
        });
      }
    });
  }

  getDesaInfo() async {
    http.get(Uri.parse(apiURLGetDetailDesaById),
        headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        setState(() {
          namaDesa = parsedJson['desadat_nama'];
          dashboardAdminDesa.namaDesaAdat = parsedJson['desadat_nama'];
          dashboardAdminDesa.logoDesa = parsedJson['desadat_logo'].toString();
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    getDesaInfo();
    getCountBelumDivalidasi();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if(notification!=null && android!=null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    color: Colors.white,
                    playSound: true,
                    icon: '@mipmap/ic_launcher'
                )
            )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("SiRada", style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: HexColor("#025393")
          )),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.person_outline_rounded),
              color: HexColor("#025393"),
              onPressed: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context) => adminProfile())).then((value) {
                  getUserInfo();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              color: HexColor("#025393"),
              onPressed: (){
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.0))
                      ),
                      content: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                'images/logout.png',
                                height: 50,
                                width: 50,
                              ),
                            ),
                            Container(
                              child: Text("Logout?", style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: HexColor("#025393")
                              ), textAlign: TextAlign.center),
                              margin: EdgeInsets.only(top: 10),
                            ),
                            Container(
                              child: Text("Apakah Anda yakin ingin logout?", style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14
                              ), textAlign: TextAlign.center),
                              margin: EdgeInsets.only(top: 10),
                            )
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            var body = jsonEncode({
                              "token" : loginPage.token
                            });
                            http.post(Uri.parse(apiURLRemoveFCMToken),
                              headers: {"Content-Type" : "application/json"},
                              body: body
                            ).then((http.Response response) async {
                              var data = response.statusCode;
                              if(data == 200) {
                                final SharedPreferences sharedpref = await SharedPreferences.getInstance();
                                sharedpref.remove('userId');
                                sharedpref.remove('pendudukId');
                                sharedpref.remove('desaId');
                                sharedpref.remove('email');
                                sharedpref.remove('role');
                                sharedpref.remove('status');
                                Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => welcomeScreen()), (route) => false);
                              }
                            });
                          },
                          child: Text("Ya", style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: HexColor("#025393")
                          )),
                        ),
                        TextButton(
                          onPressed: (){Navigator.of(context).pop();},
                          child: Text("Tidak", style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: HexColor("#025393")
                          )),
                        )
                      ],
                    );
                  }
                );
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: namaAdmin == null ? ProfileShimmer() : Row(
                  children: <Widget>[
                    Container(
                      child: profilePicture == null ? Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('images/profilepic.png'),
                            fit: BoxFit.fill
                          )
                        ),
                      ) : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage('https://storage.siradaskripsi.my.id/img/profile/${profilePicture}'),
                            fit: BoxFit.fill,
                          )
                        ),
                      ),
                      margin: EdgeInsets.only(left: 15),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text("Selamat datang kembali", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            )),
                          ),
                          Container(
                            child: Text("${namaAdmin.toString()} !", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                            )),
                          )
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20),
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: 20),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text("Desa Anda", style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                )),
                margin: EdgeInsets.only(top: 20, left: 15),
              ),
              Container(
                child: namaDesa == null ? ProfileShimmer() : Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: dashboardAdminDesa.logoDesa == null ? Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage('images/noimage.png'),
                                  fit: BoxFit.fill
                              )
                          ),
                        ) : Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage('https://storage.siradaskripsi.my.id/img/logo-desa/${dashboardAdminDesa.logoDesa}')
                              )
                          ),
                        ),
                        margin: EdgeInsets.only(left: 20),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(namaDesa.toString(), style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                              )),
                              margin: EdgeInsets.only(left: 20),
                            ),
                            Container(
                              child: TextButton(
                                child: Text("Lihat Detail Desa", style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: HexColor("#025393")
                                )),
                                onPressed: (){
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => detailDesaAdmin()));
                                },
                              ),
                              margin: EdgeInsets.only(left: 15),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0,3)
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text("Manajemen Pengguna", style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                )),
                margin: EdgeInsets.only(top: 20, left: 15),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => prajuruDesaAdatAdmin()));
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                'images/staff.png',
                                height: 40,
                                width: 40,
                              ),
                            ),
                            Container(
                              child: Text("Prajuru Desa Adat", style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                              )),
                              margin: EdgeInsets.only(left: 20),
                            ),
                          ],
                        ),
                      ),
                      margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0,3)
                          )
                        ]
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => prajuruBanjarAdatAdmin()));
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                'images/staff.png',
                                height: 40,
                                width: 40,
                              ),
                            ),
                            Container(
                              child: Text("Prajuru Banjar Adat", style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700
                              )),
                              margin: EdgeInsets.only(left: 20),
                            ),
                          ],
                        ),
                      ),
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0,3)
                            )
                          ]
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => manajemenPanitiaDesaAdatAdmin()));
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                'images/panitia.png',
                                height: 40,
                                width: 40,
                              )
                            ),
                            Container(
                              child: Text("Panitia Kegiatan", style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                              )),
                              margin: EdgeInsets.only(left: 20)
                            )
                          ]
                        )
                      ),
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0,3)
                          )
                        ]
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text("Manajemen Surat", style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w700
                )),
                margin: EdgeInsets.only(top: 20, left: 15),
              ),
              Container(
                child: loginPage.role == "Bendesa" ? Container(
                    child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => permintaanVerifikasiSuratKeluarAdmin()));
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Image.asset(
                                      'images/validation.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Container(
                                    child: Text("Permintaan Verifikasi Surat", style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700
                                    )),
                                    margin: EdgeInsets.only(left: 20),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: countBelumDivalidasi == 0 ? Container() : Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12
                                ),
                                child: Text(countBelumDivalidasi.toString(), style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                )),
                              ),
                            )
                          ],
                        )
                    ),
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0,3)
                          )
                        ]
                    )
                ) : loginPage.role == "Penyarikan" ? Container(
                    child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => permintaanVerifikasiSuratKeluarAdmin()));
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Image.asset(
                                      'images/validation.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  Container(
                                    child: Text("Permintaan Verifikasi Surat", style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700
                                    )),
                                    margin: EdgeInsets.only(left: 20),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12
                                ),
                                child: Text("12", style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                )),
                              ),
                            )
                          ],
                        )
                    ),
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0,3)
                          )
                        ]
                    )
                ) : Container(),
              ),
              Container(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => suratDiterimaAdmin()));
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            'images/penerima.png',
                            height: 40,
                            width: 40,
                          ),
                        ),
                        Container(
                          child: Text("Surat Diterima", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )),
                          margin: EdgeInsets.only(left: 20),
                        )
                      ],
                    ),
                  ),
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0,3)
                        )
                      ]
                  )
              ),
              Container(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => suratKeluarNonPanitiaAdmin()));
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            'images/email.png',
                            height: 40,
                            width: 40,
                          ),
                        ),
                        Container(
                          child: Text("Surat Keluar", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )),
                          margin: EdgeInsets.only(left: 20),
                        )
                      ],
                    ),
                  ),
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0,3)
                        )
                      ]
                  )
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => nomorSuratAdmin()));
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                'images/paper.png',
                                height: 40,
                                width: 40,
                              ),
                            ),
                            Container(
                              child: Text("Nomor Surat", style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700
                              )),
                              margin: EdgeInsets.only(left: 20),
                            )
                          ],
                        ),
                      ),
                      margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0,3)
                            )
                          ]
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => suratMasukAdmin()));
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                'images/email.png',
                                height: 40,
                                width: 40,
                              ),
                            ),
                            Container(
                              child: Text("Surat Masuk", style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                              )),
                              margin: EdgeInsets.only(left: 20),
                            )
                          ],
                        ),
                      ),
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0,3)
                          )
                        ]
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => suratKeluarNonPanitiaAdmin()));
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                'images/email.png',
                                height: 40,
                                width: 40,
                              ),
                            ),
                            Container(
                              child: Text("Surat Keluar", style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                              )),
                              margin: EdgeInsets.only(left: 20),
                            )
                          ],
                        ),
                      ),
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0,3)
                          )
                        ]
                      )
                    ),
                  ],
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => agendaAcaraAdmin()));
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          'images/kalendar.png',
                          height: 40,
                          width: 40,
                        ),
                      ),
                      Container(
                        child: Text("Agenda Acara", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                        )),
                        margin: EdgeInsets.only(left: 20),
                      )
                    ],
                  ),
                ),
                margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0,3)
                    )
                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}