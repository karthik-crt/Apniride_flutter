AddRatings addRatingsFromJson(Map<String, dynamic> json) =>
    AddRatings.fromJson(json);

class AddRatings {
  AddRatings({
    required this.StatusCode,
    required this.StatusMessage,
    required this.data,
  });
  late final String StatusCode;
  late final String StatusMessage;
  late final Data data;

  AddRatings.fromJson(Map<String, dynamic> json) {
    StatusCode = json['StatusCode'];
    StatusMessage = json['StatusMessage'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StatusCode'] = StatusCode;
    _data['StatusMessage'] = StatusMessage;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.ride,
    required this.user,
    required this.driver,
    required this.stars,
    required this.feedback,
    required this.createdAt,
    required this.userName,
    required this.driverName,
  });
  late final int id;
  late final int ride;
  late final int user;
  late final int driver;
  late final int stars;
  late final String feedback;
  late final String createdAt;
  late final String userName;
  late final String driverName;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    ride = json['ride'] ?? 0;
    user = json['user'] ?? 0;
    driver = json['driver'] ?? 0;
    stars = json['stars'] ?? "";
    feedback = json['feedback'] ?? "";
    createdAt = json['created_at'] ?? "";
    userName = json['user_name'] ?? "";
    driverName = json['driver_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['ride'] = ride;
    _data['user'] = user;
    _data['driver'] = driver;
    _data['stars'] = stars;
    _data['feedback'] = feedback;
    _data['created_at'] = createdAt;
    _data['user_name'] = userName;
    _data['driver_name'] = driverName;
    return _data;
  }
}
