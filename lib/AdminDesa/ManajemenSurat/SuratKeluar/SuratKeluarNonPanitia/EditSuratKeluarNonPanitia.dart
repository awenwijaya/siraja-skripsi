import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:surat/AdminDesa/Dashboard.dart';
import 'package:surat/LoginAndRegistration/LoginPage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:surat/shared/LoadingAnimation/loading.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class editSuratKeluarNonPanitia extends StatefulWidget {
  static var idSuratKeluar;
  const editSuratKeluarNonPanitia({Key key}) : super(key: key);

  @override
  State<editSuratKeluarNonPanitia> createState() => _editSuratKeluarNonPanitiaState();
}

class _editSuratKeluarNonPanitiaState extends State<editSuratKeluarNonPanitia> {
  var apiURLShowDataEditSuratKeluar = "https://siradaskripsi.my.id/api/admin/surat/keluar/panitia/edit/${editSuratKeluarNonPanitia.idSuratKeluar}";
  var apiURLShowDataNomorSuratKeluarEdit = "https://siradaskripsi.my.id/api/admin/surat/keluar/panitia/edit/nomor_surat/${editSuratKeluarNonPanitia.idSuratKeluar}";
  var apiURLShowKodeSurat = "https://siradaskripsi.my.id/api/data/admin/surat/non-panitia/kode/${loginPage.desaId}";
  var apiURLGetDataBendesaAdat = "https://siradaskripsi.my.id/api/data/staff/prajuru/desa_adat/bendesa/${loginPage.desaId}";
  var apiURLGetDataPenyarikan = "https://siradaskripsi.my.id/api/data/staff/prajuru/desa_adat/penyarikan/${loginPage.desaId}";
  var apiURLShowPrajuru = "https://siradaskripsi.my.id/api/data/admin/surat/keluar/prajuru/${editSuratKeluarNonPanitia.idSuratKeluar}";
  var apiURLSimpanEditSuratKeluar = "https://siradaskripsi.my.id/api/admin/surat/keluar/non-panitia/edit/up";
  var apiURLShowKomponenNomorSurat = "https://siradaskripsi.my.id/api/data/admin/surat/nomor_surat/${loginPage.desaId}";
  var apiURLGetLampiran = "https://siradaskripsi.my.id/api/data/admin/surat/keluar/lampiran/${editSuratKeluarNonPanitia.idSuratKeluar}";
  var apiURLGetKelihanAdat = "https://siradaskripsi.my.id/api/data/staff/prajuru_banjar_adat/kelihan_adat/${loginPage.desaId}";
  var apiURLGetBendesa = "https://siradaskripsi.my.id/api/data/staff/prajuru_desa_adat/bendesa/${loginPage.desaId}";
  var apiURLGetTetujonPrajuruDesa = "https://siradaskripsi.my.id/api/data/surat/keluar/tetujon/prajuru/desa/${editSuratKeluarNonPanitia.idSuratKeluar}";
  var apiURLGetTetujonPrajuruBanjar = "https://siradaskripsi.my.id/api/data/surat/keluar/tetujon/prajuru/banjar/${editSuratKeluarNonPanitia.idSuratKeluar}";
  var apiURLGetTetujonPihakLain = "https://siradaskripsi.my.id/api/data/surat/keluar/tetujon/pihak-lain/${editSuratKeluarNonPanitia.idSuratKeluar}";
  var apiURLGetTumusanPrajuruDesa = "https://siradaskripsi.my.id/api/data/surat/keluar/tumusan/prajuru/desa/${editSuratKeluarNonPanitia.idSuratKeluar}";
  var apiURLGetTumusanPrajuruBanjar = "https://siradaskripsi.my.id/api/data/surat/keluar/tumusan/prajuru/banjar/${editSuratKeluarNonPanitia.idSuratKeluar}";
  var apiURLGetTumusanPihakLain = "https://siradaskripsi.my.id/api/data/surat/keluar/tumusan/pihak-lain/${editSuratKeluarNonPanitia.idSuratKeluar}";

  //url tetujon, tumusan, lampiran
  var apiURLUpTetujonPihakLain = "https://siradaskripsi.my.id/api/admin/surat/keluar/tetujon/pihak-lain/up";
  var apiURLUpTumusanPihakLain = "https://siradaskripsi.my.id/api/admin/surat/keluar/tumusan/pihak-lain/up";
  var apiURLUpTetujonPrajuruBanjar = "https://siradaskripsi.my.id/api/admin/surat/keluar/tetujon/banjar/up";
  var apiURLUpTumusanPrajuruBanjar = "https://siradaskripsi.my.id/api/admin/surat/keluar/tumusan/banjar/up";
  var apiURLUpTetujonPrajuruDesa = "https://siradaskripsi.my.id/api/admin/surat/keluar/tetujon/desa/up";
  var apiURLUpTumusanPrajuruDesa = "https://siradaskripsi.my.id/api/admin/surat/keluar/tumusan/desa/up";
  var apiURLUpLampiran = "https://siradaskripsi.my.id/api/upload/lampiran";
  var apiURLSaveEditLampiran = "https://siradaskripsi.my.id/api/admin/surat/keluar/lampiran/edit/up";

  //kodesurat
  var nomorUrutSurat;
  var kodeDesa;
  var bulan;
  var tahun;
  var statusSurat;

  //loading indicator
  bool LoadingData = true;
  bool KodeSuratLoading = true;
  bool Loading = false;
  bool LoadingPenyarikan = true;
  bool LoadingBendesa = true;
  bool NomorSuratLoading = false;
  bool isVisible = true;
  bool isSendToKrama = false;

  //selected
  var selectedKodeSurat;
  var selectedBendesaAdat;
  var selectedPenyarikan;
  File file;
  String namaFile;
  String filePath;

  //list
  List kodeSuratList = List();
  List bendesaList = List();
  List penyarikanList = List();

  List lampiran = [];
  List fileName = [];
  List lampiranUploadName = [];

  //get tetujon
  List prajuruDesaList = List();
  List prajuruBanjarList = [];
  List selectedKelihanAdat = [];
  List selectedBendesa = [];

  List selectedKelihanAdatTumusan = [];
  List selectedBendesaTumusan = [];

  List pihakLain = [];
  List pihakLainTumusan = [];

