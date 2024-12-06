import 'package:flutter/material.dart';

import '../../../Services/TextToAnnouncementService.dart';

class PlatformChangeAnnouncementPage extends StatefulWidget {
  const PlatformChangeAnnouncementPage({Key? key}) : super(key: key);

  @override
  _PlatformChangeAnnouncementPageState createState() => _PlatformChangeAnnouncementPageState();
}

class _PlatformChangeAnnouncementPageState extends State<PlatformChangeAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _originalPlatformController = TextEditingController();
  final TextEditingController _newPlatformController = TextEditingController();
  final TextEditingController _trainNumberController = TextEditingController();
  final TextEditingController _reasonForChangeController = TextEditingController();
  final TextEditingController _effectiveTimeController = TextEditingController();
  final TextEditingController _affectedServicesController = TextEditingController();

  @override
  void dispose() {
    _originalPlatformController.dispose();
    _newPlatformController.dispose();
    _trainNumberController.dispose();
    _reasonForChangeController.dispose();
    _effectiveTimeController.dispose();
    _affectedServicesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Change Announcement'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildTextFormField(
              controller: _originalPlatformController,
              label: 'Original Platform Number',
              prefixIcon: Icons.directions_railway,
              validator: (value) => value?.isEmpty ?? true ? 'Original Platform Number is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _newPlatformController,
              label: 'New Platform Number',
              prefixIcon: Icons.directions_railway,
              validator: (value) => value?.isEmpty ?? true ? 'New Platform Number is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _trainNumberController,
              label: 'Train/Vehicle Number',
              prefixIcon: Icons.confirmation_number,
              validator: (value) => value?.isEmpty ?? true ? 'Train/Vehicle Number is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _reasonForChangeController,
              label: 'Reason for Change',
              prefixIcon: Icons.info,
              validator: (value) => value?.isEmpty ?? true ? 'Reason for Change is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _effectiveTimeController,
              label: 'Effective Time',
              prefixIcon: Icons.access_time,
              validator: (value) => value?.isEmpty ?? true ? 'Effective Time is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _affectedServicesController,
              label: 'Affected Services',
              prefixIcon: Icons.miscellaneous_services,
              validator: (value) => value?.isEmpty ?? true ? 'Affected Services are required' : null,
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
              child: const Text('Create Platform Change Announcement', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String announcement = """
        Attention, please. There is a platform change for train/vehicle number ${_trainNumberController.text}. 
        The original platform number ${_originalPlatformController.text} has been changed to platform number ${_newPlatformController.text}.
        The reason for this change is: ${_reasonForChangeController.text}. This change will be effective from ${_effectiveTimeController.text}.
        Affected services include: ${_affectedServicesController.text}.
        Thank you for your attention.
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
