import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:surat/LoginAndRegistration/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:surat/Penduduk/Profile/EditProfile.dart';

class kramaProfile extends StatefulWidget {
  static var namaPenduduk;
  static var nikPenduduk;
  static var alamatPenduduk;
  static var golonganDarah;
  static var asalDesaPenduduk;
  static var jenisKelaminPenduduk;
  static var usernamePenduduk;
  static var emailPenduduk;
  static var nomorTeleponPenduduk;
  static var statusPerkawinan;
  static var agamaPenduduk;
  static var pendidikanTerakhir;
  static var profilePicture;
  static var namaPekerjaan;
  static var pendudukId;
  const kramaProfile({Key key}) : super(key: key);

  @override
  State<kramaProfile> createState() => _kramaProfileState();
}

class _kramaProfileState extends State<kramaProfile> {
  var apiURLUserProfile = "https://siradaskripsi.my.id/api/data/userdata/${loginPage.userId}";
  var apiURLRemoveFCMToken = "https://siradaskripsi.my.id/api/autentikasi/login/token/remove";

  getUserInfo() async {
    http.get(Uri.parse(apiURLUserProfile),
        headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        setState(() {
          kramaProfile.namaPenduduk = parsedJson['nama'];
          kramaProfile.usernamePenduduk = parsedJson['username'];
          kramaProfile.profilePicture = parsedJson['foto'];
          kramaProfile.pendudukId = parsedJson['penduduk_id'].toString();
          kramaProfile.nikPenduduk = parsedJson['nik'].toString();
          kramaProfile.alamatPenduduk = parsedJson['alamat'];
          kramaProfile.golonganDarah = parsedJson['golongan_darah'];
          kramaProfile.asalDesaPenduduk = parsedJson['desadat_nama'];
          kramaProfile.jenisKelaminPenduduk = parsedJson['jenis_kelamin'];
          kramaProfile.emailPenduduk = parsedJson['email'];
          kramaProfile.nomorTeleponPenduduk = parsedJson['telepon'];
          kramaProfile.statusPerkawinan = parsedJson['status_perkawinan'];
          kramaProfile.agamaPenduduk = parsedJson['agama'];
          kramaProfile.namaPekerjaan = parsedJson['profesi'];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Profil Saya", style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            color: Colors.white
          )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: (){Navigator.of(context).pop();},
          ),
          backgroundColor: HexColor("#025393")
        ),
        body: kramaProfile.namaPenduduk == null ? ProfilePageShimmer() : SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: kramaProfile.profilePicture == null ? Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('images/profilepic.png'),
                      fit: BoxFit.fill
                    )
                  ),
                ) : Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage('https://storage.siradaskripsi.my.id/img/profile/${kramaProfile.profilePicture}')
                    )
                  )
                ),
                margin: EdgeInsets.only(top: 30)
              ),
              Container(
                child: Text(kramaProfile.namaPenduduk.toString(), style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: HexColor("#025393")
                ), textAlign: TextAlign.center),
                margin: EdgeInsets.only(top: 20)
              ),
              Container(
                child: Text(kramaProfile.usernamePenduduk.toString(), style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14
                ), textAlign: TextAlign.center),
                margin: EdgeInsets.only(top: 5),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("NIK", style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              fontSize: 14
                            ), textAlign: TextAlign.left),
                            margin: EdgeInsets.only(top: 15)
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              kramaProfile.nikPenduduk.toString(),
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14
                              ),
                            ),
                            margin: EdgeInsets.only(top: 5)
                          )
                        ]
                      )
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Alamat", style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              fontSize: 14
                            ), textAlign: TextAlign.left),
                            margin: EdgeInsets.only(top: 15)
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              kramaProfile.alamatPenduduk.toString(),
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14
                              )
                            ),
                            margin: EdgeInsets.only(top: 5)
                          )
                        ]
                      )
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Status Perkawinan", style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              fontSize: 14
                            ), textAlign: TextAlign.center),
                            margin: EdgeInsets.only(top: 15)
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(kramaProfile.statusPerkawinan.toString(), style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14
                            )),
                            margin: EdgeInsets.only(top: 5)
                          )
                        ],
                      )
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Pekerjaan", style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              fontSize: 14
                            ), textAlign: TextAlign.left),
                            margin: EdgeInsets.only(top: 15)
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              kramaProfile.namaPekerjaan.toString(),
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14
                              ),
                            ),
                            margin: EdgeInsets.only(top: 5)
                          )
                        ],
                      )
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Jenis Kelamin", style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              fontSize: 14
                            ), textAlign: TextAlign.left),
                            margin: EdgeInsets.only(top: 15)
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(kramaProfile.jenisKelaminPenduduk.toString(), style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14
                            )),
                            margin: EdgeInsets.only(top: 5)
                          )
                        ]
                      )
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Golongan Darah", style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              fontSize: 14
                            ), textAlign: TextAlign.left),
                            margin: EdgeInsets.only(top: 15)
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(kramaProfile.golonganDarah.toString(), style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14
                            )),
                            margin: EdgeInsets.only(top: 5)
                          )
                        ]
                      )
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Agama", style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              fontSize: 14
                            ), textAlign: TextAlign.left),
                            margin: EdgeInsets.only(top: 15)
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(kramaProfile.agamaPenduduk.toString(), style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14
                            )),
                            margin: EdgeInsets.only(top: 5, bottom: 15)
                          )
                        ]
                      )
                    )
                  ]
                ),
                decoration: BoxDecoration(
                  color: HexColor("EEEEEE"),
                  borderRadius: BorderRadius.circular(25)
                ),
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20)
              ),
              Container(
                child: FlatButton(
                  onPressed: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => editProfileKrama())).then((value) {
                      getUserInfo();
                    });
                  },
                  child: Text("Edit Profil", style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    color: HexColor("#025393"),
                    fontWeight: FontWeight.w700
                  )),
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(color: HexColor("#025393"), width: 2)
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50)
                ),
                margin: EdgeInsets.only(bottom: 10)
              ),
            ]
          )
        )
      )
    );
  }
}