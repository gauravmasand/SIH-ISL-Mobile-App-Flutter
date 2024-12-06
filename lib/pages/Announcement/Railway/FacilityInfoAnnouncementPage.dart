import 'package:flutter/material.dart';

import '../../../Services/TextToAnnouncementService.dart';

class FacilityInfoAnnouncementPage extends StatefulWidget {
  const FacilityInfoAnnouncementPage({Key? key}) : super(key: key);

  @override
  _FacilityInfoAnnouncementPageState createState() => _FacilityInfoAnnouncementPageState();
}

class _FacilityInfoAnnouncementPageState extends State<FacilityInfoAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _facilityNameController = TextEditingController();
  final TextEditingController _currentStatusController = TextEditingController();
  final TextEditingController _operatingHoursController = TextEditingController();
  final TextEditingController _servicesAvailableController = TextEditingController();
  final TextEditingController _maintenanceUpdatesController = TextEditingController();
  final TextEditingController _contactInformationController = TextEditingController();

  @override
  void dispose() {
    _facilityNameController.dispose();
    _currentStatusController.dispose();
    _operatingHoursController.dispose();
    _servicesAvailableController.dispose();
    _maintenanceUpdatesController.dispose();
    _contactInformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facility Info Announcement'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildTextFormField(
              controller: _facilityNameController,
              label: 'Facility Name',
              prefixIcon: Icons.location_city,
              validator: (value) => value?.isEmpty ?? true ? 'Facility Name is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _currentStatusController,
              label: 'Current Status',
              prefixIcon: Icons.info,
              validator: (value) => value?.isEmpty ?? true ? 'Current Status is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _operatingHoursController,
              label: 'Operating Hours',
              prefixIcon: Icons.access_time,
              validator: (value) => value?.isEmpty ?? true ? 'Operating Hours are required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _servicesAvailableController,
              label: 'Services Available',
              prefixIcon: Icons.miscellaneous_services,
              validator: (value) => value?.isEmpty ?? true ? 'Services Available are required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _maintenanceUpdatesController,
              label: 'Maintenance Updates',
              prefixIcon: Icons.build,
              validator: (value) => value?.isEmpty ?? true ? 'Maintenance Updates are required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _contactInformationController,
              label: 'Contact Information',
              prefixIcon: Icons.phone,
              validator: (value) => value?.isEmpty ?? true ? 'Contact Information is required' : null,
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
              child: const Text('Create Facility Info Announcement', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String announcement = """
        Attention, update for ${_facilityNameController.text}.
        Status: ${_currentStatusController.text}.
        Operating hours: ${_operatingHoursController.text}.
        Services: ${_servicesAvailableController.text}.
        Maintenance: ${_maintenanceUpdatesController.text}.
        For help, contact: ${_contactInformationController.text}.
        Thank you.
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
