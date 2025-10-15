DisplayVehicles displayVehiclesFromJson(Map<String, dynamic> json) =>
    DisplayVehicles.fromJson(json);

class DisplayVehicles {
  DisplayVehicles({
    required this.statusCode,
    required this.statusMessage,
    required this.vehicleTypes,
  });

  final String statusCode;
  final String statusMessage;
  final List<VehicleTypes> vehicleTypes;

  factory DisplayVehicles.fromJson(Map<String, dynamic> json) {
    return DisplayVehicles(
      statusCode: json['statusCode'] as String,
      statusMessage: json['statusMessage'] as String,
      vehicleTypes: List.from(json['vehicleTypes'])
          .map((e) => VehicleTypes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'vehicleTypes': vehicleTypes.map((e) => e.toJson()).toList(),
    };
  }
}

class VehicleTypes {
  VehicleTypes({
    required this.id,
    required this.vehicleImage,
    required this.vehicleImageUrl,
    required this.pricingRules,
    required this.name,
    required this.description,
    required this.baseFare,
    required this.perKmRate,
    required this.perMinuteRate,
    required this.seatingCapacity,
    required this.luggageCapacity,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String vehicleImage;
  final String vehicleImageUrl;
  final List<PricingRules> pricingRules;
  final String name;
  final String description;
  final String baseFare;
  final String perKmRate;
  final String perMinuteRate;
  final int seatingCapacity;
  final int luggageCapacity;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  factory VehicleTypes.fromJson(Map<String, dynamic> json) {
    return VehicleTypes(
      id: json['id'] as int,
      vehicleImage: json['vehicleImage'] ?? '',
      vehicleImageUrl: json['vehicleImageUrl'] ?? '',
      pricingRules: List.from(json['pricing_rules'] ?? [])
          .map((e) => PricingRules.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      baseFare: json['base_fare'] ?? '',
      perKmRate: json['per_km_rate'] ?? '',
      perMinuteRate: json['per_minute_rate'] ?? '',
      seatingCapacity: json['seating_capacity'] as int,
      luggageCapacity: json['luggage_capacity'] as int,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleImage': vehicleImage,
      'vehicleImageUrl': vehicleImageUrl,
      'pricing_rules': pricingRules.map((e) => e.toJson()).toList(),
      'name': name,
      'description': description,
      'base_fare': baseFare,
      'per_km_rate': perKmRate,
      'per_minute_rate': perMinuteRate,
      'seating_capacity': seatingCapacity,
      'luggage_capacity': luggageCapacity,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PricingRules {
  PricingRules({
    required this.id,
    required this.vehicleType,
    required this.minDistance,
    required this.maxDistance,
    required this.perKmRate,
    required this.gstPercentage,
    required this.commissionPercentage,
  });

  final int id;
  final String vehicleType;
  final double minDistance;
  final double maxDistance;
  final double perKmRate;
  final double gstPercentage;
  final double commissionPercentage;

  factory PricingRules.fromJson(Map<String, dynamic> json) {
    return PricingRules(
      id: json['id'] as int,
      vehicleType: json['vehicle_type'] ?? '',
      minDistance: (json['min_distance'] as num).toDouble(),
      maxDistance: (json['max_distance'] as num).toDouble(),
      perKmRate: (json['per_km_rate'] as num).toDouble(),
      gstPercentage: (json['gst_percentage'] as num).toDouble(),
      commissionPercentage: (json['commission_percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_type': vehicleType,
      'min_distance': minDistance,
      'max_distance': maxDistance,
      'per_km_rate': perKmRate,
      'gst_percentage': gstPercentage,
      'commission_percentage': commissionPercentage,
    };
  }
}
