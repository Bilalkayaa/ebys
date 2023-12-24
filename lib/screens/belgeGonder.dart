import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../dataB/dBHelper.dart';
import '../dataB/foldertable.dart';
import '../dataB/showmassage.dart';
import '../user/file.dart';
import '../user/user.dart';

class belgeGonder extends StatefulWidget {
  final GetStorage box;

  belgeGonder({required this.box});
  @override
  State<StatefulWidget> createState() {
    return BelgeGonder(box: box);
  }
}

class BelgeGonder extends State {
  var db = DbHelper();
  var db2 = DbHelperfile();
  final GetStorage box;
  BelgeGonder({required this.box});
  late List<user> users = [];
  Color _randomColor =
      Colors.primaries[Random().nextInt(Colors.primaries.length)];
  int userCount = 0;

  @override
  Widget build(BuildContext context) {
    getUsers();

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          "Belge Gönder",
        ),
      ),
      body: buildUserList(),
    );
  }

  ListView buildUserList() {
    return ListView.builder(
        itemCount: userCount,
        itemBuilder: (BuildContext context, int positions) {
          return Card(
              color: Colors.grey,
              elevation: 20.0,
              shape: StadiumBorder(),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _randomColor,
                  child: Text(this.users[positions].name![0].toUpperCase()),
                ),
                title: Text(
                  this.users[positions].name!.toUpperCase() +
                      " " +
                      this.users[positions].lastName!.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black),
                ),
                onTap: () {
                  if (box.read("id") == this.users[positions].id) {
                    showSnackBar(context, "Kendinize Belge Gönderemezsiniz!");
                  } else {
                    goToFile(this.users[positions].id!);
                    showSnackBar(context, 'Belge Gönderildi');
                  }
                },
              ));
        });
  }

  void goToFile(int id) async {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}";
    String? filePath = await FilePicker.platform
        .pickFiles(
          type: FileType.any,
        )
        .then((result) => result?.files.single.path);

    if (filePath != null) {
      print('Seçilen belgenin yolu: $filePath');
      db2.insert(file(
          fromemployee: box.read("id"),
          toemployee: id,
          path: filePath,
          date: formattedDate));
    } else {
      print('Belge seçilmedi');
    }
  }

  void getUsers() {
    var productsFuture = db.getusers();
    productsFuture.then((data) {
      this.users = data;
      userCount = data.length;
      setState(() {});
    });
  }
}
