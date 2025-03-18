import 'package:flutter/material.dart';
import 'package:project1/api_services/login_otp/addcamp_service.dart';
import 'package:project1/controllers/user_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:project1/theme_controller.dart';
import 'package:get/get.dart';

class AddCampaignPage extends StatefulWidget {
  const AddCampaignPage({super.key});

  @override
  _AddCampaignPageState createState() => _AddCampaignPageState();
}

class _AddCampaignPageState extends State<AddCampaignPage> {
  List<bool> _selectedButtons = [true, false, false];
  String _selectedViews = "50";
  String _selectedTime = "60";
  int _totalCost = 0; // Default value
  String _labelText = "Number of Views";
  final TextEditingController _videoController = TextEditingController();
  String? _videoUrl;
  final UserController userController = Get.find();
  YoutubePlayerController? _ytController;
  final ThemeController themeController = Get.find();
  final AddcampService addcampService = AddcampService();
  final FocusNode _videoFocusNode = FocusNode(); // Add FocusNode for TextField
  @override
  void initState() {
    super.initState();
    _calculateTotalCost(); // Calculate cost at startup
  }

  @override
  void dispose() {
    if (_ytController != null) {
      _ytController!.pause();
      _ytController!.dispose();
      _ytController = null;
    }
    _videoController.dispose();
    _videoFocusNode.dispose(); // Dispose FocusNode
    super.dispose();
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 4,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchAndPlayVideo() async {
    String? videoUrl = _videoController.text.trim();
    String? videoId = YoutubePlayer.convertUrlToId(videoUrl);

    _showLoadingDialog();

    if (videoId != null) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _ytController?.dispose();
        _ytController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
        );
        _videoUrl = videoUrl;
        print("Video URL set to: $_videoUrl");
      });
      // Dismiss keyboard after adding video
      _videoFocusNode.unfocus();
      print("Page refreshed and video should start playing");
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid YouTube URL")),
      );
      // Dismiss keyboard on error too
      _videoFocusNode.unfocus();
      print("Error: Invalid YouTube URL: $videoUrl");
    }
  }

  void _showSubscribeWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning"),
          content: const Text(
            "There may be a decrease in subscribers. Remember ytguru is an intermediary, YouTube makes the decision.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedButtons[0] = false;
                  _selectedButtons[1] = true;
                  _selectedButtons[2] = false;
                  _labelText = "Number of Subscribers";
                });
                Navigator.of(context).pop();
              },
              child: const Text("Okay"),
            ),
          ],
        );
      },
    );
  }

  void _showCustomDropdownDialog(String title, List<String> items,
      String currentValue, Function(String) onSelect) {
    if (_videoUrl == null) {
      Get.rawSnackbar(
        messageText: Center(
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.black87,
                ),
                child: const Text(
                  "Please add a video before doing this",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 40),
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    _videoFocusNode.unfocus();

    double itemHeight = 40.0;
    FixedExtentScrollController scrollController =
        FixedExtentScrollController();

    // Find initial index
    int initialIndex = items.indexOf(currentValue);
    if (initialIndex == -1) initialIndex = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpToItem(initialIndex);
    });

    String selectedValue = currentValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Please select the number you want to gain",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(color: Colors.grey, thickness: 1),
                          SizedBox(height: itemHeight),
                          const Divider(color: Colors.grey, thickness: 1),
                        ],
                      ),
                      ListWheelScrollView.useDelegate(
                        controller: scrollController,
                        itemExtent: itemHeight,
                        physics:
                            const FixedExtentScrollPhysics(), // Step scrolling
                        diameterRatio: 2.0,
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            final itemIndex = index % items.length;
                            return SizedBox(
                              height: itemHeight,
                              child: Center(
                                child: Text(
                                  items[itemIndex],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: themeController.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                int index = scrollController.selectedItem % items.length;
                selectedValue = items[index];

                onSelect(selectedValue);

                setState(() {
                  _calculateTotalCost();
                });

                Navigator.of(context).pop();
              },
              child: const Text("Select"),
            ),
          ],
        );
      },
    );
  }

  void _calculateTotalCost() {
    int quantity = int.tryParse(_selectedViews) ?? 0;
    int time = int.tryParse(_selectedTime) ?? 0;

    if (_selectedButtons[0]) {
      // Views selected
      _totalCost = quantity * time;
    } else if (_selectedButtons[1]) {
      // Subscribers selected
      _totalCost = (200 * quantity) + (quantity * time);
    } else if (_selectedButtons[2]) {
      // Likes selected
      _totalCost = ((15.0 / 31.0) * (quantity * time) + 1920).round();
    }

    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_ytController != null) {
          _ytController!.pause();
          _ytController!.dispose();
          _ytController = null;
        }
        setState(() {
          _videoUrl = null;
        });
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title:
              const Text("add campaign", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (_ytController != null) {
                _ytController!.pause();
                _ytController!.dispose();
                _ytController = null;
              }
              setState(() {
                _videoUrl = null;
              });
              Navigator.pop(context);
            },
          ),
          actions: [
            Row(
              children: [
                Obx(() => Text(
                      userController.userPoints.value,
                      style: TextStyle(
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                      ),
                    )),
                const SizedBox(width: 5),
                Icon(Icons.favorite,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 200,
              color: Colors.black,
              child: _videoUrl == null
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Do not create too many campaigns for one video.",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "YT will not count many views for one IP in very short time.",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "YT need 72 hours to soo your views updated on YT app",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Use YT Studio to check view in real time",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _ytController!,
                        showVideoProgressIndicator: true,
                      ),
                      builder: (context, player) {
                        return Column(
                          children: [player],
                        );
                      },
                    ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: themeController.isDarkMode
                      ? const Color(0xFF131225)
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.info,
                                color: themeController.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "How to get link: Open your video on YT -> Share button -> Copy Link",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: themeController.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _videoController,
                              focusNode: _videoFocusNode, // Assign FocusNode
                              style: TextStyle(
                                  color: themeController.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                              decoration: InputDecoration(
                                labelText: "Video Link address (URL)",
                                labelStyle: TextStyle(
                                    color: themeController.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _fetchAndPlayVideo,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF17887D),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text("Add"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border:
                              Border.all(color: Colors.grey[300]!, width: 1),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            _buildToggleButton(
                              Icons.play_circle_outline,
                              "View",
                              _selectedButtons,
                              0,
                              isFirst: true,
                            ),
                            _buildToggleButton(
                              Icons.notifications,
                              "Subscribe",
                              _selectedButtons,
                              1,
                            ),
                            _buildToggleButton(
                              Icons.thumb_up,
                              "Like",
                              _selectedButtons,
                              2,
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Campaign Settings",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _labelText,
                            style: TextStyle(
                              fontSize: 13,
                              color: themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              List<String> items = _selectedButtons[0]
                                  ? [
                                      "25",
                                      "50",
                                      "100",
                                      "150",
                                      "200",
                                      "250",
                                      "300",
                                      "350",
                                      "400",
                                      "450",
                                      "500",
                                      "550",
                                      "600",
                                      "650",
                                      "700",
                                      "750",
                                      "800",
                                      "850",
                                      "900",
                                      "950",
                                      "1000"
                                    ]
                                  : _selectedButtons[1]
                                      ? [
                                          "10",
                                          "20",
                                          "30",
                                          "40",
                                          "50",
                                          "60",
                                          "70",
                                          "80",
                                          "90",
                                          "100"
                                        ]
                                      : [
                                          "10",
                                          "20",
                                          "30",
                                          "40",
                                          "50",
                                          "60",
                                          "70",
                                          "80",
                                          "90",
                                          "100"
                                        ];
                              _showCustomDropdownDialog(
                                _labelText,
                                items,
                                _selectedViews,
                                (String newValue) {
                                  setState(() {
                                    _selectedViews = newValue;
                                    _calculateTotalCost();
                                  });
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _selectedViews,
                                    style: TextStyle(
                                      color: themeController.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: themeController.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Time Required (sec.)",
                            style: TextStyle(
                              fontSize: 13,
                              color: themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showCustomDropdownDialog(
                                "Time Required",
                                [
                                  "60",
                                  "90",
                                  "120",
                                  "150",
                                  "180",
                                  "210",
                                  "240",
                                  "270",
                                  "300"
                                ],
                                _selectedTime,
                                (String newValue) {
                                  setState(() {
                                    _selectedTime = newValue;
                                  });
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _selectedTime,
                                    style: TextStyle(
                                      color: themeController.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: themeController.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Campaign Costs",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Total Cost:",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: themeController.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          const Spacer(),
                          Text("$_totalCost", // Use the variable here
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: themeController.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          Icon(Icons.favorite,
                              color: themeController.isDarkMode
                                  ? Colors.white70
                                  : Colors.black45),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF17887D),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text("Decrease Cost %10"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_videoUrl == null) {
                                Get.rawSnackbar(
                                  messageText: Center(
                                    child: IntrinsicWidth(
                                      child: IntrinsicHeight(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 1), // Thin border
                                            borderRadius: BorderRadius.circular(
                                                4), // Rounded corners
                                            color: Colors
                                                .black87, // Background color
                                          ),
                                          child: const Text(
                                            "Please add a video before doing this",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  backgroundColor:
                                      Colors.transparent, // No background box
                                  snackPosition: SnackPosition
                                      .BOTTOM, // Show at the bottom
                                  margin: const EdgeInsets.only(
                                      bottom: 40), // Floating slightly above
                                  padding: EdgeInsets.zero, // No extra padding
                                  duration: const Duration(
                                      seconds: 2), // Auto-hide after 2 sec
                                );
                                return;
                              }

                              int? viewNumView, viewTime, viewCost;
                              int? subNumView, subTime, subCost;
                              int? likeNumView, likeTime, likeCost;

                              viewCost = subCost = likeCost = null;

                              if (_selectedButtons[0]) {
                                viewNumView = int.tryParse(_selectedViews);
                                viewTime = int.tryParse(_selectedTime);
                                viewCost =
                                    (viewNumView ?? 0) * (viewTime ?? 0) * 1;
                              } else if (_selectedButtons[1]) {
                                subNumView = int.tryParse(_selectedViews);
                                subTime = int.tryParse(_selectedTime);
                                subCost = (200 * (subNumView ?? 0)) +
                                    ((subNumView ?? 0) * (subTime ?? 0));
                              } else if (_selectedButtons[2]) {
                                likeNumView = int.tryParse(_selectedViews);
                                likeTime = int.tryParse(_selectedTime);
                                likeCost = ((15.0 / 31.0) *
                                            ((subNumView ?? 0) *
                                                (subTime ?? 0)) +
                                        1920)
                                    .round();
                              }

                              var response = await addcampService.addCampaign(
                                videoUrl: _videoController.text,
                                viewNumView: viewNumView,
                                viewTime: viewTime,
                                viewCost: viewCost,
                                subNumView: subNumView,
                                subTime: subTime,
                                subCost: subCost,
                                likeNumView: likeNumView,
                                likeTime: likeTime,
                                likeCost: likeCost,
                              );

                              print("📥 Final Processed Response: $response");

// Fetch updated user data
                              final userController = Get.find<
                                  UserController>(); // ✅ Get UserController
                              await userController.fetchUserData(
                                  forceRefresh: true);
                              setState(() {});
                              String message = response["message"] ??
                                  "An unexpected error occurred";

                              if (message
                                      .toLowerCase()
                                      .contains("capmpaign has been created") ||
                                  message
                                      .toLowerCase()
                                      .contains("campaign has created")) {
                                message =
                                    "Campaign has been created successfully!";
                              }

                              String title = response["success"] == true ||
                                      response["status"] == "success"
                                  ? "Success"
                                  : "Error";
                              Get.snackbar(
                                "", // Empty title
                                message,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black,
                                colorText: Colors.white, // White text
                                margin: EdgeInsets.only(
                                  // Controls position and width
                                  bottom: 20, // Space from bottom
                                  left: 20, // Prevent full width
                                  right: 20, // Prevent full width
                                ),
                                padding: EdgeInsets.symmetric(
                                  // Tight padding around text
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                borderRadius: 4, // Slight rounding (optional)
                                titleText: SizedBox
                                    .shrink(), // Removes title space completely
                                isDismissible: true,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text("Done"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(
      IconData icon, String label, List<bool> isSelected, int index,
      {bool isFirst = false, bool isLast = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 1) {
            _showSubscribeWarningDialog();
          } else {
            setState(() {
              for (int i = 0; i < isSelected.length; i++) {
                isSelected[i] = (i == index);
              }
              if (index == 0) {
                _labelText = "Number of Views";
              } else if (index == 2) {
                _labelText = "Number of Likes";
              }
              print("Toggle button $index selected, label: $_labelText");
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected[index]
                ? const Color(0xFF17887D)
                : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: isFirst ? const Radius.circular(25) : Radius.zero,
              bottomLeft: isFirst ? const Radius.circular(25) : Radius.zero,
              topRight: isLast ? const Radius.circular(25) : Radius.zero,
              bottomRight: isLast ? const Radius.circular(25) : Radius.zero,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected[index] ? Colors.white : Colors.black,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected[index] ? Colors.white : Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
