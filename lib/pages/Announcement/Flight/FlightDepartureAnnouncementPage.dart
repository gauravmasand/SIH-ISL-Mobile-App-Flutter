import 'package:flutter/material.dart';

import '../../../Services/TextToAnnouncementService.dart';

class FlightDepartureAnnouncementPage extends StatefulWidget {
  const FlightDepartureAnnouncementPage({Key? key}) : super(key: key);

  @override
  _FlightDepartureAnnouncementPageState createState() => _FlightDepartureAnnouncementPageState();
}

class _FlightDepartureAnnouncementPageState extends State<FlightDepartureAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _departureDate;
  TimeOfDay? _departureTime;
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
  final TextEditingController _departureTerminalController = TextEditingController();

  @override
  void dispose() {
    _flightNumberController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _departureTerminalController.dispose();
    _otherAirlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar:AppBar(
        title: const Text(
          'Flight Departure Announcement',
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
            // Airline Selection
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
            // Flight Number
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
            // From and To
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
            // Departure Date and Time
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    label: 'Departure Date',
                    value: _departureDate?.toString().split(' ')[0],
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => _departureDate = date);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDatePicker(
                    label: 'Departure Time',
                    value: _departureTime?.format(context),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() => _departureTime = time);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Departure Terminal
            _buildTextFormField(
              controller: _departureTerminalController,
              label: 'Departure Terminal',
              prefixIcon: Icons.directions_transit,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 30),
            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Create Departure Announcement',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String generateDepartureAnnouncement({
    required BuildContext context,
    required String airline,
    required String flightNumber,
    required String from,
    required String to,
    required DateTime departureDate,
    required TimeOfDay departureTime,
    required String departureTerminal,
    String? otherAirline,
  }) {
    // Start with a greeting and airline information
    String announcement = 'Hello, passengers. ';
    announcement += otherAirline != null && airline == 'Other'
        ? 'Departure for $otherAirline flight $flightNumber.'
        : 'Departure for $airline flight $flightNumber.';

    // Add origin and destination details
    announcement += ' Flight from $from to $to.';

    // Add departure time and date
    announcement += ' Departure on ${departureDate.toString().split(' ')[0]} at ${departureTime.format(context)}.';

    // Add terminal information
    announcement += ' Go to terminal $departureTerminal.';

    // Closing statement
    announcement += ' Keep boarding pass and ID ready. Thank you. Safe journey.';

    // Log for debugging
    print("Generated ISL Departure Announcement: $announcement");

    // Return the final announcement
    return announcement.trim();

  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_departureDate == null || _departureTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select departure date and time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Generate the departure announcement
      String announcement = generateDepartureAnnouncement(
        context: context,
        airline: _selectedAirline,
        flightNumber: _flightNumberController.text,
        from: _fromController.text,
        to: _toController.text,
        departureDate: _departureDate!,
        departureTime: _departureTime!,
        departureTerminal: _departureTerminalController.text,
        otherAirline: _selectedAirline == 'Other' ? _otherAirlineController.text : null,
      );

      // Navigate to the TextToAnnouncementService page to display the announcement
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
                color: Color(0xFF757575),
              ),
            ),
            const Icon(
              Icons.calendar_today,
              size: 20,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }
}