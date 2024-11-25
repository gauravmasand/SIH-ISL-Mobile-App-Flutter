import 'package:flutter/material.dart';

class TrainAnnouncementForm extends StatefulWidget {
  const TrainAnnouncementForm({Key? key}) : super(key: key);

  @override
  _TrainAnnouncementFormState createState() => _TrainAnnouncementFormState();
}

class _TrainAnnouncementFormState extends State<TrainAnnouncementForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _departureDate;
  TimeOfDay? _departureTime;
  String _selectedTrainType = 'Express';

  final List<String> _trainTypes = [
    'Express',
    'Local',
    'Superfast',
    'Mail',
    'Passenger'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train Announcement'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextFormField(
              label: 'Train Number',
              prefixIcon: Icons.train,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter train number' : null,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Train Type',
              value: _selectedTrainType,
              items: _trainTypes.map((type) => DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedTrainType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextFormField(
                    label: 'From Station',
                    prefixIcon: Icons.departure_board,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextFormField(
                    label: 'To Station',
                    prefixIcon: Icons.share_arrival_time_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    label: 'Departure Date',
                    value: _departureDate?.toString().split(' ')[0],
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => _departureDate = date);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDatePicker(
                    label: 'Departure Time',
                    value: _departureTime?.format(context),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() => _departureTime = time);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              label: 'Platform Number',
              prefixIcon: Icons.confirmation_number,
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              label: 'Additional Information',
              prefixIcon: Icons.info_outline,
              maxLines: 3,
              hintText: 'E.g., Delays, Platform changes, etc.',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Save announcement and show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Announcement saved successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Create Announcement'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,  // Changed type here
    required void Function(String?) onChanged,      // Changed type here
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(    // Added type parameter
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    int maxLines = 1,
    String? hintText,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }

  Widget _buildDatePicker({
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(value ?? 'Select'),
      ),
    );
  }
}
