import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:surat/AdminDesa/ManajemenPanitia/EditPanitia.dart';
import 'package:surat/AdminDesa/ManajemenPanitia/TambahPanitia.dart';
import 'package:surat/LoginAndRegistration/LoginPage.dart';

class manajemenPanitiaDesaAdatAdmin extends StatefulWidget {
  const manajemenPanitiaDesaAdatAdmin({Key key}) : super(key: key);

  @override
  State<manajemenPanitiaDesaAdatAdmin> createState() => _manajemenPanitiaDesaAdatAdminState();
}

class _manajemenPanitiaDesaAdatAdminState extends State<manajemenPanitiaDesaAdatAdmin> {
  var apiURLGetDataTimKegiatanAktif = "https://siradaskripsi.my.id/api/panitia/${loginPage.desaId}/aktif";
  var apiURLGetDataTimKegiatanTidakAktif = "https://siradaskripsi.my.id/api/panitia/${loginPage.desaId}/tidak-aktif";
  var apiURLSetPanitiaTidakAktif = "https://siradaskripsi.my.id/api/panitia/set_tidak_aktif";
  var apiURLSetPanitiaAktif = "https://siradaskripsi.my.id/api/panitia/set_aktif";

  DateTime sekarang = DateTime.now();
  DateTime periodeAkhirPanitia;

  FToast ftoast;

  //list aktif
  bool LoadingAktif = true;
  bool availableDataAktif = false;
  var namaPanitiaAktif = [];
  var idPanitiaAktif = [];
  var jabatanPanitiaAktif = [];
  var timKegiatanPanitiaAktif = [];
  var periodeMulaiPanitiaAktif = [];
  var periodeAkhirPanitiaAktif = [];

  //list tidak aktif
  bool LoadingTidakAktif = true;
  bool availableDataTidakAktif = false;
  var namaPanitiaTidakAktif = [];
  var idPanitiaTidakAktif = [];
  var jabatanPanitiaTidakAktif = [];
  var timKegiatanPanitiaTidakAktif = [];
  var periodeMulaiPanitiaTidakAktif = [];
  var periodeAkhirPanitiaTidakAktif = [];

  var selectedIdPanitia;

  final controllerSearchAktif = TextEditingController();
  final controllerSearchTidakAktif = TextEditingController();

  //search
  bool isSearch = false;
  var apiURLSearchAktif = "https://siradaskripsi.my.id/api/panitia/${loginPage.desaId}/aktif/search";

  //search tidak aktif
  bool isSearchTidakAktif = false;
  var apiURLSearchTidakAktif = "https://siradaskripsi.my.id/api/panitia/${loginPage.desaId}/tidak_aktif/search";

