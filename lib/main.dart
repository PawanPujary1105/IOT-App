import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import "package:custom_switch/custom_switch.dart";

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool switchVal;
  String textVal;
  int apiVal;
  var contColor = Colors.amber,textColor = Colors.cyan;

  setDataOneApi() async {
    await Dio().post("https://api.thingspeak.com/update?api_key=1ZJ4KA5ZLPTZYGV1&field1=1");
  }

  getDataApi() async{
    var resp = await Dio().get("https://api.thingspeak.com/channels/789962/feeds.json?api_key=M0MTMZWEA0SWDJMS&results=2");
    print(resp.data);
    return int.parse(resp.data['feeds'][1]['field1']);
  }

  setDataZeroApi() async {
    await Dio().post("https://api.thingspeak.com/update?api_key=1ZJ4KA5ZLPTZYGV1&field1=0");
  }

  @override
  void initState(){
    getDataApi().then((res){
      setState(() {
        apiVal=res;
        if(apiVal==0){
          switchVal=false;
          textVal="On";
        }
        else{
          switchVal=true;
          textVal="Off";
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: apiVal!=null?Container(
          color: contColor,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 300,
                ),
                CustomSwitch(
                    value: switchVal,
                    activeColor: Colors.lightGreenAccent,
                    onChanged: (val) {
                      setState(() {
                        switchVal = val;
                        if (textVal == "On") {
                          textVal = "Off";
                          contColor = Colors.cyan;
                          textColor=Colors.amber;
                        } else {
                          textVal = "On";
                          contColor = Colors.amber;
                          textColor=Colors.cyan;
                        }
                      });
                      if (val == true) {
                        setDataOneApi();
                      } else {
                        setDataZeroApi();
                      }
                    }),
                SizedBox(height:15),
                Text(
                  "Press to Switch " + textVal,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: textColor),
                ),
              ],
            ),
          ),
        ):Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
