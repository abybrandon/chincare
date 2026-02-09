import 'package:chincare/data/article.dart';
import 'package:chincare/model/article_model.dart';
import 'package:chincare/widget/article_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'article_detail_screen.dart';
import '';

class ChinchillaListScreen extends StatefulWidget {
  const ChinchillaListScreen({super.key});

  @override
  State<ChinchillaListScreen> createState() => _ChinchillaListScreenState();
}

class _ChinchillaListScreenState extends State<ChinchillaListScreen> {
  // Fungsi untuk mengambil data dari backend
  Future<List<Article>> fetchArticles() async {
    final response = await http.get(
      Uri.parse('https://beendapps.site/get-articles'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> articlesRaw = responseData['data'];
      return articlesRaw.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat artikel');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe9e3d6),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat datang di ensiklopedia chinchilla kamu.",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Jelajahi berbagai artikel informatif tentang chinchilla.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Article>>(
                future: fetchArticles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF9FAF9C)));
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Belum ada artikel tersedia."));
                  }

                  final articles = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return ArticleCard(
                        article: article,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ArticleDetailScreen(article: article),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}