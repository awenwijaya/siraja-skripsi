import 'dart:convert';
import 'package:surat/AdminDesa/ManajemenStaff/ManajemenPrajuruBanjarAdat/DetailPrajuruBanjarAdat.dart';
import 'package:surat/LoginAndRegistration/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class prajuruBanjarAdatAdmin extends StatefulWidget {
  const prajuruBanjarAdatAdmin({Key key}) : super(key: key);

  @override
  _prajuruBanjarAdatAdminState createState() => _prajuruBanjarAdatAdminState();
}

class _prajuruBanjarAdatAdminState extends State<prajuruBanjarAdatAdmin> {
  var prajuruBanjarAdatID = [];
  var namaPrajuru = [];
  var namaBanjar = [];
  bool Loading = true;
  bool LoadingProses = false;
  bool availableData = false;
  var apiURLShowListPrajuruBanjarAdat = "http://192.168.18.10:8000/api/data/staff/prajuru_banjar_adat/325";

  Future refreshListPrajuruBanjarAdat() async {
    Uri uri = Uri.parse(apiURLShowListPrajuruBanjarAdat);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      var data = json.decode(response.body);
      this.prajuruBanjarAdatID = [];
      this.namaPrajuru = [];
      this.namaBanjar = [];
      setState(() {
        Loading = false;
        availableData = true;
        for(var i = 0; i < data.length; i++) {
          this.prajuruBanjarAdatID.add(data[i]['prajuru_banjar_adat_id']);
          this.namaPrajuru.add(data[i]['nama']);
          this.namaBanjar.add(data[i]['nama_banjar_adat']);
        }
      });
    }else{
      setState(() {
        Loading = false;
        availableData = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshListPrajuruBanjarAdat();
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
          title: Text("Pegawai Banjar Adat", style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            color: HexColor("#025393")
          ))
        ),
        body: Loading ? Center(
          child: Lottie.asset('assets/loading-circle.json')
        ) : availableData ? RefreshIndicator(
          onRefresh: refreshListPrajuruBanjarAdat,
          child: ListView.builder(
            itemCount: prajuruBanjarAdatID.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  setState(() {
                    detailPrajuruBanjarAdatAdmin.prajuruBanjarAdatId = prajuruBanjarAdatID[index];
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
                                    child: Text("${namaPrajuru[index]}", style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor("#025393")
                                    ))
                                  ),
                                  Container(
                                    child: Text("${namaBanjar[index]}", style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700
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
                          itemBuilder: (context) => [
                            PopupMenuItem(
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
                            PopupMenuItem(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      Icons.delete,
                                      color: HexColor("#025393")
                                    )
                                  ),
                                  Container(
                                    child: Text("Hapus", style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14
                                    )),
                                    margin: EdgeInsets.only(left: 10)
                                  )
                                ]
                              )
                            )
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
        ) : Container(
          child: Center(
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
                  child: Text("Tidak ada Data Pegawai Banjar Adat", style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black26
                  ), textAlign: TextAlign.center),
                  margin: EdgeInsets.only(top: 10)
                ),
                Container(
                  child: Text("Tidak ada data pegawai Banjar Adat. Anda bisa menambahkannya dengan cara menekan tombol + dan isi data pegawai Banjar Adat pada form yang telah disediakan", style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    color: Colors.black26
                  ), textAlign: TextAlign.center),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  margin: EdgeInsets.only(top: 10)
                )
              ]
            )
          ),
          alignment: Alignment(0.0, 0.0)
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){},
          child: Icon(Icons.add),
          backgroundColor: HexColor("#025393"),
        ),
      )
    );
  }
}