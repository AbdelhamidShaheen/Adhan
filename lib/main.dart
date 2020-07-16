import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan_flutter/adhan_flutter.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          cardTheme: CardTheme(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              color: Colors.deepOrange,
              shadowColor: Colors.cyan),
          textTheme: TextTheme(
              bodyText2: TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      home: Adhan(),
    );
  }
}

class Adhan extends StatefulWidget {
  @override
  _AdhanState createState() => _AdhanState();
}

class _AdhanState extends State<Adhan> {
  var chroc, fagr, zahr, asr, magrp, asha, nextPray;
  DateTime nextPrayTime;
  bool chekedMohzn1 = false;
  bool chekedMohzn2 = false;
  bool chekedMohzn3 = false;
  bool chekedMohzn4 = false;

  @override
  Widget build(BuildContext context) {
    updateState();
    return Scaffold(
      endDrawer: Opacity(
        opacity: 1,
        child: Drawer(
          elevation: 100,
          child: Container(
            color: Colors.deepOrangeAccent,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Text(
                    "المؤذن",
                    style:
                        TextStyle(fontSize: 40, color: Colors.lightGreenAccent),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Switch(
                          value: this.chekedMohzn1,
                          onChanged: (state) {
                            if (state)
                              setState(() {
                                this.chekedMohzn1 = state;
                                this.chekedMohzn2 = false;
                                this.chekedMohzn3 = false;
                                this.chekedMohzn4 = false;
                              });
                          }),
                      Text("عبدالباسط عبد الصمد")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Switch(
                          value: this.chekedMohzn2,
                          onChanged: (state) {
                            if (state)
                              setState(() {
                                this.chekedMohzn2 = state;
                                this.chekedMohzn1 = false;
                                this.chekedMohzn3 = false;
                                this.chekedMohzn4 = false;
                              });
                          }),
                      Text("عبدالباسط عبد الصمد")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Switch(
                          value: this.chekedMohzn3,
                          onChanged: (state) {
                            if (state)
                              setState(() {
                                this.chekedMohzn3 = state;
                                this.chekedMohzn1 = false;
                                this.chekedMohzn2 = false;
                                this.chekedMohzn4 = false;
                              });
                          }),
                      Text("عبدالباسط عبد الصمد")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Switch(
                          value: this.chekedMohzn4,
                          onChanged: (state) {
                            if (state)
                              setState(() {
                                this.chekedMohzn4 = state;
                                this.chekedMohzn1 = false;
                                this.chekedMohzn2 = false;
                                this.chekedMohzn3 = false;
                              });
                          }),
                      Text("عبدالباسط عبد الصمد")
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "صلاتى",
          style: TextStyle(
              color: Colors.deepOrangeAccent,
              fontSize: 35,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.lightGreenAccent,
              Colors.green,
              Colors.lightGreenAccent,
              Colors.green,
              Colors.lightGreenAccent,
              Colors.green,
              Colors.lightGreenAccent,
            ])),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: FutureBuilder(
                future: getPray(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  Widget child;
                  if (snapshot.hasData) {
                    child = getCards();
                  } else {
                    child = Center(
                        child: SizedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.amber,
                        strokeWidth: 10,
                      ),
                    ));
                  }

                  return child;
                }),
          )
        ],
      ),
    );
  }

  getCards() {
    return Column(
      children: <Widget>[
        Expanded(
            flex: 2,
            child: Container(
              constraints: BoxConstraints.expand(),
              child: Card(
                  shape: CircleBorder(
                      side: BorderSide(
                          color: Colors.cyanAccent,
                          width: 10,
                          style: BorderStyle.solid)),
                  shadowColor: Colors.cyanAccent,
                  color: Colors.deepOrangeAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "باقى على",
                        style: TextStyle(
                          color: Colors.cyanAccent,
                        ),
                      ),
                      Text(
                        "${getArabicName(this.nextPray)}",
                        style: TextStyle(
                          color: Colors.cyanAccent,
                        ),
                      ),
                      Text(
                        "${getRestTime()}",
                        style: TextStyle(
                          color: Colors.cyanAccent,
                        ),
                      )
                    ],
                  )),
            )),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: Card(
          child: Row(
            children: <Widget>[
              Text("${DateFormat().add_jm().format(this.fagr)}"),
              Text("الفجر")
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        )),
        Expanded(
            child: Card(
          child: Row(
            children: <Widget>[
              Text("${DateFormat().add_jm().format(this.chroc)}"),
              Text("الشروق")
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        )),
        Expanded(
            child: Card(
          child: Row(
            children: <Widget>[
              Text("${DateFormat().add_jm().format(this.zahr)}"),
              Text("الظهر")
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        )),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: Card(
          child: Row(
            children: <Widget>[
              Text("${DateFormat().add_jm().format(this.asr)}"),
              Text("العصر")
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        )),
        Expanded(
            child: Card(
          child: Row(
            children: <Widget>[
              Text("${DateFormat().add_jm().format(this.magrp)}"),
              Text("المغرب")
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        )),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: Card(
          child: Row(
            children: <Widget>[
              Text("${DateFormat().add_jm().format(this.asha)}"),
              Text("العشاء")
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        )),
      ],
    );
  }

  getPray() async {
    Position position = await Geolocator().getCurrentPosition();

    var adhan = AdhanFlutter.create(
        Coordinates(position.latitude, position.longitude),
        DateTime.now(),
        CalculationMethod.EGYPTIAN);

    this.chroc = await adhan.sunrise;
    this.zahr = await adhan.dhuhr;
    this.asr = await adhan.asr;
    this.magrp = await adhan.maghrib;
    this.asha = await adhan.isha;
    this.fagr = await adhan.fajr;
    // list of pray
    print("??????????????????????????????${this.magrp.hour}");

    try {
      this.nextPray = await fetNextPrayer(await adhan.currentPrayer());

      this.nextPrayTime = await adhan.timeForPrayer(this.nextPray);
    } catch (Ex) {
      print(">>>>>>>>>>>>>>>>>>>>>>>>$Ex");
    }

    return true;
  }

  fetNextPrayer(Prayer current) {
    List<Prayer> pray = [
      Prayer.FAJR,
      Prayer.SUNRISE,
      Prayer.DHUHR,
      Prayer.ASR,
      Prayer.MAGHRIB,
      Prayer.ISHA
    ];
    int index = pray.indexWhere((element) => element == current);
    if (index == 5) {
      index = 0;
      return pray.elementAt(index);
    }
    return pray.elementAt(index + 1);
  }

  getArabicName(Prayer p) {
    switch (p) {
      case Prayer.SUNRISE:
        return "الشروق";
        break;
      case Prayer.FAJR:
        return "الفجر";
        break;
      case Prayer.DHUHR:
        return "الظهر";
        break;
      case Prayer.ASR:
        return "العصر";
        break;
      case Prayer.MAGHRIB:
        return "المغرب";
        break;
      case Prayer.ISHA:
        return "العشاء";
        break;
      default:
        return "null";
    }
  } //end getArab

  getRestTime() {
    var nowTime = DateTime.now();
    int rHour = this.nextPrayTime.hour;
    int rminute = this.nextPrayTime.minute;
    int second = 60 - DateTime.now().second;

    var timeObject = DateTime(
        nowTime.year, nowTime.month, nowTime.day, rHour, rminute, second);
    var time = timeObject
        .subtract(Duration(hours: nowTime.hour, minutes: nowTime.minute));

    return "${DateFormat("h:mm:ss").format(time)}";
  }

  updateState() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
  }
} //end adhan
