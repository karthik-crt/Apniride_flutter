import 'package:flutter/material.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Active Offers",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // City Rides
          const Text(
            "City Rides",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          offerCard(
            title: "20% off your next 5 rides",
            subtitle:
                "Valid for rides within the city limits.\nOffer expires on July 31st.",
            imageUrl: "assets/offer1.png",
          ),

          const SizedBox(height: 20),

          // Tourist Rides
          const Text(
            "Tourist Rides",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          offerCard(
            title: "Free ride to popular tourist spots",
            subtitle:
                "Enjoy a complimentary ride to select tourist destinations.",
            imageUrl: "assets/offer2.png",
          ),

          const SizedBox(height: 20),

          // Long Trips
          const Text(
            "Long Trips",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          offerCard(
            title: "Discounted rates for long-distance travel",
            subtitle: "Get up to 15% off on rides exceeding 50 miles.",
            imageUrl: "assets/offer1.png",
          ),

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
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: Text("View Details"),
                )
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
              //fit: BoxFit.cover,
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
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