  Future refreshListPanitiaAktif() async {
    Uri uri = Uri.parse(apiURLGetDataTimKegiatanAktif);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      var data = json.decode(response.body);
      this.namaPanitiaAktif = [];
      this.idPanitiaAktif = [];
      this.jabatanPanitiaAktif = [];
      this.timKegiatanPanitiaAktif = [];
      this.periodeMulaiPanitiaAktif = [];
      this.periodeAkhirPanitiaAktif = [];
      setState(() {
        LoadingAktif = false;
        availableDataAktif = true;
      });
      for(var i = 0; i < data.length; i++) {
        this.namaPanitiaAktif.add(data[i]['nama']);
        this.idPanitiaAktif.add(data[i]['panitia_desa_adat_id']);
        this.jabatanPanitiaAktif.add(data[i]['jabatan']);
        this.timKegiatanPanitiaAktif.add(data[i]['panitia']);
        this.periodeMulaiPanitiaAktif.add(data[i]['tanggal_mulai_menjabat']);
        this.periodeAkhirPanitiaAktif.add(data[i]['tanggal_akhir_menjabat']);
      }
    }else {
      setState(() {
        LoadingAktif = false;
        availableDataAktif = false;
      });
    }
  }

  Future refreshListSearchPanitiaAktif() async {
    setState(() {
      LoadingAktif = true;
      isSearch = true;
    });
    var body = jsonEncode({
      "search_query" : controllerSearchAktif.text
    });
    http.post(Uri.parse(apiURLSearchAktif),
        headers: {"Content-Type" : "application/json"},
        body: body
    ).then((http.Response response) async {
      var statusCode = response.statusCode;
      if(statusCode == 200) {
        var data = json.decode(response.body);
        this.namaPanitiaAktif = [];
        this.idPanitiaAktif = [];
        this.jabatanPanitiaAktif = [];
        this.timKegiatanPanitiaAktif = [];
        this.periodeMulaiPanitiaAktif = [];
        this.periodeAkhirPanitiaAktif = [];
        setState(() {
          LoadingAktif = false;
          availableDataAktif = true;
        });
        for(var i = 0; i < data.length; i++) {
          this.namaPanitiaAktif.add(data[i]['nama']);
          this.idPanitiaAktif.add(data[i]['panitia_desa_adat_id']);
          this.jabatanPanitiaAktif.add(data[i]['jabatan']);
          this.timKegiatanPanitiaAktif.add(data[i]['panitia']);
          this.periodeMulaiPanitiaAktif.add(data[i]['tanggal_mulai_menjabat']);
          this.periodeAkhirPanitiaAktif.add(data[i]['tanggal_akhir_menjabat']);
        }
      }else {
        setState(() {
          LoadingAktif = false;
          availableDataAktif = false;
        });
      }
    });
  }

  Future setPanitiaAktif() async {
    Uri uri = Uri.parse("https://siradaskripsi.my.id/api/panitia/get_periode_akhir/$selectedIdPanitia");
    final response  = await http.get(uri);
    if(response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        periodeAkhirPanitia = DateTime.parse(data['tanggal_akhir_menjabat']);
        print(periodeAkhirPanitia.toString());
      });
      if(periodeAkhirPanitia.isBefore(sekarang)) {
        ftoast.showToast(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.redAccent
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.close),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text("Tidak bisa mengaktifkan kembali panitia karena periode menjabat telah berakhir", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white
                      )),
                    ),
                  )
                ],
              ),
            ),
            toastDuration: Duration(seconds: 3)
        );
      }else {
        var body = jsonEncode({
          "panitia_desa_adat_id" : selectedIdPanitia
        });
        http.post(Uri.parse(apiURLSetPanitiaAktif),
          headers: {"Content-Type" : "application/json"},
          body: body
        ).then((http.Response response) {
          var responseValue = response.statusCode;
          if(responseValue == 200) {
            ftoast.showToast(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.green
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.done),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text("Panitia berhasil diaktifkan kembali", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              toastDuration: Duration(seconds: 3)
            );
            refreshListPanitiaTidakAktif();
            refreshListPanitiaAktif();
            Navigator.of(context).pop(true);
          }
        });
      }
    }
  }

  Future refreshListPanitiaTidakAktif() async {
    Uri uri = Uri.parse(apiURLGetDataTimKegiatanTidakAktif);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      var data = json.decode(response.body);
      this.namaPanitiaTidakAktif = [];
      this.idPanitiaTidakAktif = [];
      this.jabatanPanitiaTidakAktif = [];
      this.timKegiatanPanitiaTidakAktif = [];
      this.periodeMulaiPanitiaTidakAktif = [];
      this.periodeAkhirPanitiaTidakAktif = [];
      setState(() {
        LoadingTidakAktif = false;
        availableDataTidakAktif = true;
      });
      for(var i = 0; i < data.length; i++) {
        this.namaPanitiaTidakAktif.add(data[i]['nama']);
        this.idPanitiaTidakAktif.add(data[i]['panitia_desa_adat_id']);
        this.jabatanPanitiaTidakAktif.add(data[i]['jabatan']);
        this.timKegiatanPanitiaTidakAktif.add(data[i]['panitia']);
        this.periodeMulaiPanitiaTidakAktif.add(data[i]['tanggal_mulai_menjabat']);
        this.periodeAkhirPanitiaTidakAktif.add(data[i]['tanggal_akhir_menjabat']);
      }
    }else {
      setState(() {
        LoadingTidakAktif = false;
        availableDataTidakAktif = false;
      });
    }
  }

  Future refreshListSearchPanitiaTidakAktif() async {
    setState(() {
      LoadingTidakAktif = true;
      isSearchTidakAktif = true;
    });
    var body = jsonEncode({
      "search_query" : controllerSearchTidakAktif.text
    });
    http.post(Uri.parse(apiURLSearchTidakAktif),
        headers: {"Content-Type" : "application/json"},
        body: body
    ).then((http.Response response) async {
      var statusCode = response.statusCode;
      if(statusCode == 200) {
        var data = json.decode(response.body);
        this.namaPanitiaTidakAktif = [];
        this.idPanitiaTidakAktif = [];
        this.jabatanPanitiaTidakAktif = [];
        this.timKegiatanPanitiaTidakAktif = [];
        this.periodeMulaiPanitiaTidakAktif = [];
        this.periodeAkhirPanitiaTidakAktif = [];
        setState(() {
          LoadingTidakAktif = false;
          availableDataTidakAktif = true;
        });
        for(var i = 0; i < data.length; i++) {
          this.namaPanitiaTidakAktif.add(data[i]['nama']);
          this.idPanitiaTidakAktif.add(data[i]['panitia_desa_adat_id']);
          this.jabatanPanitiaTidakAktif.add(data[i]['jabatan']);
          this.timKegiatanPanitiaTidakAktif.add(data[i]['panitia']);
          this.periodeMulaiPanitiaTidakAktif.add(data[i]['tanggal_mulai_menjabat']);
          this.periodeAkhirPanitiaTidakAktif.add(data[i]['tanggal_akhir_menjabat']);
        }
      }else {
        setState(() {
          LoadingTidakAktif = false;
          availableDataTidakAktif = false;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshListPanitiaAktif();
    refreshListPanitiaTidakAktif();
    ftoast = FToast();
    ftoast.init(this.context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: HexColor("#025393"),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          title: Text("Panitia Kegiatan", style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            color: HexColor("#025393")
          )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/panitia.png',
                  height: 100,
                  width: 100,
                ),
                margin: EdgeInsets.only(top: 20),
              ),
              Container(
                child: FlatButton(
                  onPressed: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => tambahPanitiaKegiatanAdmin())).then((value) {
                      refreshListPanitiaAktif();
                      refreshListPanitiaTidakAktif();
                    });
                  },
                  child: Text("Tambah Data Panitia", style: TextStyle(
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
                margin: EdgeInsets.only(top: 15, bottom: 15),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DefaultTabController(
                      length: 2,
                      initialIndex: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            child: TabBar(
                              labelColor: HexColor("#025393"),
                              unselectedLabelColor: Colors.black,
                              tabs: [
                                Tab(child: Text("Aktif", style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700
                                ))),
                                Tab(child: Text("Tidak Aktif", style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700
                                )))
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.575,
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: Colors.black26, width: 0.5))
                            ),
                            child: TabBarView(
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          child: TextField(
                                            controller: controllerSearchAktif,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(50.0),
                                                    borderSide: BorderSide(color: HexColor("#025393"))
                                                ),
                                                hintText: "Cari nama, jabatan atau tim kegiatan Panitia Kegiatan...",
                                                suffixIcon: isSearch ? IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: (){
                                                    setState(() {
                                                      LoadingAktif = true;
                                                      controllerSearchAktif.text = "";
                                                      isSearch = false;
                                                      refreshListPanitiaAktif();
                                                    });
                                                  },
                                                ) : IconButton(
                                                  icon: Icon(Icons.search),
                                                  onPressed: (){
                                                    if(controllerSearchAktif.text != "") {
                                                      setState(() {
                                                        isSearch = true;
                                                      });
                                                      refreshListSearchPanitiaAktif();
                                                    }
                                                  },
                                                )
                                            ),
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14
                                            ),
                                          ),
                                          margin: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20)
                                      ),
                                      Container(
                                        child: LoadingAktif ? ListTileShimmer() : availableDataAktif ? Expanded(
                                          flex: 1,
                                          child: RefreshIndicator(
                                            onRefresh: isSearch ? refreshListSearchPanitiaAktif : refreshListPanitiaAktif,
                                            child: ListView.builder(
                                              itemCount: idPanitiaAktif.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: (){},
                                                  child: Container(
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                child: Image.asset(
                                                                  'images/person.png',
                                                                  height: 40,
                                                                  width: 40,
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    Container(
                                                                      child: SizedBox(
                                                                        width: MediaQuery.of(context).size.width * 0.55,
                                                                        child: Text(
                                                                          "${namaPanitiaAktif[index]}", style: TextStyle(
                                                                            fontFamily: "Poppins",
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: HexColor("#025393")
                                                                        ),
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          softWrap: false,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: SizedBox(
                                                                        width: MediaQuery.of(context).size.width * 0.55,
                                                                        child: Text(
                                                                          "${jabatanPanitiaAktif[index]}", style: TextStyle(
                                                                            fontFamily: "Poppins",
                                                                            fontSize: 14,
                                                                            color: Colors.black
                                                                        ),
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          softWrap: false,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: SizedBox(
                                                                        width: MediaQuery.of(context).size.width * 0.55,
                                                                        child: Text(
                                                                          "${timKegiatanPanitiaAktif[index]}", style: TextStyle(
                                                                            fontFamily: "Poppins",
                                                                            fontSize: 14,
                                                                            color: Colors.black26
                                                                        ),
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          softWrap: false,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: SizedBox(
                                                                        width: MediaQuery.of(context).size.width * 0.55,
                                                                        child: Text(
                                                                          "${periodeMulaiPanitiaAktif[index].toString()} - ${periodeAkhirPanitiaAktif[index].toString()}", style: TextStyle(
                                                                            fontFamily: "Poppins",
                                                                            fontSize: 14,
                                                                            color: Colors.black26
                                                                        ),
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          softWrap: false,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                margin: EdgeInsets.only(left: 15),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment.centerRight,
                                                          child: PopupMenuButton<int>(
                                                            onSelected: (item) {
                                                              onSelected(context, item);
                                                              selectedIdPanitia = idPanitiaAktif[index];
                                                            },
                                                            itemBuilder: (context) => [
                                                              PopupMenuItem<int>(
                                                                value: 0,
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Container(
                                                                      child: Icon(
                                                                        Icons.edit,
                                                                        color: HexColor("#025393"),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: Text("Edit", style: TextStyle(
                                                                          fontFamily: "Poppins",
                                                                          fontSize: 14
                                                                      )),
                                                                      margin: EdgeInsets.only(left: 10),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              PopupMenuItem<int>(
                                                                value: 1,
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Container(
                                                                      child: Icon(
                                                                        Icons.close,
                                                                        color: HexColor("#025393"),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: Text("Atur Menjadi Tidak Aktif", style: TextStyle(
                                                                          fontFamily: "Poppins",
                                                                          fontSize: 14
                                                                      )),
                                                                      margin: EdgeInsets.only(left: 10),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                    height: 90,
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
                                                );
                                              },
                                            ),
                                          ),
                                        ) : Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Icon(
                                                  CupertinoIcons.person_alt,
                                                  size: 50,
                                                  color: Colors.black26,
                                                ),
                                              ),
                                              Container(
                                                child: Text("Tidak ada Data Panitia Kegiatan", style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black26
                                                ), textAlign: TextAlign.center),
                                                margin: EdgeInsets.only(top: 10),
                                                padding: EdgeInsets.symmetric(horizontal: 30),
                                              ),
                                              Container(
                                                child: Text("Tidak ada data panitia kegiatan. Anda bisa menambahkannya dengan cara menekan tombol Tambah Data Panitia dan isi data pada form yang telah disediakan", style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 14,
                                                    color: Colors.black26
                                                ), textAlign: TextAlign.center),
                                                padding: EdgeInsets.symmetric(horizontal: 30),
                                                margin: EdgeInsets.only(top: 10),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          child: TextField(
                                            controller: controllerSearchTidakAktif,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(50.0),
                                                    borderSide: BorderSide(color: HexColor("#025393"))
                                                ),
                                                hintText: "Cari nama, jabatan, atau asal banjar Prajuru Banjar Adat...",
                                                suffixIcon: isSearchTidakAktif ? IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: (){
                                                    setState(() {
                                                      LoadingTidakAktif = true;
                                                      controllerSearchTidakAktif.text = "";
                                                      isSearchTidakAktif = false;
                                                      refreshListPanitiaTidakAktif();
                                                    });
                                                  },
                                                ) : IconButton(
                                                  icon: Icon(Icons.search),
                                                  onPressed: (){
                                                    if(controllerSearchTidakAktif.text != "") {
                                                      setState(() {
                                                        isSearchTidakAktif = true;
                                                      });
                                                      refreshListSearchPanitiaTidakAktif();
                                                    }
                                                  },
                                                )
                                            ),
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14
                                            ),
                                          ),
                                          margin: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20)
                                      ),
                                      Container(
                                        child: LoadingTidakAktif ? ListTileShimmer() : availableDataTidakAktif ? Expanded(
                                          flex: 1,
                                          child: RefreshIndicator(
                                            onRefresh: isSearchTidakAktif ? refreshListSearchPanitiaTidakAktif : refreshListPanitiaTidakAktif,
                                            child: ListView.builder(
                                              itemCount: idPanitiaTidakAktif.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: (){},
                                                  child: Container(
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                child: Image.asset(
                                                                  'images/person.png',
                                                                  height: 40,
                                                                  width: 40,
                                                                ),
                                                              ),
                                                              Container(
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: <Widget>[
                                                                      Container(
                                                                        child: SizedBox(
                                                                          width: MediaQuery.of(context).size.width * 0.55,
                                                                          child: Text(
                                                                            "${namaPanitiaTidakAktif[index]}", style: TextStyle(
                                                                              fontFamily: "Poppins",
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: HexColor("#025393")
                                                                          ),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            softWrap: false,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child: SizedBox(
                                                                          width: MediaQuery.of(context).size.width * 0.55,
                                                                          child: Text(
                                                                            "${jabatanPanitiaTidakAktif[index]}", style: TextStyle(
                                                                              fontFamily: "Poppins",
                                                                              fontSize: 14,
                                                                              color: Colors.black
                                                                          ),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            softWrap: false,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child: SizedBox(
                                                                          width: MediaQuery.of(context).size.width * 0.55,
                                                                          child: Text(
                                                                            "${timKegiatanPanitiaTidakAktif[index]}", style: TextStyle(
                                                                              fontFamily: "Poppins",
                                                                              fontSize: 14,
                                                                              color: Colors.black26
                                                                          ),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            softWrap: false,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child: SizedBox(
                                                                          width: MediaQuery.of(context).size.width * 0.55,
                                                                          child: Text(
                                                                            "${periodeMulaiPanitiaTidakAktif[index].toString()} - ${periodeAkhirPanitiaTidakAktif[index].toString()}", style: TextStyle(
                                                                              fontFamily: "Poppins",
                                                                              fontSize: 14,
                                                                              color: Colors.black26
                                                                          ),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            softWrap: false,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  margin: EdgeInsets.only(left: 15)
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment.centerRight,
                                                          child: PopupMenuButton<int>(
                                                            onSelected: (item) {
                                                              onSelected(context, item);
                                                              selectedIdPanitia = idPanitiaTidakAktif[index];
                                                            },
                                                            itemBuilder: (context) => [
                                                              PopupMenuItem<int>(
                                                                value: 2,
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Container(
                                                                      child: Icon(
                                                                        Icons.done,
                                                                        color: HexColor("#025393"),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: Text("Atur Menjadi Aktif", style: TextStyle(
                                                                          fontFamily: "Poppins",
                                                                          fontSize: 14
                                                                      )),
                                                                      margin: EdgeInsets.only(left: 10),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                    height: 90,
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
                                                );
                                              },
                                            ),
                                          ),
                                        ) : Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Icon(
                                                  CupertinoIcons.person_alt,
                                                  size: 50,
                                                  color: Colors.black26,
                                                ),
                                              ),
                                              Container(
                                                child: Text("Tidak ada Data", style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black26
                                                ), textAlign: TextAlign.center),
                                                margin: EdgeInsets.only(top: 10),
                                                padding: EdgeInsets.symmetric(horizontal: 30),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]
                                  )
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch(item) {

      case 0:
        setState(() {
          editPanitiaDesaAdatAdmin.panitiaId = selectedIdPanitia;
        });
        Navigator.push(context, CupertinoPageRoute(builder: (context) => editPanitiaDesaAdatAdmin())).then((value) {
          refreshListPanitiaAktif();
          refreshListPanitiaTidakAktif();
        });
        break;

      case 1:
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
                        'images/question.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    Container(
                      child: Text("Atur Panitia Menjadi Tidak Aktif", style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: HexColor("#025393")
                      ), textAlign: TextAlign.center),
                      margin: EdgeInsets.only(top: 10),
                    ),
                    Container(
                      child: Text("Apakah Anda yakin ingin menonaktifkan panitia ini? Setelah panitia ini di non-aktifkan maka ia akan kehilangan hak akses login.", style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                      ), textAlign: TextAlign.center),
                      margin: EdgeInsets.only(top: 10),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: (){
                    var body = jsonEncode({
                      "panitia_desa_adat_id" : selectedIdPanitia
                    });
                    http.post(Uri.parse(apiURLSetPanitiaTidakAktif),
                      headers: {"Content-Type" : "application/json"},
                      body: body
                    ).then((http.Response response) {
                      var responseValue = response.statusCode;
                      if(responseValue == 200) {
                        refreshListPanitiaAktif();
                        refreshListPanitiaTidakAktif();
                        ftoast.showToast(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.green
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.done),
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.65,
                                    child: Text("Panitia Kegiatan berhasil dinonaktifkan", style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white
                                    )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          toastDuration: Duration(seconds: 3)
                        );
                        Navigator.of(context).pop();
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
        break;

      case 2:
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        'images/question.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    Container(
                      child: Text("Atur Panitia Menjadi Aktif", style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: HexColor("#025393")
                      ), textAlign: TextAlign.center),
                      margin: EdgeInsets.only(top: 10),
                    ),
                    Container(
                      child: Text("Apakah Anda yakin ingin mengaktifkan kembali panitia ini? Setelah panitia ini diaktifkan maka ia akan memperoleh hak akses loginnya kembali.", style: TextStyle(
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
                  onPressed: (){
                    setPanitiaAktif();
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
        break;
    }
  }
}