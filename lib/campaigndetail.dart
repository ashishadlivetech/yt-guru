import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:project1/api_services/camp_deta.dart';
import 'package:project1/theme_controller.dart';

class CampaignDetailsPage extends StatefulWidget {
  final String campaignId;
  final String email; // Pass the mobile number to the page

  const CampaignDetailsPage(
      {super.key, required this.campaignId, required this.email});

  @override
  _CampaignDetailsPageState createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage> {
  Map<String, dynamic>? campaignDetails;
  List<dynamic> participants = [];
  final ThemeController themeController = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
    fetchCampaignDetails();
  }

  Future<void> fetchCampaignDetails() async {
    try {
      // Fetch campaign list using CampData's fetchCampaigns method
      var campaigns = await CampData().fetchCampaigns(widget.email);
      // Find the campaign matching the campaignId
      var campaign = campaigns.firstWhere(
          (campaign) => campaign.id.toString() == widget.campaignId,
          orElse: () => Campaign(
              id: 0,
              url: '',
              viewTime: '',
              viewCost: '',
              subTime: '',
              subCost: '',
              likeTime: '',
              likeCost: ''));

      setState(() {
        // Store the fetched campaign details
        campaignDetails = {
          "title": campaign.url, // Replace with relevant campaign data
          "type": "Example Type", // Replace with actual campaign type
          "status": "Active", // Replace with actual status
          "start_time": "2025-02-24", // Replace with actual start time
          "progress": 75, // Replace with actual progress
          "participants": participants // Assuming this is part of your response
        };
      });
    } catch (e) {
      print("Error fetching campaign details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text("Campaign details",
            style: TextStyle(
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            )),
        backgroundColor:
            themeController.isDarkMode ? Colors.black : Colors.white,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: themeController.isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: campaignDetails == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color:
                      themeController.isDarkMode ? Colors.black : Colors.white,
                  child: Text(
                    "Campaign details",
                    style: TextStyle(
                      fontSize: 16,
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode
                          ? Color(0xFF131225)
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCampaignInfo(),
                        const SizedBox(height: 20),
                        Text(
                          "Participated Users",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(child: _buildUserList()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCampaignInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: themeController.isDarkMode ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.circle),
                child: const Icon(Icons.play_circle_filled,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  campaignDetails?["title"] ?? "Loading...",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow("Campaign Types", campaignDetails?["type"] ?? "N/A"),
          _buildInfoRow("Status", campaignDetails?["status"] ?? "N/A"),
          _buildInfoRow("Start Time", campaignDetails?["start_time"] ?? "N/A"),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (campaignDetails?["progress"] ?? 0) / 100,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(height: 5),
              Text("${campaignDetails?["progress"] ?? 0}/100",
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 12,
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black54,
              )),
          Text(value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: themeController.isDarkMode ? Colors.white : Colors.black,
              )),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return participants.isEmpty
        ? Center(
            child: Text("No participants yet",
                style: TextStyle(
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black)))
        : ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final user = participants[index];
              return _buildUserRow(user["initial"], user["id"].toString(),
                  user["time"], Colors.blue);
            },
          );
  }

  Widget _buildUserRow(String initial, String id, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: color,
              child: Text(initial,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID: $id",
                    style: TextStyle(
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                Text(time,
                    style: TextStyle(
                        color: themeController.isDarkMode
                            ? Colors.white70
                            : Colors.black87,
                        fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
    );
  }
}
