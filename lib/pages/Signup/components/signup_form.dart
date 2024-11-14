import 'package:flutter/material.dart';

import '../../../Services/AuthServices.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import '../VerifyOTPPage.dart';


class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? name;
    String? email;
    String? password;
    String? gender;
    String? typeOfUser = 'normal';

    return Form(
      key: _formKey,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (value) {
              name = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Your name",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (value) {
                email = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              obscureText: true,
              cursorColor: kPrimaryColor,
              onSaved: (value) {
                password = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding, bottom: defaultPadding),
            child: DropdownButtonFormField<String>(
              value: gender,
              onChanged: (value) {
                gender = value;
              },
              items: ['male', 'female', 'other']
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
                  .toList(),
              hint: const Text('Select your gender'),
              validator: (value) {
                if (value == null) {
                  return 'Please select your gender';
                }
                return null;
              },
            ),
          ),
          DropdownButtonFormField<String>(
            value: typeOfUser,
            onChanged: (value) {
              typeOfUser = value;
            },
            items: ['deaf', 'mute', 'normal']
                .map((label) => DropdownMenuItem(
              child: Text(label),
              value: label,
            ))
                .toList(),
            hint: const Text('Select user type'),
            validator: (value) {
              if (value == null) {
                return 'Please select your user type';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                AuthService authService = AuthService();
                var registerResponse = await authService.registerUser(
                  name!, email!, password!, gender!, typeOfUser!,
                );
                if (registerResponse['message'] == "User registered. Please verify your email.") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(registerResponse['message'])),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => VerifyOtpScreen(email: email!)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(registerResponse['message'])),
                  );
                }
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 220),
        ],
      ),
    );
  }
}
