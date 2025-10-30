import '../../model/WalletHistory_data.dart';

abstract class WalletHistoryState {}

class WalletHistoryInitial extends WalletHistoryState {}

class WalletHistoryLoading extends WalletHistoryState {}

class WalletHistorySuccess extends WalletHistoryState {
  final WalletHistory walletHistory;

  WalletHistorySuccess(this.walletHistory);

  @override
  List<Object?> get props => [walletHistory];
}

class WalletHistoryError extends WalletHistoryState {
  final String message;

  WalletHistoryError(this.message);
}
