import 'package:flutter/material.dart';
import 'package:isl/pages/Announcement/Railway/DelayOfTrainAnnouncementPage.dart';
import 'package:isl/pages/Announcement/Railway/EmergencyAnnouncementPage.dart';
import 'package:isl/pages/Announcement/Railway/FacilityInfoAnnouncementPage.dart';
import 'package:isl/pages/Announcement/Railway/PassengerPagingAnnouncement.dart';
import 'package:isl/pages/Announcement/Railway/SafetyAndSecurityAnnouncementPage.dart';
import 'Flight/BaggageClaimPage.dart';
import 'Flight/EmergencyPage.dart';
import 'Flight/FacilityInfoPage.dart';
import 'Flight/FlightArrivalAnnouncementPage.dart';
import 'Flight/FlightBoardingAnnouncementPage.dart';
import 'Flight/FlightDepartureAnnouncementPage.dart';
import 'Flight/GateChangeAnnouncementPage.dart';
import 'Flight/PassengerPagingPage.dart';
import 'Flight/SecurityAnnouncementPage.dart';
import 'Railway/ArrivalAnnouncementPage.dart';
import 'Railway/DepartureAnnouncementPage.dart';
import 'Railway/PlatformChangeAnnouncementPage.dart';
import 'SavedAnnouncement/SavedAnnouncementPage.dart';

class AnnouncementBasePage extends StatelessWidget {
  const AnnouncementBasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text(
          'Announcements',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFF444444), // Subtle dark grey for a softer feel
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFF8F9FA), // Light, neutral background colour
        elevation: 0, // Flat appearance for a cleaner look
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF444444)),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15), // Rounded bottom corners
          ),
        ),
        toolbarHeight: 70, // Slightly taller AppBar for a more spacious look
        shadowColor: Colors.grey.withOpacity(0.3), // Soft shadow effect
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Transportation Mode Grid
              Row(
                children: [
                  Expanded(
                    child: _buildTransportCard(
                      title: 'Airport',
                      icon: Icons.flight,
                      color: Colors.blue,
                      onTap: () => _showAnnouncementTypes(context, 'Airport'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTransportCard(
                      title: 'Railway',
                      icon: Icons.train,
                      color: Colors.green,
                      onTap: () => _showAnnouncementTypes(context, 'Railway'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Announcements Card
              Container(
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SavedAnnouncementsPage()),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Icon(
                            Icons.campaign,
                            size: 160,
                            color: Colors.purple.withOpacity(0.1),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.history,
                                  color: Colors.purple,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Recent Announcements',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'View and reuse your previously created announcements',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransportCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAnnouncementTypes(BuildContext context, String transportMode) {
    List<Map<String, dynamic>> announcementTypes;

    if (transportMode == 'Airport') {
      announcementTypes = [
        {'title': 'Flight Boarding', 'icon': Icons.flight_takeoff, 'color': const Color(0xFF1E88E5), "action": FlightBoardingAnnouncementPage()},
        {'title': 'Departure', 'icon': Icons.airplanemode_active, 'color': const Color(0xFF43A047), "action": FlightDepartureAnnouncementPage()},
        {'title': 'Arrival', 'icon': Icons.airplanemode_on, 'color': const Color(0xFFFB8C00), "action": FlightArrivalAnnouncementPage()},
        {'title': 'Gate Changes', 'icon': Icons.door_sliding, 'color': const Color(0xFFFFA000), "action": GateChangeAnnouncementPage()},
        {'title': 'Baggage Claim', 'icon': Icons.luggage, 'color': const Color(0xFF6D4C41), "action": BaggageClaimAnnouncementPage()},
        {'title': 'Security', 'icon': Icons.shield, 'color': const Color(0xFFD32F2F), "action": SecurityAnnouncementPage()},
        {'title': 'Passenger Paging', 'icon': Icons.contact_page, 'color': const Color(0xFF3949AB), "action": PassengerPagingPage()},
        {'title': 'Facility Info', 'icon': Icons.info_outline, 'color': const Color(0xFF00796B), "action": FacilityInfoPage()},
        {'title': 'Emergency', 'icon': Icons.error, 'color': const Color(0xFF8E24AA), "action": EmergencyPage()},
      ];
    } else {
      announcementTypes = [
        {'title': 'Arrival', 'icon': Icons.train, 'color': const Color(0xFF43A047), "action": ArrivalAnnouncementPage()},
        {'title': 'Departure', 'icon': Icons.train, 'color': const Color(0xFF43A047), "action": DepartureAnnouncementPage()},
        {'title': 'Platform Changes', 'icon': Icons.edit_location, 'color': const Color(0xFFFB8C00), "action": PlatformChangeAnnouncementPage()},
        {'title': 'Delay', 'icon': Icons.access_time, 'color': const Color(0xFFE53935), "action": DelayOfTrainAnnouncementPage()},
        {'title': 'Safety & Security', 'icon': Icons.security, 'color': const Color(0xFF1E88E5), "action": SafetyAndSecurityAnnouncementPage()},
        {'title': 'Facility Info', 'icon': Icons.info, 'color': const Color(0xFF00897B), "action": FacilityInfoAnnouncementPage()},
        {'title': 'Passenger Paging', 'icon': Icons.person_search, 'color': const Color(0xFF3949AB), "action": PassengerPagingAnnouncementPage()},
        {'title': 'Emergency', 'icon': Icons.warning, 'color': const Color(0xFF8E24AA), "action": EmergencyAnnouncementPage()},
      ];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    '$transportMode Announcements',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: announcementTypes.length,
                    itemBuilder: (context, index) {
                      final announcementType = announcementTypes[index];
                      return _buildAnnouncementTypeCard(
                        context: context,
                        title: announcementType['title'],
                        icon: announcementType['icon'],
                        color: announcementType['color'],
                        page: announcementType['action'],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAnnouncementTypeCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: color,
                  ),
                ),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: _getFontSize(title),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getFontSize(String text) {
    if (text.length > 20) {
      return 14;
    } else {
      return 16;
    }
  }
}