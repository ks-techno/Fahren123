class Solar {
  int id;
  num power;
  String productionUnit;
  String solarName;
  String snNo;
  Solar({required this.id, required this.solarName, required this.power, required this.productionUnit, required this.snNo});

  factory Solar.fromLocalJson( json) {
    return Solar(
      id: json['id'],
      solarName: json['name'],
      power: num.tryParse("${json['power']}")??0,
      productionUnit: json['unit'],
      snNo: json['sn'],
    );
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = solarName;
    data['power'] = power;
    data['unit'] = productionUnit;
    data['sn'] = snNo;
    return data;
  }
}
