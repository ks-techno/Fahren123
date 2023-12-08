class WeatherModel {
  final double tempInC;
  final String tempTime;
  final String tempCondition;
  final String tempConditionIcon;
  final bool isNightTime;


  WeatherModel({
    required this.tempInC,
    required this.tempTime,
    required this.tempCondition,
    required this.tempConditionIcon,
    required this.isNightTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      tempInC: json['temp_f']??json['avgtemp_f'],
      tempCondition: json['condition']['text'],
      tempConditionIcon: "https:${json['condition']['icon']}",
      tempTime: json['last_updated'].toString().split(' ').first,
      isNightTime: json['is_day']==0
    );
  }
}
