import 'package:flutter/material.dart';

class PassengerPagingPage extends StatefulWidget {
  const PassengerPagingPage({Key? key}) : super(key: key);

  @override
  _PassengerPagingPageState createState() => _PassengerPagingPageState();
}

class _PassengerPagingPageState extends State<PassengerPagingPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passengerNameController =
  TextEditingController();
  final TextEditingController _requestingPartyController =
  TextEditingController();
  final TextEditingController _locationToReportController =
  TextEditingController();
  final TextEditingController _flightNumberController =
  TextEditingController();
  final TextEditingController _gateNumberController = TextEditingController();
  final TextEditingController _additionalMessageController =
  TextEditingController();

  String _selectedUrgencyLevel = 'Low';
  String _selectedMessageType = 'Information';

  final List<String> _urgencyLevels = ['Low', 'Medium', 'High'];
  final List<String> _messageTypes = ['Information', 'Emergency'];

  @override
  void dispose() {
    _passengerNameController.dispose();
    _requestingPartyController.dispose();
    _locationToReportController.dispose();
    _flightNumberController.dispose();
    _gateNumberController.dispose();
    _additionalMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'Passenger Paging',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFF444444),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF444444)),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        toolbarHeight: 70,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Passenger Name
            _buildTextFormField(
              controller: _passengerNameController,
              label: 'Passenger Name',
              prefixIcon: Icons.person,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Passenger name is required'
                  : null,
            ),
            const SizedBox(height: 20),

            // Requesting Party
            _buildTextFormField(
              controller: _requestingPartyController,
              label: 'Requesting Party',
              prefixIcon: Icons.people,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Requesting party is required' : null,
            ),
            const SizedBox(height: 20),

            // Location to Report
            _buildTextFormField(
              controller: _locationToReportController,
              label: 'Location to Report',
              prefixIcon: Icons.location_on,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Location is required' : null,
            ),
            const SizedBox(height: 20),

            // Flight Number (Optional)
            _buildTextFormField(
              controller: _flightNumberController,
              label: 'Flight Number (if applicable)',
              prefixIcon: Icons.confirmation_number,
            ),
            const SizedBox(height: 20),

            // Gate Number (Optional)
            _buildTextFormField(
              controller: _gateNumberController,
              label: 'Gate Number (if applicable)',
              prefixIcon: Icons.door_front_door,
            ),
            const SizedBox(height: 20),

            // Urgency Level
            _buildDropdownField(
              label: 'Urgency Level',
              value: _selectedUrgencyLevel,
              items: _urgencyLevels.map((level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level, style: TextStyle(color: Colors.black87),),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedUrgencyLevel = value);
                }
              },
            ),
            const SizedBox(height: 20),

            // Message Type
            _buildDropdownField(
              label: 'Message Type',
              value: _selectedMessageType,
              items: _messageTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type, style: TextStyle(color: Colors.black87),),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedMessageType = value);
                }
              },
            ),
            const SizedBox(height: 20),

            // Additional Message Details (Optional)
            _buildTextFormField(
              controller: _additionalMessageController,
              label: 'Additional Message Details (optional)',
              prefixIcon: Icons.message,
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
                'Create Passenger Paging Announcement',
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passenger paging announcement saved successfully'),
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
}
