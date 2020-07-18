import 'dart:ui';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'HexColor.dart';
import 'GuestBook.dart';

void main() => runApp(WCS());

class WCS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wonmo Cyber school',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => _buildWebView(context, size)));
              },
              child: Container(
                child: Image(
                  image: AssetImage('assets/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Text("touch the logo"),
          ],
        ),
      ),
    );
  }
}

Widget _buildWebView(BuildContext context, Size size) {
  return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.book,
              color: Colors.grey[200],
            ),
            tooltip: "write guest book",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GuestBook()));
            },
          )
        ],
        elevation: 0,
        backgroundColor: HexColor("#4e7791"),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          width: size.width,
          height: size.height,
          child: WebView(
            initialUrl: 'https://wonmocyberschool.com',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ));
}
