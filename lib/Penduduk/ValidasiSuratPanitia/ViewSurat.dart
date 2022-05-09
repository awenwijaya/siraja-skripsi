import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:surat/Penduduk/ValidasiSuratPanitia/ViewLampiran.dart';

class viewSuratKrama extends StatefulWidget {
  static var suratKeluarId;
  const viewSuratKrama({Key key}) : super(key: key);

  @override
  _viewSuratKramaState createState() => _viewSuratKramaState();
}

class _viewSuratKramaState extends State<viewSuratKrama> {
  var tanggalSurat;
  var nomorSurat;
  var lepihan;
  var parindikan;
  var pemahbah;
  var daging;
  var pamuput;
  var pihakPenerima;
  var namaDesa;
  var namaKecamatan;
  var namaKabupaten;
  var alamat;
  var kontakWa1;
  var kontakWa2;
  var logoDesa;
  var timKegiatan;
  var apiURLShowDetailSuratKeluar = "http://192.168.18.10:8000/api/data/surat/keluar/view/${viewSuratKrama.suratKeluarId}";
  var apiURLShowPanitia = "http://192.168.18.10:8000/api/data/admin/surat/keluar/panitia/${viewSuratKrama.suratKeluarId}";
  var apiURLShowPrajuru = "http://192.168.18.10:8000/api/data/admin/surat/keluar/prajuru/${viewSuratKrama.suratKeluarId}";
  var namaKetua;
  var namaSekretaris;
  var namaBendesa;
  var createdAt;
  var lampiran;
  var tumusan;
  bool LoadData = true;

