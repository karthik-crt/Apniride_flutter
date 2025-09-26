import 'package:equatable/equatable.dart';

import '../../model/invoice_data.dart';

abstract class InvoiceHistoryState extends Equatable {
  const InvoiceHistoryState();

  @override
  List<Object?> get props => [];
}

class InvoiceHistoryInitial extends InvoiceHistoryState {}

class InvoiceHistoryLoading extends InvoiceHistoryState {}

class InvoiceHistorySuccess extends InvoiceHistoryState {
  final InvoiceHistory invoices;

  const InvoiceHistorySuccess(this.invoices);

  @override
  List<Object?> get props => [invoices];
}

class InvoiceHistoryError extends InvoiceHistoryState {
  final String message;

  const InvoiceHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
