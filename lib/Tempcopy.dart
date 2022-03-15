import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import './api.dart';

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
  // print(data);
  printdata() async {
    //final data = await Api().getSensorData(lat,long);
   // return data;
  }

  color(parameter) {
    if (parameter <= 4) {
      return Colors.green;
    } else if (parameter <= 7 && parameter > 4) {
      return Colors.blue;
    } else if (parameter > 7) {
      return Colors.red;
    }
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
          print(snapshot);
          if (snapshot.hasData) {
            children = <Widget>[
//map
            ];
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
          }
          return new Scaffold(
              appBar: new AppBar(title: new Text('Leaflet Maps')),
              //appBar: new AppBar(title: new Text(data[0]['sensorid']['S'])),

              body: new FlutterMap(
                options: new MapOptions(
                    center: new LatLng(19.073, 72.899), minZoom: 10.0),
                layers: [
                  new TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  new MarkerLayerOptions(markers: [
                    for (var i in snapshot.data)
                      new Marker(
                        width: 45.0,
                        height: 45.0,
                        point: new LatLng(double.parse(i['latitude']['S']),
                            double.parse(i['longitude']['S'])),
                        builder: (context) => new Container(
                            child: IconButton(
                          icon: Icon(Icons.location_on),
                          color: color(double.parse(i['distance']['S'])),
                          iconSize: 45.0,
                          onPressed: () {
                            print('Marker Tapped');
                          },
                        )),
                      ),
                  ])
                ],
              ));
        },
      ),
    );
  }
}
