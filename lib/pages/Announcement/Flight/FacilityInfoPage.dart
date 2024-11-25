import 'package:flutter/material.dart';

class FacilityInfoPage extends StatefulWidget {
  const FacilityInfoPage({Key? key}) : super(key: key);

  @override
  _FacilityInfoPageState createState() => _FacilityInfoPageState();
}

class _FacilityInfoPageState extends State<FacilityInfoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _facilityAreaController =
  TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _alternativeOptionsController =
  TextEditingController();
  final TextEditingController _affectedServicesController =
  TextEditingController();
  final TextEditingController _specialInstructionsController =
  TextEditingController();
  final TextEditingController _contactInformationController =
  TextEditingController();

  String _selectedStatus = 'Operational';
  String _selectedImpactLevel = 'Low';

  final List<String> _statusOptions = ['Operational', 'Closed', 'Limited'];
  final List<String> _impactLevels = ['Low', 'Medium', 'High'];

  @override
  void dispose() {
    _facilityAreaController.dispose();
    _durationController.dispose();
    _alternativeOptionsController.dispose();
    _affectedServicesController.dispose();
    _specialInstructionsController.dispose();
    _contactInformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'Facility Info',
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
            // Facility Area
            _buildTextFormField(
              controller: _facilityAreaController,
              label: 'Facility Area',
              prefixIcon: Icons.location_city,
              validator: (value) =>
              value?.isEmpty ?? true ? 'Facility area is required' : null,
            ),
            const SizedBox(height: 20),

            // Status
            _buildDropdownField(
              label: 'Status',
              value: _selectedStatus,
              items: _statusOptions.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
            const SizedBox(height: 20),

            // Duration (Optional)
            _buildTextFormField(
              controller: _durationController,
              label: 'Duration (if applicable)',
              prefixIcon: Icons.access_time,
            ),
            const SizedBox(height: 20),

            // Alternative Options (Optional)
            _buildTextFormField(
              controller: _alternativeOptionsController,
              label: 'Alternative Options (if applicable)',
              prefixIcon: Icons.swap_horiz,
            ),
            const SizedBox(height: 20),

            // Impact Level
            _buildDropdownField(
              label: 'Impact Level',
              value: _selectedImpactLevel,
              items: _impactLevels.map((level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedImpactLevel = value);
                }
              },
            ),
            const SizedBox(height: 20),

            // Affected Services
            _buildTextFormField(
              controller: _affectedServicesController,
              label: 'Affected Services',
              prefixIcon: Icons.miscellaneous_services,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Affected services are required'
                  : null,
            ),
            const SizedBox(height: 20),

            // Special Instructions (Optional)
            _buildTextFormField(
              controller: _specialInstructionsController,
              label: 'Special Instructions (optional)',
              prefixIcon: Icons.notes,
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Contact Information (Optional)
            _buildTextFormField(
              controller: _contactInformationController,
              label: 'Contact Information (optional)',
              prefixIcon: Icons.contact_phone,
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
                'Create Facility Info Announcement',
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
          content: Text('Facility info announcement saved successfully'),
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
