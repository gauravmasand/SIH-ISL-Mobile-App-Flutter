import 'package:flutter/material.dart';

import '../../../Services/TextToAnnouncementService.dart';

class DepartureAnnouncementPage extends StatefulWidget {
  const DepartureAnnouncementPage({Key? key}) : super(key: key);

  @override
  _DepartureAnnouncementPageState createState() => _DepartureAnnouncementPageState();
}

class _DepartureAnnouncementPageState extends State<DepartureAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _trainNumberController = TextEditingController();
  final TextEditingController _destinationStationController = TextEditingController();
  final TextEditingController _scheduledDepartureTimeController = TextEditingController();
  final TextEditingController _platformNumberController = TextEditingController();
  final TextEditingController _carrierNameController = TextEditingController();
  final TextEditingController _passengerInstructionsController = TextEditingController();

  @override
  void dispose() {
    _trainNumberController.dispose();
    _destinationStationController.dispose();
    _scheduledDepartureTimeController.dispose();
    _platformNumberController.dispose();
    _carrierNameController.dispose();
    _passengerInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departure Announcement'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildTextFormField(
              controller: _trainNumberController,
              label: 'Train/Vehicle Number',
              prefixIcon: Icons.directions_railway,
              validator: (value) => value?.isEmpty ?? true ? 'Train/Vehicle Number is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _destinationStationController,
              label: 'Destination Station',
              prefixIcon: Icons.location_on,
              validator: (value) => value?.isEmpty ?? true ? 'Destination Station is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _scheduledDepartureTimeController,
              label: 'Scheduled Departure Time',
              prefixIcon: Icons.access_time,
              validator: (value) => value?.isEmpty ?? true ? 'Scheduled Departure Time is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _platformNumberController,
              label: 'Platform Number',
              prefixIcon: Icons.confirmation_number,
              validator: (value) => value?.isEmpty ?? true ? 'Platform Number is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _carrierNameController,
              label: 'Carrier/Company Name',
              prefixIcon: Icons.business,
              validator: (value) => value?.isEmpty ?? true ? 'Carrier/Company Name is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _passengerInstructionsController,
              label: 'Passenger Instructions',
              prefixIcon: Icons.info,
              maxLines: 3,
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
              child: const Text('Create Departure Announcement', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String announcement = """
        Attention, please. This is an announcement for the departure of train/vehicle number ${_trainNumberController.text}, 
        heading towards ${_destinationStationController.text}. The scheduled departure time is ${_scheduledDepartureTimeController.text} 
        from platform number ${_platformNumberController.text}. The carrier is ${_carrierNameController.text}.
        ${_passengerInstructionsController.text.isNotEmpty ? "Passenger instructions: ${_passengerInstructionsController.text}." : ""}
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
