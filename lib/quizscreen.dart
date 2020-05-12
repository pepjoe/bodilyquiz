import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bodilyquiz/navbutton/nextbutton.dart';
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
          debugPrint('File failed to load');
          return Scaffold(
            body: Center(
              child: Text(
                "Loading",
              ),
            ),
          );
        } else {
          debugPrint('Filed loaded!');
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

  Color colortoshow = Colors.deepPurpleAccent;
  Color right = Colors.green;
  Color wrong = Colors.red;
  int marks = 0;
  int i = 1;
  int j = 1;

  Map<String, Color> btncolor = {
    "a": Colors.deepPurpleAccent,
    "b": Colors.deepPurpleAccent,
    "c": Colors.deepPurpleAccent,
    "d": Colors.deepPurpleAccent,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void nextQuestion() {
    setState(() {
      if (j < 6) {
        i = j;
        j++;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ScorePage(marks: marks),
        ));
      }
      btncolor["a"] = Colors.deepPurpleAccent;
      btncolor["b"] = Colors.deepPurpleAccent;
      btncolor["c"] = Colors.deepPurpleAccent;
      btncolor["d"] = Colors.deepPurpleAccent;
    });
  }

  void checkAnswer(String k) {
    if (MyData[2][i.toString()] == MyData[1][i.toString()][k]) {
      marks = marks + 5;
      colortoshow = right;
    } else {
      colortoshow = wrong;
    }
    setState(() {
      btncolor[k] = colortoshow;
    });
  }

  Widget choiceButton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkAnswer(k),
        child: Text(
          MyData[1][i.toString()][k],
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Nunito",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: btncolor[k],
        splashColor: Colors.deepPurple[700],
        highlightColor: Colors.deepPurple[700],
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
                "Complete the flutter Bodilyquiz",
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
                    fontFamily: "Nunito",
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
                    choiceButton('a'),
                    choiceButton('b'),
                    choiceButton('c'),
                    choiceButton('d'),
                  ],
                ),
              ),
            ),
            Container(
                alignment: Alignment.topRight,
                child: RaisedButton(
                  onPressed: () {
                    nextQuestion();
                  },
                  child: NextButton(text:'NEXT'),
                ),
            )
          ],
        ),
      ),
    );
  }
}