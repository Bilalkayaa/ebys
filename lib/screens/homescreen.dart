import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../dataB/foldertable.dart';
import '../user/file.dart';
import 'belgeGonder.dart';
import 'belgeOlustur.dart';
import 'gelenBelgeler.dart';
import 'gonderilenBelgeler.dart';

class HomeScreen extends StatefulWidget {
  final GetStorage box;

  HomeScreen({required this.box});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreen(box: box);
  }
}

class _HomeScreen extends State<HomeScreen> {
  final GetStorage box;
  late List<file> files = [];
  var db = DbHelperfile();
  int filecount = 0;
  int unread = 0;

  void initState() {
    super.initState();
    getFiles();
    bak2();
  }

  _HomeScreen({required this.box});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    unread = getUnreadFileCount();
    //bak();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
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
          "Hoşgeldiniz ${(box.read("name")).toString().toUpperCase()}",
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/wqew.jpg",
              fit: BoxFit.fitWidth,
              colorBlendMode: BlendMode.dstATop,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 225.0,
                horizontal: 40.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GelenBelgeler(),
                    GonderilenBelgeler(),
                    BelgeGonder(),
                    Belgeolustur(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget GelenBelgeler() {
    return ElevatedButton(
        onPressed: () {
          updateFileAsRead();
          unread = getUnreadFileCount();
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => gelenBelgeler(box: box))))
              .then((value) {
            setState(() {});
          });

          bak2();
          print("*************");
        },
        child: Text("Gelen Belgeler" + "\nOkunmamış:" + "($unread)",
            style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal)),
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 4, 245, 255),
            fixedSize: Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            )));
  }

  Widget BelgeGonder() {
    return Container(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => belgeGonder(
                            box: box,
                          ))));
            },
            child: Text("Belge Gönder",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal)),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 4, 245, 255),
                fixedSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ))));
  }

  Widget GonderilenBelgeler() {
    return Container(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => gonderilenBelgeler(
                            box: box,
                          ))));
            },
            child: Text("Gonderilen Belgeler",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal)),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 4, 245, 255),
                fixedSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ))));
  }

  Widget Belgeolustur() {
    return Container(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => belgeOlustur(box: box))));
            },
            child: Text("Belge Oluştur",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal)),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 4, 245, 255),
                fixedSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ))));
  }

  Future<void> getFiles() async {
    var usersFuture = db.getfiles();
    usersFuture.then((data) {
      this.files = data;
      filecount = data.length;
      setState(() {});
    });
  }

  void bak() {
    unread = 0;
    for (var fileObj in files) {
      if (fileObj.toemployee == box.read("id") && fileObj.flag == 1) {
        db.updateFlag(box.read("id"));
        unread++;
      }
    }
  }

  void updateFileAsRead() {
    for (var fileObj in files) {
      if (fileObj.toemployee == box.read("id") && fileObj.flag == 1) {
        db.updateFlag(box.read("id"));
      }
    }
    getFiles();
  }

  int getUnreadFileCount() {
    int unreadFileCount = 0;
    for (var pFile in files) {
      if (pFile.toemployee == box.read("id") && pFile.flag == 1)
        unreadFileCount++;
    }
    return unreadFileCount;
  }

  void bak2() {
    for (var userObj in files) {
      print('path: ${userObj.path}');
      print('flag: ${userObj.flag}');
    }
  }
}
