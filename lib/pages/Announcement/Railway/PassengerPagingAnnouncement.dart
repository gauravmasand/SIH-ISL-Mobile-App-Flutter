import 'package:flutter/material.dart';

import '../../../Services/TextToAnnouncementService.dart';

class PassengerPagingAnnouncementPage extends StatefulWidget {
  const PassengerPagingAnnouncementPage({Key? key}) : super(key: key);

  @override
  _PassengerPagingAnnouncementPageState createState() => _PassengerPagingAnnouncementPageState();
}

class _PassengerPagingAnnouncementPageState extends State<PassengerPagingAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passengerNameController = TextEditingController();
  final TextEditingController _contactDetailsController = TextEditingController();
  final TextEditingController _lastKnownLocationController = TextEditingController();
  final TextEditingController _reasonForPageController = TextEditingController();
  final TextEditingController _urgencyLevelController = TextEditingController();
  final TextEditingController _messageDetailsController = TextEditingController();

  @override
  void dispose() {
    _passengerNameController.dispose();
    _contactDetailsController.dispose();
    _lastKnownLocationController.dispose();
    _reasonForPageController.dispose();
    _urgencyLevelController.dispose();
    _messageDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Paging Announcement'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildTextFormField(
              controller: _passengerNameController,
              label: 'Passenger Name',
              prefixIcon: Icons.person,
              validator: (value) => value?.isEmpty ?? true ? 'Passenger Name is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _contactDetailsController,
              label: 'Contact Details',
              prefixIcon: Icons.contact_phone,
              validator: (value) => value?.isEmpty ?? true ? 'Contact Details are required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _lastKnownLocationController,
              label: 'Last Known Location',
              prefixIcon: Icons.location_on,
              validator: (value) => value?.isEmpty ?? true ? 'Last Known Location is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _reasonForPageController,
              label: 'Reason for Page',
              prefixIcon: Icons.help_outline,
              validator: (value) => value?.isEmpty ?? true ? 'Reason for Page is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _urgencyLevelController,
              label: 'Urgency Level',
              prefixIcon: Icons.priority_high,
              validator: (value) => value?.isEmpty ?? true ? 'Urgency Level is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _messageDetailsController,
              label: 'Message Details',
              prefixIcon: Icons.message,
              maxLines: 3,
              validator: (value) => value?.isEmpty ?? true ? 'Message Details are required' : null,
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
              child: const Text('Create Passenger Paging Announcement', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String announcement = """
      Attention please, paging passenger ${_passengerNameController.text}.
      Contact Details: ${_contactDetailsController.text}.
      Last known location: ${_lastKnownLocationController.text}.
      Reason for page: ${_reasonForPageController.text}.
      Urgency Level: ${_urgencyLevelController.text}.
      Message: ${_messageDetailsController.text}.
      Thank you for your immediate attention.
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
