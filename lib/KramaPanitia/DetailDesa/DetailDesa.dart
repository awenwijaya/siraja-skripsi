import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:surat/LoginAndRegistration/LoginPage.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class detailDesaKramaPanitia extends StatefulWidget {
  static var logoDesa;
  static var kontakWADesa1;
  static var kontakWADesa2;
  const detailDesaKramaPanitia({Key key}) : super(key: key);

  @override
  State<detailDesaKramaPanitia> createState() => _detailDesaKramaPanitiaState();
}

class _detailDesaKramaPanitiaState extends State<detailDesaKramaPanitia> {
  var apiURLGetDetailDesaById = "https://siradaskripsi.my.id/api/data/userdata/desa/${loginPage.desaId}";
  var namaDesa;
  var status;
  var kodePos;
  var alamatKantorDesa;
  var teleponKantorDesa;
  var emailDesa;
  var webDesa;
  var luasDesa;
  var namaKecamatan;
  var long;
  var lat;
  bool Loading = true;

  getDesaInfo() async {
    http.get(Uri.parse(apiURLGetDetailDesaById),
        headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        setState(() {
          Loading = false;
          namaDesa = parsedJson['desadat_nama'];
          status = parsedJson['desadat_status_aktif'].toString();
          alamatKantorDesa = parsedJson['desadat_alamat_kantor'];
          teleponKantorDesa = parsedJson['desadat_telpon_kantor'];
          emailDesa = parsedJson['desadat_email'];
          webDesa = parsedJson['desadat_web'];
          luasDesa = parsedJson['desadat_luas'].toString();
          namaKecamatan = parsedJson['name'];
          long = parsedJson['desadat_kantor_long'];
          lat = parsedJson['desadat_kantor_lat'];
          detailDesaKramaPanitia.kontakWADesa1 = parsedJson['desadat_wa_kontak_1'];
          detailDesaKramaPanitia.kontakWADesa2 = parsedJson['desadat_wa_kontak_2'];
          detailDesaKramaPanitia.logoDesa = parsedJson['desadat_logo'].toString();
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDesaInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Detail Desa", style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            color: Colors.white
          )),
          backgroundColor: HexColor("#025393"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: (){Navigator.of(context).pop();},
          ),
        ),
        body: Loading ? Center(
          child: Lottie.asset('assets/loading-circle.json'),
        ) : SingleChildScrollView(
          child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: detailDesaKramaPanitia.logoDesa == null ? AssetImage('images/noimage.png') : NetworkImage('https://storage.siradaskripsi.my.id/img/logo-desa/${detailDesaKramaPanitia.logoDesa}')
                                        )
                                    ),
                                  ),
                                  Container(
                                      child: Text(namaDesa, style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 16,
                                          color: HexColor("#025393"),
                                          fontWeight: FontWeight.w700
                                      )),
                                      margin: EdgeInsets.only(top: 10)
                                  )
                                ],
                              ),
                              margin: EdgeInsets.only(top: 20)
                          ),
                          Container(
                              child: Column(
                                  children: <Widget>[
                                    Container(
                                        alignment: Alignment.topLeft,
                                        child: Text("Kontak Desa", style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700
                                        )),
                                        margin: EdgeInsets.only(top: 15, left: 25)
                                    ),
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Icon(
                                                    Icons.phone,
                                                    color: HexColor("#025393"),
                                                    size: 30,
                                                  ),
                                                  margin: EdgeInsets.only(left: 20),
                                                ),
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Text("Nomor Telepon", style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w700,
                                                            color: HexColor("#025393")
                                                        )),
                                                      ),
                                                      Container(
                                                          child: teleponKantorDesa == null ? Text("Nomor telepon belum diinputkan", style: TextStyle(
                                                              fontFamily: "Poppins",
                                                              fontSize: 14
                                                          )) : Text(teleponKantorDesa.toString(), style: TextStyle(
                                                              fontFamily: "Poppins",
                                                              fontSize: 14
                                                          ))
                                                      )
                                                    ],
                                                  ),
                                                  margin: EdgeInsets.only(left: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: teleponKantorDesa == null ? Container() : TextButton(
                                              onPressed: () async {
                                                final url = 'tel:$teleponKantorDesa';
                                                if(await canLaunch(url)) {
                                                  await launch(url);
                                                }
                                              },
                                              child: Text("Hubungi Kantor Desa", style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: HexColor("#025393")
                                              )),
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
                                    Container(
                                      child: GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, CupertinoPageRoute(builder: (context) => kontakWADesaKramaPanitia()));
                                          },
                                          child: Row(
                                              children: <Widget>[
                                                Container(
                                                    child: Icon(
                                                        Icons.phone,
                                                        color: HexColor("#025393"),
                                                        size: 30
                                                    ),
                                                    margin: EdgeInsets.only(left: 20)
                                                ),
                                                Container(
                                                    child: Text("Kontak WhatsApp Desa", style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w700,
                                                        color: HexColor("#025393")
                                                    )),
                                                    margin: EdgeInsets.only(left: 15)
                                                )
                                              ]
                                          )
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
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Icon(
                                                    Icons.location_on_outlined,
                                                    color: HexColor("#025393"),
                                                    size: 30,
                                                  ),
                                                  margin: EdgeInsets.only(left: 20),
                                                ),
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Text("Alamat Kantor", style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w700,
                                                            color: HexColor("#025393")
                                                        )),
                                                      ),
                                                      Container(
                                                          child: alamatKantorDesa == null ? Text("Alamat kantor belum diinputkan", style: TextStyle(
                                                              fontFamily: "Poppins",
                                                              fontSize: 14
                                                          )) : Container(
                                                            child: SizedBox(
                                                              width: MediaQuery.of(context).size.width * 0.7,
                                                              child: Text(alamatKantorDesa.toString(), style: TextStyle(
                                                                  fontFamily: "Poppins",
                                                                  fontSize: 14
                                                              )),
                                                            ),
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                  margin: EdgeInsets.only(left: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              alignment: Alignment.center,
                                              child: alamatKantorDesa == null ? Container() : lat == null ? Container() : TextButton(
                                                  onPressed: () async {
                                                    String googleURL = "https://www.google.com/maps/search/?api=1&query=${lat},${long}";
                                                    if(await canLaunch(googleURL)) {
                                                      await launch(googleURL);
                                                    }else{
                                                      throw 'Could not open the map';
                                                    }
                                                  },
                                                  child: Text("Buka di Google Maps", style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700,
                                                      color: HexColor("#025393")
                                                  ))
                                              )
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
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Icon(
                                                    Icons.email,
                                                    color: HexColor("#025393"),
                                                    size: 30,
                                                  ),
                                                  margin: EdgeInsets.only(left: 20),
                                                ),
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Text("Email", style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w700,
                                                            color: HexColor("#025393")
                                                        )),
                                                      ),
                                                      Container(
                                                          child: emailDesa == null ? Text("Email belum diinputkan", style: TextStyle(
                                                              fontFamily: "Poppins",
                                                              fontSize: 14
                                                          )) : Text(emailDesa.toString(), style: TextStyle(
                                                              fontFamily: "Poppins",
                                                              fontSize: 14
                                                          ))
                                                      )
                                                    ],
                                                  ),
                                                  margin: EdgeInsets.only(left: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: emailDesa == null ? Container() : TextButton(
                                              onPressed: () async {
                                                final url = 'mailto:$emailDesa';

                                                if(await canLaunch(url)) {
                                                  await launch(url);
                                                }
                                              },
                                              child: Text("Hubungi Kantor Desa", style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: HexColor("#025393")
                                              )),
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
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Icon(
                                                    Icons.web,
                                                    color: HexColor("#025393"),
                                                    size: 30,
                                                  ),
                                                  margin: EdgeInsets.only(left: 20),
                                                ),
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        child: Text("Website", style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w700,
                                                            color: HexColor("#025393")
                                                        )),
                                                      ),
                                                      Container(
                                                          child: webDesa == null ? Text("Website belum diinputkan", style: TextStyle(
                                                              fontFamily: "Poppins",
                                                              fontSize: 14
                                                          )) : SizedBox(
                                                            width: MediaQuery.of(context).size.width * 0.7,
                                                            child: Text(webDesa.toString(), style: TextStyle(
                                                                fontFamily: "Poppins",
                                                                fontSize: 14
                                                            ), maxLines: 1,
                                                              softWrap: false,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                  margin: EdgeInsets.only(left: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: webDesa == null ? Container() : TextButton(
                                              onPressed: () async {
                                                final url = "https://$webDesa";

                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                }
                                              },
                                              child: Text("Kunjungi Website Desa", style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: HexColor("#025393")
                                              )),
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
                                    )
                                  ]
                              )
                          )
                        ]
                    )
                ),
                Container(
                    alignment: Alignment.topLeft,
                    child: Text("Detail Desa Lainnya", style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    )),
                    margin: EdgeInsets.only(top: 20, left: 25)
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.location_on_rounded,
                          color: HexColor("#025393"),
                          size: 30,
                        ),
                        margin: EdgeInsets.only(left: 20),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text("Kecamatan", style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: HexColor("#025393")
                              )),
                            ),
                            Container(
                              child: Text(namaKecamatan.toString(), style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14
                              )),
                            )
                          ],
                        ),
                        margin: EdgeInsets.only(left: 15),
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
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.location_on_rounded,
                          color: HexColor("#025393"),
                          size: 30,
                        ),
                        margin: EdgeInsets.only(left: 20),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text("Luas Daerah", style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: HexColor("#025393")
                              )),
                            ),
                            Container(
                              child: Text("${luasDesa.toString()} km", style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14
                              )),
                            )
                          ],
                        ),
                        margin: EdgeInsets.only(left: 15),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
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
                )
              ]
          )
        ),
      ),
    );
  }
}

