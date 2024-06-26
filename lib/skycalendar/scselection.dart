import 'package:flutter/material.dart';
import 'package:astroquest/globals.dart';

class SkyCalendar extends StatefulWidget {
  const SkyCalendar({super.key});

  @override
  State<SkyCalendar> createState() => _SkyCalendarState();
}

class _SkyCalendarState extends State<SkyCalendar> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.05;

    SizedBox spacing() {
      return SizedBox(height: padding * 0.8);
    }

    return Container(
      decoration: background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
          appBar: appBar('Sky Calendar'),
          body: ListView(
            padding: EdgeInsets.all(padding),
                children: <Widget>[
                  spacing(),
                ],),
              ),
            );
  }
}
