import 'package:flutter/material.dart';
import 'package:isl/Services/TextToAnnouncementService.dart';

class GateChangeAnnouncementPage extends StatefulWidget {
  const GateChangeAnnouncementPage({Key? key}) : super(key: key);

  @override
  _GateChangeAnnouncementPageState createState() => _GateChangeAnnouncementPageState();
}

class _GateChangeAnnouncementPageState extends State<GateChangeAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _flightNumberController = TextEditingController();
  final TextEditingController _airlineNameController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _originalGateController = TextEditingController();
  final TextEditingController _newGateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _additionalInstructionsController = TextEditingController();
  final TextEditingController _otherAirlineController = TextEditingController();
  TimeOfDay? _departureTime;

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
  String _selectedAirline = 'IndiGo';

  @override
  void dispose() {
    _flightNumberController.dispose();
    _airlineNameController.dispose();
    _destinationController.dispose();
    _originalGateController.dispose();
    _newGateController.dispose();
    _reasonController.dispose();
    _additionalInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar:AppBar(
        title: const Text(
          'Gate Change Announcement',
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
            // Airline Selection Dropdown with 'Other' Option
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
              validator: (value) => value?.isEmpty ?? true ? 'Flight number is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _destinationController,
              label: 'Destination',
              prefixIcon: Icons.flight_land,
              validator: (value) => value?.isEmpty ?? true ? 'Destination is required' : null,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTextFormField(
                    controller: _originalGateController,
                    label: 'Original Gate',
                    prefixIcon: Icons.door_front_door,
                    validator: (value) => value?.isEmpty ?? true ? 'Original gate is required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextFormField(
                    controller: _newGateController,
                    label: 'New Gate',
                    prefixIcon: Icons.door_front_door,
                    validator: (value) => value?.isEmpty ?? true ? 'New gate is required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDatePicker(
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
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _reasonController,
              label: 'Reason for Change (Optional)',
              prefixIcon: Icons.info,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _additionalInstructionsController,
              label: 'Additional Instructions (Optional)',
              prefixIcon: Icons.notes,
              maxLines: 3,
            ),
            const SizedBox(height: 30),
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
                'Create Gate Change Announcement',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
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

  String generateGateChangeAnnouncement({
    required BuildContext context,
    required String airline,
    required String flightNumber,
    required String destination,
    required String originalGate,
    required String newGate,
    required TimeOfDay departureTime,
    String? reason,
    String? additionalInstructions,
    String? otherAirline,
  }) {
    // Start with a greeting and airline information
    String announcement = 'Attention, passengers. ';
    announcement += otherAirline != null && airline == 'Other'
        ? 'This is an announcement for $otherAirline Airlines flight $flightNumber.'
        : 'This is an announcement for $airline flight $flightNumber.';

    // Add destination and gate change details
    announcement += ' The flight to $destination will now depart from gate $newGate instead of gate $originalGate.';

    // Add departure time
    announcement += ' The departure time remains scheduled for ${departureTime.format(context)}.';

    // Add reason for the change if provided
    if (reason != null && reason.isNotEmpty) {
      announcement += ' The gate change is due to $reason.';
    }

    // Add additional instructions if provided
    if (additionalInstructions != null && additionalInstructions.isNotEmpty) {
      announcement += ' Please note: $additionalInstructions.';
    }

    // Closing statement
    announcement +=
    ' We apologise for any inconvenience caused and thank you for your understanding. Please proceed to gate $newGate promptly.';

    // Log for debugging
    print("Generated Gate Change Announcement: $announcement");

    // Return the final announcement
    return announcement.trim();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_departureTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select the departure time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Generate the gate change announcement
      String announcement = generateGateChangeAnnouncement(
        context: context,
        airline: _selectedAirline,
        flightNumber: _flightNumberController.text,
        destination: _destinationController.text,
        originalGate: _originalGateController.text,
        newGate: _newGateController.text,
        departureTime: _departureTime!,
        reason: _reasonController.text.isNotEmpty ? _reasonController.text : null,
        additionalInstructions: _additionalInstructionsController.text.isNotEmpty
            ? _additionalInstructionsController.text
            : null,
        otherAirline: _selectedAirline == 'Other' ? _otherAirlineController.text : null,
      );

      // Navigate to a page to display the announcement
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TextToAnnouncementService(text: announcement),
        ),
      );
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    int maxLines = 1,
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
      maxLines: maxLines,
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
              Icons.access_time,
              size: 20,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }
}
