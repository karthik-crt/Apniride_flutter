import 'package:apniride_flutter/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentPlacesScreen extends StatefulWidget {
  const RecentPlacesScreen({Key? key}) : super(key: key);

  @override
  State<RecentPlacesScreen> createState() => _RecentPlacesScreenState();
}

class _RecentPlacesScreenState extends State<RecentPlacesScreen> {
  final TextEditingController _controller = TextEditingController();

  // Original data
  final List<Map<String, String>> allPlaces = [
    {
      "title": "Office",
      "subtitle": "Abayashram, Kattamnallur, Bangalore -560049",
      "distance": "2.7km",
    },
    {
      "title": "Coffee shop",
      "subtitle": "No 113/B, 6th Cross, Ashokapuram, Banglore - 653",
      "distance": "1.1km",
    },
    {
      "title": "Biriyani Shop",
      "subtitle": "19, 39th A Cross, 11th Main Road, IV, T Block, Chennai",
      "distance": "4.9km",
    },
    {
      "title": "Zudio Dress Shop",
      "subtitle": "4140 Parker Rd. Allentown, New Delhi - 31134",
      "distance": "4.0km",
    },
    {
      "title": "Saloon",
      "subtitle": "1821, 3th Ring Road cross, HBR Layout, 5th Block",
      "distance": "4.0km",
    },
  ];

  // Dynamic list (filtered)
  List<Map<String, String>> recentPlaces = [];

  @override
  void initState() {
    super.initState();
    recentPlaces = List.from(allPlaces);
  }

  void _filterPlaces(String query) {
    setState(() {
      if (query.isEmpty) {
        recentPlaces = List.from(allPlaces);
      } else {
        recentPlaces = allPlaces
            .where((place) =>
                place["title"]!.toLowerCase().contains(query.toLowerCase()) ||
                place["subtitle"]!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _clearAll() {
    setState(() {
      recentPlaces.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Search places...",
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey, fontSize: 13.sp),
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey.shade700,
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                              _filterPlaces("");
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) => _filterPlaces(value),
              ),

              const SizedBox(height: 20),

              // Recent places header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent places",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                      onTap: _clearAll,
                      child: Text(
                        "Clear All",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),

              const SizedBox(height: 10),
              const Divider(),

              // Recent Places List
              // Expanded(
              //   child: recentPlaces.isEmpty
              //       ? const Center(
              //           child: Text("No recent places found"),
              //         )
              //       : ListView.builder(
              //           itemCount: recentPlaces.length,
              //           itemBuilder: (context, index) {
              //             final place = recentPlaces[index];
              //             return Padding(
              //               padding: const EdgeInsets.symmetric(vertical: 8.0),
              //               child: Row(
              //                 children: [
              //                   const Icon(Icons.access_time,
              //                       color: Colors.black54),
              //                   const SizedBox(width: 12),
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         Text(place["title"]!,
              //                             style: Theme.of(context)
              //                                 .textTheme
              //                                 .bodyMedium
              //                                 ?.copyWith(
              //                                     color: Colors.grey.shade700,
              //                                     fontWeight: FontWeight.bold)),
              //                         const SizedBox(height: 2),
              //                         Text(
              //                           place["subtitle"]!,
              //                           style: Theme.of(context)
              //                               .textTheme
              //                               .bodyMedium
              //                               ?.copyWith(
              //                                   fontSize: 10.5.sp,
              //                                   color: Colors.grey.shade500,
              //                                   fontWeight: FontWeight.normal),
              //                           maxLines: 1,
              //                           overflow: TextOverflow.ellipsis,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   Text(
              //                     place["distance"]!,
              //                     style: Theme.of(context)
              //                         .textTheme
              //                         .bodyMedium
              //                         ?.copyWith(
              //                             color: Colors.grey.shade700,
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 11.sp),
              //                   ),
              //                 ],
              //               ),
              //             );
              //           },
              //         ),
              // ),
              Expanded(
                child: recentPlaces.isEmpty
                    ? const Center(
                        child: Text("No recent places found"),
                      )
                    : ListView.builder(
                        itemCount: recentPlaces.length,
                        itemBuilder: (context, index) {
                          final place = recentPlaces[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        color: Colors.black54),
                                    SizedBox(width: 10.w),
                                    Text(place["title"]!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.bold)),
                                    Spacer(),
                                    Text(
                                      place["distance"]!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 30.w),
                                  child: Text(
                                    place["subtitle"]!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontSize: 10.5.sp,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.normal),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
