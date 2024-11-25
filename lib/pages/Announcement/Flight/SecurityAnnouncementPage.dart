import 'package:flutter/material.dart';

class SecurityAnnouncementPage extends StatefulWidget {
  const SecurityAnnouncementPage({Key? key}) : super(key: key);

  @override
  _SecurityAnnouncementPageState createState() =>
      _SecurityAnnouncementPageState();
}

class _SecurityAnnouncementPageState extends State<SecurityAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _securityZoneController = TextEditingController();
  final TextEditingController _natureOfAlertController =
  TextEditingController();
  final TextEditingController _requiredActionController =
  TextEditingController();
  final TextEditingController _affectedAreasController =
  TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _specialInstructionsController =
  TextEditingController();
  final TextEditingController _contactPersonController =
  TextEditingController();

  String _selectedAlertLevel = 'Low';
  final List<String> _alertLevels = ['Low', 'Medium', 'High', 'Critical'];

  @override
  void dispose() {
    _securityZoneController.dispose();
    _natureOfAlertController.dispose();
    _requiredActionController.dispose();
    _affectedAreasController.dispose();
    _durationController.dispose();
    _specialInstructionsController.dispose();
    _contactPersonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar:AppBar(
        title: const Text(
          'Security Announcement',
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
            // Security Zone/Area
            _buildTextFormField(
              controller: _securityZoneController,
              label: 'Security Zone/Area',
              prefixIcon: Icons.security,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Security zone/area is required'
                  : null,
            ),
            const SizedBox(height: 20),

            // Alert Level
            _buildDropdownField(
              label: 'Alert Level',
              value: _selectedAlertLevel,
              items: _alertLevels.map((level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level, style: TextStyle(color: Colors.black87),),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedAlertLevel = value);
                }
              },
            ),
            const SizedBox(height: 20),

            // Nature of Alert
            _buildTextFormField(
              controller: _natureOfAlertController,
              label: 'Nature of Alert',
              prefixIcon: Icons.warning,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Nature of alert is required' : null,
            ),
            const SizedBox(height: 20),

            // Required Action
            _buildTextFormField(
              controller: _requiredActionController,
              label: 'Required Action',
              prefixIcon: Icons.check_circle,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Required action is required' : null,
            ),
            const SizedBox(height: 20),

            // Affected Gates/Areas
            _buildTextFormField(
              controller: _affectedAreasController,
              label: 'Affected Gates/Areas',
              prefixIcon: Icons.location_on,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Affected gates/areas are required'
                  : null,
            ),
            const SizedBox(height: 20),

            // Duration (Optional)
            _buildTextFormField(
              controller: _durationController,
              label: 'Duration (if applicable)',
              prefixIcon: Icons.access_time,
            ),
            const SizedBox(height: 20),

            // Special Instructions (Optional)
            _buildTextFormField(
              controller: _specialInstructionsController,
              label: 'Special Instructions (optional)',
              prefixIcon: Icons.notes,
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Contact Person/Department (Optional)
            _buildTextFormField(
              controller: _contactPersonController,
              label: 'Contact Person/Department (optional)',
              prefixIcon: Icons.contact_mail,
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
                'Create Security Announcement',
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
          content: Text('Security announcement saved successfully'),
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
