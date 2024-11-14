import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(16.0), // optional padding
          child: Text(
            "WELCOME !",
            style: TextStyle(
              fontSize: 36.0, // Adjust this size for xl6 equivalent
              fontWeight: FontWeight.bold,
              color: Color(0xFFB09CCF), // Color in Flutter format
            ),
          ),
        ),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset(
                "assets/icons/chat.svg",
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}