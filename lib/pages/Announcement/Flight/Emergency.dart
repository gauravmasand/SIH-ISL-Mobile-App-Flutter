import 'package:flutter/material.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emergencyTypeController =
  TextEditingController();
  final TextEditingController _affectedAreasController =
  TextEditingController();
  final TextEditingController _requiredActionsController =
  TextEditingController();
  final TextEditingController _assemblyPointsController =
  TextEditingController();
  final TextEditingController _contactNumbersController =
  TextEditingController();
  final TextEditingController _safetyInstructionsController =
  TextEditingController();
  final TextEditingController _updatesController = TextEditingController();
  final TextEditingController _alternativeRoutesController =
  TextEditingController();

  String _selectedSeverityLevel = 'Low';

  final List<String> _severityLevels = ['Low', 'Medium', 'High', 'Critical'];

  @override
  void dispose() {
    _emergencyTypeController.dispose();
    _affectedAreasController.dispose();
    _requiredActionsController.dispose();
    _assemblyPointsController.dispose();
    _contactNumbersController.dispose();
    _safetyInstructionsController.dispose();
    _updatesController.dispose();
    _alternativeRoutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'Emergency Information',
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
            // Emergency Type
            _buildTextFormField(
              controller: _emergencyTypeController,
              label: 'Emergency Type',
              prefixIcon: Icons.warning,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Emergency type is required' : null,
            ),
            const SizedBox(height: 20),

            // Severity Level
            _buildDropdownField(
              label: 'Severity Level',
              value: _selectedSeverityLevel,
              items: _severityLevels.map((level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedSeverityLevel = value);
                }
              },
            ),
            const SizedBox(height: 20),

            // Affected Areas
            _buildTextFormField(
              controller: _affectedAreasController,
              label: 'Affected Areas',
              prefixIcon: Icons.location_on,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Affected areas are required' : null,
            ),
            const SizedBox(height: 20),

            // Required Actions
            _buildTextFormField(
              controller: _requiredActionsController,
              label: 'Required Actions',
              prefixIcon: Icons.check_circle,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Required actions are required' : null,
            ),
            const SizedBox(height: 20),

            // Assembly Points (Optional)
            _buildTextFormField(
              controller: _assemblyPointsController,
              label: 'Assembly Points (if applicable)',
              prefixIcon: Icons.people_alt,
            ),
            const SizedBox(height: 20),

            // Emergency Contact Numbers
            _buildTextFormField(
              controller: _contactNumbersController,
              label: 'Emergency Contact Numbers',
              prefixIcon: Icons.phone,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Emergency contact numbers are required'
                  : null,
            ),
            const SizedBox(height: 20),

            // Safety Instructions
            _buildTextFormField(
              controller: _safetyInstructionsController,
              label: 'Safety Instructions',
              prefixIcon: Icons.security,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Safety instructions are required'
                  : null,
            ),
            const SizedBox(height: 20),

            // Updates/Status
            _buildTextFormField(
              controller: _updatesController,
              label: 'Updates/Status',
              prefixIcon: Icons.update,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Updates/Status are required' : null,
            ),
            const SizedBox(height: 20),

            // Alternative Routes/Exits (Optional)
            _buildTextFormField(
              controller: _alternativeRoutesController,
              label: 'Alternative Routes/Exits (if applicable)',
              prefixIcon: Icons.directions,
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
                'Create Emergency Announcement',
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
          content: Text('Emergency announcement saved successfully'),
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
