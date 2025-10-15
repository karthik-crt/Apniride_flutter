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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Offers",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: BlocBuilder<OffersCubit, OffersState>(
        builder: (context, state) {
          if (state is OffersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OffersSuccess) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Active Offers",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // City Rides
                const Text(
                  "Available Offers",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
                const SizedBox(height: 10),
                ...state.offersData.data.map((offer) => Column(
                      children: [
                        offerCard(
                          title:
                              "${offer.cashback}% Cashback on ${offer.vehicleType} rides",
                          subtitle:
                              "For distances between ${offer.minDistance} and ${offer.maxDistance} km\n${offer.waterBottles > 0 ? "${offer.waterBottles} Water Bottle${offer.waterBottles > 1 ? 's' : ''}" : ''}${offer.discount.isNotEmpty ? '\n${offer.discount}' : ''}",
                          imageUrl: "assets/car.png",
                        ),
                        const SizedBox(height: 10),
                      ],
                    )),
                const SizedBox(height: 30),
                // Eligibility Section
                const Text(
                  "Eligibility",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _eligibilityTile(
                  icon: Icons.directions_car,
                  title: "Ride Frequency",
                  subtitle: "You've taken 12 rides this month",
                ),
                const SizedBox(height: 12),
                _eligibilityTile(
                  icon: Icons.star_border,
                  title: "Rider Rating",
                  subtitle: "Your average rating is 4.8 stars",
                ),
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

  Widget offerCard({
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              width: 90,
              height: 150,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/car.png'),
            ),
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