  //komponen surat keluar
  final controllerNomorSurat = TextEditingController();
  final controllerLepihan = TextEditingController();
  final controllerParindikan = TextEditingController();
  final controllerTetujon = TextEditingController();
  final controllerDagingSurat = TextEditingController();
  final controllerPemahbah = TextEditingController();
  final controllerPamuput = TextEditingController();
  final controllerTempatKegiatan = TextEditingController();
  final controllerBusanaKegiatan = TextEditingController();
  final controllerWaktuKegiatan = TextEditingController();
  final controllerTanggalKegiatanText = TextEditingController();
  final controllerPihakLainTetujon = TextEditingController();
  final controllerPihakLainTumusan = TextEditingController();
  final DateRangePickerController controllerTanggalKegiatan = DateRangePickerController();
  final controllerPihakLainTetujonEmail = TextEditingController();
  final controllerPihakLainTumusanEmail = TextEditingController();
  TimeOfDay startTime;
  TimeOfDay endTime;
  String tanggalMulai;
  String tanggalMulaiValue;
  String tanggalBerakhir;
  String tanggalBerakhirValue;
  DateTime tanggalMulaiKegiatan;
  DateTime tanggalAkhirKegiatan;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FToast ftoast;

  getTumusan() async {
    http.get(Uri.parse(apiURLGetTumusanPrajuruDesa),
        headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          selectedBendesaTumusan = jsonData;
        });
      }
    });
  }

   getTetujonPrajuruBanjar() async {
    http.get(Uri.parse(apiURLGetTetujonPrajuruBanjar),
        headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      print(responseValue.toString());
      if(responseValue == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          selectedKelihanAdat = jsonData;
        });
      }
    });
  }

  getTumusanPrajuruBanjar() async {
    http.get(Uri.parse(apiURLGetTumusanPrajuruBanjar),
        headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      print(responseValue.toString());
      if(responseValue == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          selectedKelihanAdatTumusan = jsonData;
        });
      }
    });
  }

  getTetujonPihakLain() async {
    http.get(Uri.parse(apiURLGetTetujonPihakLain),
        headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          pihakLain = jsonData;
        });
      }
    });
  }

  getTumusanPihakLain() async {
    http.get(Uri.parse(apiURLGetTumusanPihakLain),
        headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          pihakLainTumusan = jsonData;
        });
      }
    });
  }

  getLampiran() async {
    http.get(Uri.parse(apiURLGetLampiran),
        headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200) {
        var jsonData = json.decode(response.body);
        this.fileName = [];
        for(var i = 0; i < jsonData.length; i++) {
          this.fileName.add(jsonData[i]['file']);
        }
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
          selectedBendesaAdat = int.parse(parsedJson['prajuru_desa_adat_id'].toString());
        });
      }
    });
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      tanggalMulai = DateFormat("dd-MMM-yyyy").format(args.value.startDate).toString();
      tanggalMulaiValue = DateFormat("yyyy-MM-dd").format(args.value.startDate).toString();
      tanggalBerakhir = DateFormat("dd-MMM-yyyy").format(args.value.endDate ?? args.value.startDate).toString();
      tanggalBerakhirValue = DateFormat("yyyy-MM-dd").format(args.value.endDate ?? args.value.startDate).toString();
      controllerTanggalKegiatanText.text = tanggalBerakhirValue == null ? "$tanggalMulai - $tanggalMulai" : "$tanggalMulai - $tanggalBerakhir";
    });
  }

  getPenyarikanInfo() async {
    var body = jsonEncode({
      "jabatan" : "penyarikan"
    });
    http.post(Uri.parse(apiURLShowPrajuru),
        headers: {"Content-Type" : "application/json"},
        body: body
    ).then((http.Response response) {
      if(response.statusCode == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        setState(() {
          selectedPenyarikan = int.parse(parsedJson['prajuru_desa_adat_id'].toString());
        });
      }
    });
  }

  Future getDataSuratKeluar() async {
    var response  = await http.get(Uri.parse(apiURLShowDataEditSuratKeluar));
    if(response.statusCode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        controllerNomorSurat.text = parsedJson['nomor_surat'];
        controllerLepihan.text = parsedJson['lepihan'].toString();
        controllerParindikan.text = parsedJson['parindikan'];
        controllerTetujon.text = parsedJson['pihak_penerima'];
        controllerPemahbah.text = parsedJson['pamahbah_surat'] == null ? "" : parsedJson['pamahbah_surat'];
        controllerDagingSurat.text = parsedJson['daging_surat'] == null ? "" : parsedJson['daging_surat'];
        controllerPamuput.text = parsedJson['pamuput_surat'] == null ? "" : parsedJson['pamuput_surat'];
        controllerTempatKegiatan.text = parsedJson['tempat_kegiatan'] == null ? "" : parsedJson['tempat_kegiatan'];
        controllerBusanaKegiatan.text = parsedJson['busana'] == null ? "" : parsedJson['busana'];
        selectedKodeSurat = parsedJson['kode_nomor_surat'];
        tanggalAkhirKegiatan = parsedJson['tanggal_selesai'] == null ? null : DateTime.parse(parsedJson['tanggal_selesai']);
        tanggalMulaiKegiatan = parsedJson['tanggal_mulai'] == null ? null : DateTime.parse(parsedJson['tanggal_mulai']);
        statusSurat = parsedJson['status'];
        if(tanggalAkhirKegiatan != null || tanggalMulaiKegiatan != null) {
          controllerTanggalKegiatan.selectedRange = PickerDateRange(tanggalMulaiKegiatan, tanggalAkhirKegiatan);
          tanggalMulai = DateFormat("dd-MMM-yyyy").format(tanggalMulaiKegiatan).toString();
          tanggalMulaiValue = DateFormat("yyyy-MM-dd").format(tanggalMulaiKegiatan).toString();
          tanggalBerakhir = DateFormat("dd-MMM-yyyy").format(tanggalAkhirKegiatan).toString();
          tanggalBerakhirValue = DateFormat("yyyy-MM-dd").format(tanggalAkhirKegiatan).toString();
          controllerTanggalKegiatanText.text = tanggalBerakhirValue == null ? "$tanggalMulai - $tanggalMulai" : "$tanggalMulai - $tanggalBerakhir";
        }
        startTime = parsedJson['waktu_mulai'] == null ? null : TimeOfDay(hour: int.parse(parsedJson['waktu_mulai'].split(":")[0]), minute: int.parse(parsedJson['waktu_mulai'].split(":")[1]));
        endTime = parsedJson['waktu_selesai'] == null ? null : TimeOfDay(hour: int.parse(parsedJson['waktu_selesai'].split(":")[0]), minute: int.parse(parsedJson['waktu_selesai'].split(":")[1]));
        if(startTime != null && endTime != null) {
          controllerWaktuKegiatan.text = "${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute}";
        }
        if(parsedJson['pihak_krama'] != null) {
          isSendToKrama = true;
          isVisible = false;
        }
        LoadingData = false;
      });
    }
  }

  Future getKodeSurat() async {
    var response = await http.get(Uri.parse(apiURLShowKodeSurat));
    if(response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        kodeSuratList = jsonData;
        KodeSuratLoading = false;
      });
    }
  }

  Future getKomponenNomorSurat() async {
    setState(() {
      NomorSuratLoading = true;
    });
    var body = jsonEncode({
      "kode_surat" : selectedKodeSurat
    });
    http.post(Uri.parse(apiURLShowKomponenNomorSurat),
        headers: {"Content-Type" : "application/json"},
        body: body
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      print(responseValue);
      if(responseValue == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        setState(() {
          NomorSuratLoading = false;
          nomorUrutSurat = parsedJson['nomor_urut_surat'];
          kodeDesa = parsedJson['kode_desa'];
          bulan = parsedJson['bulan'];
          tahun = parsedJson['tahun'];
          controllerNomorSurat.text = "$nomorUrutSurat/$selectedKodeSurat-$kodeDesa/$bulan/$tahun";
        });
      }
    });
  }

  Future pilihBerkas() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false
    );
    if(result != null) {
      setState(() {
        filePath = result.files.first.path;
        namaFile = result.files.first.name;
        file = File(result.files.single.path);
        lampiran.add(file);
        fileName.add(namaFile);
        lampiranUploadName.add(namaFile);
      });
      print(filePath);
      print(namaFile);
    }
  }

  Future getBendesaAdat() async {
    var response = await http.get(Uri.parse(apiURLGetDataBendesaAdat));
    if(response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        bendesaList = jsonData;
        LoadingBendesa = false;
      });
    }
  }

  Future getPenyarikan() async {
    var response = await http.get(Uri.parse(apiURLGetDataPenyarikan));
    if(response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        penyarikanList = jsonData;
        LoadingPenyarikan = false;
      });
    }
  }

  getKelihanAdat() async {
    http.get(Uri.parse(apiURLGetKelihanAdat),
      headers: {"Content-Type" : "application/json"}
    ).then((http.Response response) {
      var responseValue = response.statusCode;
      if(responseValue == 200){
        var jsonData = json.decode(response.body);
        setState(() {
          prajuruBanjarList = jsonData;
        });
      }
    });
  }

  Future getBendesa() async {
    var response = await http.get(Uri.parse(apiURLGetBendesa));
    if(response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        prajuruDesaList = jsonData;
      });
      http.get(Uri.parse(apiURLGetTetujonPrajuruDesa),
          headers: {"Content-Type" : "application/json"}
      ).then((http.Response response) {
        var responseValue = response.statusCode;
        if(responseValue == 200) {
          var jsonData = json.decode(response.body);
          setState(() {
            selectedBendesa = jsonData;
          });
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataSuratKeluar();
    getKodeSurat();
    getBendesaAdat();
    getPenyarikan();
    getBendesaInfo();
    getPenyarikanInfo();
    getLampiran();
    getKelihanAdat();
    getBendesa();
    getTumusan();
    getTetujonPrajuruBanjar();
    getTumusanPrajuruBanjar();
    getTetujonPihakLain();
    getTumusanPihakLain();
    final DateTime sekarang = DateTime.now();
    ftoast = FToast();
    ftoast.init(this.context);
    tanggalMulai = DateFormat("dd-MMM-yyyy").format(tanggalMulaiKegiatan == null ? sekarang : tanggalMulaiKegiatan).toString();
    tanggalBerakhir = DateFormat("dd-MMM-yyyy").format(tanggalAkhirKegiatan == null ? sekarang.add(Duration(days: 7)) : tanggalAkhirKegiatan).toString();
    controllerTanggalKegiatan.selectedRange = PickerDateRange(sekarang, sekarang.add(Duration(days: 7)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Loading ? loading() : Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: HexColor("#025393"),
            onPressed: (){
              Navigator.of(context).pop();
            }
          ),
          title: Text("Edit Surat", style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            color: HexColor("#025393")
          ))
        ),
        body: LoadingData ? ProfilePageShimmer() : SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text("1. Kode Surat *", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                      )),
                      margin: EdgeInsets.only(top: 20, left: 20)
                  ),
                  Container(
                      child: KodeSuratLoading ? ListTileShimmer() : Container(
                          width: 300,
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                              color: HexColor("#025393"),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Center(
                                child: Text("Pilih Kode Surat", style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.white,
                                    fontSize: 14
                                ))
                            ),
                            value: selectedKodeSurat,
                            underline: Container(),
                            icon: Icon(Icons.arrow_downward, color: Colors.white),
                            items: kodeSuratList.map((kodeSurat) {
                              return DropdownMenuItem(
                                  value: kodeSurat['kode_nomor_surat'],
                                  child: Text("${kodeSurat['kode_nomor_surat']} - ${kodeSurat['keterangan']}", style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14
                                  ))
                              );
                            }).toList(),
                            selectedItemBuilder: (BuildContext context) => kodeSuratList.map((kodeSurat) => Center(
                                child: Text("${kodeSurat['kode_nomor_surat']}", style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: Colors.white
                                ))
                            )).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedKodeSurat = value;
                              });
                              getKomponenNomorSurat();
                            },
                          ),
                          margin: EdgeInsets.only(top: 15)
                      )
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text("2. Atribut Surat", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                      )),
                      margin: EdgeInsets.only(top: 30, left: 20)
                  ),
                  Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text("Nomor Surat *", style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14
                              )),
                              margin: EdgeInsets.only(top: 20, left: 20)
                          ),
                          Container(
                            child: NomorSuratLoading ? ListTileShimmer() : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if(value.isEmpty) {
                                      return "Data tidak boleh kosong";
                                    }else {
                                      return null;
                                    }
                                  },
                                  controller: controllerNomorSurat,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                        borderSide: BorderSide(color: HexColor("#025393"))
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14
                                  ),
                                )
                            ),
                          ),
                          Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: Text("Lepihan (Lampiran) *", style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14
                                      )),
                                      margin: EdgeInsets.only(top: 20, left: 20)
                                  ),
                                  Container(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if(value.isEmpty) {
                                              return "Data tidak boleh kosong";
                                            }else {
                                              return null;
                                            }
                                          },
                                          controller: controllerLepihan,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(50.0),
                                                borderSide: BorderSide(color: HexColor("#025393"))
                                            ),
                                            hintText: "Lepihan",
                                          ),
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 14
                                          ),
                                        )
                                    ),
                                  )
                                ],
                              )
                          ),
                          Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: Text("Parindikan *", style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14
                                      )),
                                      margin: EdgeInsets.only(top: 20, left: 20)
                                  ),
                                  Container(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if(value.isEmpty) {
                                              return "Data tidak boleh kosong";
                                            }else {
                                              return null;
                                            }
                                          },
                                          controller: controllerParindikan,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(50.0),
                                                borderSide: BorderSide(color: HexColor("#025393"))
                                            ),
                                            hintText: "Parindikan",
                                          ),
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 14
                                          ),
                                        )
                                    ),
                                  )
                                ],
                              )
                          ),
                        ],
                      )
                  ),
                  Container(
                      child: Text("3. Daging Surat", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                      )),
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 30, left: 20)
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text("Pemahbah", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14
                      )),
                      margin: EdgeInsets.only(top: 20, left: 20)
                  ),
                  Container(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                        child: TextField(
                          controller: controllerPemahbah,
                          maxLines: 5,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: HexColor("#025393"))
                              ),
                              hintText: "Pemahbah (Pendahuluan)"
                          ),
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14
                          ),
                        )
                    ),
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text("Daging Surat", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14
                      )),
                      margin: EdgeInsets.only(top: 20, left: 20)
                  ),
                  Container(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                        child: TextField(
                          controller: controllerDagingSurat,
                          maxLines: 20,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: HexColor("#025393"))
                              ),
                              hintText: "Daging (Isi)"
                          ),
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14
                          ),
                        )
                    ),
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text("Pamuput Surat", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14
                      )),
                      margin: EdgeInsets.only(top: 20, left: 20)
                  ),
                  Container(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                        child: TextField(
                          controller: controllerPamuput,
                          maxLines: 5,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: HexColor("#025393"))
                              ),
                              hintText: "Pamuput (Penutup)"
                          ),
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14
                          ),
                        )
                    ),
                  ),
                  Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Tempat Kegiatan", style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14
                            )),
                            margin: EdgeInsets.only(top: 20, left: 20),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                              child: TextField(
                                controller: controllerTempatKegiatan,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                        borderSide: BorderSide(color: HexColor("#025393"))
                                    ),
                                    hintText: "Tempat Kegiatan"
                                ),
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  Container(
                      child: Column(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.topLeft,
                                child: Text("Tanggal Kegiatan", style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14
                                )),
                                margin: EdgeInsets.only(top: 20, left: 20)
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                child: GestureDetector(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Pilih Tanggal Kegiatan", style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: HexColor("025393")
                                          )),
                                          content: Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(
                                                  height: 250,
                                                  width: 250,
                                                  child: SfDateRangePicker(
                                                    controller: controllerTanggalKegiatan,
                                                    selectionMode: DateRangePickerSelectionMode.range,
                                                    onSelectionChanged: selectionChanged,
                                                    allowViewNavigation: true,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("Simpan", style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w700,
                                                color: HexColor("025393")
                                              )),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      }
                                    );
                                  },
                                  child: TextField(
                                    controller: controllerTanggalKegiatanText,
                                    enabled: false,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(50.0),
                                            borderSide: BorderSide(color: HexColor("#025393"))
                                        ),
                                        hintText: "Tanggal kegiatan belum terpilih",
                                        prefixIcon: Icon(CupertinoIcons.calendar)
                                    ),
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14
                                    ),
                                  ),
                                )
                              ),
                              margin: EdgeInsets.only(top: 10),
                            ),
                          ]
                      )
                  ),
                  Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Waktu Kegiatan", style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14
                            )),
                            margin: EdgeInsets.only(top: 20, left: 20),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: GestureDetector(
                                onTap: (){
                                  TimeRangePicker.show(
                                      context: context,
                                      unSelectedEmpty: true,
                                      headerDefaultStartLabel: "Waktu Mulai",
                                      headerDefaultEndLabel: "Waktu Selesai",
                                      onSubmitted: (TimeRangeValue value) {
                                        setState(() {
                                          startTime = value.startTime;
                                          endTime = value.endTime;
                                          controllerWaktuKegiatan.text = startTime == null ? "--:--" : endTime == null ? "${startTime.hour}:${startTime.minute} - ${startTime.hour}:${startTime.minute}": "${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute}";
                                        });
                                      }
                                  );
                                },
                                child: TextField(
                                  controller: controllerWaktuKegiatan,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(50.0),
                                          borderSide: BorderSide(color: HexColor("#025393"))
                                      ),
                                      hintText: "Waktu kegiatan belum terpilih",
                                      prefixIcon: Icon(CupertinoIcons.time_solid)
                                  ),
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14
                                  ),
                                ),
                              ),
                            ),
                            margin: EdgeInsets.only(top: 10),
                          ),
                        ],
                      )
                  ),
                  Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Busana Kegiatan", style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 14
                            )),
                            margin: EdgeInsets.only(top: 20, left: 20),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                              child: TextField(
                                controller: controllerBusanaKegiatan,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                        borderSide: BorderSide(color: HexColor("#025393"))
                                    ),
                                    hintText: "Busana Kegiatan"
                                ),
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  Container(
                      child: Text("4. Lingga Tangan Miwah Pesengan", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                      )),
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 30, left: 20)
                  ),
                  Container(
                      child: Column(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.topLeft,
                                child: Text("Penyarikan *", style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14
                                )),
                                margin: EdgeInsets.only(top: 20, left: 20)
                            ),
                            Container(
                                child: LoadingPenyarikan ? ListTileShimmer() : Container(
                                    width: 300,
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: HexColor("#025393"),
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint: Center(
                                          child: Text("Pilih Data Penyarikan", style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: Colors.white,
                                              fontSize: 14
                                          ))
                                      ),
                                      value: selectedPenyarikan,
                                      underline: Container(),
                                      icon: Icon(Icons.arrow_downward, color: Colors.white),
                                      items: penyarikanList.map((penyarikan) {
                                        return DropdownMenuItem(
                                            value: penyarikan['prajuru_desa_adat_id'],
                                            child: Text("${penyarikan['nik']} - ${penyarikan['nama']}", style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14
                                            ))
                                        );
                                      }).toList(),
                                      selectedItemBuilder: (BuildContext context) => penyarikanList.map((penyarikan) => Center(
                                          child: Text("${penyarikan['nik']} - ${penyarikan['nama']}", style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 14,
                                              color: Colors.white
                                          ))
                                      )).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPenyarikan = value;
                                        });
                                      },
                                    ),
                                    margin: EdgeInsets.only(top: 15)
                                )
                            )
                          ]
                      )
                  ),
                  Container(
                      child: Column(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.topLeft,
                                child: Text("Bendesa *", style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14
                                )),
                                margin: EdgeInsets.only(top: 20, left: 20)
                            ),
                            Container(
                                child: LoadingBendesa ? ListTileShimmer() : Container(
                                    width: 300,
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: HexColor("#025393"),
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: DropdownButton(
                                        isExpanded: true,
                                        hint: Center(
                                            child: Text("Pilih Bendesa Adat", style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                color: Colors.white
                                            ))
                                        ),
                                        value: selectedBendesaAdat,
                                        underline: Container(),
                                        icon: Icon(Icons.arrow_downward, color: Colors.white),
                                        items: bendesaList.map((bendesa) {
                                          return DropdownMenuItem(
                                              value: bendesa['prajuru_desa_adat_id'],
                                              child: Text("${bendesa['nik']} - ${bendesa['nama']}", style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14
                                              ))
                                          );
                                        }).toList(),
                                        selectedItemBuilder: (BuildContext context) => bendesaList.map((bendesa) => Center(
                                            child: Text("${bendesa['nik']} - ${bendesa['nama']}", style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                color: Colors.white
                                            ))
                                        )).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedBendesaAdat = value;
                                          });
                                        }
                                    ),
                                    margin: EdgeInsets.only(top: 15)
                                )
                            )
                          ]
                      )
                  ),
                  Container(
                      child: Text("5. Lepihan Surat", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                      )),
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 30, left: 20)
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: MultiSelectChipDisplay(
                        items: fileName.map((e) => MultiSelectItem(e, e)).toList(),
                        onTap: (value) {
                          setState(() {
                            if(lampiran.isNotEmpty) {
                              for(var i = 0; i < fileName.length; i++) {
                                var index = 0;
                                if(lampiranUploadName[index] == value) {
                                  setState(() {
                                    lampiranUploadName.remove(lampiranUploadName[index]);
                                    lampiran.remove(lampiran[index]);
                                  });
                                }else{
                                  setState(() {
                                    index = index + 1;
                                  });
                                }
                              }
                            }
                            setState(() {
                              fileName.remove(value);
                            });
                          });
                        },
                      )
                  ),
                  Container(
                    child: FlatButton(
                        onPressed: (){
                          if(controllerLepihan.text == "") {
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
                                                      'images/alert.png',
                                                      height: 50,
                                                      width: 50,
                                                    )
                                                ),
                                                Container(
                                                    child: Text("Data Lepihan Belum Terisi", style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w700,
                                                        color: HexColor("#025393")
                                                    ), textAlign: TextAlign.center),
                                                    margin: EdgeInsets.only(top: 10)
                                                ),
                                                Container(
                                                    child: Text("Data lepihan belum terisi. Silahkan isi data lepihan terlebih dahulu dan coba lagi", style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 14
                                                    ), textAlign: TextAlign.center),
                                                    margin: EdgeInsets.only(top: 10)
                                                )
                                              ]
                                          )
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("OK", style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w700,
                                              color: HexColor("#025393")
                                          )),
                                          onPressed: (){Navigator.of(context).pop();},
                                        )
                                      ]
                                  );
                                }
                            );
                          }else if(controllerLepihan.text == "0" || controllerLepihan.text == "-") {
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
                                                      'images/alert.png',
                                                      height: 50,
                                                      width: 50,
                                                    )
                                                ),
                                                Container(
                                                    child: Text("Tidak Dapat Memilih Berkas Lepihan", style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w700,
                                                        color: HexColor("#025393")
                                                    ), textAlign: TextAlign.center),
                                                    margin: EdgeInsets.only(top: 10)
                                                ),
                                                Container(
                                                    child: Text("Tidak dapat memilih berkas lepihan karena Anda menginputkan tidak ada berkas lepihan", style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 14
                                                    ), textAlign: TextAlign.center),
                                                    margin: EdgeInsets.only(top: 10)
                                                )
                                              ]
                                          )
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("OK", style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w700,
                                              color: HexColor("#025393")
                                          )),
                                          onPressed: (){Navigator.of(context).pop();},
                                        )
                                      ]
                                  );
                                }
                            );
                          }else{
                            pilihBerkas();
                          }
                        },
                        child: Text("Unggah Berkas", style: TextStyle(
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
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50)
                    ),
                    margin: EdgeInsets.only(top: 20),
                  ),
                  Container(
                    child: Text("6. Tetujon Surat", style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    )),
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 30, left: 20),
                  ),
                  Visibility(
                    visible: isVisible,
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text("Prajuru Desa Adat", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )),
                          margin: EdgeInsets.only(top: 15, left: 20),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: MultiSelectDialogField(
                              title: Text("Prajuru Desa Adat"),
                              buttonText: Text("Tambah Penerima Prajuru Desa Adat", style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14
                              )),
                              buttonIcon: Icon(Icons.expand_more),
                              initialValue: selectedBendesa,
                              searchable: true,
                              checkColor: Colors.white,
                              items: prajuruDesaList.map((item) => MultiSelectItem(item, "${item['jabatan']} - ${item['nama']}")).toList(),
                              listType: MultiSelectListType.LIST,
                              onConfirm: (values) {
                                setState(() {
                                  selectedBendesa.addAll(values);
                                  values.clear();
                                });
                              },
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: MultiSelectChipDisplay(
                            items: selectedBendesa.map((e) => MultiSelectItem(e, "${e['jabatan']} - ${e['nama']}")).toList(),
                            onTap: (value) {
                              setState(() {
                                selectedBendesa.remove(value);
                              });
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text("Prajuru Banjar Adat", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )),
                          margin: EdgeInsets.only(top: 15, left: 20),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: MultiSelectDialogField(
                              title: Text("Prajuru Banjar Adat"),
                              buttonText: Text("Tambah Penerima Prajuru Banjar Adat", style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14
                              )),
                              buttonIcon: Icon(Icons.expand_more),
                              searchable: true,
                              checkColor: Colors.white,
                              items: prajuruBanjarList.map((item) => MultiSelectItem(item, "Banjar ${item['nama_banjar_adat']} - ${item['nama']}")).toList(),
                              listType: MultiSelectListType.LIST,
                              onConfirm: (values) {
                                setState(() {
                                  selectedKelihanAdat.addAll(values);
                                  values.clear();
                                });
                              },
                            )
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: MultiSelectChipDisplay(
                              items: selectedKelihanAdat.map((e) => MultiSelectItem(e, "Banjar ${e['nama_banjar_adat']} - ${e['nama']}")).toList(),
                              onTap: (value) {
                                setState(() {
                                  selectedKelihanAdat.remove(value);
                                });
                              },
                            )
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text("Pihak Lain", style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w700
                          )),
                          margin: EdgeInsets.only(top: 15, left: 20),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                    child: TextField(
                                      controller: controllerPihakLainTetujon,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(50.0),
                                              borderSide: BorderSide(color: HexColor("#025393"))
                                          ),
                                          hintText: "Nama Pihak Lain"
                                      ),
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14
                                      ),
                                    )
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                    child: TextField(
                                      controller: controllerPihakLainTetujonEmail,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(50.0),
                                              borderSide: BorderSide(color: HexColor("#025393"))
                                          ),
                                          hintText: "Email Pihak Lain"
                                      ),
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                          margin: EdgeInsets.only(right: 10, left: 10),
                        ),
                        Container(
                          child: FlatButton(
                            onPressed: (){
                              if(controllerPihakLainTetujon.text != "") {
                                if(controllerPihakLainTetujonEmail.text != "") {
                                  if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(controllerPihakLainTetujonEmail.text)) {
                                    var tetujonPihakLainArray = {'pihak_lain': controllerPihakLainTetujon.text, 'email_pihak_lain': controllerPihakLainTetujonEmail.text == "" ? null : controllerPihakLainTetujonEmail.text};
                                    setState(() {
                                      pihakLain.add(tetujonPihakLainArray);
                                      controllerPihakLainTetujon.text = "";
                                      controllerPihakLainTetujonEmail.text = "";
                                    });
                                  }else {
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
                                                  child: Text("Silahkan masukkan email yang valid", style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white
                                                  )),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                    );
                                  }
                                }else {
                                  var tetujonPihakLainArray = {'pihak_lain': controllerPihakLainTetujon.text, 'email_pihak_lain': controllerPihakLainTetujonEmail.text == "" ? null : controllerPihakLainTetujonEmail.text};
                                  setState(() {
                                    pihakLain.add(tetujonPihakLainArray);
                                    controllerPihakLainTetujon.text = "";
                                    controllerPihakLainTetujonEmail.text = "";
                                  });
                                }
                              }else {
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
                                              child: Text("Data nama pihak lain tidak boleh kosong", style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white
                                              )),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                );
                              }
                            },
                            child: Text("Tambah Pihak Lain", style: TextStyle(
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
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: MultiSelectChipDisplay(
                            items: pihakLain.map((e) => MultiSelectItem(e, "${e['pihak_lain']} (${e['email_pihak_lain'] == null ? "Tidak ada email" : e['email_pihak_lain']})")).toList(),
                            onTap: (value) {
                              setState(() {
                                pihakLain.remove(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: CheckboxListTile(
                      title: Text("Kirimkan surat ini ke Krama Desa ${dashboardAdminDesa.namaDesaAdat}", style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: Colors.black
                      )),
                      value: isSendToKrama,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool value) {
                        setState(() {
                          isSendToKrama = value;
                          isVisible = !isVisible;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Text("7. Tumusan Surat", style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    )),
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 30, left: 20),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("Prajuru Desa Adat", style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    )),
                    margin: EdgeInsets.only(top: 15, left: 20),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: MultiSelectDialogField(
                        title: Text("Prajuru Desa Adat"),
                        buttonText: Text("Tambah Tumusan Prajuru Desa Adat", style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14
                        )),
                        buttonIcon: Icon(Icons.expand_more),
                        initialValue: selectedBendesa,
                        searchable: true,
                        selectedColor: HexColor("#025393"),
                        checkColor: Colors.white,
                        items: prajuruDesaList.map((item) => MultiSelectItem(item, "${item['jabatan']} - ${item['nama']}")).toList(),
                        listType: MultiSelectListType.LIST,
                        onConfirm: (values) {
                          setState(() {
                            selectedBendesaTumusan.addAll(values);
                            values.clear();
                          });
                        },
                      )
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: MultiSelectChipDisplay(
                      items: selectedBendesaTumusan.map((e) => MultiSelectItem(e, "${e['jabatan']} - ${e['nama']}")).toList(),
                      onTap: (value) {
                        setState(() {
                          selectedBendesaTumusan.remove(value);
                        });
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("Prajuru Banjar Adat", style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    )),
                    margin: EdgeInsets.only(top: 15, left: 20),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: MultiSelectDialogField(
                        title: Text("Prajuru Banjar Adat"),
                        buttonText: Text("Tambah Tumusan Prajuru Banjar Adat", style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14
                        )),
                        buttonIcon: Icon(Icons.expand_more),
                        searchable: true,
                        selectedColor: HexColor("#025393"),
                        checkColor: Colors.white,
                        items: prajuruBanjarList.map((item) => MultiSelectItem(item, "Banjar ${item['nama_banjar_adat']} - ${item['nama']}")).toList(),
                        listType: MultiSelectListType.LIST,
                        onConfirm: (values) {
                          setState(() {
                            selectedKelihanAdatTumusan.addAll(values);
                            values.clear();
                          });
                        },
                      )
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: MultiSelectChipDisplay(
                        items: selectedKelihanAdatTumusan.map((e) => MultiSelectItem(e, "Banjar ${e['nama_banjar_adat']} - ${e['nama']}")).toList(),
                        onTap: (value) {
                          setState(() {
                            selectedKelihanAdatTumusan.remove(value);
                          });
                        },
                      )
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("Pihak Lain", style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    )),
                    margin: EdgeInsets.only(top: 15, left: 20),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                              child: TextField(
                                controller: controllerPihakLainTumusan,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      borderSide: BorderSide(color: HexColor("#025393"))
                                  ),
                                  hintText: "Nama Pihak Lain",
                                ),
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14
                                ),
                              )
                          ),
                        ),
                        Flexible(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                              child: TextField(
                                controller: controllerPihakLainTumusanEmail,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      borderSide: BorderSide(color: HexColor("#025393"))
                                  ),
                                  hintText: "Email Pihak Lain",
                                ),
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14
                                ),
                              )
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(right: 10, left: 10),
                  ),
                  Container(
                    child: FlatButton(
                      onPressed: (){
                        if(controllerPihakLainTumusan.text != "") {
                          if(controllerPihakLainTumusanEmail.text != "") {
                            if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(controllerPihakLainTumusanEmail.text)) {
                              var tumusanPihakLainArray = {'pihak_lain' : controllerPihakLainTumusan.text, 'email_pihak_lain' : controllerPihakLainTumusanEmail.text == "" ? null : controllerPihakLainTumusanEmail.text};
                              setState(() {
                                pihakLainTumusan.add(tumusanPihakLainArray);
                                controllerPihakLainTumusan.text = "";
                                controllerPihakLainTumusanEmail.text = "";
                              });
                            }else {
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
                                            child: Text("Silahkan masukkan email yang valid", style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white
                                            )),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              );
                            }
                          }else {
                            var tumusanPihakLainArray = {'pihak_lain' : controllerPihakLainTumusan.text, 'email_pihak_lain' : controllerPihakLainTumusanEmail.text == "" ? null : controllerPihakLainTumusanEmail.text};
                            setState(() {
                              pihakLainTumusan.add(tumusanPihakLainArray);
                              controllerPihakLainTumusan.text = "";
                              controllerPihakLainTumusanEmail.text = "";
                            });
                          }
                        }else {
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
                                        child: Text("Data nama pihak lain tidak boleh kosong", style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                              )
                          );
                        }
                      },
                      child: Text("Tambah Pihak Lain", style: TextStyle(
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
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: MultiSelectChipDisplay(
                        items: pihakLainTumusan.map((e) => MultiSelectItem(e, "${e['pihak_lain']} (${e['email_pihak_lain'] == null ? "Tidak ada email" : e['email_pihak_lain']})")).toList(),
                        onTap: (value) {
                          setState(() {
                            pihakLainTumusan.remove(value);
                          });
                        },
                      )
                  ),
                  Container(
                      child: FlatButton(
                          onPressed: () {
                            if(controllerLepihan.text != "0" && fileName.isEmpty) {
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
                                            child: Text("Silahkan unggah berkas lampiran", style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white
                                            )),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              );
                            }else if(controllerLepihan.text == "0" && fileName.isNotEmpty) {
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
                                            child: Text("Silahkan kosongkan lampiran sebelum melanjutkan", style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white
                                            )),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              );
                            }else if(selectedBendesa.isEmpty && selectedKelihanAdat.isEmpty && pihakLain.isEmpty) {
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
                                            child: Text("Silahkan masukkan penerima surat", style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white
                                            )),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              );
                            }else if(formKey.currentState.validate()) {
                              setState(() {
                                Loading = true;
                              });
                              var body = jsonEncode({
                                "surat_keluar_id" : editSuratKeluarNonPanitia.idSuratKeluar,
                                "desa_adat_id" : loginPage.desaId,
                                "master_surat" : selectedKodeSurat,
                                "nomor_surat" : controllerNomorSurat.text,
                                "nomor_urut_surat" : nomorUrutSurat == null ? null : nomorUrutSurat,
                                "user_id" : loginPage.userId,
                                "lepihan" : controllerLepihan.text,
                                "parindikan" : controllerParindikan.text,
                                "pihak_penerima" : controllerTetujon.text,
                                "pemahbah_surat" : controllerPemahbah.text,
                                "daging_surat" : controllerDagingSurat.text == "" ? null : controllerDagingSurat.text,
                                "tanggal_mulai" : tanggalMulaiValue == null ? null : tanggalMulaiValue,
                                "tanggal_selesai" : tanggalMulaiValue == null ? null : tanggalBerakhir == null ? tanggalMulaiValue : tanggalBerakhirValue,
                                "waktu_mulai" : startTime == null ? null : "${startTime.hour}:${startTime.minute}",
                                "waktu_selesai" : startTime == null ? null : endTime == null ? "${startTime.hour}:${startTime.minute}" : "${endTime.hour}:${endTime.minute}",
                                "pamuput_surat" : controllerPamuput.text == "" ? null : controllerPamuput.text,
                                "busana" : controllerBusanaKegiatan.text == "" ? null : controllerBusanaKegiatan.text,
                                "tempat_kegiatan" : controllerTempatKegiatan.text == "" ? null : controllerTempatKegiatan.text,
                                "bendesa_adat_id" : selectedBendesaAdat,
                                "penyarikan_id" : selectedPenyarikan,
                                "status_surat" : statusSurat,
                                "pihak_krama" : isSendToKrama ? "Desa Adat ${dashboardAdminDesa.namaDesaAdat}" : null
                              });
                              http.post(Uri.parse(apiURLSimpanEditSuratKeluar),
                                  headers: {"Content-Type" : "application/json"},
                                  body: body
                              ).then((http.Response response) async {
                                var responseValue = response.statusCode;
                                print("status upload edit surat keluar non-panitia : ${response.statusCode.toString()}");
                                if(responseValue == 200) {
                                  await uploadLampiran();
                                  await uploadPrajuruDesa();
                                  await uploadPrajuruBanjar();
                                  await uploadPihakLain();
                                  setState(() {
                                    Loading = false;
                                  });
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
                                                child: Text("Surat keluar berhasil diperbaharui", style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white
                                                )),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  );
                                  Navigator.of(context).pop(true);
                                }
                              });
                            }
                          },
                          child: Text("Simpan", style: TextStyle(
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
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50)
                      ),
                      margin: EdgeInsets.only(top: 20, bottom: 20)
                  )
                ]
            ),
          )
        )
      )
    );
  }

  Future uploadLampiran() async {
    Map<String, String> headers = {
      'Content-Type' : 'multipart/form-data'
    };
    Map<String, String> body = {
      "surat_keluar_id" : editSuratKeluarNonPanitia.idSuratKeluar.toString()
    };
    var request_delete = http.MultipartRequest("POST", Uri.parse("https://siradaskripsi.my.id/api/admin/surat/keluar/lampiran/delete"))
                              ..fields.addAll(body)
                              ..headers.addAll(headers);
    var response_delete = await request_delete.send();
    print("delete lampiran status code : ${response_delete.statusCode.toString()}");
    if(lampiran.isNotEmpty) {
      for(var i = 0; i < lampiran.length; i++) {
        var request = http.MultipartRequest('POST', Uri.parse(apiURLUpLampiran))
          ..headers.addAll(headers)
          ..files.add(await http.MultipartFile.fromPath('lampiran', lampiran[i].path));
        await request.send().then((response) {
          print("upload lampiran status code: ${response.statusCode.toString()}");
        });
        for(var i = 0; i < fileName.length; i++) {
          Map<String, String> body = {
            "surat_keluar_id" : editSuratKeluarNonPanitia.idSuratKeluar.toString(),
            "file_name" : fileName[i].toString()
          };
          var request = http.MultipartRequest("POST", Uri.parse(apiURLSaveEditLampiran))
            ..fields.addAll(body)
            ..headers.addAll(headers);
          await request.send().then((response) {
            print("upload lampiran status code (save edit): ${response.statusCode.toString()}");
          });
        }
      }
    }else {
      for(var i = 0; i < fileName.length; i++) {
        Map<String, String> body = {
          "surat_keluar_id" : editSuratKeluarNonPanitia.idSuratKeluar.toString(),
          "file_name" : fileName[i].toString()
        };
        var request = http.MultipartRequest("POST", Uri.parse("https://siradaskripsi.my.id/api/admin/surat/keluar/lampiran/edit/up"))
          ..fields.addAll(body)
          ..headers.addAll(headers);
        await request.send().then((response) {
          print("upload lampiran status code (save edit): ${response.statusCode.toString()}");
        });
      }
    }
  }

  Future uploadPrajuruBanjar() async {
    var list = [];
    var listTumusan = [];
    Map<String, String> body = {
      "surat_keluar_id" : editSuratKeluarNonPanitia.idSuratKeluar.toString()
    };
    Map<String, String> headers = {
      'Content-Type' : 'multipart/form-data'
    };
    var request_delete = http.MultipartRequest("POST", Uri.parse("https://siradaskripsi.my.id/api/admin/surat/keluar/tetujon/banjar/delete"))
      ..fields.addAll(body)
      ..headers.addAll(headers);
    await request_delete.send().then((response) {
      print("delete tetujon prajuru banjar status code : ${response.statusCode.toString()}");
    });
    var request_delete_tumusan = http.MultipartRequest("POST", Uri.parse("https://siradaskripsi.my.id/api/admin/surat/keluar/tumusan/banjar/delete"))
      ..fields.addAll(body)
      ..headers.addAll(headers);
    await request_delete_tumusan.send().then((response) async {
      print("delete tetujon prajuru banjar status code : ${response.statusCode.toString()}");
      if(isSendToKrama == false) {
        if(selectedKelihanAdat.isNotEmpty) {
          for(var i = 0; i < selectedKelihanAdat.length; i++) {
            setState(() {
              var prajuruBanjarArray = {'prajuru_banjar_adat_id' : selectedKelihanAdat[i]['prajuru_banjar_adat_id'].toString(), 'surat_keluar_id' : editSuratKeluarNonPanitia.idSuratKeluar.toString()};
              list.add(prajuruBanjarArray);
            });
          }
          var body = jsonEncode(list);
          await http.post(Uri.parse(apiURLUpTetujonPrajuruBanjar),
              headers: {"Content-Type" : "application/json"},
              body: body
          ).then((http.Response response) {
            print("respons status: ${response.statusCode}");
          });
        }
      }
      if(selectedKelihanAdatTumusan.isNotEmpty) {
        for(var i = 0; i < selectedKelihanAdatTumusan.length; i++) {
          setState(() {
            var prajuruBanjarAdatTumusan = {'prajuru_banjar_adat_id': selectedKelihanAdatTumusan[i]['prajuru_banjar_adat_id'].toString(), 'surat_keluar_id' : editSuratKeluarNonPanitia.idSuratKeluar.toString()};
            listTumusan.add(prajuruBanjarAdatTumusan);
          });
        }
        var body = jsonEncode(listTumusan);
        await http.post(Uri.parse(apiURLUpTumusanPrajuruBanjar),
            headers: {"Content-Type" : "application/json"},
            body: body
        ).then((http.Response response) {
          print("respons status tumusan : ${response.statusCode}");
        });
      }
    });
  }

  Future uploadPrajuruDesa() async {
    var list = [];
    var listTumusan = [];
    Map<String, String> body = {
      "surat_keluar_id" : editSuratKeluarNonPanitia.idSuratKeluar.toString()
    };
    Map<String, String> headers = {
      'Content-Type' : 'multipart/form-data'
    };
    var request_delete = http.MultipartRequest("POST", Uri.parse("https://siradaskripsi.my.id/api/admin/surat/keluar/tetujon/desa/delete"))
      ..fields.addAll(body)
      ..headers.addAll(headers);
    await request_delete.send().then((response) {
      print("delete tetujon prajuru desa status code : ${response.statusCode.toString()}");
    });
    var request_delete_tumusan = http.MultipartRequest("POST", Uri.parse("https://siradaskripsi.my.id/api/admin/surat/keluar/tumusan/desa/delete"))
      ..fields.addAll(body)
      ..headers.addAll(headers);
    await request_delete_tumusan.send().then((response) async {
      print("delete tumusan prajuru desa status code : ${response.statusCode.toString()}");
      if(isSendToKrama == false) {
        if(selectedBendesa.isNotEmpty) {
          for(var i = 0; i < selectedBendesa.length; i++) {
            setState(() {
              var prajuruDesaArray = {'prajuru_desa_adat_id' : selectedBendesa[i]['prajuru_desa_adat_id'].toString(), 'surat_keluar_id' : editSuratKeluarNonPanitia.idSuratKeluar.toString()};
              list.add(prajuruDesaArray);
            });
          }
          var body = jsonEncode(list);
          await http.post(Uri.parse(apiURLUpTetujonPrajuruDesa),
              headers: {"Content-Type" : "application/json"},
              body: body
          ).then((http.Response response) {
            print("respons status prajuru desa adat: ${response.statusCode}");
          });
        }
      }
      if(selectedBendesaTumusan.isNotEmpty) {
        for(var i = 0; i < selectedBendesaTumusan.length; i++) {
          setState(() {
            var prajuruDesaAdatTumusan = {'prajuru_desa_adat_id' : selectedBendesaTumusan[i]['prajuru_desa_adat_id'].toString(), 'surat_keluar_id' : editSuratKeluarNonPanitia.idSuratKeluar.toString()};
            listTumusan.add(prajuruDesaAdatTumusan);
          });
        }
        var body = jsonEncode(listTumusan);
        await http.post(Uri.parse(apiURLUpTumusanPrajuruDesa),
            headers: {"Content-Type" : "application/json"},
            body: body
        ).then((http.Response response) {
          print("respons status prajuru desa adat tumusan: ${response.statusCode}");
        });
      }
    });
  }

  Future uploadPihakLain() async {
    var list = [];
    var listTumusan = [];
    Map<String, String> body = {
      "surat_keluar_id" : editSuratKeluarNonPanitia.idSuratKeluar.toString()
    };
    Map<String, String> headers = {
      'Content-Type' : 'multipart/form-data'
    };
    var request_delete = http.MultipartRequest("POST", Uri.parse("https://siradaskripsi.my.id/api/admin/surat/keluar/tetujon/pihak-lain/delete"))
      ..fields.addAll(body)
      ..headers.addAll(headers);
    await request_delete.send().then((response) {
      print("delete tetujon pihak lain status code : ${response.statusCode.toString()}");
    });
    var request_delete_tumusan = http.MultipartRequest("POST", Uri.parse("https://siradaskripsi.my.id/api/admin/surat/keluar/tumusan/pihak-lain/delete"))
      ..fields.addAll(body)
      ..headers.addAll(headers);
    await request_delete_tumusan.send().then((response) async {
      print("delete tumusan pihak lain status code : ${response.statusCode.toString()}");
      if(isSendToKrama == false) {
        if(pihakLain.isNotEmpty) {
          for(var i = 0; i < pihakLain.length; i++) {
            setState(() {
              var pihakLainArray = {'surat_keluar_id' : editSuratKeluarNonPanitia.idSuratKeluar.toString(), 'pihak_lain' : pihakLain[i]['pihak_lain'].toString(), 'email_pihak_lain' : pihakLain[i]['email_pihak_lain']};
              list.add(pihakLainArray);
            });
          }
          var body = jsonEncode(list);
          await http.post(Uri.parse(apiURLUpTetujonPihakLain),
              headers: {"Content-Type" : "application/json"},
              body: body
          ).then((http.Response response) {
            print("respons pihak lain status : ${response.statusCode}");
          });
        }
      }
      if(pihakLainTumusan.isNotEmpty) {
        for(var i = 0; i < pihakLainTumusan.length; i++) {
          setState(() {
            var pihakLainArray = {'surat_keluar_id' : editSuratKeluarNonPanitia.idSuratKeluar.toString(), 'pihak_lain' : pihakLainTumusan[i]['pihak_lain'].toString(), 'email_pihak_lain' : pihakLainTumusan[i]['email_pihak_lain']};
            listTumusan.add(pihakLainArray);
          });
        }
        var body = jsonEncode(listTumusan);
        await http.post(Uri.parse(apiURLUpTumusanPihakLain),
            headers: {"Content-Type" : "application/json"},
            body: body
        ).then((http.Response response) {
          print("respons pihak lain tembusan status: ${response.statusCode}");
        });
      }
    });
  }
}