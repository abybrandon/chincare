import 'package:chincare/my_chinchilla/list_chinchilla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Peta Gratis
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

const Color primaryBrown = Color(0xFF8B5E3C);
const Color accentOrange = Color(0xFFFF914D);

class ChinchillaShop extends StatefulWidget {
  const ChinchillaShop({super.key});

  @override
  State<ChinchillaShop> createState() => _ChinchillaShopState();
}

class _ChinchillaShopState extends State<ChinchillaShop> {
  // Koordinat Toko Anda
  static const LatLng _storeLocation = LatLng(-6.1304724, 106.7441287);

  // Fungsi WhatsApp
  void _launchWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/6287788606682");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // Fungsi Buka Maps Luar
  void _launchMaps() async {
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${_storeLocation.latitude},${_storeLocation.longitude}";
    final Uri url = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F1EA),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Toko Chinchilla",
          style: TextStyle(
            color: primaryBrown,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image yang lebih modern
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlYQp89P8f8qRy7b2s-eYLuzRRgHoROqbMVQ&s',
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle("Tentang Kami"),
            const Text(
              "Kami menyediakan Chinchilla kualitas premium dengan perawatan terbaik dan perlengkapan lengkap untuk kebutuhan anabul eksotis Anda.",
              style: TextStyle(color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Ganti bagian katalog produk di dalam Column build utama:
            _buildSectionTitle("Katalog Produk"),
          GridView.count(
              shrinkWrap: true, 
              physics: const NeverScrollableScrollPhysics(), 
              crossAxisCount: 2, 
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.65, // Sesuaikan agar konten Card tidak terpotong
              children: [
                _buildProductCard(
                  name: 'Chinchilla White',
                  price: 'Rp 7.500.000',
                  imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKIqNs9VEDLZEhwPPeZpPOnhYWgGdN5agDXQ&s',
                  isBestSeller: true,
                  isFavorite: true,
                ),
                _buildProductCard(
                  name: 'Premium Hay',
                  price: 'Rp 95.000',
                  imageUrl: 'https://premiumqualityhayandfeed.com/wp-content/uploads/2019/07/grss.jpg',
                  isBestSeller: false,
                ),
                _buildProductCard(
                  name: 'Kandang Roda',
                  price: 'Rp 850.000',
                  imageUrl: 'https://image.made-in-china.com/202f0j00ZKdbsVqgGmkY/Collapsible-Metal-Cat-Rotating-Casters-Enclosure-Pet-Bed-Pet-Cage-House.webp',
                  isBestSeller: false,
                ),
                _buildProductCard(
                  name: 'Sand Bath',
                  price: 'Rp 50.000',
                  imageUrl: 'https://m.media-amazon.com/images/I/51j6TXv5rBL._UF1000,1000_QL80_.jpg',
                  isBestSeller: false,
                ),

               
              ],
            ),

            _buildSectionTitle("Lokasi Toko"),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: _storeLocation,
                    initialZoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.chinchilla.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _storeLocation,
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Aksi Minimalis
            Row(
              children: [
                Expanded(
                  child: _buildIconButton(
                    "WhatsApp",
                    const Color.fromARGB(255, 16, 181, 101),
                    Icons.message,
                    _launchWhatsApp,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildIconButton(
                    "Buka Maps",
                    Colors.blueAccent,
                    Icons.map_outlined,
                    _launchMaps,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Widget Helper untuk scannability ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryBrown,
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String name,
    required String price,
    required String imageUrl,
    bool isFavorite = false,
    bool isBestSeller = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        // aksi ke detail produk
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFFFF7E6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= IMAGE =================
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Badge Best Seller
                  if (isBestSeller)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accentOrange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Best Seller",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Favorite Icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= DETAIL =================
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    price,
                    style: const TextStyle(
                      color: accentOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Action Button
                  Container(
                    width: double.infinity,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text(
                        "Chat WhatsApp",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(String name, String price, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: bgColor,
            child: Icon(icon, color: accentOrange, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryBrown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
