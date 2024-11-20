import 'package:flutter/material.dart';

class FlightAnnouncementForm extends StatefulWidget {
  const FlightAnnouncementForm({Key? key}) : super(key: key);

  @override
  _FlightAnnouncementFormState createState() => _FlightAnnouncementFormState();
}

class _FlightAnnouncementFormState extends State<FlightAnnouncementForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _departureDate;
  TimeOfDay? _departureTime;
  String _selectedFlightType = 'Domestic';
  String _selectedAirline = 'IndiGo';

  final List<String> _flightTypes = ['Domestic', 'International'];

  final List<String> _airlines = [
    'IndiGo',
    'Air India',
    'SpiceJet',
    'Vistara',
    'Air Asia',
    'Go First',
    'Other'
  ];

  // Form field controllers
  final TextEditingController _flightNumberController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _gateController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();

  String? _boardingStatus;
  final List<String> _boardingStatuses = [
    'On Time',
    'Delayed',
    'Boarding',
    'Final Call',
    'Gate Closed'
  ];

  @override
  void dispose() {
    _flightNumberController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _gateController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Announcement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Flight Type Selection
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Flight Type',
                    value: _selectedFlightType,
                    items: _flightTypes.map((type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    )).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() => _selectedFlightType = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Airline',
                    value: _selectedAirline,
                    items: _airlines.map((airline) => DropdownMenuItem<String>(
                      value: airline,
                      child: Text(airline),
                    )).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() => _selectedAirline = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Flight Number
            _buildTextFormField(
              controller: _flightNumberController,
              label: 'Flight Number',
              prefixIcon: Icons.flight,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter flight number';
                }
                // Basic flight number validation
                if (!RegExp(r'^[A-Z0-9]{2,8}$').hasMatch(value!)) {
                  return 'Enter valid flight number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // From and To
            Row(
              children: [
                Expanded(
                  child: _buildTextFormField(
                    controller: _fromController,
                    label: 'From',
                    prefixIcon: Icons.flight_takeoff,
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextFormField(
                    controller: _toController,
                    label: 'To',
                    prefixIcon: Icons.flight_land,
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Date and Time
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
            const SizedBox(height: 16),

            // Gate and Status
            Row(
              children: [
                Expanded(
                  child: _buildTextFormField(
                    controller: _gateController,
                    label: 'Gate Number',
                    prefixIcon: Icons.door_front_door,
                    validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Status',
                    value: _boardingStatus ?? 'On Time',
                    items: _boardingStatuses.map((status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    )).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() => _boardingStatus = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Additional Information
            _buildTextFormField(
              controller: _infoController,
              label: 'Additional Information',
              prefixIcon: Icons.info_outline,
              maxLines: 3,
              hintText: 'Enter any special instructions or information',
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton.icon(
              onPressed: _submitForm,
              icon: const Icon(Icons.save),
              label: const Text('Create Announcement'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_departureDate == null || _departureTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select both departure date and time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create announcement data
      final announcementData = {
        'flightType': _selectedFlightType,
        'airline': _selectedAirline,
        'flightNumber': _flightNumberController.text,
        'from': _fromController.text,
        'to': _toController.text,
        'departureDate': _departureDate,
        'departureTime': _departureTime,
        'gateNumber': _gateController.text,
        'status': _boardingStatus,
        'additionalInfo': _infoController.text,
      };

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Announcement saved successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Return to previous screen
      Navigator.pop(context);
    }
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Flight Announcement Help'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Flight Number format: 2-8 characters (letters and numbers)'),
              SizedBox(height: 8),
              Text('• All fields marked with * are required'),
              SizedBox(height: 8),
              Text('• Gate number should be entered as displayed on airport screens'),
              SizedBox(height: 8),
              Text('• Additional information can include baggage details, connecting flights, etc.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
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
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    int maxLines = 1,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value ?? 'Select'),
            const Icon(Icons.calendar_today, size: 20),
          ],
        ),
      ),
    );
  }
}