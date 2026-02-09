import 'dart:convert';

import 'package:chincare/chinchilla/chinchilla_model.dart';
import 'package:chincare/chinchilla_shop/chinchilla_shop.dart';
import 'package:chincare/data/article.dart';
import 'package:chincare/ensiklopedia/detail_chinchilla.dart';
import 'package:chincare/ensiklopedia/list_chinchilla.dart';
import 'package:chincare/home/article_detail_screen.dart';
import 'package:chincare/home/chinchilla_list_screen.dart';
import 'package:chincare/home/profile_page.dart';
import 'package:chincare/my_chinchilla/add_chinchilla.dart';
import 'package:chincare/my_chinchilla/detail_chinchilla.dart';
import 'package:chincare/my_chinchilla/list_chinchilla.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  final String uid;
  final String name;

  const DashboardPage({super.key, required this.uid, required this.name});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [_buildHome(), MyChinchillasScreen(), ProfilePage()];
  }

  Future<List<Article>> fetchLimitedArticles() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://beendapps.site/get-articles',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> articlesRaw = responseData['data'];
        // Kita ambil 5 data teratas saja
        return articlesRaw
            .map((json) => Article.fromJson(json))
            .toList()
            .take(5)
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor, // Background krem pucat sesuai gambar
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Color.fromARGB(255, 219, 203, 164),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_mosaic_outlined),
            label: "My Chinchilla",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // --- 1. HALAMAN HOME (VISUAL MATCH) ---
  Widget _buildHome() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const Icon(Icons.menu, color: Colors.black),
            title: const Text(
              "My Chinchilla",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.upcoming, color: Colors.white),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Upcoming update — fitur ini akan segera hadir',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: const Color(0xFF9AA58F), // green soft
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                icon: const Icon(Icons.search, color: Colors.black),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.upcoming, color: Colors.white),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Upcoming update — fitur ini akan segera hadir',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: const Color(0xFF9AA58F), // green soft
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                icon: const Icon(Icons.person_outline, color: Colors.black),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BAGIAN ATAS: INFO CHINCHILLA & TABUIS
                  SizedBox(
                    height:
                        230, // Tinggi ini menampung seluruh menu kanan agar pas
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Kartu Kiri (Info Chinchilla)
                        Expanded(flex: 1, child: _buildChinchillaInfoCard()),
                        const SizedBox(width: 12),
                        // Kolom Kanan (Menu Action)
                        Expanded(flex: 1, child: _buildRightMenuColumn()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // CARE ACADEMY SECTION
                  _buildSectionHeader("Article Academy", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChinchillaListScreen(),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  // Bungkus dengan SizedBox untuk menentukan tinggi slider
                  SizedBox(
                    height: 180,
                    child: FutureBuilder<List<Article>>(
                      future: fetchLimitedArticles(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final articles = snapshot.data ?? [];

                        if (articles.isEmpty) {
                          return const Center(
                            child: Text("No articles available"),
                          );
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: articles.length,
                          padding: const EdgeInsets.only(right: 16),
                          itemBuilder: (context, index) {
                            return _buildCareAcademyCard(articles[index]);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // SHOP & SERVICES SECTION
                  _buildSectionHeader("Shop & Services", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChinchillaShop()),
                    );
                  }),

                  _buildShopCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET: Kartu Info Chinchilla (Kiri Atas)
  Widget _buildChinchillaInfoCard() {
    return GestureDetector(
      onTap: () {
        //  Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => ChinchillaDetailScreen()),
        //       );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 250, 250, 246),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkCgbpBo-xbNqO0_SzqbnBOVx6u_rfrem6hg&s",
                height: 120,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "My Chinchilla",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              "Healthy Condition",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Spacer(), // Mendorong icon ke bawah agar kartu terlihat penuh & simetris
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(
                  Icons.person_pin_circle,
                  size: 18,
                  color: Color.fromARGB(255, 219, 203, 164),
                ),
                Icon(
                  Icons.add_circle_outline,
                  size: 18,
                  color: Color.fromARGB(255, 219, 203, 164),
                ),
                Icon(
                  Icons.chat_bubble_outline,
                  size: 18,
                  color: Color.fromARGB(255, 219, 203, 164),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET: Kolom Menu Kanan (Tabuis, Buck Top)

  Widget _buildRightMenuColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment
          .spaceBetween, // Menyebar menu agar sejajar tinggi kartu kiri
      children: [
        _menuTile("Bath Time", "2 Times in a week", 'bath.png'),
        _menuTile("Weight", "400gr-600gr normal", 'weight.png'),
        _menuTile("Temperatur", "10 – 20°", 'temperature.png'),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddChinchillaScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9FAF9C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Add Chinchilla",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _menuTile(String title, String? sub, String icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 250, 250, 246),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                if (sub != null)
                  Text(
                    sub,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
              ],
            ),
          ),
          Image.asset("images/$icon", height: 18, width: 18),
        ],
      ),
    );
  }

  Widget _buildSmallActionCard(String title, String sub, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  sub,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          Icon(icon, size: 18, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSimpleListTile(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        ],
      ),
    );
  }

  // WIDGET: Section Header
  Widget _buildSectionHeader(String title, VoidCallback function) {
    return GestureDetector(
      onTap: function,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  // WIDGET: Care Academy Card (Full Width)
  Widget _buildCareAcademyCard(Article article) {
    return GestureDetector(
      onTap: () {
        // Langsung ke detail artikel yang diklik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Container(
        width: 320,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 250, 246),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ArticleRibbonBadge(),
                  SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          article.title, // Judul dari API

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF2D442E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Image(
                        image: AssetImage("images/icon_lamp.png"),
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFEBE4D5), thickness: 1),
                  Text(
                    article.subtitle, // Subtitle dari API
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B8E6B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Read More",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF6B8E6B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                article.image, // Gambar dari API
                height: 100,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset("images/icon_chin.png", height: 100, width: 80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// MASUKKAN INI KE DALAM CLASS _DashboardPageState (sebelum penutup kurung kurawal class)

Widget _buildShopCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 0.0),
    child: InkWell( // Mengganti GestureDetector dengan InkWell agar ada efek klik
      onTap: () {
        print("Shop Card Clicked!"); // Untuk debugging di console
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChinchillaShop()),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect( // Memastikan gambar mengikuti border radius container
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            "images/shop_card.png",
            width: double.infinity,
            fit: BoxFit.contain, // Sesuaikan fit agar gambar tidak terpotong
          ),
        ),
      ),
    ),
  );
}

class ArticleRibbonBadge extends StatelessWidget {
  final String text;
  final IconData icon;

  const ArticleRibbonBadge({
    super.key,
    this.text = 'Article',
    this.icon = Icons.lightbulb_outline,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RibbonPainter(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF2E7D32)),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
              ),
            ),
            SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}

class _RibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8F5E9)
      ..style = PaintingStyle.fill;

    final path = Path();

    // kiri atas
    path.moveTo(0, 0);
    path.lineTo(size.width - 10, 0);

    // lekukan kanan
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 10, size.height);

    // bawah
    path.lineTo(0, size.height);

    // rounded kiri
    path.quadraticBezierTo(-6, size.height / 2, 0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
