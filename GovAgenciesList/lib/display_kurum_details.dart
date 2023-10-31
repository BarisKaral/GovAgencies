import 'package:flutter/material.dart';
import 'package:kurumlar/kurum.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

class DisplayKurumDetails extends StatelessWidget {
  final Kurum kurum;

  const DisplayKurumDetails({
    Key? key,
    required this.kurum,
  }) : super(key: key);

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Arama yapılırken hata oluştu: $url';
    }
  }

  void _openMapsNavigation(String address) {
    MapsLauncher.launchQuery(address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: _govAgenciesDetailsAppBar,
      body: buildScrollView(),
      bottomNavigationBar: _govAgenciesDetailsBottomNavBar,
    );
  }

  AppBar get _govAgenciesDetailsAppBar{
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      backgroundColor: Colors.black54,
      title: const Text(
        'KURUM AYRINTILARI',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  SingleChildScrollView buildScrollView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black54,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDetailText(kurum.title.toString(), 20, FontWeight.bold),
            const SizedBox(height: 20),
            buildDetailText('Kurum Kodu: ${kurum.code.toString()}', 16),
            const SizedBox(height: 10),
            buildDetailText('Web Sitesi: ${kurum.link.toString()}', 16),
            const SizedBox(height: 10),
            buildDetailText('E-posta: ${kurum.email.toString()}', 16),
            const SizedBox(height: 10),
            buildPhoneText('Telefon: ${kurum.tel.toString()}'),
            const SizedBox(height: 10),
            buildMapsText('Adres: ${kurum.adres.toString()}'),
          ],
        ),
      ),
    );
  }

  Widget buildDetailText(String text, double fontSize, [FontWeight fontWeight = FontWeight.normal]) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Colors.white,
      ),
    );
  }

  Widget buildPhoneText(String text) {
    return GestureDetector(
      onTap: () {
        _makePhoneCall(kurum.tel.toString());
      },
      child: buildDetailText(text, 16),
    );
  }

  Widget buildMapsText(String text) {
    return GestureDetector(
      onTap: () {
        _openMapsNavigation(kurum.adres.toString());
      },
      child: buildDetailText(text, 16),
    );
  }

  Widget get _govAgenciesDetailsBottomNavBar{
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      color: Colors.grey[400],
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _makePhoneCall(kurum.tel.toString());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'ARA',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _openMapsNavigation(kurum.adres.toString());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'YOL TARİFİ',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
