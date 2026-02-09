// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/material.dart';
// class PrivacyPolicyWebPage extends StatefulWidget {
//   const PrivacyPolicyWebPage({super.key});

//   @override
//   State<PrivacyPolicyWebPage> createState() => _PrivacyPolicyWebPageState();
// }

// class _PrivacyPolicyWebPageState extends State<PrivacyPolicyWebPage> {
//   late final WebViewController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse('https://doc-hosting.flycricket.io/chinchilla-care-privacy-policy/78da7fd1-9009-48f1-b5f4-5e8d4a5ba309/privacy')); // Ganti dengan URL Anda
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Privacy Policy"),
//         backgroundColor: const Color(0xFF6B8E6B),
//       ),
//       body: WebViewWidget(controller: controller),
//     );
//   }
// }


import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Privacy Policy"),
            _buildParagraph(
                "This privacy policy applies to the Chinchilla Care app (hereby referred to as 'Application') for mobile devices that was created by CV Sayap Kebebasan Abadi (hereby referred to as 'Service Provider') as a Free service. This service is intended for use 'AS IS'."),
            
            _buildSectionTitle("Information Collection and Use"),
            _buildParagraph(
                "The Application collects information when you download and use it. This information may include:"),
            _buildBulletPoint("Your device's Internet Protocol address (e.g. IP address)"),
            _buildBulletPoint("The pages of the Application that you visit"),
            _buildBulletPoint("The time and date of your visit and time spent"),
            _buildBulletPoint("The operating system used on your mobile device"),
            
            _buildSectionTitle("Third Party Access"),
            _buildParagraph(
                "Only aggregated, anonymized data is periodically transmitted to external services to aid the Service Provider in improving the Application and their service."),
            
            _buildSectionTitle("Data Retention Policy"),
            _buildParagraph(
                "The Service Provider will retain User Provided data for as long as you use the Application. If you'd like them to delete data, please contact them at sayapkebebasandevv@gmail.com."),
            
            _buildSectionTitle("Children"),
            _buildParagraph(
                "The Service Provider does not use the Application to knowingly solicit data from or market to children under the age of 13."),
            
            _buildSectionTitle("Contact Us"),
            _buildParagraph(
                "If you have any questions regarding privacy, please contact the Service Provider via email at sayapkebebasandevv@gmail.com."),
            
            const SizedBox(height: 20),
            const Text(
              "Effective as of: 2026-01-17",
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets biar kodingan gak berantakan ---

  Widget _buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(fontSize: 14, height: 1.5),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}