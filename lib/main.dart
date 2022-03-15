import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import './api.dart';
import 'package:location/location.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getlocation() async {
    Location location = new Location();

// bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    // print(_locationData.latitude);
    // print(_locationData.longitude);
    return _locationData;
  }

  // print(data);
  printdata() async {
    final location = await getlocation();
    print(location);
    final data =
        await Api().getSensorData(location.latitude, location.longitude);
    print(data);

    return {'data': data, 'location': location};
  }

  var length = 200;
  var gutterheight = 100;

  color(dist, rate) {
    print(dist);
    print(rate);
    if (dist >= 100) {
      //logic for not overflowing
      if (rate <= 0 && dist > 110) {
        return Color.fromARGB(255, 248, 130, 169);
      } else if (rate > 0 && rate < 2 && dist > 100 && dist < 110) {
        return Color.fromARGB(255, 39, 150, 241);
      } else if (rate > 2 && dist > 100 && dist < 110) {
        return Color.fromARGB(255, 218, 132, 3);
      }
    } else {
      // logic for overflowing
      if (dist > 90 && dist < 100) {
        return Colors.green;
      } else if (dist > 70 && dist < 90) {
        return Colors.yellow;
      } else if (dist < 70) {
        return Colors.red;
      }
      //  else if ((length - dist) - gutterheight < 2) {
      //   return Colors.blue;
      // } else if (rate > 2 && gutterheight - (length - dist) < 2) {
      //   return Colors.orange;
      // } else if ((length - dist) - gutterheight <= 4 ) {
      //   return Colors.yellow;
      // }  else if ((length - dist) - gutterheight <= 7 && dist > 4) {
      //   return Colors.green;
      // }
    }
  }

  ListTile _tile(String title, IconData icon, color) {
    return ListTile(
      dense: true,
      //contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      //contentPadding:
      //EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0.0, top: 0.0),
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      minVerticalPadding: 0,
      title: Text(title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 10,
          )),
      leading: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      // style: Theme.of(context).textTheme.headline2!,
      style: TextStyle(fontSize: 36, color: Colors.blue),
      textAlign: TextAlign.center,
      child: FutureBuilder(
        future: printdata(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Widget> children;
          // print(snapshot.data['location'].latitude);
          // print(snapshot.data['data']);
          if (snapshot.hasData) {
            //children = <Widget>[
//map

            //   const Icon(
            //   Icons.check_circle_outline,
            //   color: Colors.green,
            //   size: 60,
            // ),
            // //for(int i=0;i<=2;i++) Icon(Icons.check_circle_outline,color: Colors.green,size: 60),
            // for(var i in snapshot.data) Text(i['latitude']['S']),
            // Padding(
            //  padding: const EdgeInsets.only(top: 16),
            //    child: Text('Result:  ${snapshot.data[0]['latitude']['S']}'),
            //  )
            //];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          }
          // return Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: children,
          //   ),
          // );
          // var a = getlocation();

          return new Scaffold(
              appBar: new AppBar(title: new Text('Maps')),
              //appBar: new AppBar(title: new Text(data[0]['sensorid']['S'])),

              body: Stack(
                children: <Widget>[
                  new FlutterMap(
                    options: new MapOptions(
                        //center: new LatLng(snapshot.data['location'].latitude,
                        //snapshot.data['location'].longitude),
                        center: new LatLng(19.0727, 72.8979),
                        minZoom: 10.0),
                    layers: [
                      new TileLayerOptions(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c']),
                      new MarkerLayerOptions(markers: [
                        new Marker(
                          width: 45.0,
                          height: 45.0,
                          // point: new LatLng(snapshot.data['location'].latitude,
                          // snapshot.data['location'].longitude),
                          point: new LatLng(19.0727, 72.8979),
                          builder: (context) => new Container(
                              child: IconButton(
                            icon: Icon(Icons.adjust_rounded),
                            color: Colors.black,
                            iconSize: 35.0,
                            onPressed: () {
                              //                 final snackBar = SnackBar(
                              //   content: const Text('Your Current Location'),
                              //   action: SnackBarAction(
                              //     label: 'Undo',
                              //     onPressed: () {
                              //       // Some code to undo the change.
                              //     },
                              //   ),
                              // );

                              // // Find the ScaffoldMessenger in the widget tree
                              // // and use it to show a SnackBar.
                              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                          )),
                        ),
                        for (var i in snapshot.data['data'])
                          new Marker(
                            width: 45.0,
                            height: 45.0,
                            point: new LatLng(double.parse(i['latitude']['S']),
                                double.parse(i['longitude']['S'])),
                            builder: (context) => new Container(
                                child: IconButton(
                              icon: Icon(
                                Icons.location_on,
                                semanticLabel:
                                    'Text to announce in accessibility modes',
                              ),
                              color: color(double.parse(i['distance']['S']),
                                  double.parse(i['rate']['S'])),
                              iconSize: 45.0,

                              onPressed: () {
                                //                   final snackBar = SnackBar(
                                //   content: const Text('Your Current Location'),
                                //   action: SnackBarAction(
                                //     label: 'Undo',
                                //     onPressed: () {
                                //       // Some code to undo the change.
                                //     },
                                //   ),
                                // );

                                // // Find the ScaffoldMessenger in the widget tree
                                // // and use it to show a SnackBar.
                                //  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              },

                              // tooltip: tooltip_text,
                            )),
                          ),
                      ]),
                    ],
                  ), //flutter maps
                  Positioned(
                    // right: 40.0,
                    // top: 40.0,
                    bottom: 10.0,
                    right: 10.0,

                    child: Container(
                        color: Colors.black.withOpacity(0.2),
                        height: 110.0,
                        width: 150.0,
                        child: ListView(
                          children: [
                            const Text('Flooding',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            _tile('Low', Icons.location_on, Colors.green),
                            _tile('Medium', Icons.location_on, Colors.yellow),
                            _tile('Hign', Icons.location_on, Colors.red),
                          ],
                        )

                        // color: Colors.pink,
                        // height: 190.0,
                        // width: 150.0,
                        // padding: const EdgeInsets.all(20),
                        // child: Row(
                        //   children: [
                        //     Column(
                        //       children: [
                        //         Icon(Icons.location_on, color: Colors.black),
                        //         Icon(Icons.location_on, color: Colors.cyan),
                        //         Icon(Icons.location_on, color: Colors.white),
                        //         Icon(Icons.location_on, color: Colors.yellow),
                        //         Icon(Icons.location_on, color: Colors.green),
                        //         Icon(Icons.location_on, color: Colors.blue),

                        //       ],
                        //     ),

                        //     Column(
                        //       //mainAxisSize: MainAxisSize.min,
                        //       children: <Widget>[
                        //         const Text('location '),
                        //         const Text('location '),
                        //       ],
                        //     ),
                        //     // const Text(
                        //     //   '170 Reviews',
                        //     //   style: TextStyle(
                        //     //     color: Colors.black,
                        //     //     fontWeight: FontWeight.w800,
                        //     //     fontFamily: 'Roboto',
                        //     //     letterSpacing: 0.2,
                        //     //     fontSize: 10,
                        //     //   ),
                        //     // ),
                        //   ],
                        // )
                        ),
                  ),
                  Positioned(
                    // right: 40.0,
                    // top: 40.0,
                    bottom: 10.0,
                    left: 10.0,

                    child: Container(
                        color: Colors.black.withOpacity(0.2),
                        height: 110.0,
                        width: 150.0,
                        child: ListView(
                          children: [
                            const Text('Prediction',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            _tile('No Flooding', Icons.location_on,
                                Color.fromARGB(255, 248, 130, 169)),
                            _tile('Medium', Icons.location_on,
                                Color.fromARGB(255, 39, 150, 241)),
                            _tile('High', Icons.location_on,
                                Color.fromARGB(255, 218, 132, 3)),
                          ],
                        )

                        // color: Colors.pink,
                        // height: 190.0,
                        // width: 150.0,
                        // padding: const EdgeInsets.all(20),
                        // child: Row(
                        //   children: [
                        //     Column(
                        //       children: [
                        //         Icon(Icons.location_on, color: Colors.black),
                        //         Icon(Icons.location_on, color: Colors.cyan),
                        //         Icon(Icons.location_on, color: Colors.white),
                        //         Icon(Icons.location_on, color: Colors.yellow),
                        //         Icon(Icons.location_on, color: Colors.green),
                        //         Icon(Icons.location_on, color: Colors.blue),

                        //       ],
                        //     ),

                        //     Column(
                        //       //mainAxisSize: MainAxisSize.min,
                        //       children: <Widget>[
                        //         const Text('location '),
                        //         const Text('location '),
                        //       ],
                        //     ),
                        //     // const Text(
                        //     //   '170 Reviews',
                        //     //   style: TextStyle(
                        //     //     color: Colors.black,
                        //     //     fontWeight: FontWeight.w800,
                        //     //     fontFamily: 'Roboto',
                        //     //     letterSpacing: 0.2,
                        //     //     fontSize: 10,
                        //     //   ),
                        //     // ),
                        //   ],
                        // )
                        ),
                  ),
                ], //widget
              ) //Stack Ends
              );
        },
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   var apidata = printdata();
  //   apidata.then((val) {
  //     print(val[0]);
  //     print(val.length);
  //   });
  //   return new Scaffold(
  //       appBar: new AppBar(title: new Text('Leaflet Maps')),
  //       //appBar: new AppBar(title: new Text(data[0]['sensorid']['S'])),

  //         body: new FlutterMap(
  //           options:
  //               new MapOptions(center: new LatLng(19.073, 72.899), minZoom: 10.0),
  //           layers: [
  //             new TileLayerOptions(
  //                 urlTemplate:
  //                     "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
  //                 subdomains: ['a', 'b', 'c']),
  //             new MarkerLayerOptions(markers: [
  //               new Marker(
  //                 width: 45.0,
  //                 height: 45.0,
  //                 point: new LatLng(19.073, 72.899),
  //                 builder: (context) => new Container(
  //                     child: IconButton(
  //                   icon: Icon(Icons.location_on),
  //                   color: Colors.red,
  //                   iconSize: 45.0,
  //                   onPressed: () {
  //                     print('Marker Tapped');
  //                   },
  //                 )),
  //               ),
  //             ])
  //           ],
  //         ));
  // }
}
