import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:splashscreen/splashscreen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: DockerApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class DockerApp extends StatefulWidget {
  @override
  _DockerAppState createState() => _DockerAppState();
}

class _DockerAppState extends State<DockerApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 20,
      navigateAfterSeconds: new MainPage(),
      backgroundColor: Colors.white10,
      image: Image.asset(
        "assets/google-firestore.png",
        alignment: Alignment.center,
      ),
      photoSize: 150,
      title: Text(
        "FIRESTORE",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      loadingText: Text(
        "Loading",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      loaderColor: Colors.red,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("KNOW ABOUT FIREBASE !!"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                margin: EdgeInsets.only(top: 105),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      "https://image.freepik.com/free-photo/blue-orange-yellow-color-papers-background_23-2147981628.jpg",
                    ),
                    fit: BoxFit.cover),
              ),
            ),
            ListTile(
                title: Text(
                  'CONSOLE',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(
                  Icons.developer_mode,
                  size: 30,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendData(),
                      ));
                }),
            ListTile(
                title: Text(
                  'DATABASES',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Icon(
                  Icons.storage,
                  size: 30,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GetData(),
                      ));
                }),
          ],
        ),
      ),
      body: Container(
        height: 700,
        padding: EdgeInsets.all(5),
        child: ListView(
          children: [
            Container(
              height: 680,
              decoration: BoxDecoration(
                border: Border.all(width: 20, color: Colors.orange[100]),
                image: DecorationImage(
                  alignment: Alignment.center,
                  image: NetworkImage(
                      "https://miro.medium.com/max/3840/1*cGKDeKFfjJbQbh9B8X2uMg.gif"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendData extends StatefulWidget {
  @override
  _SendDataState createState() => _SendDataState();
}

class _SendDataState extends State<SendData> {
  var url, cmd, webdata, txt;
  var index = 0;

  web(cmd) async {
    url = "http://192.168.43.195/cgi-bin/linux_firebase.py?x=${cmd}";
    var response = await http.get(url);

    print(webdata);
    setState(() {
      webdata = response.body;
      FirebaseFirestore fscon = FirebaseFirestore.instance;
      fscon.collection("firebases").add({
        "Command Executed": webdata,
        "Current Time": DateTime.now(),
        "Operating System": Platform.operatingSystem,
        "Version": Platform.operatingSystemVersion,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var myScaffold = Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome Flutter_Firebase!",
        ),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 50, top: 50, right: 40, bottom: 20),
              child: TextField(
                autofocus: false,
                enabled: true,
                cursorColor: Colors.red,
                decoration: InputDecoration(
                    hintText: "Enter the Suffix (eg. 'images' )",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.black))),
                onChanged: (value) {
                  cmd = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 100, right: 100, bottom: 20),
              alignment: Alignment.center,
              width: 20,
              height: 40,
              color: Colors.blue[400],
              child: FlatButton(
                onPressed: () {
                  web(cmd);
                },
                child: Text(
                  "Execute",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                width: 200,
                height: 400,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    width: 5,
                    color: Colors.blue,
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.only(top: 50),
                  scrollDirection: Axis.horizontal,
                  children: [
                    Text(
                      webdata ?? "  Connecting to RedHat Server...",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
    return myScaffold;
  }
}

class GetData extends StatefulWidget {
  @override
  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  var url, cmd, txt;
  var i;
  var data;
  fetchFireData() async {
    var fscon = FirebaseFirestore.instance;
    data = await fscon.collection("firebases").get();
    for (i in data.docs) {
      print(i.data());
    }
  }

  @override
  Widget build(BuildContext context) {
    var myScaffold = Scaffold(
      appBar: AppBar(
        title: Text(
          "STORAGE",
        ),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 80),
        child: ListView(children: <Widget>[
          Image(
              image: AssetImage(
            "assets/google-firestore.png",
          )),
          Container(
            margin:
                EdgeInsets.only(left: 100, right: 100, bottom: 20, top: 100),
            alignment: Alignment.center,
            width: 20,
            height: 40,
            color: Colors.blue[400],
            child: FlatButton(
              onPressed: () => fetchFireData(),
              child: Text(
                "Fetch Results",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
    return myScaffold;
  }
}
