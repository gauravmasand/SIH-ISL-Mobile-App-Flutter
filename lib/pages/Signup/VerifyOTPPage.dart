import 'package:flutter/material.dart';
import 'package:isl/pages/MainHomePage/MainHomePage.dart';
import 'package:isl/pages/Welcome/components/welcome_image.dart';
import 'package:isl/pages/Welcome/welcome_screen.dart';

import '../../Services/AuthServices.dart';
import '../../constants.dart';
import '../Login/login_screen.dart';


class VerifyOtpScreen extends StatelessWidget {
  final String email;
  VerifyOtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? otp;
    FocusNode currentFocus = FocusNode();
    List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
    List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: defaultPadding),
                Text("Enter the OTP sent to $email", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) => _otpInputField(context, index, otpControllers, focusNodes)).toList(),
                ),
                const SizedBox(height: defaultPadding * 2),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      otp = otpControllers.map((controller) => controller.text).join();
                      AuthService authService = AuthService();
                      var otpResponse = await authService.verifyEmail(email, int.parse(otp!));
                      if (otpResponse['message'] == "Email verified successfully") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(otpResponse['message'])),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainHomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(otpResponse['message'])),
                        );
                      }
                    }
                  },
                  child: Text("Verify OTP".toUpperCase(), style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpInputField(BuildContext context, int index, List<TextEditingController> controllers, List<FocusNode> focusNodes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SizedBox(
        width: 45,
        child: TextFormField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          autofocus: index == 0,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          maxLength: 1,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            counterText: '',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(focusNodes[index - 1]);
            }
          },
          onSaved: (value) {
            controllers[index].text = value ?? '';
          },
        ),
      ),
    );
  }
}
