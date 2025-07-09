// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ChannelDetailsPage extends StatelessWidget {
//   final Map<String, dynamic> channel;
//   final bool isDark;

//   const ChannelDetailsPage({
//     super.key,
//     required this.channel,
//     required this.isDark,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: isDark ? Colors.black : Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: isDark ? Colors.white : Colors.black,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: NetworkImage(channel['image']),
//                   radius: 28,
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   channel['name'],
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: _textColor(),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Analytics Section
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _analyticsTile("Channel Analytics", "Monthly Views",
//                     channel['monthlyViews']),
//                 _analyticsTile("Watch Time", "", channel['watchTime']),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Channel Info Icons
//             Wrap(
//               spacing: 20,
//               runSpacing: 12,
//               children: [
//                 _iconText(
//                     Icons.people, "Subscribers: ${channel['subscribers']}"),
//                 _iconText(
//                     Icons.grid_view_rounded, "Category ${channel['category']}"),
//                 _iconText(Icons.monetization_on,
//                     "Monetized: ${channel['monetized'] ? 'Yes' : 'No'}"),
//                 _iconText(
//                     Icons.calendar_month, "Channel Age: ${channel['age']}"),
//                 _iconText(Icons.currency_rupee,
//                     "Revenue: ${channel['revenue']} (Not Monetized)"),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // Description
//             Text("Description",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: _textColor())),
//             const SizedBox(height: 8),
//             Text(
//               "This YouTube channel focuses on Movies and editing, boasting over ${channel['subscribers']} subscribers and more than 2.6 million lifetime views. It meets all the requirements for monetization, making it eligible to be monetized.\n\nThe channel has a clean record with no strikes, offering an excellent opportunity for potential buyers.",
//               style: TextStyle(fontSize: 14, height: 1.5, color: _textColor()),
//             ),
//             const SizedBox(height: 24),

//             // FAQ Title
//             Text("Frequently Asked Questions",
//                 style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: _textColor())),
//             const SizedBox(height: 12),

//             // FAQ with dividers
//             Column(
//               children: [
//                 _faqWithDivider("1. What is ${channel['name']} about?"),
//                 _faqWithDivider(
//                     "2. How many subscribers does the channel have?"),
//                 _faqWithDivider("3. Is the channel monetized?"),
//                 _faqWithDivider(
//                     "4. What is the channel's monthly performance?"),
//                 _faqWithDivider("5. What revenue does the channel generate?"),
//                 _faqWithDivider("6. How old is the channel?", isLast: true),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // BUY NOW Button
//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: () async {
//                   final url = Uri.parse(
//                       "https://wa.me/?text=I'm%20interested%20in%20buying%20this%20channel");
//                   if (await canLaunchUrl(url)) {
//                     await launchUrl(url, mode: LaunchMode.externalApplication);
//                   }
//                 },
//                 icon: const Icon(Icons.chat),
//                 label: const Text("BUY NOW"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(28)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }

//   // Analytics Tile Widget
//   Widget _analyticsTile(String title, String subtitle, String value) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
//           const SizedBox(height: 4),
//           Text(
//             subtitle.isEmpty ? value : "$subtitle\n$value",
//             style: TextStyle(
//                 fontWeight: FontWeight.bold, fontSize: 14, color: _textColor()),
//           ),
//         ],
//       ),
//     );
//   }

//   // Icon Text Widget
//   Widget _iconText(IconData icon, String text) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 18, color: _textColor()),
//         const SizedBox(width: 6),
//         Flexible(
//           child: Text(
//             text,
//             style: TextStyle(fontSize: 13, color: _textColor()),
//           ),
//         ),
//       ],
//     );
//   }

//   // Single FAQ Item
//   Widget _faq(String title) => ExpansionTile(
//         tilePadding: EdgeInsets.zero,
//         childrenPadding: const EdgeInsets.only(bottom: 12),
//         title: Text(title,
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//                 color: _textColor())),
//         trailing: const Icon(Icons.add),
//         children: [
//           Text("Answer here...",
//               style: TextStyle(color: _textColor().withOpacity(0.6))),
//         ],
//       );

//   // FAQ with Divider Below
//   Widget _faqWithDivider(String title, {bool isLast = false}) {
//     return Column(
//       children: [
//         _faq(title),
//         if (!isLast)
//           const Divider(
//             height: 1,
//             thickness: 1,
//             color: Color(0xFFE0E0E0), // Light grey
//           ),
//       ],
//     );
//   }

//   // Text color logic
//   Color _textColor() => isDark ? Colors.white : Colors.black;
// }

import 'package:flutter/material.dart';
import 'package:project1/api_services/buychaneel/buychannel_api.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelDetailsPage extends StatelessWidget {
  final ChannelModel channel;
  final bool isDark;

  const ChannelDetailsPage({
    super.key,
    required this.channel,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(channel.img),
                  radius: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    channel.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Analytics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _analyticsTile("Monthly Views", "${channel.viewCount}"),
                _analyticsTile("Watch Time", "2440 hours"),
              ],
            ),
            const SizedBox(height: 20),

            // Info
            Wrap(
              spacing: 20,
              runSpacing: 12,
              children: [
                _iconText(Icons.people, "Subscribers: ${channel.subCount}"),
                _iconText(
                    Icons.grid_view_rounded, "Category: ${channel.category}"),
                _iconText(
                    Icons.monetization_on, "Monetized:${channel.monetized}"),
                _iconText(
                    Icons.calendar_month, "Channel Age: ${channel.channelAge}"),
                _iconText(Icons.currency_rupee, "Revenue: ₹${channel.revenue}"),
              ],
            ),
            const SizedBox(height: 24),

            // Description
            Text("Description",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _textColor())),
            const SizedBox(height: 8),
            Text(
              channel.description ??
                  "This YouTube channel is ready for monetization, with strong engagement and consistent performance. It’s a great buy for content creators or media entrepreneurs.",
              style: TextStyle(fontSize: 14, height: 1.5, color: _textColor()),
            ),
            const SizedBox(height: 24),

            // FAQs
            Text("Frequently Asked Questions",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor())),
            const SizedBox(height: 12),
            Column(
              children: [
                _faqWithDivider("1. What is ${channel.title} about?"),
                _faqWithDivider(
                    "2. How many subscribers does the channel have?"),
                _faqWithDivider("3. Is the channel monetized?"),
                _faqWithDivider(
                    "4. What is the channel's monthly performance?"),
                _faqWithDivider("5. What revenue does the channel generate?"),
                _faqWithDivider("6. How old is the channel?", isLast: true),
              ],
            ),
            const SizedBox(height: 24),

            // Buy Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final url = Uri.parse(
                    "https://wa.me/?text=I'm%20interested%20in%20buying%20this%20channel%20(${channel.title})",
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.chat),
                label: const Text("BUY NOW"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Text color helper
  Color _textColor() => isDark ? Colors.white : Colors.black;

  // Analytics Tile
  Widget _analyticsTile(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: _textColor())),
        ],
      ),
    );
  }

  // Icon and text row
  Widget _iconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: _textColor()),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: _textColor()),
          ),
        ),
      ],
    );
  }

  // FAQ Entry
  Widget _faq(String title) => ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 12),
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: _textColor())),
        trailing: const Icon(Icons.add),
        children: [
          Text("Answer will be provided here...",
              style: TextStyle(color: _textColor().withOpacity(0.6))),
        ],
      );

  // FAQ with Divider
  Widget _faqWithDivider(String title, {bool isLast = false}) {
    return Column(
      children: [
        _faq(title),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE0E0E0),
          ),
      ],
    );
  }
}
