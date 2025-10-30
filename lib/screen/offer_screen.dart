import 'package:apniride_flutter/screen/bottom_bar.dart';
import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apniride_flutter/Bloc/Offers/offers_cubit.dart';
import 'package:apniride_flutter/model/offers_data.dart';

import '../Bloc/Offers/offers_state.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OffersCubit>().getOffers(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text("Offers",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
      ),
      body: BlocBuilder<OffersCubit, OffersState>(
        builder: (context, state) {
          if (state is OffersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OffersSuccess) {
            final validOffers = state.offersData.data
                .where((offer) =>
                    offer.vehicleType.isNotEmpty &&
                    (offer.cashback > 0 ||
                        offer.waterBottles > 0 ||
                        offer.tea > 0 ||
                        offer.discount.isNotEmpty))
                .toList();

            if (validOffers.isEmpty) {
              return const Center(child: Text("No valid offers available"));
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Active Offers",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // const Text(
                //   "Available Offers",
                //   style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.w500,
                //       color: Colors.grey),
                // ),
                const SizedBox(height: 10),
                ...validOffers.map((offer) => Column(
                      children: [
                        offerCard(
                          title: _buildTitle(offer),
                          subtitle: _buildSubtitle(offer),
                          imageUrls: _buildImageUrls(offer),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )),
                const SizedBox(height: 30),
                // Eligibility Section
                // const Text(
                //   "Eligibility",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 16),
                // _eligibilityTile(
                //   icon: Icons.directions_car,
                //   title: "Ride Frequency",
                //   subtitle: "You've taken 12 rides this month",
                // ),
                // const SizedBox(height: 12),
                // _eligibilityTile(
                //   icon: Icons.star_border,
                //   title: "Rider Rating",
                //   subtitle: "Your average rating is 4.8 stars",
                // ),
              ],
            );
          } else if (state is OffersError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No offers available"));
        },
      ),
    );
  }

  String _buildTitle(Data offer) {
    if (offer.cashback > 0) {
      return (offer.heading?.isNotEmpty == true)
          ? offer.heading!
          : "${offer.cashback} Cashback on ${offer.vehicleType} rides";
    } else {
      return "${offer.vehicleType} Ride Offer";
    }
  }

  String _buildSubtitle(Data offer) {
    List<String> subtitleParts = [
      (offer.message?.isNotEmpty == true) ? offer.message! : " ",
    ];

    if (offer.waterBottles > 0) {
      subtitleParts.add(
          "${offer.waterBottles} Water Bottle${offer.waterBottles > 1 ? 's' : ''}");
    }
    if (offer.tea > 0) {
      subtitleParts.add("${offer.tea} Tea${offer.tea > 1 ? 's' : ''}");
    }
    if (offer.discount.isNotEmpty) {
      subtitleParts.add(offer.discount);
    }

    return subtitleParts.join('\n');
  }

  List<dynamic> _buildImageUrls(Data offer) {
    List<dynamic> imageUrls = [];

    // Add vehicle image or default Flutter icon
    if (offer.vehicleImageUrl.isNotEmpty) {
      imageUrls.add(offer.vehicleImageUrl);
    } else {
      imageUrls.add(Icons.local_offer); // Default Flutter icon
    }

    // Add water bottle and tea images if applicable
    if (offer.waterBottles > 0) {
      imageUrls.add("assets/bottle.png");
    }
    if (offer.tea > 0) {
      imageUrls.add("assets/tea.jpeg");
    }

    return imageUrls;
  }

  Widget offerCard({
    required String title,
    required String subtitle,
    required List<dynamic> imageUrls,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Row(
            children: imageUrls
                .map((url) => Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: url is String
                            ? url.startsWith('http')
                                ? Image.network(
                                    url,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.local_offer,
                                      size: 40,
                                      color: AppColors.background,
                                    ),
                                  )
                                : Image.asset(
                                    url,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.local_offer,
                                      size: 40,
                                      color: AppColors.background,
                                    ),
                                  )
                            : Icon(
                                url as IconData,
                                size: 40,
                                color: AppColors.background,
                              ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _eligibilityTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal.shade700,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
