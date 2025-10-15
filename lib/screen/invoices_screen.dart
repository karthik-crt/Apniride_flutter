import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:apniride_flutter/utils/app_theme.dart';
import '../Bloc/InvoiceHistory/invoice_cubit.dart';
import '../Bloc/InvoiceHistory/invoice_state.dart';

class InvoicesHistoryScreen extends StatefulWidget {
  const InvoicesHistoryScreen({Key? key}) : super(key: key);

  @override
  State<InvoicesHistoryScreen> createState() => _InvoicesHistoryScreenState();
}

class _InvoicesHistoryScreenState extends State<InvoicesHistoryScreen> {
  static const String baseUrl = 'http://192.168.0.3:9000/api';

  @override
  void initState() {
    super.initState();
    context.read<InvoiceHistoryCubit>().fetchInvoiceHistory(context);
  }

  Future<void> _downloadAndViewInvoice(int id) async {
    try {
      final apiUrl = Uri.parse('$baseUrl/invoice/$id/');
      print("apiurl $apiUrl");
      final response = await http.get(apiUrl);
      print("response $response");

      if (response.statusCode == 200) {
        print("success");
        final bytes = response.bodyBytes;

        //Save to temporary directory
        final dir = await getTemporaryDirectory();
        final fileName = 'invoice_$id.pdf';
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(bytes, flush: true);
        print("File saved to: ${file.path}");
        print("File exists: ${await file.exists()}");

        // Navigate to PDF viewer screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerScreen(
              filePath: file.path,
              fileName: fileName,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to download invoice for ID $id: ${response.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading invoice for ID $id: $e')),
      );
      print('Download error for invoice $id: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Back",
                    style: textTheme?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<InvoiceHistoryCubit, InvoiceHistoryState>(
                builder: (context, state) {
                  if (state is InvoiceHistoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is InvoiceHistorySuccess) {
                    final invoices = state.invoices.data;
                    if (invoices.isEmpty) {
                      return const Center(
                          child: Text("No invoice history available"));
                    }
                    return ListView.builder(
                      itemCount: invoices.length,
                      itemBuilder: (context, index) {
                        final invoice = invoices[index];
                        String formattedTime;
                        try {
                          final utcDateTime =
                              DateTime.parse(invoice.pickupTime);
                          final istDateTime = utcDateTime.add(
                            const Duration(hours: 5, minutes: 30),
                          );
                          formattedTime = DateFormat('MMM dd, yyyy - hh:mm a')
                              .format(istDateTime);
                        } catch (e) {
                          formattedTime = 'Invalid date';
                          print(
                              "Date parsing error for invoice ${invoice.id}: $e");
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.directions_car,
                                      size: 28, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      invoice.vehicleDisplay,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    "₹${invoice.fare.toStringAsFixed(2)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 13.sp,
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      invoice.pickupInfo,
                                      style: textTheme?.copyWith(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "Date: $formattedTime",
                                      style: textTheme?.copyWith(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: () {
                                  print("Taping invoices");
                                  _downloadAndViewInvoice(invoice.id);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  child: Text(
                                    "View Invoice (PDF)",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 8.5.sp,
                                        ),
                                  ),
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is InvoiceHistoryError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(
                      child: Text("No invoice history available"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String filePath;
  final String fileName;

  const PDFViewerScreen(
      {Key? key, required this.filePath, required this.fileName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Full-screen PDF viewer
            PDFView(
              filePath: filePath,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error loading PDF: $error')),
                );
              },
              onPageError: (page, error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error on page $page: $error')),
                );
              },
            ),
            Positioned(
              top: 10.h,
              right: 10.w,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
