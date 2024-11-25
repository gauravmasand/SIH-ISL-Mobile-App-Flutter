import 'package:flutter/material.dart';
import 'package:isl/Services/TextToAnnouncementService.dart';

class ArrivalAnnouncementPage extends StatefulWidget {
  const ArrivalAnnouncementPage({Key? key}) : super(key: key);

  @override
  _ArrivalAnnouncementPageState createState() => _ArrivalAnnouncementPageState();
}

class _ArrivalAnnouncementPageState extends State<ArrivalAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _trainNumberController = TextEditingController();
  final TextEditingController _originStationController = TextEditingController();
  final TextEditingController _expectedArrivalTimeController = TextEditingController();
  final TextEditingController _platformNumberController = TextEditingController();
  final TextEditingController _carrierNameController = TextEditingController();
  final TextEditingController _additionalInstructionsController = TextEditingController();

  @override
  void dispose() {
    _trainNumberController.dispose();
    _originStationController.dispose();
    _expectedArrivalTimeController.dispose();
    _platformNumberController.dispose();
    _carrierNameController.dispose();
    _additionalInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arrival Announcement'),
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
              controller: _originStationController,
              label: 'Origin Station',
              prefixIcon: Icons.location_on,
              validator: (value) => value?.isEmpty ?? true ? 'Origin Station is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _expectedArrivalTimeController,
              label: 'Expected Arrival Time',
              prefixIcon: Icons.access_time,
              validator: (value) => value?.isEmpty ?? true ? 'Expected Arrival Time is required' : null,
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
              controller: _additionalInstructionsController,
              label: 'Additional Instructions',
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
              child: const Text('Create Arrival Announcement', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String announcement = """
      Attention please, this is an announcement for the arrival of train/vehicle number ${_trainNumberController.text}, originating from ${_originStationController.text}. The expected arrival time is ${_expectedArrivalTimeController.text} at platform number ${_platformNumberController.text}. The carrier is ${_carrierNameController.text}.
      ${_additionalInstructionsController.text.isNotEmpty ? "Additional instructions: ${_additionalInstructionsController.text}." : ""}
      Thank you for your attention.
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
