import 'package:flutter/material.dart';
import './traintrack.dart';

class TrainStops extends StatelessWidget {
  final String station;
  final String towardsDirection;
  final List trains;
  final int trainIndex;

  TrainStops(this.station, this.towardsDirection, this.trains, this.trainIndex);
  @override
  Widget build(BuildContext context) {
    Duration delayDuration = trains[trainIndex]["delayTime"];
    print(trains[trainIndex]);

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 4.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        leading: InkWell(
          child: Icon(
            Icons.keyboard_arrow_left,
            size: 26.0,
            color: Colors.white,
          ),
          onTap: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          FlatButton(
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              if (trains[trainIndex]["trainId"] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        TrackingSwitch(trains[trainIndex]["trainId"]),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      contentPadding: EdgeInsets.only(
                          bottom: 0.0, top: 15.0, left: 20.0, right: 20.0),
                      contentTextStyle:
                          TextStyle(fontSize: 15.0, color: Colors.black),
                      content: Text(
                          "Your Train is already Live",style: TextStyle(color: Colors.black),),
                      title: Text("Error"),
                      titleTextStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("OK",style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              }
            },
            child: Text("Track"),
          )
        ],
        titleSpacing: 0.0,
        centerTitle: false,
        title: Text(
          "${TimeOfDay.fromDateTime(DateTime.parse(trains[trainIndex]["stops"][station]["scheduletime"]).add(trains[trainIndex]["delayTime"])).format(context)}  -  $station",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -1.0,
          ),
        ),
      ),
      body: Scrollbar(
        child: ListView.builder(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          itemCount: trains[trainIndex]["stoppingStations"].length,
          itemBuilder: (BuildContext context, int index) {
            DateTime stopScheduleTime = DateTime.parse(trains[trainIndex]
                    ["stops"][trains[trainIndex]["stoppingStations"][index]]
                ["scheduletime"]);
            DateTime stopLiveTime = stopScheduleTime.add(delayDuration);

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
                  dense: true,
                  title: Row(
                    children: <Widget>[
                      Container(
                        width: 120.0,
                        child: Row(
                          children: <Widget>[
                            Text(
                                TimeOfDay.fromDateTime(stopLiveTime)
                                    .format(context),
                                style: TextStyle(
                                    color: trains[trainIndex]["live"]?Colors.green:Colors.red,
                                    fontSize: 20.0,fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    color: Colors.black,
                                    height: 30.0,
                                    width: 2.0,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              trains[trainIndex]["stops"][trains[trainIndex]
                                  ["stoppingStations"][index]]["stop"],
                              style: TextStyle(fontSize: 22.0),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.black,
                                  height: 30.0,
                                  width: 2.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                    "PF No.\n      ${trains[trainIndex]["stops"][trains[trainIndex]["stoppingStations"][index]]["platform"]}",
                                    style: TextStyle(
                                        color: Colors.teal[300],
                                        fontSize: 15.0,
                                        letterSpacing: -1.0)),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
