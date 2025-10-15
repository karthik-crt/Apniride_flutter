AddWallet addWalletFromJson(Map<String, dynamic> json) =>
    AddWallet.fromJson(json);

class AddWallet {
  AddWallet({
    required this.statusCode,
    required this.message,
    required this.balance,
  });

  late final String statusCode;
  late final String message;
  late final num balance;

  AddWallet.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'] as String;
    message = json['message'] as String;
    balance = json['balance'] as num;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    data['message'] = message;
    data['balance'] = balance;
    return data;
  }
}
