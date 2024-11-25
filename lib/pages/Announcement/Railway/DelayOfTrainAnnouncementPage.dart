import 'package:flutter/material.dart';

import '../../../Services/TextToAnnouncementService.dart';

class DelayOfTrainAnnouncementPage extends StatefulWidget {
  const DelayOfTrainAnnouncementPage({Key? key}) : super(key: key);

  @override
  _DelayOfTrainAnnouncementPageState createState() => _DelayOfTrainAnnouncementPageState();
}

class _DelayOfTrainAnnouncementPageState extends State<DelayOfTrainAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _trainNumberController = TextEditingController();
  final TextEditingController _originalScheduledTimeController = TextEditingController();
  final TextEditingController _expectedDelayedTimeController = TextEditingController();
  final TextEditingController _reasonForDelayController = TextEditingController();
  final TextEditingController _estimatedArrivalDepartureController = TextEditingController();
  final TextEditingController _alternateOptionsController = TextEditingController();

  @override
  void dispose() {
    _trainNumberController.dispose();
    _originalScheduledTimeController.dispose();
    _expectedDelayedTimeController.dispose();
    _reasonForDelayController.dispose();
    _estimatedArrivalDepartureController.dispose();
    _alternateOptionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delay Announcement'),
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
              prefixIcon: Icons.confirmation_number,
              validator: (value) => value?.isEmpty ?? true ? 'Train/Vehicle Number is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _originalScheduledTimeController,
              label: 'Original Scheduled Time',
              prefixIcon: Icons.access_time,
              validator: (value) => value?.isEmpty ?? true ? 'Original Scheduled Time is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _expectedDelayedTimeController,
              label: 'Expected Delayed Time',
              prefixIcon: Icons.timer,
              validator: (value) => value?.isEmpty ?? true ? 'Expected Delayed Time is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _reasonForDelayController,
              label: 'Reason for Delay',
              prefixIcon: Icons.info,
              validator: (value) => value?.isEmpty ?? true ? 'Reason for Delay is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _estimatedArrivalDepartureController,
              label: 'Estimated Arrival/Departure',
              prefixIcon: Icons.directions,
              validator: (value) => value?.isEmpty ?? true ? 'Estimated Arrival/Departure is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _alternateOptionsController,
              label: 'Alternate Options',
              prefixIcon: Icons.swap_horiz,
              validator: (value) => value?.isEmpty ?? true ? 'Alternate Options are required' : null,
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
              child: const Text('Create Delay Announcement', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String announcement = """
      Attention please, train number ${_trainNumberController.text} scheduled at ${_originalScheduledTimeController.text} is delayed. The expected delayed time is ${_expectedDelayedTimeController.text}.
      The reason for the delay is: ${_reasonForDelayController.text}.
      The estimated arrival time is now ${_estimatedArrivalDepartureController.text}.
      Alternate options include: ${_alternateOptionsController.text}.
      We apologise for the inconvenience caused.
      Thank you for your patience.
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
