import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:bodilyquiz/scorepage.dart';

class getjson extends StatelessWidget {

  String langname;
  getjson(this.langname);
  String assettoload;

  setasset() {
    if (langname == "Flutter") {
      assettoload = "assets/flutter.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    setasset();
    return FutureBuilder(
      future:
      DefaultAssetBundle.of(context).loadString(assettoload, cache: true),
      builder: (context, snapshot) {
        List MyData = json.decode(snapshot.data.toString());
        if (MyData == null) {
          return Scaffold(
            body: Center(
              child: Text(
                "Loading",
              ),
            ),
          );
        } else {
          return QuizScreen(MyData: MyData);
        }
      },
    );
  }
}

class QuizScreen extends StatefulWidget {
  var MyData;

  QuizScreen({Key key, @required this.MyData}) : super(key: key);
  @override
  _QuizScreenState createState() => _QuizScreenState(MyData);
}

class _QuizScreenState extends State<QuizScreen> {
  var MyData;
  _QuizScreenState(this.MyData);

  Color colortoshow = Colors.pinkAccent;
  Color right = Colors.green;
  Color wrong = Colors.red;
  int marks = 0;
  int i = 1;
  int j = 1;
  int timer = 30;
  String showtimer = "30";
  var random_array;

  Map<String, Color> btncolor = {
    "a": Colors.pinkAccent,
    "b": Colors.pinkAccent,
    "c": Colors.pinkAccent,
    "d": Colors.pinkAccent,
  };

  bool canceltimer = false;

  genrandomarray(){
    var distinctIds = [];
    var rand = new Random();
    for (int i = 0; ;) {
      distinctIds.add(rand.nextInt(5));
      random_array = distinctIds.toSet().toList();
      if(random_array.length < 5){
        continue;
      }else{
        break;
      }
    }
    print(random_array);
  }

  @override
  void initState() {
    starttimer();
    genrandomarray();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextquestion();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });
  }

  void nextquestion() {
    canceltimer = false;
    timer = 30;
    setState(() {
      if (j < 5) {
        i = random_array[j];
        j++;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ScorePage(marks: marks),
        ));
      }
      btncolor["a"] = Colors.pinkAccent;
      btncolor["b"] = Colors.pinkAccent;
      btncolor["c"] = Colors.pinkAccent;
      btncolor["d"] = Colors.pinkAccent;
    });
    starttimer();
  }

  void checkanswer(String k) {
    if (MyData[2][i.toString()] == MyData[1][i.toString()][k]) {
      marks = marks + 5;
      colortoshow = right;
    } else {
      colortoshow = wrong;
    }
    setState(() {
      btncolor[k] = colortoshow;
      canceltimer = true;
    });

    Timer(Duration(seconds: 1), nextquestion);
  }

  Widget choicebutton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkanswer(k),
        child: Text(
          MyData[1][i.toString()][k],
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: btncolor[k],
        splashColor: Colors.pink[700],
        highlightColor: Colors.pink[700],
        minWidth: 200.0,
        height: 45.0,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "Bodilyquiz",
              ),
              content: Text("You Can't Go Back At This Stage."),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ok',
                  ),
                )
              ],
            ));
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  MyData[0][i.toString()],
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Quando",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    choicebutton('a'),
                    choicebutton('b'),
                    choicebutton('c'),
                    choicebutton('d'),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                    showtimer,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}