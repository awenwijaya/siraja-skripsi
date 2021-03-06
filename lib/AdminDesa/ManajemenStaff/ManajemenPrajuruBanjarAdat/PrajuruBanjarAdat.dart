import 'dart:convert';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:surat/AdminDesa/ManajemenStaff/ManajemenPrajuruBanjarAdat/DetailPrajuruBanjarAdat.dart';
import 'package:surat/AdminDesa/ManajemenStaff/ManajemenPrajuruBanjarAdat/EditPrajuruBanjarAdat.dart';
import 'package:surat/AdminDesa/ManajemenStaff/ManajemenPrajuruBanjarAdat/TambahPrajuruBanjarAdat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:surat/LoginAndRegistration/LoginPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class prajuruBanjarAdatAdmin extends StatefulWidget {
  const prajuruBanjarAdatAdmin({Key key}) : super(key: key);

  @override
  _prajuruBanjarAdatAdminState createState() => _prajuruBanjarAdatAdminState();
}

class _prajuruBanjarAdatAdminState extends State<prajuruBanjarAdatAdmin> {
  var prajuruBanjarAdatIDAktif = [];
  var namaPrajuruAktif = [];
  var namaBanjarAktif = [];
  var jabatanAktif = [];
  var pendudukIdAktif = [];
  var prajuruBanjarAdatIDTidakAktif = [];
  var namaPrajuruTidakAktif = [];
  var namaBanjarTidakAktif = [];
  var jabatanTidakAktif = [];
  var pendudukIdTidakAktif = [];
  bool LoadingAktif = true;
  bool LoadingTidakAktif = true;
  bool LoadingProses = false;
  bool availableDataTidakAktif = false;
  bool availableDataAktif = false;
  DateTime sekarang = DateTime.now();
  DateTime periodeAkhirPrajuru;
  var selectedIdPrajuruBanjarAdat;
  var selectedIdPenduduk;
  var apiURLShowListPrajuruBanjarAdatAktif = "https://siradaskripsi.my.id/api/data/staff/prajuru_banjar_adat/aktif/${loginPage.desaId}";
  var apiURLShowListPrajuruBanjarAdatTidakAktif =  "https://siradaskripsi.my.id/api/data/staff/prajuru_banjar_adat/tidak_aktif/${loginPage.desaId}";
  var apiURLDeletePrajuruBanjarAdat = "https://siradaskripsi.my.id/api/admin/prajuru/banjar_adat/delete";
  var apiURLSetPrajuruBanjarTidakAktif = "https://siradaskripsi.my.id/api/admin/prajuru/banjar_adat/set_tidak_aktif";
  var apiURLSetPrajuruBanjarAktif = "https://siradaskripsi.my.id/api/data/staff/prajuru_banjar_adat/set_aktif";
  var apiURLGetNamaBanjarFilter = "https://siradaskripsi.my.id/api/data/admin/prajuru_banjar_adat/filter/show_nama_banjar";
  var apiURLGetJabatanFilter = "https://siradaskripsi.my.id/api/data/admin/prajuru_banjar_adat/filter/show_jabatan";
  var apiURLShowFilterResult = "https://siradaskripsi.my.id/api/data/admin/prajuru_banjar_adat/filter/show_result";
  FToast ftoast;
  final controllerSearchAktif = TextEditingController();
  final controllerSearchTidakAktif = TextEditingController();

  List jabatanFilterAktif = List();
  List banjarFilterAktif = List();
  List jabatanFilterTidakAktif = List();
  List banjarFilterTidakAktif = List();
  var selectedJabatanFilterAktif;
  var selectedBanjarFilterAktif;
  var selectedJabatanFilterTidakAktif;
  var selectedBanjarFilterTidakAktif;
  bool LoadingFilterAktif = true;
  bool isFilterAktif = false;
  bool LoadingFilterTidakAktif = true;
  bool isFilterTidakAktif = false;

