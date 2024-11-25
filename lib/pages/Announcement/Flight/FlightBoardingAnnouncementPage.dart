import 'package:flutter/material.dart';

import '../../../Services/TextToAnnouncementService.dart';

class FlightBoardingAnnouncementPage extends StatefulWidget {
  const FlightBoardingAnnouncementPage({Key? key}) : super(key: key);

  @override
  _FlightBoardingAnnouncementPageState createState() => _FlightBoardingAnnouncementPageState();
}

class _FlightBoardingAnnouncementPageState extends State<FlightBoardingAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _boardingDate;
  TimeOfDay? _boardingTime;
  String _selectedAirline = 'IndiGo';
  final TextEditingController _otherAirlineController = TextEditingController();

  var themeColor = Colors.teal;

  final List<String> _airlines = [
    'IndiGo',
    'Air India',
    'SpiceJet',
    'Vistara',
    'Air Asia',
    'Go First',
    'Other'
  ];

  final TextEditingController _flightNumberController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _gateController = TextEditingController();


  @override
  void dispose() {
    _flightNumberController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _gateController.dispose();
    _otherAirlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar:AppBar(
        title: const Text(
          'Flight Boarding Announcement',
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildDropdownField(
              label: 'Airline',
              value: _selectedAirline,
              items: _airlines.map((airline) => DropdownMenuItem<String>(
                value: airline,
                child: Text(
                  airline,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              )).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() => _selectedAirline = value);
                }
              },
            ),
            if (_selectedAirline == 'Other') ...[
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _otherAirlineController,
                label: 'Enter Airline Name',
                prefixIcon: Icons.airplanemode_active,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
            ],
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _flightNumberController,
              label: 'Flight Number',
              prefixIcon: Icons.confirmation_number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter flight number';
                }
                if (!RegExp(r'^[A-Z0-9]{2,8}$').hasMatch(value!)) {
                  return 'Enter a valid flight number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTextFormField(
                    controller: _fromController,
                    label: 'From',
                    prefixIcon: Icons.flight_takeoff,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextFormField(
                    controller: _toController,
                    label: 'To',
                    prefixIcon: Icons.flight_land,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    label: 'Boarding Date',
                    value: _boardingDate?.toString().split(' ')[0],
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => _boardingDate = date);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDatePicker(
                    label: 'Boarding Time',
                    value: _boardingTime?.format(context),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() => _boardingTime = time);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _gateController,
              label: 'Gate Number',
              prefixIcon: Icons.door_front_door,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: themeColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Create Boarding Announcement',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String generateBoardingAnnouncement({
    required BuildContext context,
    required String airline,
    required String flightNumber,
    required String from,
    required String to,
    required DateTime boardingDate,
    required TimeOfDay boardingTime,
    required String gateNumber,
    String? otherAirline,
  }) {
    // Start with a greeting and airline information
    String announcement = 'Attention, passengers. ';
    announcement += otherAirline != null && airline == 'Other'
        ? 'This is a boarding announcement for $otherAirline Airlines flight $flightNumber.'
        : 'This is a boarding announcement for $airline flight $flightNumber.';

    // Add origin and destination details
    announcement += ' The flight will be departing from $from and arriving at $to.';

    // Add boarding time and date
    announcement +=
    ' Boarding is scheduled to begin on ${boardingDate.toString().split(' ')[0]} at ${boardingTime.format(context)}.';

    // Add gate information
    announcement += ' Passengers are requested to proceed to gate $gateNumber.';

    // Closing statement
    announcement +=
    ' Please ensure you have your boarding passes and identification ready. Thank you for flying with us, and we wish you a pleasant journey.';

    // Log for debugging
    print("Generated Boarding Announcement: $announcement");

    // Return the final announcement
    return announcement.trim();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_boardingDate == null || _boardingTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select both boarding date and time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Generate the boarding announcement
      String announcement = generateBoardingAnnouncement(
        context: context, // Pass the BuildContext here
        airline: _selectedAirline,
        flightNumber: _flightNumberController.text,
        from: _fromController.text,
        to: _toController.text,
        boardingDate: _boardingDate!,
        boardingTime: _boardingTime!,
        gateNumber: _gateController.text,
        otherAirline: _selectedAirline == 'Other' ? _otherAirlineController.text : null,
      );

      print("The announcement is " + announcement);

      // Navigate to the TextToAnnouncementService page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TextToAnnouncementService(text: announcement),
        ),
      );
    }
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: themeColor,),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Widget _buildDatePicker({
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? 'Select',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF757575), // Subtle grey for placeholder text
              ),
            ),
            const Icon(
              Icons.calendar_today,
              size: 20,
              color: Color(0xFF757575), // Subtle grey icon colour
            ),
          ],
        ),
      ),
    );
  }
}
