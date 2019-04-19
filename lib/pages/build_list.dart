import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './trainstops.dart';

final String url =
    'https://suburbantransporttracker.firebaseio.com/trainId/trainsList.json';

final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();
//Repplce list noewtime with Trains list

class TrainListBuild extends StatefulWidget {
  final String _station;
  final String _towardsDirection;
  TrainListBuild(this._station, this._towardsDirection);
  @override
  State<StatefulWidget> createState() {
    return _TrainListState(_station, _towardsDirection);
  }
}

class _TrainListState extends State<TrainListBuild> {
  final String station;
  final String towardsDirection;
  Map data;
  List trains = [];

  _TrainListState(this.station, this.towardsDirection);

  Future<Map> _firebaseRequest() async {
    var response = await http.get(
      Uri.encodeFull(url),
    );
    data = jsonDecode(response.body);
    print(data);
    List trackingIds = data["trackingIds"];
    print(trackingIds);

    trains.clear();
    for (int i = 0; i < trackingIds.length; i++) {
      if (data[trackingIds[i]] != null &&
          data[trackingIds[i]]["update"]["live"] == true &&
          towardsDirection == data[trackingIds[i]]["towardsDirection"] &&
          data[trackingIds[i]]["stoppingStations"].contains(station)) {
        Duration delayTime;
        var stops = data[trackingIds[i]]["stops"];
        var stoppingStations = data[trackingIds[i]]["stoppingStations"];
        bool live = data[trackingIds[i]]["update"]["live"];
        DateTime lastLocScheduledTime = DateTime.parse(data[trackingIds[i]]
                ["stops"][data[trackingIds[i]]["update"]["updateLocation"]]
            ["scheduletime"]);
        DateTime lastLocLiveUpdateTime =
            DateTime.parse(data[trackingIds[i]]["update"]["actualCreatedAt"]);
        delayTime = lastLocLiveUpdateTime.difference(lastLocScheduledTime);

        trains.add({
          "dataIndex": i,
          "stops": stops,
          "delayTime": delayTime,
          "stoppingStations": stoppingStations,
          "live": live,
          "destination": data[trackingIds[i]]["destination"],
          "pace": data[trackingIds[i]]["pace"],
          "route": data[trackingIds[i]]["route"],
          "source": data[trackingIds[i]]["source"],
          "towardsDirection": data[trackingIds[i]]["towardsDirection"],
          "trainId": data[trackingIds[i]]["trainId"],
          "update": data[trackingIds[i]]["update"]
        });
      } else {
        if (data[trackingIds[i]] != null &&
            data[trackingIds[i]]["update"]["live"] == false &&
            towardsDirection == data[trackingIds[i]]["towardsDirection"] &&
            data[trackingIds[i]]["stoppingStations"].contains(station)) {
          Duration delayTime = Duration.zero;
          var stops = data[trackingIds[i]]["stops"];
          var stoppingStations = data[trackingIds[i]]["stoppingStations"];
          bool live = data[trackingIds[i]]["update"]["live"];

          trains.add({
            "dataIndex": i,
            "stops": stops,
            "delayTime": delayTime,
            "stoppingStations": stoppingStations,
            "live": live,
            "destination": data[trackingIds[i]]["destination"],
            "pace": data[trackingIds[i]]["pace"],
            "route": data[trackingIds[i]]["route"],
            "source": data[trackingIds[i]]["source"],
            "towardsDirection": data[trackingIds[i]]["towardsDirection"],
            "trainId": data[trackingIds[i]]["trainId"],
            "update": data[trackingIds[i]]["update"]
          });
        }
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      child: StreamBuilder(
        stream: _firebaseRequest().asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scrollbar(
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                itemCount: trains.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime scheduletime = DateTime.parse(
                      trains[index]["stops"][station]["scheduletime"]);
                  Duration delayTime = trains[index]["delayTime"];
                  DateTime mystationliveTime = scheduletime.add(delayTime);
                  Widget _delay() {
                    if (trains[index]["live"] == true) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "${trains[index]["route"]}",
                              style: TextStyle(fontSize: 25.0),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              "${trains[index]["pace"]}",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  letterSpacing: -1.0,
                                  color: Colors.grey[700]),
                            ),
                            Text(
                              "The train is delayed by ${delayTime.inMinutes % 1440.toInt()} Minutes",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 8.0),
                            ),
                            Text(
                                "The train last crossed ${trains[index]["update"]["updateLocation"]} at ${TimeOfDay.fromDateTime(DateTime.parse(trains[index]["update"]["actualCreatedAt"])).format(context)}",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 8.0))
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "${trains[index]["route"]}",
                              style: TextStyle(fontSize: 25.0),
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              "${trains[index]["pace"]}",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  letterSpacing: -1.0,
                                  color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      );
                    }
                  }

                  return Container(
                    padding: EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                          color: Colors.grey[350],
                        ),
                      ),
                    ),
                    child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => TrainStops(
                                      station,
                                      towardsDirection,
                                      trains,
                                      index)));
                        },
                        title: Row(
                          children: <Widget>[
                            Column(children: <Widget>[
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Train ${trains[index]["trainId"]}",
                                style: TextStyle(
                                    fontSize: 11.0, color: Colors.grey[600]),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              new Text(
                                TimeOfDay.fromDateTime(mystationliveTime)
                                    .format(context),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  letterSpacing: -1.0,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                trains[index]["live"] == true
                                    ? "Live"
                                    : "Not Live",
                                style: TextStyle(
                                    color: trains[index]["live"] == true
                                        ? Colors.green
                                        : Colors.red),
                              ),
                              SizedBox(
                                height: 8.0,
                              )
                            ]),
                            SizedBox(
                              width: 8.0,
                            ),
                            _delay(),
                          ],
                        )),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Loading..",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            );
          }
        },
      ),
      onRefresh: () => _firebaseRequest(),
    );
  }
}
