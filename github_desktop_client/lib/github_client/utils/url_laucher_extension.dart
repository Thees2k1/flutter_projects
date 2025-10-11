import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

extension UrlLauncherEX on State {
  Future<void> launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      if (mounted) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Navigation error'),
            content: Text('Could not launch $url'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    }
  }
}
