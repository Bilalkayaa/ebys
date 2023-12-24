import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../dataB/showmassage.dart';
import 'belgeGonder.dart';

class belgeOlustur extends StatefulWidget {
  final GetStorage box;

  belgeOlustur({required this.box});
  @override
  State<StatefulWidget> createState() {
    return BelgeOLustur(box: box);
  }
}

class BelgeOLustur extends State<belgeOlustur> {
  final GetStorage box;
  BelgeOLustur({required this.box});
  final _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Izin';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Belge Oluştur",
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 175,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDropdownButton(),
                _datePicker(),
                buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _datePicker() {
    return Container(
      padding: EdgeInsets.only(right: 40, left: 40),
      child: TextField(
        controller: _dateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Date",
          icon: Icon(Icons.event),
          hintText: "Date",
        ),
        onTap: () async {
          final selectedDate = await showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            initialDate: DateTime.now(),
            selectableDayPredicate: (DateTime day) {
              return day.isAfter(DateTime.now().subtract(Duration(days: 1)));
            },
          );
          if (selectedDate != null) {
            setState(() {
              _dateController.text =
                  DateFormat('dd/MM/yyyy').format(selectedDate);
            });
          }
          print(_dateController.text);
        },
      ),
    );
  }

  Widget buildDropdownButton() {
    List<String> list = ['Izin', 'Ucretsiz izin', 'Dogum izni', 'Istifa'];

    return Container(
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.white),
        underline: Container(
          height: 1,
          color: Colors.white,
        ),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget buildButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
        bottom: 10.0,
        left: 100,
        right: 100,
      ),
      child: Container(
        height: 35.0,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 4, 245, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: () {
            if (_dateController.text.isEmpty) {
              showSnackBar(context, "Tarih bilgisini doldurunuz");
            } else {
              create(box.read("name"), box.read("lastName"),
                  _dateController.text, dropdownValue);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => belgeGonder(
                            box: box,
                          ))));
              showSnackBar(context, "Belge Oluşturuldu Gonderime Hazır");
            }
          },
          child: Text(
            'Oluştur',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createFile(String ad, String txt) async {
    var path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    String dosyayolu = "${path.toString()}/$ad.txt";
    try {
      File dosya = File(dosyayolu);
      dosya.writeAsStringSync(txt);

      print('Dosya oluşturuldu ve veri yazıldı: $path');
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  void create(String name, String lastName, String date, String type) {
    String dilekce;
    switch (type) {
      case "Izin":
        dilekce = """
          Sayın Yetkili,

          ${name} ${lastName}, ${date} tarihinden itibaren ${type}'ne başvurmak için bu dilekçeyi sunmaktadır. İzin süresince yaptığı işlerin düzenli bir şekilde yürütülebilmesi için gerekli önlemleri almış olup, iş akışına herhangi bir aksama yaşanmamasını temin eder.

          Saygılarımla,
          ${name} ${lastName}
          """;
        createFile(name + lastName + type.replaceAll(" ", ""), dilekce);

        break;
      case "Ucretsiz izin":
        dilekce = """
          Sayın Yetkili,

          ${name} ${lastName}, ${date} tarihinden itibaren ${type}'ne başvurmak için bu dilekçeyi sunmaktadır. Ücretsiz izin süresince yaptığı işlerin düzenli bir şekilde yürütülebilmesi için gerekli önlemleri almış olup, iş akışına herhangi bir aksama yaşanmamasını temin eder.

          Saygılarımla,
          ${name} ${lastName}
          """;
        createFile(name + lastName + type.replaceAll(" ", ""), dilekce);
        break;
      case "Dogum izni":
        dilekce = """
        Sayın Yetkili,

        ${name} ${lastName}, ${date} tarihinden itibaren ${type}'ne başvurmak için bu dilekçeyi sunmaktadır. Doğum izni süresince yaptığı işlerin düzenli bir şekilde yürütülebilmesi için gerekli önlemleri almış olup, iş akışına herhangi bir aksama yaşanmamasını temin eder.

        Saygılarımla,
        ${name} ${lastName}
        """;
        createFile(name + lastName + type.replaceAll(" ", ""), dilekce);
        break;
      case "Istifa":
        dilekce = """
        Sayın Yetkili,

        ${name} ${lastName}, ${date} tarihinden itibaren işten ayrılmak için bu dilekçeyi sunmaktadır. İşten ayrılırken mevcut iş akışının zarar görmemesi için gerekli önlemleri alacağını taahhüt eder.

        Saygılarımla,
        ${name} ${lastName}
        """;
        createFile(name + lastName + type.replaceAll(" ", ""), dilekce);
        break;
    }
  }
}