  //search
  bool isSearch = false;
  var apiURLSearchAktif = "https://siradaskripsi.my.id/api/admin/staff/prajuru_banjar_adat/aktif/${loginPage.desaId}/search";

  //search tidak aktif
  bool isSearchTidakAktif = false;
  var apiURLSearchTidakAktif = "https://siradaskripsi.my.id/api/admin/staff/prajuru_banjar_adat/tidak_aktif/${loginPage.desaId}/search";

  Future getFilterKomponenAktif() async{
    var body = jsonEncode({
      "status" : "aktif",
      "desa_adat_id" : loginPage.desaId
    });
    http.post(Uri.parse(apiURLGetNamaBanjarFilter),
      headers: {"Content-Type" : "application/json"},
      body: body
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          banjarFilterAktif = jsonData;
        });
      }
    });
    http.post(Uri.parse(apiURLGetJabatanFilter),
        headers: {"Content-Type" : "application/json"},
        body: body
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          jabatanFilterAktif = jsonData;
        });
      }
    });
    LoadingFilterAktif = false;
  }

  Future getFilterKomponenTidakAktif() {
    var body = jsonEncode({
      "status" : "tidak aktif",
      "desa_adat_id" : loginPage.desaId
    });
    http.post(Uri.parse(apiURLGetNamaBanjarFilter),
        headers: {"Content-Type" : "application/json"},
        body: body
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          banjarFilterTidakAktif = jsonData;
        });
      }
    });
    http.post(Uri.parse(apiURLGetJabatanFilter),
        headers: {"Content-Type" : "application/json"},
        body: body
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          jabatanFilterTidakAktif = jsonData;
        });
      }
    });
    LoadingFilterTidakAktif = false;
  }

  Future refreshListPrajuruBanjarAdatAktif() async {
    Uri uri = Uri.parse(apiURLShowListPrajuruBanjarAdatAktif);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      var data = json.decode(response.body);
      this.prajuruBanjarAdatIDAktif = [];
      this.namaPrajuruAktif = [];
      this.jabatanAktif = [];
      this.namaBanjarAktif = [];
      this.pendudukIdAktif = [];
      setState(() {
        LoadingAktif = false;
        availableDataAktif = true;
        for(var i = 0; i < data.length; i++) {
          this.prajuruBanjarAdatIDAktif.add(data[i]['prajuru_banjar_adat_id']);
          this.namaPrajuruAktif.add(data[i]['nama']);
          this.jabatanAktif.add(data[i]['jabatan']);
          this.namaBanjarAktif.add(data[i]['nama_banjar_adat']);
          this.pendudukIdAktif.add(data[i]['penduduk_id']);
        }
      });
    }else{
      setState(() {
        LoadingAktif = false;
        availableDataAktif = false;
      });
    }
  }

  Future refreshListPrajuruBanjarAdatTidakAktif() async {
    Uri uri = Uri.parse(apiURLShowListPrajuruBanjarAdatTidakAktif);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      var data = json.decode(response.body);
      this.prajuruBanjarAdatIDTidakAktif = [];
      this.namaPrajuruTidakAktif = [];
      this.jabatanTidakAktif = [];
      this.namaBanjarTidakAktif = [];
      this.pendudukIdTidakAktif = [];
      setState(() {
        LoadingTidakAktif = false;
        availableDataTidakAktif = true;
        for(var i = 0; i < data.length; i++) {
          this.prajuruBanjarAdatIDTidakAktif.add(data[i]['prajuru_banjar_adat_id']);
          this.namaPrajuruTidakAktif.add(data[i]['nama']);
          this.jabatanTidakAktif.add(data[i]['jabatan']);
          this.namaBanjarTidakAktif.add(data[i]['nama_banjar_adat']);
          this.pendudukIdTidakAktif.add(data[i]['penduduk_id']);
        }
      });
    }else{
      setState(() {
        LoadingTidakAktif = false;
        availableDataTidakAktif = false;
      });
    }
  }

  Future showFilterResultAktif() async {
    setState(() {
      LoadingAktif = true;
      isFilterAktif = true;
    });
    var body = jsonEncode({
      "filter_jabatan" : selectedJabatanFilterAktif == null ? null : selectedJabatanFilterAktif,
      "filter_banjar" : selectedBanjarFilterAktif == null ? null : selectedBanjarFilterAktif,
      "desa_adat_id" : loginPage.desaId,
      "search_query" : controllerSearchAktif.text,
      "status" : "aktif"
    });
    http.post(Uri.parse(apiURLShowFilterResult),
        headers: {"Content-Type" : "application/json"},
        body: body
    ).then((http.Response response) async {
      var statusCode = response.statusCode;
      if(statusCode == 200) {
        var data = json.decode(response.body);
        this.prajuruBanjarAdatIDAktif = [];
        this.namaPrajuruAktif = [];
        this.jabatanAktif = [];
        this.namaBanjarAktif = [];
        this.pendudukIdAktif = [];
        setState(() {
          LoadingAktif = false;
          availableDataAktif = true;
          for(var i = 0; i < data.length; i++) {
            this.prajuruBanjarAdatIDAktif.add(data[i]['prajuru_banjar_adat_id']);
            this.namaPrajuruAktif.add(data[i]['nama']);
            this.jabatanAktif.add(data[i]['jabatan']);
            this.namaBanjarAktif.add(data[i]['nama_banjar_adat']);
            this.pendudukIdAktif.add(data[i]['penduduk_id']);
          }
        });
      }else {
        setState(() {
          LoadingAktif = false;
          availableDataAktif = false;
        });
      }
    });
  }

  Future showFilterResultTidakAktif() async {
    setState(() {
      isFilterTidakAktif = true;
      LoadingTidakAktif = true;
    });
    var body = jsonEncode({
      "filter_jabatan" : selectedJabatanFilterTidakAktif == null ? null : selectedJabatanFilterTidakAktif,
      "filter_banjar" : selectedBanjarFilterTidakAktif == null ? null : selectedBanjarFilterTidakAktif,
      "desa_adat_id" : loginPage.desaId,
      "status" : "tidak aktif",
      "search_query" : controllerSearchTidakAktif.text
    });
    http.post(Uri.parse(apiURLShowFilterResult),
        headers: {"Content-Type" : "application/json"},
        body: body
    ).then((http.Response response) async {
      var statusCode = response.statusCode;
      if(response.statusCode == 200) {
        var data = json.decode(response.body);
        this.prajuruBanjarAdatIDTidakAktif = [];
        this.namaPrajuruTidakAktif = [];
        this.jabatanTidakAktif = [];
        this.namaBanjarTidakAktif = [];
        this.pendudukIdTidakAktif = [];
        setState(() {
          LoadingTidakAktif = false;
          availableDataTidakAktif = true;
          for(var i = 0; i < data.length; i++) {
            this.prajuruBanjarAdatIDTidakAktif.add(data[i]['prajuru_banjar_adat_id']);
            this.namaPrajuruTidakAktif.add(data[i]['nama']);
            this.jabatanTidakAktif.add(data[i]['jabatan']);
            this.namaBanjarTidakAktif.add(data[i]['nama_banjar_adat']);
            this.pendudukIdTidakAktif.add(data[i]['penduduk_id']);
          }
        });
      }else{
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
    refreshListPrajuruBanjarAdatAktif();
    refreshListPrajuruBanjarAdatTidakAktif();
    getFilterKomponenAktif();
    getFilterKomponenTidakAktif();
    ftoast = FToast();
    ftoast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: HexColor("#025393"),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                title: Text("Prajuru Banjar Adat", style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: HexColor("#025393")
                )),
              bottom: TabBar(
                labelColor: HexColor("#025393"),
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(child: Column(
                    children: <Widget>[
                      Icon(Icons.done, color: HexColor("228B22")),
                      Text("Aktif", style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700
                      ))
                    ],
                  )),
                  Tab(child: Column(
                    children: <Widget>[
                      Icon(Icons.close, color: HexColor("990000")),
                      Text("Tidak Aktif", style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700
                      ))
                    ],
                  ))
                ],
              )
            ),
            body: TabBarView(
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
                                      hintText: "Cari Prajuru Banjar Adat...",
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.search),
                                        onPressed: (){
                                          if(controllerSearchAktif.text != "") {
                                            setState(() {
                                              isFilterAktif = true;
                                            });
                                            showFilterResultAktif();
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
                              child: LoadingFilterAktif ? ListTileShimmer() : Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(width: 1, color: Colors.black38)
                                          ),
                                          child: DropdownButton(
                                            isExpanded: true,
                                            hint: Center(
                                                child: Text("Semua Jabatan", style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 14
                                                ))
                                            ),
                                            value: selectedJabatanFilterAktif,
                                            underline: Container(),
                                            items: jabatanFilterAktif.map((jabatan) {
                                              return DropdownMenuItem(
                                                  value: jabatan['jabatan_prajuru_banjar_id'],
                                                  child: Text("${jabatan['jabatan']}", style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 14
                                                  ))
                                              );
                                            }).toList(),
                                            selectedItemBuilder: (BuildContext context) => jabatanFilterAktif.map((jabatan) => Center(
                                                child: Text("${jabatan['jabatan']}", style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 14
                                                ))
                                            )).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedJabatanFilterAktif = value;
                                              });
                                              showFilterResultAktif();
                                            },
                                          ),
                                          margin: EdgeInsets.symmetric(horizontal: 5),
                                        )
                                    ),
                                    Flexible(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(width: 1, color: Colors.black38)
                                          ),
                                          child: DropdownButton(
                                            onChanged: (value) {
                                              setState(() {
                                                selectedBanjarFilterAktif = value;
                                              });
                                              showFilterResultAktif();
                                            },
                                            value: selectedBanjarFilterAktif,
                                            underline: Container(),
                                            hint: Center(
                                              child: Text("Semua Banjar", style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14
                                              )),
                                            ),
                                            isExpanded: true,
                                            items: banjarFilterAktif.map((banjar) {
                                              return DropdownMenuItem(
                                                  value: banjar['banjar_adat_id'],
                                                  child: Text("${banjar['nama_banjar_adat']}", style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 14
                                                  ))
                                              );
                                            }).toList(),
                                            selectedItemBuilder: (BuildContext context) => banjarFilterAktif.map((banjar) => Center(
                                              child: Text(banjar['nama_banjar_adat'], style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Poppins"
                                              )),
                                            )).toList(),
                                          ),
                                          margin: EdgeInsets.symmetric(horizontal: 5),
                                        )
                                    )
                                  ],
                                ),
                                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  if(isSearch == true) Container(
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          LoadingAktif = true;
                                          controllerSearchAktif.text = "";
                                          isSearch = false;
                                          refreshListPrajuruBanjarAdatAktif();
                                        });
                                      },
                                      child: Text("Reset Pencarian", style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white
                                      )),
                                      color: HexColor("#025393"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          side: BorderSide(color: HexColor("#025393"), width: 2)
                                      ),
                                    ),
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: <Widget>[
                                  if(isFilterAktif == true) Container(
                                    child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          isFilterAktif = false;
                                          selectedJabatanFilterAktif = null;
                                          selectedBanjarFilterAktif = null;
                                          controllerSearchAktif.text = "";
                                          LoadingAktif = true;
                                        });
                                        refreshListPrajuruBanjarAdatAktif();
                                      },
                                      child: Text("Hapus Filter", style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white
                                      )),
                                      color: HexColor("#025393"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          side: BorderSide(color: HexColor("#025393"), width: 2)
                                      ),
                                    ),
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                child: LoadingAktif ? ListTileShimmer() : availableDataAktif ? Expanded(
                                    flex: 1,
                                    child: RefreshIndicator(
                                        onRefresh: isFilterAktif ? showFilterResultAktif : refreshListPrajuruBanjarAdatAktif,
                                        child: ListView.builder(
                                            itemCount: prajuruBanjarAdatIDAktif.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      detailPrajuruBanjarAdatAdmin.prajuruBanjarAdatId = prajuruBanjarAdatIDAktif[index];
                                                    });
                                                    Navigator.push(context, CupertinoPageRoute(builder: (context) => detailPrajuruBanjarAdatAdmin()));
                                                  },
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
                                                                              width: 40
                                                                          )
                                                                      ),
                                                                      Container(
                                                                          child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Container(
                                                                                    child: SizedBox(
                                                                                        width: MediaQuery.of(context).size.width * 0.55,
                                                                                        child: Text("${namaPrajuruAktif[index]}", style: TextStyle(
                                                                                            fontFamily: "Poppins",
                                                                                            fontSize: 16,
                                                                                            fontWeight: FontWeight.w700,
                                                                                            color: HexColor("#025393")
                                                                                        ), maxLines: 1,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            softWrap: false
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                Container(
                                                                                    child: Text("${jabatanAktif[index]}", style: TextStyle(
                                                                                        fontFamily: "Poppins",
                                                                                        fontSize: 14
                                                                                    ))
                                                                                ),
                                                                                Container(
                                                                                    child: Text("Banjar: ${namaBanjarAktif[index]}", style: TextStyle(
                                                                                        fontFamily: "Poppins",
                                                                                        fontSize: 14
                                                                                    ))
                                                                                )
                                                                              ]
                                                                          ),
                                                                          margin: EdgeInsets.only(left: 15)
                                                                      )
                                                                    ]
                                                                )
                                                            ),
                                                            Container(
                                                                alignment: Alignment.centerRight,
                                                                child: PopupMenuButton<int>(
                                                                    onSelected: (item) {
                                                                      setState(() {
                                                                        selectedIdPrajuruBanjarAdat = prajuruBanjarAdatIDAktif[index];
                                                                        selectedIdPenduduk = pendudukIdAktif[index];
                                                                      });
                                                                      onSelected(context, item);
                                                                    },
                                                                    itemBuilder: (context) => [
                                                                      PopupMenuItem<int>(
                                                                          value: 0,
                                                                          child: Row(
                                                                              children: <Widget>[
                                                                                Container(
                                                                                    child: Icon(
                                                                                        Icons.edit,
                                                                                        color: HexColor("#025393")
                                                                                    )
                                                                                ),
                                                                                Container(
                                                                                    child: Text("Edit", style: TextStyle(
                                                                                        fontFamily: "Poppins",
                                                                                        fontSize: 14
                                                                                    )),
                                                                                    margin: EdgeInsets.only(left: 10)
                                                                                )
                                                                              ]
                                                                          )
                                                                      ),
                                                                      PopupMenuItem<int>(
                                                                          value: 2,
                                                                          child: Row(
                                                                              children: <Widget>[
                                                                                Container(
                                                                                    child: Icon(
                                                                                        Icons.close,
                                                                                        color: HexColor("#025393")
                                                                                    )
                                                                                ),
                                                                                Container(
                                                                                    child: Text("Atur Menjadi Tidak Aktif", style: TextStyle(
                                                                                        fontFamily: "Poppins",
                                                                                        fontSize: 14
                                                                                    )),
                                                                                    margin: EdgeInsets.only(left: 10)
                                                                                )
                                                                              ]
                                                                          )
                                                                      ),
                                                                    ]
                                                                )
                                                            )
                                                          ]
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
                                                  )
                                              );
                                            }
                                        )
                                    )
                                ) : Container(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              child: Icon(
                                                CupertinoIcons.person_alt,
                                                size: 50,
                                                color: Colors.black26,
                                              )
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
                                        ]
                                    ),
                                  margin: EdgeInsets.only(top: 40),
                                )
                            )
                          ]
                      )
                  ),
                  Container(
                      child: Container(
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
                                          hintText: "Cari Prajuru Banjar Adat...",
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.search),
                                            onPressed: (){
                                              if(controllerSearchTidakAktif.text != "") {
                                                setState(() {
                                                  isFilterTidakAktif = true;
                                                });
                                                showFilterResultTidakAktif();
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
                                  child: LoadingFilterTidakAktif ? ListTileShimmer() : Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Flexible(
                                          child: Container(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                border: Border.all(width: 1, color: Colors.black38)
                                              ),
                                              child: DropdownButton(
                                                isExpanded: true,
                                                hint: Center(
                                                  child: Text("Semua Jabatan", style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 14
                                                  )),
                                                ),
                                                value: selectedJabatanFilterTidakAktif,
                                                underline: Container(),
                                                items: jabatanFilterTidakAktif.map((jabatan) {
                                                  return DropdownMenuItem(
                                                    value: jabatan['jabatan_prajuru_banjar_id'],
                                                    child: Text(jabatan['jabatan'], style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 14
                                                    )),
                                                  );
                                                }).toList(),
                                                selectedItemBuilder: (BuildContext context) => jabatanFilterTidakAktif.map((jabatan) => Center(
                                                  child: Text("${jabatan['jabatan']}", style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 14
                                                  )),
                                                )).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedJabatanFilterTidakAktif = value;
                                                  });
                                                  showFilterResultTidakAktif();
                                                },
                                              ),
                                              margin: EdgeInsets.symmetric(horizontal: 5),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(width: 1, color: Colors.black38)
                                            ),
                                            child: DropdownButton(
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedBanjarFilterTidakAktif = value;
                                                });
                                                showFilterResultTidakAktif();
                                              },
                                              value: selectedBanjarFilterTidakAktif,
                                              underline: Container(),
                                              hint: Center(
                                                child: Text("Semua Banjar", style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14
                                                )),
                                              ),
                                              isExpanded: true,
                                              items: banjarFilterTidakAktif.map((banjar) {
                                                return DropdownMenuItem(
                                                  value: banjar['banjar_adat_id'],
                                                  child: Text("${banjar['nama_banjar_adat']}", style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 14
                                                  )),
                                                );
                                              }).toList(),
                                              selectedItemBuilder: (BuildContext context) => banjarFilterTidakAktif.map((banjar) => Center(
                                                child: Text("${banjar['nama_banjar_adat']}", style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14
                                                )),
                                              )).toList(),
                                            ),
                                            margin: EdgeInsets.symmetric(horizontal: 5),
                                          ),
                                        )
                                      ],
                                    ),
                                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                  )
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      if(isSearchTidakAktif == true) Container(
                                        child: FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              setState(() {
                                                LoadingTidakAktif = true;
                                                controllerSearchTidakAktif.text = "";
                                                isSearchTidakAktif = false;
                                                refreshListPrajuruBanjarAdatTidakAktif();
                                              });
                                            });
                                          },
                                          child: Text("Reset Pencarian", style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white
                                          )),
                                          color: HexColor("025393"),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            side: BorderSide(color: HexColor("025393"), width: 2)
                                          ),
                                        ),
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      if(isFilterTidakAktif == true) Container(
                                        child: FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              selectedJabatanFilterTidakAktif = null;
                                              selectedBanjarFilterTidakAktif = null;
                                              controllerSearchTidakAktif.text = "";
                                            });
                                            if(isFilterTidakAktif == true) {
                                              setState(() {
                                                LoadingTidakAktif = true;
                                                isFilterTidakAktif = false;
                                              });
                                              refreshListPrajuruBanjarAdatTidakAktif();
                                            }
                                          },
                                          child: Text("Hapus Filter", style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white
                                          )),
                                          color: HexColor("#025393"),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              side: BorderSide(color: HexColor("#025393"), width: 2)
                                          ),
                                        ),
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: LoadingTidakAktif ? ListTileShimmer() : availableDataTidakAktif ? Expanded(
                                    flex: 1,
                                    child: RefreshIndicator(
                                        onRefresh: isFilterTidakAktif ? showFilterResultTidakAktif : refreshListPrajuruBanjarAdatTidakAktif,
                                        child: ListView.builder(
                                            itemCount: prajuruBanjarAdatIDTidakAktif.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      detailPrajuruBanjarAdatAdmin.prajuruBanjarAdatId = prajuruBanjarAdatIDTidakAktif[index];
                                                    });
                                                    Navigator.push(context, CupertinoPageRoute(builder: (context) => detailPrajuruBanjarAdatAdmin()));
                                                  },
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
                                                                              width: 40
                                                                          )
                                                                      ),
                                                                      Container(
                                                                          child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Container(
                                                                                    child: SizedBox(
                                                                                        width: MediaQuery.of(context).size.width * 0.55,
                                                                                        child: Text("${namaPrajuruTidakAktif[index]}", style: TextStyle(
                                                                                            fontFamily: "Poppins",
                                                                                            fontSize: 16,
                                                                                            fontWeight: FontWeight.w700,
                                                                                            color: HexColor("#025393")
                                                                                        ), maxLines: 1,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            softWrap: false
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                Container(
                                                                                    child: Text("${jabatanTidakAktif[index]}", style: TextStyle(
                                                                                        fontFamily: "Poppins",
                                                                                        fontSize: 14
                                                                                    ))
                                                                                ),
                                                                                Container(
                                                                                    child: Text("Banjar: ${namaBanjarTidakAktif[index]}", style: TextStyle(
                                                                                        fontFamily: "Poppins",
                                                                                        fontSize: 14
                                                                                    ))
                                                                                )
                                                                              ]
                                                                          ),
                                                                          margin: EdgeInsets.only(left: 15)
                                                                      )
                                                                    ]
                                                                )
                                                            ),
                                                            Container(
                                                              alignment: Alignment.centerRight,
                                                              child: PopupMenuButton<int>(
                                                                onSelected: (item) {
                                                                  onSelected(context, item);
                                                                  selectedIdPrajuruBanjarAdat = prajuruBanjarAdatIDTidakAktif[index];
                                                                },
                                                                itemBuilder: (context) => [
                                                                  PopupMenuItem<int>(
                                                                    value: 3,
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          child: Icon(
                                                                            Icons.done,
                                                                            color: HexColor("025393")
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
                                                          ]
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
                                                  )
                                              );
                                            }
                                        )
                                    ),
                                  ) : Container(
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                child: Icon(
                                                    CupertinoIcons.person_alt,
                                                    size: 50,
                                                    color: Colors.black26
                                                )
                                            ),
                                            Container(
                                                child: Text("Tidak ada Data", style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black26
                                                ), textAlign: TextAlign.center),
                                                margin: EdgeInsets.only(top: 10)
                                            )
                                          ]
                                      ),
                                    margin: EdgeInsets.only(top: 40),
                                  ),
                                )
                              ]
                          )
                      )
                  )
                ]
            ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.push(context, CupertinoPageRoute(builder: (context) => tambahPrajuruBanjarAdatAdmin())).then((value) {
                refreshListPrajuruBanjarAdatAktif();
                refreshListPrajuruBanjarAdatTidakAktif();
                isFilterAktif = false;
                selectedJabatanFilterAktif = null;
                selectedBanjarFilterAktif = null;
              });
            },
            child: Icon(Icons.add),
            backgroundColor: HexColor("025393"),
          ),
        ),
      )
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        setState(() {
          isSearch = false;
          isSearchTidakAktif = false;
          controllerSearchAktif.text = "";
          controllerSearchTidakAktif.text = "";
          editPrajuruBanjarAdatAdmin.idPegawai = selectedIdPrajuruBanjarAdat;
        });
        Navigator.push(context, CupertinoPageRoute(builder: (context) => editPrajuruBanjarAdatAdmin())).then((value) {
          refreshListPrajuruBanjarAdatAktif();
          refreshListPrajuruBanjarAdatTidakAktif();
          getFilterKomponenAktif();
          getFilterKomponenTidakAktif();
        });
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        child: Image.asset(
                          'images/question.png',
                          height: 50,
                          width: 50,
                        )
                    ),
                    Container(
                        child: Text("Atur Prajuru Menjadi Tidak Aktif", style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: HexColor("#025393")
                        ), textAlign: TextAlign.center),
                        margin: EdgeInsets.only(top: 10)
                    ),
                    Container(
                      child: Text("Apakah Anda yakin ingin menonaktifkan Prajuru ini? Setelah Prajuru di non-aktifkan maka ia akan kehilangan hak akses login", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14
                      ), textAlign: TextAlign.center),
                      margin: EdgeInsets.only(top: 10),
                    )
                  ]
                )
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: (){
                    var body = jsonEncode({
                      "prajuru_banjar_adat_id" : selectedIdPrajuruBanjarAdat,
                      "penduduk_id" : selectedIdPenduduk
                    });
                    http.post(Uri.parse(apiURLSetPrajuruBanjarTidakAktif),
                      headers: {"Content-Type" : "application/json"},
                      body: body
                    ).then((http.Response response) {
                      var responseValue = response.statusCode;
                      if(responseValue == 200) {
                        isSearch = false;
                        isSearchTidakAktif = false;
                        controllerSearchAktif.text = "";
                        controllerSearchTidakAktif.text = "";
                        isSearch = false;
                        isSearchTidakAktif = false;
                        controllerSearchAktif.text = "";
                        controllerSearchTidakAktif.text = "";
                        refreshListPrajuruBanjarAdatAktif();
                        refreshListPrajuruBanjarAdatTidakAktif();
                        getFilterKomponenAktif();
                        getFilterKomponenTidakAktif();
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
                                      child: Text("Prajuru Banjar Adat berhasil dinonaktifkan", style: TextStyle(
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
                  ))
                ),
                TextButton(
                  onPressed: (){Navigator.of(context).pop();},
                  child: Text("Tidak", style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: HexColor("#025393")
                  ))
                )
              ]
            );
          }
        );
        break;

      case 3:
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
                      child: Text("Atur Prajuru Menjadi Aktif", style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: HexColor("025393")
                      ), textAlign: TextAlign.center),
                      margin: EdgeInsets.only(top: 10),
                    ),
                    Container(
                      child: Text("Apakah Anda yakin ingin mengaktifkan kembali Prajuru ini? Setelah Prajuru di aktifkan maka ia akan mendapatkan kembali hak akses login", style: TextStyle(
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
                    Uri uri = Uri.parse("https://siradaskripsi.my.id/api/data/staff/prajuru_banjar_adat/periode_akhir/$selectedIdPrajuruBanjarAdat");
                    final response = await http.get(uri);
                    if(response.statusCode == 200) {
                      var data = json.decode(response.body);
                      setState(() {
                        periodeAkhirPrajuru = DateTime.parse(data['tanggal_akhir_menjabat']);
                        print(periodeAkhirPrajuru.toString());
                      });
                      if(periodeAkhirPrajuru.isBefore(sekarang)) {
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
                                    child: Text("Tidak dapat mengaktifkan kembali Prajuru karena periode menjabat telah berakhir", style: TextStyle(
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
                          "prajuru_banjar_adat_id" : selectedIdPrajuruBanjarAdat
                        });
                        http.post(Uri.parse(apiURLSetPrajuruBanjarAktif),
                          headers: {"Content-Type" : "application/json"},
                          body: body
                        ).then((http.Response response) {
                          if(response.statusCode == 200) {
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
                                        child: Text("Prajuru Banjar Adat berhasil diaktifkan kembali", style: TextStyle(
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
                            refreshListPrajuruBanjarAdatAktif();
                            refreshListPrajuruBanjarAdatTidakAktif();
                            getFilterKomponenAktif();
                            getFilterKomponenTidakAktif();
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    }
                  },
                  child: Text("Ya", style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: HexColor("025393")
                  )),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("Tidak", style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: HexColor("025393")
                  )),
                )
              ],
            );
          }
        );
    }
  }
}