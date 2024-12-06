import 'package:flutter/material.dart';

import '../../../Services/TextToAnnouncementService.dart';

class SafetyAndSecurityAnnouncementPage extends StatefulWidget {
  const SafetyAndSecurityAnnouncementPage({Key? key}) : super(key: key);

  @override
  _SafetyAndSecurityAnnouncementPageState createState() => _SafetyAndSecurityAnnouncementPageState();
}

class _SafetyAndSecurityAnnouncementPageState extends State<SafetyAndSecurityAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _alertTypeController = TextEditingController();
  final TextEditingController _affectedAreaController = TextEditingController();
  final TextEditingController _safetyInstructionsController = TextEditingController();
  final TextEditingController _emergencyContactsController = TextEditingController();
  final TextEditingController _restrictedZonesController = TextEditingController();
  final TextEditingController _actionRequiredController = TextEditingController();

  @override
  void dispose() {
    _alertTypeController.dispose();
    _affectedAreaController.dispose();
    _safetyInstructionsController.dispose();
    _emergencyContactsController.dispose();
    _restrictedZonesController.dispose();
    _actionRequiredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety and Security Announcement'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildTextFormField(
              controller: _alertTypeController,
              label: 'Alert Type',
              prefixIcon: Icons.warning,
              validator: (value) => value?.isEmpty ?? true ? 'Alert Type is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _affectedAreaController,
              label: 'Affected Area',
              prefixIcon: Icons.location_on,
              validator: (value) => value?.isEmpty ?? true ? 'Affected Area is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _safetyInstructionsController,
              label: 'Safety Instructions',
              prefixIcon: Icons.security,
              validator: (value) => value?.isEmpty ?? true ? 'Safety Instructions are required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _emergencyContactsController,
              label: 'Emergency Contacts',
              prefixIcon: Icons.phone,
              validator: (value) => value?.isEmpty ?? true ? 'Emergency Contacts are required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _restrictedZonesController,
              label: 'Restricted Zones',
              prefixIcon: Icons.block,
              validator: (value) => value?.isEmpty ?? true ? 'Restricted Zones are required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _actionRequiredController,
              label: 'Action Required',
              prefixIcon: Icons.check_circle,
              validator: (value) => value?.isEmpty ?? true ? 'Action Required is required' : null,
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
              child: const Text('Create Safety & Security Announcement', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String announcement = """
        Attention, ${_alertTypeController.text} alert.
        Affected area: ${_affectedAreaController.text}.
        Follow safety instructions: ${_safetyInstructionsController.text}.
        For help, contact: ${_emergencyContactsController.text}.
        Restricted zones: ${_restrictedZonesController.text}.
        Action required: ${_actionRequiredController.text}.
        Thank you for your cooperation.
        """;

      print("The announcement is: " + announcement);


      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TextToAnnouncementService(text: announcement)));

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
}
