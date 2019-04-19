import 'package:flutter/material.dart';
import './build_list.dart';

class TrainsList extends StatelessWidget {
  final String station;
  final String towardsDirection;
  TrainsList(this.station, this.towardsDirection);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
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
          title: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  textBaseline: TextBaseline.ideographic,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      station,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      towardsDirection,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.only(right: 10.0),
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                tooltip: 'Refresh',
                onPressed: () {
                  refreshIndicatorKey.currentState.show();
                },
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: new TrainListBuild(station, towardsDirection),
      ),
    );
  }
}
