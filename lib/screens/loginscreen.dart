import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../dataB/dBHelper.dart';
import '../dataB/showmassage.dart';
import '../user/user.dart';
import 'homescreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  var db = DbHelper();
  var formKey = GlobalKey<FormState>();
  var txtemail = TextEditingController();
  var txtpassword = TextEditingController();
  late List<user> users = [];
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    /*
    db.insert(user(name: "bilal",lastName: "asd",email: "bilal",password: "123"));
    db.insert(user(name: "ahmet",lastName: "qwe",email: "ahmet",password: "12cle3"));
    db.insert(user(name: "ali",lastName: "zxc",email: "ali",password: "123"));*/

    getUsers();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "EBYS",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/wqew.jpg",
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.dstATop,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Container(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Welcome(),
                    buildEmail(),
                    buildPassword(),
                    buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Welcome() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'EBYS',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildEmail() {
    return Container(
      child: TextFormField(
        controller: txtemail,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: CustomInputDecoration(
            labelText: "E-mail", hintText: "email@example.com"),
      ),
    );
  }

  Widget buildPassword() {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: TextFormField(
        controller: txtpassword,
        obscureText: true,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration:
            CustomInputDecoration(labelText: "Password", hintText: "123"),
        onSaved: (value) {},
      ),
    );
  }

  Widget buildLoginButton() {
    return Container(
      margin: EdgeInsets.only(
        top: 25,
        bottom: 10.0,
        left: 100,
        right: 100,
      ),
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
          bak();
          check(txtemail.text, txtpassword.text);
        },
        child: Text(
          'Giriş yap',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void getUsers() {
    var usersFuture = db.getusers();
    usersFuture.then((data) {
      this.users = data;
    });
  }

  void bak() {
    for (var userObj in users) {
      print('ID: ${userObj.id}');
      print('Name: ${userObj.name}');
      print('Last Name: ${userObj.lastName}');
      print('Email: ${userObj.email}');
      print('Password: ${userObj.password}');
      print('------------------------');
    }
  }

  void check(String txtemail, String txtpassword) async {
    bool flag = false;

    for (var userObj in users) {
      if (userObj.email == txtemail && txtpassword == userObj.password) {
        box.write("name", userObj.name);
        box.write("lastName", userObj.lastName);
        box.write("email", userObj.email);
        box.write("password", userObj.password);
        box.write("id", userObj.id);
        print(box.read("name"));

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomeScreen(box: box)));
        flag = true;
        break;
      }
    }
    if (flag == false) {
      showSnackBar(context, "Kullanıcı adı veya şifre hatalı!");
    }
  }
}

class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration({required String labelText, required String hintText})
      : super(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 4, 245, 255)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 4, 245, 255)),
          ),
        );
}