class kontakWADesaKramaPanitia extends StatefulWidget {
  const kontakWADesaKramaPanitia({Key key}) : super(key: key);

  @override
  State<kontakWADesaKramaPanitia> createState() => _kontakWADesaKramaPanitiaState();
}

class _kontakWADesaKramaPanitiaState extends State<kontakWADesaKramaPanitia> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Kontak WhatsApp Desa", style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700
          )),
          backgroundColor: HexColor("#025393"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: (){Navigator.of(context).pop();},
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: detailDesaKramaPanitia.kontakWADesa1 == null ? Container() : Container(
                    child: GestureDetector(
                        onTap: () async {
                          String url = "whatsapp://send?phone=${detailDesaKramaPanitia.kontakWADesa1}";
                          await canLaunch(url) ? launch(url) : print("Can't open WhatsApp");
                        },
                        child: Container(
                            child: Row(
                                children: <Widget>[
                                  Container(
                                      child: Icon(
                                          Icons.phone,
                                          color: HexColor("#025393"),
                                          size: 30
                                      ),
                                      margin: EdgeInsets.only(left: 20)
                                  ),
                                  Container(
                                      child: Text(detailDesaKramaPanitia.kontakWADesa1.toString(), style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: HexColor("#025393")
                                      )),
                                      margin: EdgeInsets.only(left: 15)
                                  )
                                ]
                            )
                        )
                    ),
                    margin: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
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
                    )
                ),
              ),
              Container(
                child: detailDesaKramaPanitia.kontakWADesa2 == null ? Container() : Container(
                  child: GestureDetector(
                    onTap: () async {
                      String url = "whatsapp://send?phone=${detailDesaKramaPanitia.kontakWADesa2}";
                      await canLaunch(url) ? launch(url) : print("Can't open WhatsApp");
                    },
                    child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                                child: Icon(
                                    Icons.phone,
                                    color: HexColor("#025393"),
                                    size: 30
                                ),
                                margin: EdgeInsets.only(left: 20)
                            ),
                            Container(
                              child: Text(detailDesaKramaPanitia.kontakWADesa2.toString(), style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: HexColor("#025393")
                              )),
                              margin: EdgeInsets.only(left: 15),
                            )
                          ],
                        )
                    ),
                  ),
                  margin: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}