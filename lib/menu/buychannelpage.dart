// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:project1/menu/buy_channel_detail.dart';
// import '../theme_controller.dart';

// class BuyChannelsPage extends StatelessWidget {
//   BuyChannelsPage({super.key});

//   final ThemeController themeController = Get.find();

//   final List<Map<String, dynamic>> channels = [
//     {
//       "name": "Moview BuzzYT",
//       "monthlyViews": "51.2K",
//       "watchTime": "23.5k hc",
//       "subscribers": "5,300+",
//       "category": "Entertainment",
//       "monetized": false,
//       "revenue": "₹0",
//       "age": "2 year",
//       "image": "https://img.icons8.com/ios-filled/50/film-reel.png"
//     },
//     {
//       "name": "Comedy YT",
//       "monthlyViews": "41K",
//       "watchTime": "73.2k hc",
//       "subscribers": "4,300+",
//       "category": "Entertainment",
//       "monetized": false,
//       "revenue": "₹0",
//       "age": "1 year",
//       "image": "https://img.icons8.com/ios-filled/50/comedy.png"
//     },
//     {
//       "name": "Arts BuzzYT",
//       "monthlyViews": "21.2K",
//       "watchTime": "23.5k hc",
//       "subscribers": "5,498+",
//       "category": "Entertainment",
//       "monetized": false,
//       "revenue": "₹0",
//       "age": "2 year",
//       "image": "https://img.icons8.com/ios-filled/50/art.png"
//     },
//     {
//       "name": "Cricket YT",
//       "monthlyViews": "61.2K",
//       "watchTime": "54.5k hc",
//       "subscribers": "7,900+",
//       "category": "Entertainment",
//       "monetized": false,
//       "revenue": "₹0",
//       "age": "3 year",
//       "image": "https://img.icons8.com/ios-filled/50/cricket.png"
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = themeController.isDarkMode;

//     return Scaffold(
//       backgroundColor: isDark ? const Color(0xFF131225) : Colors.black,
//       appBar: AppBar(
//         title: const Text("Buy Listings Channels"),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.white,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: channels.length,
//         itemBuilder: (context, index) {
//           final item = channels[index];
//           return Container(
//             margin: const EdgeInsets.only(bottom: 20),
//             decoration: BoxDecoration(
//               color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 6,
//                   color: Colors.black.withOpacity(0.2),
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Top section
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundImage: NetworkImage(item["image"]),
//                       backgroundColor: Colors.grey[300],
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             item["name"],
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: isDark ? Colors.white : Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "Channel Analytics",
//                             style: TextStyle(
//                               color: Colors.grey[500],
//                               fontSize: 13,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "Monthly Views: ${item['monthlyViews']}",
//                             style: TextStyle(
//                               color: isDark ? Colors.white70 : Colors.black87,
//                               fontSize: 13,
//                             ),
//                           ),
//                           Text(
//                             "Watch Time: ${item['watchTime']}",
//                             style: TextStyle(
//                               color: isDark ? Colors.white70 : Colors.black87,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 // Channel Info
//                 _infoRow(Icons.people, "Subscribers: ${item['subscribers']}",
//                     isDark),
//                 _infoRow(
//                     Icons.category, "Category ${item['category']}", isDark),
//                 _infoRow(Icons.monetization_on,
//                     "Monetized: ${item['monetized'] ? 'Yes' : 'No'}", isDark),
//                 _infoRow(Icons.money_off,
//                     "Revenue: ${item['revenue']} (Not Monetized)", isDark),
//                 _infoRow(Icons.calendar_today, "Channel Age: ${item['age']}",
//                     isDark),

//                 const SizedBox(height: 16),

//                 // View Details Button
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF7EE8FA), Color(0xFF80FF72)],
//                     ),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       shadowColor: Colors.transparent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                     ),

//                     onPressed: () {
//                       Get.to(
//                         () => ChannelDetailsPage(
//                           channel: item,
//                           isDark: isDark,
//                         ),
//                         transition: Transition.cupertino,
//                       );
//                     },
//                     // Add your navigation or action here

//                     child: const Text(
//                       "View Details",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _infoRow(IconData icon, String text, bool isDark) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: isDark ? Colors.white : Colors.black),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: isDark ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/menu/buy_channel_detail.dart';
import 'package:project1/api_services/buychaneel/buychannel_api.dart';
import 'package:project1/theme_controller.dart';

class BuyChannelsPage extends StatelessWidget {
  BuyChannelsPage({super.key});

  final ThemeController themeController = Get.find(); // Assuming GetX is used

  @override
  Widget build(BuildContext context) {
    final bool isDark = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF131225) : Colors.white,
      appBar: AppBar(
        title: const Text("Buy Listings Channels"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: FutureBuilder<List<ChannelModel>>(
        future: ChannelApiService.fetchChannels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final channels = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return _buildChannelCard(channel, isDark, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildChannelCard(
      ChannelModel channel, bool isDark, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(channel.img),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(channel.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        )),
                    const SizedBox(height: 4),
                    Text("Monthly Views: ${channel.viewCount}",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 13,
                        )),
                    Text("Likes: ${channel.likeCount}",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 13,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Info Rows
          _infoRow(Icons.people, "Subscribers: ${channel.subCount}", isDark),
          _infoRow(Icons.category, "Category: ${channel.category}", isDark),
          _infoRow(
              Icons.monetization_on, "Monetized: ${channel.monetized}", isDark),
          _infoRow(Icons.attach_money, "Revenue: ₹${channel.revenue}", isDark),
          _infoRow(Icons.calendar_month, "Channel Age: ${channel.channelAge}",
              isDark),

          const SizedBox(height: 16),

          // View Details Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Get.to(
                  () => ChannelDetailsPage(channel: channel, isDark: isDark),
                  transition: Transition.cupertino,
                );
              },
              child: const Text("View Details",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isDark ? Colors.white : Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                )),
          ),
        ],
      ),
    );
  }
}
