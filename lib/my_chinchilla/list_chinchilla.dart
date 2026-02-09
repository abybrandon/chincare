import 'package:chincare/my_chinchilla/add_chinchilla.dart';
import 'package:flutter/material.dart';
import 'package:chincare/chinchilla/chinchilla_model.dart';
import 'package:chincare/my_chinchilla/detail_chinchilla.dart';
import 'package:flutter/material.dart';
import 'package:chincare/chinchilla/chinchilla_model.dart';
import 'package:chincare/my_chinchilla/detail_chinchilla.dart';
import 'package:http/http.dart' as http; // Tambahkan ini
import 'dart:convert'; // Tambahkan ini
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan ini

/// ===== COLORS =====
const bgColor = Color(0xFFF3F6F3);
const cardColor = Color(0xFFFFFBF7);
const primaryGreen = Color(0xFF9AA58F);
const textSoft = Color(0xFF7A746C);

class MyChinchillasScreen extends StatefulWidget {
  const MyChinchillasScreen({super.key});

  @override
  State<MyChinchillasScreen> createState() => _MyChinchillasScreenState();
}

class _MyChinchillasScreenState extends State<MyChinchillasScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Chinchilla> allChinchillas = []; // Untuk simpan data asli dari API
  List<Chinchilla> filteredChinchillas = []; // Untuk tampilan search
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Ambil data saat pertama buka
  }

  // FUNGSI FETCH DATA DARI API
  Future<void> _fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('user_data');
      if (userDataString == null) return;

      String uid = jsonDecode(userDataString)['uid'];

      final response = await http.get(
        Uri.parse(
          'https://beendapps.site/get-chinchillas?owner_id=$uid',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];

        setState(() {
          // Mapping JSON ke Model Chinchilla
          allChinchillas = data
              .map((json) => Chinchilla.fromJson(json))
              .toList();
          filteredChinchillas = allChinchillas;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching chinchillas: $e");
      setState(() => _isLoading = false);
    }
  }

  void _filterChinchillas(String query) {
    final q = query.toLowerCase();
    setState(() {
      filteredChinchillas = allChinchillas.where((c) {
        return c.nama.toLowerCase().contains(q) || // Pakai 'nama' sesuai API
            c.breed.toLowerCase().contains(q);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'My Chinchillas',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: primaryGreen,
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _fetchData,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: primaryGreen,
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddChinchillaScreen()),
                );
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(
            controller: _searchController,
            onChanged: _filterChinchillas,
          ),
          Expanded(
            child: RefreshIndicator(onRefresh: _fetchData, 
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryGreen),
                    )
                  : filteredChinchillas.isEmpty
                  ? const Center(
                      child: Text(
                        'No chinchilla found 🐭',
                        style: TextStyle(color: textSoft),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredChinchillas.length,
                      itemBuilder: (context, index) {
                        return _ChinchillaListCard(
                          chinchilla: filteredChinchillas[index],
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===== SEARCH BAR =====
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextField(
          controller: controller,
          cursorColor: bgColor,
          onChanged: onChanged,
          decoration: const InputDecoration(
            fillColor: bgColor,
            hoverColor: bgColor,
            focusColor: bgColor,
            hintText: 'Search chinchilla...',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}

/// ===== LIST CARD =====
class _ChinchillaListCard extends StatelessWidget {
  final Chinchilla chinchilla;
  const _ChinchillaListCard({required this.chinchilla});

  int _ageInMonths(DateTime birthDate) {
    final now = DateTime.now();
    return (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChinchillaDetailScreen(chinchilla: chinchilla),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(chinchilla.imageUrl),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chinchilla.nama,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    chinchilla.breed,
                    style: const TextStyle(fontSize: 13, color: textSoft),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.cake_outlined,
                        size: 14,
                        color: textSoft,
                      ),
                      const SizedBox(width: 4),
                      // Di dalam Widget build _ChinchillaListCard
                      Text(
                        '${chinchilla.ageInMonths} months',
                        style: const TextStyle(fontSize: 12, color: textSoft),
                      ),
                      const SizedBox(width: 14),
                      const Icon(
                        Icons.monitor_weight_outlined,
                        size: 14,
                        color: textSoft,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${chinchilla.berat} g',
                        style: const TextStyle(fontSize: 12, color: textSoft),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
