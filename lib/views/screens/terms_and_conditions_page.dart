import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Terms and Conditions',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Blood Donation App!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'The Blood Donation App is designed to connect blood donors with those in need of blood. By using this app, you agree to the following terms and conditions.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Text(
              '1. User Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'By using this app, you agree to provide accurate information, including your name, location, and phone number. This information is used to connect donors and recipients effectively.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            SizedBox(height: 10),
            Text(
              '- Your name may be visible to other users if you enable this option in the settings.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            Text(
              '- Your location will only be shared if you agree to make it visible. This helps recipients find nearby donors.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            Text(
              '- Your phone number will be shared with recipients or donors only if you explicitly agree to this.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Text(
              '2. Purpose of the App',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'The Blood Donation App facilitates the connection between blood donors and recipients. It allows users to:',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            Text(
              '- Search for blood donors or recipients based on location and blood type.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            Text(
              '- Post requests for blood donations.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            Text(
              '- View and respond to emergency blood donation requests.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Text(
              '3. Privacy and Data Usage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We value your privacy and are committed to protecting your personal information. Your data will only be used for the purposes of connecting donors and recipients. We will not share your information with third parties without your consent.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Text(
              '4. User Responsibilities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'As a user of this app, you agree to:',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            Text(
              '- Provide accurate and truthful information.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            Text(
              '- Use the app responsibly and only for its intended purpose.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            Text(
              '- Respect the privacy and confidentiality of other users.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Text(
              '5. Limitation of Liability',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'The Blood Donation App is not responsible for any issues arising from the use of this app, including but not limited to inaccurate information provided by users or failure to fulfill donation requests.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Text(
              '6. Changes to Terms',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We reserve the right to update these terms and conditions at any time. It is your responsibility to review these terms regularly.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Text(
              '7. Contact Us',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'If you have any questions or concerns about these terms and conditions, please contact us at support@bloodlife.org.',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
