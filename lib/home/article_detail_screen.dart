import 'package:chincare/data/article.dart';
import 'package:chincare/model/article_model.dart';
import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Detail Artikel', style: TextStyle(fontSize: 18)),
        backgroundColor: const Color(0xffe9e3d6),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xffF5F1E9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE HEADER (Sekarang pake Network Image)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                article.image, // URL dari API
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                // Loading builder agar rapi saat gambar belum muncul
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 220,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // KATEGORI TAG
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF9FAF9C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                article.category.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A4A4A),
                  ),
            ),

            const SizedBox(height: 8),
            Text(
              article.subtitle,
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),

            const SizedBox(height: 12),
            const Divider(color: Color(0xFFEBE4D5), thickness: 2),

            Text(
              article.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6, // Memberi jarak antar baris agar nyaman dibaca
                    fontSize: 15,
                  ),
            ),

            const SizedBox(height: 20),
            const Divider(color: Color(0xFFEBE4D5), thickness: 2),
            const SizedBox(height: 20),

            // FAKTA MENARIK
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 212, 198, 173),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'Fakta Menarik',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFEBE4D5), thickness: 1),
                  const Text(
                    'Chinchilla dapat melompat hingga ketinggian 1.8 meter dalam satu kali lompatan!',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
          SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Galeri Chinchilla',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10), // Beri jarak sedikit
                Expanded(
                  child: Divider(
                    color: Color(
                      0xFFEBE4D5,
                    ), // Menggunakan kode krem yang Anda tanyakan sebelumnya
                    thickness: 2, // Ketebalan garis
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),

            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // Gambar Kiri
    Flexible(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20), // Radius 20
          border: Border.all(
            color: Colors.black, // Warna border
            width: 2,           // Tebal border
          ),
          image: const DecorationImage(
            image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKIqNs9VEDLZEhwPPeZpPOnhYWgGdN5agDXQ&s'),
            fit: BoxFit.cover, // Agar gambar memenuhi kotak
          ),
        ),
      ),
    ),
SizedBox(width: 20,),
    // Gambar Kanan
    Flexible(
      child: Container(
         height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Radius 20
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          image: const DecorationImage(
            image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJEfjPxg4XBwU8hzPRenpJE4fAQsov4l-Kqw&s'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  ],
)
          ],
        ),
      ),
    );
  }
}