  getSuratKeluarInfo() async {
    http.get(Uri.parse(apiURLShowDetailSuratKeluar),
        headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        setState(() {
          tanggalSurat = parsedJson['tanggal_surat'];
          nomorSurat = parsedJson['nomor_surat'];
          lepihan = parsedJson['lepihan'];
          parindikan = parsedJson['parindikan'];
          tumusan = parsedJson['tumusan'];
          pemahbah = parsedJson['pamahbah_surat'];
          daging = parsedJson['daging_surat'];
          pamuput = parsedJson['pamuput_surat'];
          pihakPenerima = parsedJson['pihak_penerima'];
          namaDesa =  parsedJson['desadat_nama'];
          namaKecamatan = parsedJson['nama_kecamatan'];
          namaKabupaten = parsedJson['name'];
          alamat = parsedJson['desadat_alamat_kantor'];
          kontakWa1 = parsedJson['desadat_wa_kontak_1'];
          kontakWa2 = parsedJson['desadat_wa_kontak_2'];
          logoDesa = parsedJson['desadat_logo'];
          timKegiatan = parsedJson['tim_kegiatan'];
          lampiran = parsedJson['lampiran'];
          LoadData = false;
        });
      }
    });
  }

  getKetuaPanitiaInfo() async {
    var body = jsonEncode({
      "jabatan" : "Ketua Panitia"
    });
    http.post(Uri.parse(apiURLShowPanitia),
        headers: {"Content-Type" : "application/json"},
        body: body
    ).then((http.Response response) {
      if(response.statusCode == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        setState(() {
          namaKetua = parsedJson['nama'];
        });
      }
    });
  }

  getSekretarisPanitiaInfo() async {
    var body = jsonEncode({
      "jabatan" : "Sekretaris Panitia"
    });
    http.post(Uri.parse(apiURLShowPanitia),
        headers: {"Content-Type" : "application/json"},
        body: body
    ).then((http.Response response) {
      if(response.statusCode == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        setState(() {
          namaSekretaris = parsedJson['nama'];
        });
      }
    });
  }

  getBendesaInfo() async {
    var body = jsonEncode({
      "jabatan" : "Bendesa"
    });
    http.post(Uri.parse(apiURLShowPrajuru),
        headers: {"Content-Type" : "application/json"},
        body: body
    ).then((http.Response response) {
      if(response.statusCode == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        setState(() {
          namaBendesa = parsedJson['nama'];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSuratKeluarInfo();
    getKetuaPanitiaInfo();
    getSekretarisPanitiaInfo();
    getBendesaInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(parindikan == null ? "" : parindikan, style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700
          )),
          backgroundColor: HexColor("#025393"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: (){Navigator.of(context).pop();},
          ),
        ),
        body: LoadData ? ProfilePageShimmer() : SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage("https://picsum.photos/250?image=9"),
                          fit: BoxFit.fill
                        )
                      ),
                      margin: EdgeInsets.only(left: 20)
                    ),
                    Container(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.82,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text("DESA ADAT ${namaDesa}".toUpperCase(), style: TextStyle(
                                fontFamily: "Times New Roman",
                                fontSize: 18,
                                fontWeight: FontWeight.w700
                              ))
                            ),
                            Container(
                              child: Text("KECAMATAN ${namaKecamatan} ${namaKabupaten}".toUpperCase(), style: TextStyle(
                                fontFamily: "Times New Roman",
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                              ), textAlign: TextAlign.center),
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.symmetric(horizontal: 10)
                            ),
                            Container(
                              child: Text("${alamat}${kontakWa1 == null ? "" : ", $kontakWa1"}${kontakWa2 == null ? "" : ", $kontakWa2"}", style: TextStyle(
                                fontFamily: "Times New Roman",
                                fontSize: 16
                              ), textAlign: TextAlign.center),
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.symmetric(horizontal: 10)
                            )
                          ],
                        ),
                      )
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: 20)
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2.0, color: Colors.black)
                  )
                ),
                margin: EdgeInsets.only(top: 10, left: 15, right: 15)
              ),
              Container(
                alignment: Alignment.center,
                child: Text("${namaDesa}, ${tanggalSurat}", style: TextStyle(
                  fontFamily: "Times New Roman",
                  fontSize: 16
                )),
                margin: EdgeInsets.only(right: 15, top: 15)
              ),
              Container(
                alignment: Alignment.topRight,
                child: Text("Katur Majeng Ring : ${pihakPenerima}", style: TextStyle(
                  fontFamily: "Times New Roman",
                  fontSize: 16
                ), textAlign: TextAlign.center),
                margin: EdgeInsets.only(top: 10, right: 15)
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text("Nomor: ${nomorSurat}", style: TextStyle(
                        fontFamily: "Times New Roman",
                        fontSize: 16
                      )),
                      margin: EdgeInsets.only(top: 5)
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(lepihan == "0" ? "Lepihan: -" : "Lepihan: ${lepihan} lepih", style: TextStyle(
                            fontFamily: "Times New Roman",
                            fontSize: 16
                        )),
                        margin: EdgeInsets.only(top: 5)
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text("Parindikan: ${parindikan}", style: TextStyle(
                            fontFamily: "Times New Roman",
                            fontSize: 16
                        )),
                        margin: EdgeInsets.only(top: 5)
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(tumusan == null ? "Tumusan: -" : "Tumusan: ${tumusan}", style: TextStyle(
                            fontFamily: "Times New Roman",
                            fontSize: 16
                        )),
                        margin: EdgeInsets.only(top: 5)
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 15, top: 20)
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: Text("Om Swastiyastu", style: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                  )),
                  margin: EdgeInsets.only(top: 20, left: 15)
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: Text("\t\t\t${pemahbah}", style: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 16
                  ), textAlign: TextAlign.justify),
                  padding: EdgeInsets.only(left: 15, right: 15)
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: Text(daging == null ? "" : "\t\t\t${daging}", style: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 16
                  ), textAlign: TextAlign.justify),
                  padding: EdgeInsets.only(left: 15, right: 15)
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: Text(pamuput == null ? "" : "\t\t\t${pamuput}", style: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 16
                  ), textAlign: TextAlign.justify),
                  padding: EdgeInsets.only(left: 15, right: 15)
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: Text("Om Santih, Santih, Santih Om", style: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                  )),
                  margin: EdgeInsets.only(top: 5, left: 15)
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: timKegiatan == null ? Container() : Text(timKegiatan, style: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                  )),
                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 15),
                  padding: EdgeInsets.only(right: 15)
              ),
              Container(
                  child: Stack(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.topLeft,
                            child: namaKetua == null ? Container() : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    child: Text("Ketua", style: TextStyle(
                                        fontFamily: "Times New Roman",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700
                                    ))
                                ),
                                Container(
                                    child: Text(namaKetua, style: TextStyle(
                                        fontFamily: "Times New Roman",
                                        fontSize: 16
                                    )),
                                    margin: EdgeInsets.only(top: 25)
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(left: 10, top: 10)
                        ),
                        Container(
                            alignment: Alignment.topRight,
                            child: namaSekretaris == null ? Container() : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    child: Text("Sekretaris", style: TextStyle(
                                        fontFamily: "Times New Roman",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700
                                    ))
                                ),
                                Container(
                                    child: Text(namaSekretaris, style: TextStyle(
                                        fontFamily: "Times New Roman",
                                        fontSize: 16
                                    )),
                                    margin: EdgeInsets.only(top: 25)
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(right: 10, top: 10)
                        )
                      ]
                  )
              ),
              Container(
                  alignment: Alignment.center,
                  child: namaBendesa == null ? Container() : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          child: Text("Bendesa", style: TextStyle(
                              fontFamily: "Times New Roman",
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                          ))
                      ),
                      Container(
                          child: Text(namaBendesa, style: TextStyle(
                              fontFamily: "Times New Roman",
                              fontSize: 16
                          )),
                          margin: EdgeInsets.only(top: 25)
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(top: 20)
              ),
              Container(
                child: lampiran == null ? Container() : Container(
                  child: FlatButton(
                    onPressed: (){
                      setState(() {
                        viewLampiranSuratKrama.namaFile = lampiran;
                      });
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => viewLampiranSuratKrama()));
                    },
                    child: Text("Lihat Lampiran", style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: HexColor("#025393")
                    )),
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: HexColor("#025393"), width: 2)
                    ),
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
                  ),
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}