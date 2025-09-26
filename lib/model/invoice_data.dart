InvoiceHistory invoiceHistoryFromJson(Map<String, dynamic> json) =>
    InvoiceHistory.fromJson(json);

class InvoiceHistory {
  InvoiceHistory({
    required this.StatusCode,
    required this.StatusMessage,
    required this.data,
  });
  late final String StatusCode;
  late final String StatusMessage;
  late final List<Data> data;

  InvoiceHistory.fromJson(Map<String, dynamic> json) {
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
    required this.vehicleDisplay,
    required this.fare,
    required this.pickupInfo,
    required this.pickupTime,
    required this.invoicePdfUrl,
  });
  late final int id;
  late final String vehicleDisplay;
  late final double fare;
  late final String pickupInfo;
  late final String pickupTime;
  late final String invoicePdfUrl;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleDisplay = json['vehicle_display'];
    fare = json['fare'];
    pickupInfo = json['pickup_info'];
    pickupTime = json['pickup_time'];
    invoicePdfUrl = json['invoice_pdf_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['vehicle_display'] = vehicleDisplay;
    _data['fare'] = fare;
    _data['pickup_info'] = pickupInfo;
    _data['pickup_time'] = pickupTime;
    _data['invoice_pdf_url'] = invoicePdfUrl;
    return _data;
  }
}
