class Charger {
  int id;
  String chargerName;
  String distance;
  String address;
  String contactNo;
  String speed;
  String price;
  String image;
  Charger({required this.id, required this.chargerName, required this.distance, required this.address,required this.image, required this.contactNo,required this.speed,required this.price,});

  factory Charger.fromLocalJson( json) {
    return Charger(
      id: json['id'],
      chargerName: json['chargerName'],
      distance: json['distance'],
      address: json['address'],
      contactNo: json['contactNo'],
      speed: json['speed'],
      price: json['price'],
      image: json['image'],
    );
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['chargerName'] = chargerName;
    data['distance'] = distance;
    data['address'] = address;
    data['contactNo'] = contactNo;
    data['speed'] = speed;
    data['price'] = price;
    data['image'] = image;
    return data;
  }
}