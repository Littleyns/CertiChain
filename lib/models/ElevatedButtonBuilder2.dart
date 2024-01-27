
import 'package:flutter/material.dart';
import '../models/Document.dart';
import 'Organisation.dart';


class ElevatedButtonBuilder2 {
  static List<Widget> buildButtons({
    required List<Organisation> organizations,
    required Function onPressed,
  }) {
    List<Widget> buttons = [];

    for (int i = 0; i < organizations.length; i++) {
      String name = organizations[i].name;
      String domain = _getDomainString(organizations[i].domain);

      ElevatedButton button = ElevatedButton(
        onPressed: () => onPressed(organizations[i]),
        style: ElevatedButton.styleFrom(
          primary: i % 2 == 0 ? Colors.black : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              domain,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      );

      buttons.add(button);
    }

    return buttons;
  }

  static String _getDomainString(Domain domain) {
    switch (domain) {
      case Domain.Government:
        return 'Government';
      case Domain.Education:
        return 'Education';
      case Domain.Banking:
        return 'Banking';
      default:
        return 'Unknown';
    }
  }

}
