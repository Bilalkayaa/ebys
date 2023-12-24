import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import '../dataB/dBHelper.dart';
import '../dataB/foldertable.dart';
import '../user/file.dart';
import '../user/user.dart';

class gelenBelgeler extends StatefulWidget {
  final GetStorage box;

  gelenBelgeler({required this.box});

  @override
  State<StatefulWidget> createState() {
    return _gelenBelgeler(box: box);
  }
}

class _gelenBelgeler extends State<gelenBelgeler> {
  late List<file> files = [];
  late List<user> users = [];
  var db = DbHelperfile();
  var dbusers = DbHelper();
  final GetStorage box;
  int filecount = 0;
  int userCount = 0;
  _gelenBelgeler({required this.box});
  @override
  void initState() {
    super.initState();
    getFiles();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    getFiles();
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
          "Gelen Belgeler",
        ),
      ),
      body: buildFileList(),
    );
  }

  ListView buildFileList() {
    return ListView.builder(
      itemCount: filecount,
      itemBuilder: (BuildContext context, int positions) {
        int reversedIndex = filecount - positions - 1;
        if (box.read("id") == this.files[reversedIndex].toemployee) {
          return Card(
            color: Colors.grey,
            elevation: 20.0,
            shape: StadiumBorder(),
            child: ListTile(
              trailing: Text(
                "Kimden: " +
                    this
                        .users[this.files[reversedIndex].fromemployee! - 1]
                        .name!
                        .toUpperCase() +
                    " " +
                    this
                        .users[this.files[reversedIndex].fromemployee! - 1]
                        .lastName!
                        .toUpperCase() +
                    "\n" +
                    this.files[positions].date!,
              ), // burayı sor
              leading: Icon(
                Icons.folder,
                color: Colors.black,
                size: 40,
              ),
              title: Text(this.files[reversedIndex].path!.split('/').last),
              onTap: () {
                OpenFile.open(this.files[reversedIndex].path!);
              },
              onLongPress: () {
                alert(this.files[reversedIndex].id!).then((value) {
                  getFiles();
                  getUsers();
                });
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
