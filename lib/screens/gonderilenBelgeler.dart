import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';

import '../dataB/dBHelper.dart';
import '../dataB/foldertable.dart';
import '../user/file.dart';
import '../user/user.dart';

class gonderilenBelgeler extends StatefulWidget {
  final GetStorage box;

  gonderilenBelgeler({required this.box});

  @override
  State<StatefulWidget> createState() {
    return _gonderilenBelgeler(box: box);
  }
}

class _gonderilenBelgeler extends State<gonderilenBelgeler> {
  late List<file> files = [];
  late List<user> users = [];
  var db = DbHelperfile();
  var dbusers = DbHelper();
  final GetStorage box;
  int filecount = 0;
  int userCount = 0;
  _gonderilenBelgeler({required this.box});
  @override
  void initState() {
    getFiles();
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getFiles();
    getUsers();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gönderilen Belgeler",
        ),
      ),
      body: buildFileList(),
    );
  }

  ListView buildFileList() {
    return ListView.builder(
      itemCount: filecount,
      itemBuilder: (BuildContext context, int positions) {
        if (box.read("id") == this.files[positions].fromemployee) {
          return Card(
            color: Colors.grey,
            elevation: 20.0,
            shape: StadiumBorder(),
            child: ListTile(
              trailing: Text(
                "Kime: " +
                    this
                        .users[this.files[positions].toemployee! - 1]
                        .name!
                        .toUpperCase() +
                    " " +
                    this
                        .users[this.files[positions].toemployee! - 1]
                        .lastName!
                        .toUpperCase() +
                    "\n" +
                    this.files[positions].date!,
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              leading: Icon(
                Icons.folder,
                color: Colors.black,
                size: 40,
              ),
              title: Text(this.files[positions].path!.split('/').last),
              onTap: () {
                OpenFile.open(this.files[positions].path!);
                print(this.files[positions].path!);
              },
              onLongPress: () {
                alert(this.files[positions].id!);
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void getFiles() {
    var usersFuture = db.getfiles();
    usersFuture.then((data) {
      this.files = data;
      filecount = data.length;
      setState(() {});
    });
  }

  void getUsers() {
    var productsFuture = dbusers.getusers();
    productsFuture.then((data) {
      this.users = data;
      userCount = data.length;
      setState(() {});
    });
  }

  void bak() {
    for (var userObj in files) {
      print('fromemployee: ${userObj.fromemployee}');
      print('path: ${userObj.path}');
    }
  }

  Future<void> alert(int id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dosyayı silmek istiyor musunuz?'),
          actions: <Widget>[
            TextButton(
              child: Text('Geri Dön'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                onPressed: () {
                  db.delete(id);
                  Navigator.of(context).pop();
                },
                child: Text('Sil'))
          ],
        );
      },
    );
  }
}
