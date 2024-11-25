import 'package:flutter/material.dart';
import 'package:isl/Services/TextToAnnouncementService.dart';

class EmergencyAnnouncementPage extends StatefulWidget {
  const EmergencyAnnouncementPage({Key? key}) : super(key: key);

  @override
  _EmergencyAnnouncementPageState createState() => _EmergencyAnnouncementPageState();
}

class _EmergencyAnnouncementPageState extends State<EmergencyAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emergencyTypeController = TextEditingController();
  final TextEditingController _severityLevelController = TextEditingController();
  final TextEditingController _affectedAreasController = TextEditingController();
  final TextEditingController _evacuationInstructionsController = TextEditingController();
  final TextEditingController _emergencyContactsController = TextEditingController();
  final TextEditingController _assemblyPointsController = TextEditingController();

  @override
  void dispose() {
    _emergencyTypeController.dispose();
    _severityLevelController.dispose();
    _affectedAreasController.dispose();
    _evacuationInstructionsController.dispose();
    _emergencyContactsController.dispose();
    _assemblyPointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Announcement'),
        backgroundColor: Colors.red,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildTextFormField(
              controller: _emergencyTypeController,
              label: 'Emergency Type',
              prefixIcon: Icons.warning,
              validator: (value) => value?.isEmpty ?? true ? 'Emergency Type is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _severityLevelController,
              label: 'Severity Level',
              prefixIcon: Icons.report_problem,
              validator: (value) => value?.isEmpty ?? true ? 'Severity Level is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _affectedAreasController,
              label: 'Affected Areas',
              prefixIcon: Icons.location_on,
              validator: (value) => value?.isEmpty ?? true ? 'Affected Areas are required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _evacuationInstructionsController,
              label: 'Evacuation Instructions',
              prefixIcon: Icons.directions_run,
              validator: (value) => value?.isEmpty ?? true ? 'Evacuation Instructions are required' : null,
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
              controller: _assemblyPointsController,
              label: 'Assembly Points',
              prefixIcon: Icons.people,
              validator: (value) => value?.isEmpty ?? true ? 'Assembly Points are required' : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Create Emergency Announcement', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String announcement = """
      Attention please, we have an emergency situation: ${_emergencyTypeController.text}.
      Severity Level: ${_severityLevelController.text}.
      Affected Areas: ${_affectedAreasController.text}.
      Evacuation Instructions: ${_evacuationInstructionsController.text}.
      Emergency Contacts: ${_emergencyContactsController.text}.
      Assembly Points: ${_assemblyPointsController.text}.
      Please remain calm and follow the provided instructions.
      """;

      print("The annuncemtn is " + announcement);

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
        prefixIcon: Icon(prefixIcon, color: Colors.red),
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
