import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  Future getSensorData(lat, long) async {
    //final response = await http.get(Uri.parse(
        //"https://ov2x2abgq3.execute-api.us-east-2.amazonaws.com/final_stage/sensordata?latitude=${lat}&longitude=${long}"));
       // final response = await http.get(Uri.parse(
      //  "https://y47rbvwmmc.execute-api.us-east-2.amazonaws.com/2deployapp/sensordata?latitude=${lat}&longitude=${long}")); //new API (kiran ma'am)
     //final response = await http.get(Uri.parse(
     //"https://ov2x2abgq3.execute-api.us-east-2.amazonaws.com/final_stage/sensordata?latitude=19.0727&longitude=72.8979"));
       final response = await http.get(Uri.parse(
      "https://y47rbvwmmc.execute-api.us-east-2.amazonaws.com/2deployapp/sensordata?latitude=19.0727&longitude=72.8979"));
    // print(response.body);
    //print(lat.runtimeType);
    // print(latype);
    // print(long);

    final jsonData = jsonDecode(response.body);
    return jsonData;
    // for (int i = 0; i < jsonData.length; i++) {
    //   print(jsonData[i]);
    //   print("******");
    // }
    // print(jsonData[0]['sensorid']['S']);
  }
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: DataFromAPI(),
//     );
//   }
// }

// class DataFromAPI extends StatefulWidget {
//   @override
//   _DataFromAPIState createState() => _DataFromAPIState();
// }

// class _DataFromAPIState extends State<DataFromAPI> {
//   Future getSensorData(lat, long) async {
//     var queryParameters = {
//       'latitude': lat,
//       'longitude': long,
//     };
//     //final response = await http.get(Uri.parse(
//     // 'https://ov2x2abgq3.execute-api.us-east-2.amazonaws.com/final_stage/sensordata?latitude=19.0727&longitude=72.8979'));
//     final response = await http.get(Uri.parse(
//         'https://ov2x2abgq3.execute-api.us-east-2.amazonaws.com/final_stage/sensordata?latitude={$lat}&longitude={$long}'));

//     // print(response.body);

//     // final jsonData = jsonDecode(response.body);
//     // print(jsonData);
//     // for (int i = 0; i < jsonData.length; i++) {
//     //   print(jsonData[i]);
//     //   print("******");
//     // }
//     // // print(jsonData[0]['sensorid']['S']);

//     // return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("User Data"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text("click me"),
//           onPressed: () {
//             print("Hello123");
//             //getSensorData(lat,long);
//           },
//         ),
//       ),
//     );
//   }
// }

// class Sensor {
//   final String sensorid, distance, longi, lat;
//   Sensor(this.sensorid, this.distance, this.longi, this.lat);

//   @override
//   String toString() {
//     return '{ ${this.sensorid}, ${this.distance} , ${this.longi}, ${this.lat}}';
//   }
// }
