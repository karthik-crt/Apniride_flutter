BookRide bookRideFromJson(Map<String, dynamic> json) => BookRide.fromJson(json);

class BookRide {
  BookRide({
    required this.statusCode,
    required this.statusMessage,
    required this.ride,
  });
  late final int statusCode;
  late final String statusMessage;
  late final Ride ride;

  BookRide.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    ride = Ride.fromJson(json['ride']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['statusMessage'] = statusMessage;
    _data['ride'] = ride.toJson();
    return _data;
  }
}

class Ride {
  Ride({
    required this.id,
    required this.username,
    required this.pickup,
    required this.drop,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.pickupMode,
    required this.pickupTime,
    required this.distanceKm,
    required this.vehicleType,
    required this.fare,
    required this.fareEstimate,
    required this.driverIncentive,
    required this.customerReward,
    required this.status,
    required this.completed,
    required this.paid,
    required this.createdAt,
    this.completedAt,
    this.couponApplied,
    this.rating,
    this.feedback,
    required this.user,
    this.driver,
    required this.rejectedBy,
    this.driverName,
  });

  late final int id;
  late final String username;
  late final String bookingId;
  late final String pickup;
  late final String drop;
  late final double pickupLat;
  late final double pickupLng;
  late final double dropLat;
  late final double dropLng;
  late final String pickupMode;
  late final String pickupTime;
  late final double distanceKm;
  late final String vehicleType;
  late final double fare;
  late final double fareEstimate;
  late final double driverIncentive;
  late final CustomerReward customerReward;
  late final String status;
  late final bool completed;
  late final bool paid;
  late final String createdAt;
  late final Null completedAt;
  late final Null couponApplied;
  late final Null rating;
  late final Null feedback;
  late final int user;
  late final Null driver;
  late final List<dynamic> rejectedBy;
  late final Null driverName;

  Ride.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    bookingId = json['booking_id'] ?? "";
    pickup = json['pickup'];
    drop = json['drop'];
    pickupLat = double.parse(json['pickup_lat'].toString());
    pickupLng = double.parse(json['pickup_lng'].toString());
    dropLat = double.parse(json['drop_lat'].toString());
    dropLng = double.parse(json['drop_lng'].toString());
    pickupMode = json['pickup_mode'];
    pickupTime = json['pickup_time'];
    distanceKm = double.parse(json['distance_km'].toString());
    vehicleType = json['vehicle_type'];
    fare = double.parse(json['fare'].toString()); // Handle String or num
    fareEstimate =
        double.parse(json['fare_estimate'].toString()); // Handle String or num
    driverIncentive = double.parse(
        json['driver_incentive'].toString()); // Handle String or num
    customerReward = CustomerReward.fromJson(json['customer_reward']);
    status = json['status'];
    completed = json['completed'];
    paid = json['paid'];
    createdAt = json['created_at'];
    completedAt = json['completed_at'];
    couponApplied = json['coupon_applied'];
    rating = json['rating'];
    feedback = json['feedback'];
    user = json['user'];
    driver = json['driver'];
    rejectedBy = List.castFrom<dynamic, dynamic>(json['rejected_by']);
    driverName = json['driver_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['booking_id'] = bookingId;
    _data['pickup'] = pickup;
    _data['drop'] = drop;
    _data['pickup_lat'] = pickupLat;
    _data['pickup_lng'] = pickupLng;
    _data['drop_lat'] = dropLat;
    _data['drop_lng'] = dropLng;
    _data['pickup_mode'] = pickupMode;
    _data['pickup_time'] = pickupTime;
    _data['distance_km'] = distanceKm;
    _data['vehicle_type'] = vehicleType;
    _data['fare'] = fare;
    _data['fare_estimate'] = fareEstimate;
    _data['driver_incentive'] = driverIncentive;
    _data['customer_reward'] = customerReward.toJson();
    _data['status'] = status;
    _data['completed'] = completed;
    _data['paid'] = paid;
    _data['created_at'] = createdAt;
    _data['completed_at'] = completedAt;
    _data['coupon_applied'] = couponApplied;
    _data['rating'] = rating;
    _data['feedback'] = feedback;
    _data['user'] = user;
    _data['driver'] = driver;
    _data['rejected_by'] = rejectedBy;
    _data['driver_name'] = driverName;
    return _data;
  }
}

class CustomerReward {
  CustomerReward();

  CustomerReward.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}
