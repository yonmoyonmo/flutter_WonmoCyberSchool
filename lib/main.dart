import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'HexColor.dart';
import 'GuestBook.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

void main() => runApp(WCS());

class WCS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wonmo Cyber school',
      home: HomePage(),
      theme: ThemeData(primaryColor: HexColor("#3a637f")),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _height = 100;
  Color _color = Colors.white;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: true,
      child: Scaffold(
        body: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          color: _color,
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  width: size.width,
                  height: 70,
                  child: Text(
                    "W O N M O      C Y B E R      S C H O O L",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              GestureDetector(
                onTap: () {
                  setState(() {
                    final random = Random();
                    _height = 100 + random.nextInt(100) + 10.toDouble();
                  });

                  _launchURL(context);
                },
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 20,
                        offset: Offset(0.0, 10.0),
                      )
                    ],
                    color: Theme.of(context).primaryColor,
                  ),
                  width: size.width,
                  height: _height,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    final random = Random();
                    _height = 100 + random.nextInt(100) + 10.toDouble();
                  });
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return GuestBook();
                  }));
                },
                child: AnimatedContainer(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 20,
                        offset: Offset(0.0, 10.0),
                      )
                    ],
                  ),
                  width: size.width,
                  height: _height,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  child: Image(
                    image: AssetImage('assets/gb.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "↑↑↑ T O U C H ↑↑↑",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _launchURL(BuildContext context) async {
  try {
    await launch(
      'https://wonmocyberschool.com/',
      option: CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: CustomTabsAnimation.slideIn(),
        extraCustomTabs: <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}
