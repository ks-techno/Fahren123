import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';

import '../../../../util/styles.dart';

class WeatherItem extends StatefulWidget {
  final String date;
  final String temperature;
  final WeatherType weatherType;
  final double height;
  final double width;
  const WeatherItem({
    Key? key,
    required this.date,
    required this.temperature,
    required this.weatherType,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  State<WeatherItem> createState() => _WeatherItemState();
}

class _WeatherItemState extends State<WeatherItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            WeatherBg(
              weatherType: widget.weatherType,
              width: widget.width,
              height: widget.height,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                '${widget.temperature}\u00B0',
                style: ralewaySemiBold.copyWith(fontSize: 50,color: Theme.of(context).primaryColorDark),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                '\n\n${widget.date}',
                style: ralewaySemiBold.copyWith(fontSize: 14,color: Theme.of(context).primaryColorDark),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                '${widget.weatherType.name}\n\n',
                style: ralewaySemiBold.copyWith(fontSize: 13,color: Theme.of(context).primaryColorDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}