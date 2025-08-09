import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'favorites_manager.dart';


class HospitalListPage extends StatefulWidget {
  const HospitalListPage({super.key});

  @override
  State<HospitalListPage> createState() => _HospitalListPageState();
}

class _HospitalListPageState extends State<HospitalListPage> {
  final List<Map<String, String>> hospitals = [
    {
      'name': 'Fethi Sekin Şehir Hastanesi',
      'image': 'lib/assets/fethi_sekin.jpg',
      'phone': '+904242000000',
      'location': 'https://maps.google.com/?q=Fethi+Sekin+Şehir+Hastanesi'
    },
    {
      'name': 'Mediline Hastanesi',
      'image': 'lib/assets/fethi_sekin.jpg',
      'phone': '+904242111111',
      'location': 'https://maps.google.com/?q=Mediline+Hastanesi'
    },
    {
      'name': 'Hayat Hastanesi',
      'image': 'lib/assets/fethi_sekin.jpg',
      'phone': '+904242222222',
      'location': 'https://maps.google.com/?q=Hayat+Hastanesi'
    },
  ];


  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Çalışmıyor: $url';
    }
  }

  void toggleFavorite(Map<String, String> hospital) {
    setState(() {
      if (FavoritesManager.isFavorite(hospital['name']!)) {
        FavoritesManager.remove(hospital['name']!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${hospital['name']} favorilerden çıkarıldı')),
        );
      } else {
        FavoritesManager.add(hospital);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${hospital['name']} favorilere eklendi')),
        );
      }
    });
    print(FavoritesManager.favorites);
  }


  bool isFavorite(Map<String, String> hospital) {
    return FavoritesManager.isFavorite(hospital['name']!);
  }


  Widget buildHospitalCard(BuildContext context, Map<String, String> hospital) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  hospital['image']!,
                  height: screenHeight * 0.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: IconButton(
                  icon: Icon(
                    isFavorite(hospital) ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                    size: 30,
                  ),
                  onPressed: () => toggleFavorite(hospital),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospital['name']!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _launchUrl('tel:${hospital['phone']}'),
                  child: Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(hospital['phone']!),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _launchUrl(hospital['location']!),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text('Konumu Gör'),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hastaneler'),
      ),
      body: ListView.builder(
        itemCount: hospitals.length,
        itemBuilder: (context, index) => buildHospitalCard(context, hospitals[index]),
      ),
    );
  }
}
