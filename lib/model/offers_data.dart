Offers offersFromJson(Map<String, dynamic> json) => Offers.fromJson(json);

class Offers {
  Offers({
    required this.StatusCode,
    required this.StatusMessage,
    required this.data,
  });
  late final String StatusCode;
  late final String StatusMessage;
  late final List<Data> data;

  Offers.fromJson(Map<String, dynamic> json) {
    StatusCode = json['StatusCode'];
    StatusMessage = json['StatusMessage'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StatusCode'] = StatusCode;
    _data['StatusMessage'] = StatusMessage;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.vehicleType,
    required this.minDistance,
    required this.maxDistance,
    required this.cashback,
    required this.waterBottles,
    required this.tea,
    required this.discount,
  });
  late final int id;
  late final String vehicleType;
  late final num minDistance;
  late final num maxDistance;
  late final num cashback;
  late final num waterBottles;
  late final num tea;
  late final String discount;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleType = json['vehicle_type'];
    minDistance = json['min_distance'] ?? 0;
    maxDistance = json['max_distance'] ?? 0;
    cashback = json['cashback'] ?? 0;
    waterBottles = json['water_bottles'] ?? 0;
    tea = json['tea'] ?? 0;
    discount = json['discount'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['vehicle_type'] = vehicleType;
    _data['min_distance'] = minDistance;
    _data['max_distance'] = maxDistance;
    _data['cashback'] = cashback;
    _data['water_bottles'] = waterBottles;
    _data['tea'] = tea;
    _data['discount'] = discount;
    return _data;
  }
}
