import 'package:flutter/material.dart';

class BaggageClaimAnnouncementPage extends StatefulWidget {
  const BaggageClaimAnnouncementPage({Key? key}) : super(key: key);

  @override
  _BaggageClaimAnnouncementPageState createState() => _BaggageClaimAnnouncementPageState();
}

class _BaggageClaimAnnouncementPageState extends State<BaggageClaimAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _arrivalDate;
  TimeOfDay? _arrivalTime;
  String _selectedAirline = 'IndiGo';
  String _selectedBaggageType = 'Regular';
  final TextEditingController _flightNumberController = TextEditingController();
  final TextEditingController _originCityController = TextEditingController();
  final TextEditingController _carouselNumberController = TextEditingController();
  final TextEditingController _expectedDurationController = TextEditingController();
  final TextEditingController _specialInstructionsController = TextEditingController();
  final TextEditingController _otherAirlineController = TextEditingController();

  final List<String> _airlines = [
    'IndiGo',
    'Air India',
    'SpiceJet',
    'Vistara',
    'Air Asia',
    'Go First',
    'Other'
  ];

  final List<String> _baggageTypes = [
    'Regular',
    'Oversized',
  ];

  @override
  void dispose() {
    _flightNumberController.dispose();
    _originCityController.dispose();
    _carouselNumberController.dispose();
    _expectedDurationController.dispose();
    _specialInstructionsController.dispose();
    _otherAirlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar:AppBar(
        title: const Text(
          'Baggage Claim Announcement',
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

            // Origin City
            _buildTextFormField(
              controller: _originCityController,
              label: 'Origin City',
              prefixIcon: Icons.location_city,
              validator: (value) => value?.isEmpty ?? true ? 'Origin city is required' : null,
            ),
            const SizedBox(height: 20),

            // Carousel Number
            _buildTextFormField(
              controller: _carouselNumberController,
              label: 'Carousel Number',
              prefixIcon: Icons.directions_car,
              validator: (value) => value?.isEmpty ?? true ? 'Carousel number is required' : null,
            ),
            const SizedBox(height: 20),

            // Arrival Time
            _buildDatePicker(
              label: 'Arrival Time',
              value: _arrivalTime?.format(context),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() => _arrivalTime = time);
                }
              },
            ),
            const SizedBox(height: 20),

            // Baggage Type
            _buildDropdownField(
              label: 'Baggage Type',
              value: _selectedBaggageType,
              items: _baggageTypes.map((type) => DropdownMenuItem<String>(
                value: type,
                child: Text(
                  type,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              )).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() => _selectedBaggageType = value);
                }
              },
            ),
            const SizedBox(height: 20),

            // Expected Duration (Optional)
            _buildTextFormField(
              controller: _expectedDurationController,
              label: 'Expected Duration (Optional)',
              prefixIcon: Icons.timer,
            ),
            const SizedBox(height: 20),

            // Special Instructions (Optional)
            _buildTextFormField(
              controller: _specialInstructionsController,
              label: 'Special Instructions (Optional)',
              prefixIcon: Icons.notes,
              maxLines: 3,
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
                'Create Baggage Claim Announcement',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_arrivalTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select the arrival time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Baggage claim announcement saved successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
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
        prefixIcon: Icon(prefixIcon, color: Colors.teal),
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
