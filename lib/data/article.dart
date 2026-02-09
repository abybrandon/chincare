
import 'package:chincare/model/article_model.dart';


class Article {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String image;
  final String content;

  Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.image,
    required this.content,
  });

  // --- INI DIA FROM JSON-NYA ---
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      // Kita pakai '??' (null operator) supaya kalau data di DB kosong, aplikasi nggak crash
      id: json['id'] ?? '',
      title: json['title'] ?? 'No Title',
      subtitle: json['subtitle'] ?? '',
      category: json['category'] ?? 'General',
      image: json['image'] ?? 'https://via.placeholder.com/150', // Fallback gambar jika kosong
      content: json['content'] ?? 'No Content Available',
    );
  }

  // Opsional: Jika kamu butuh kirim balik ke API suatu saat nanti
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'image': image,
      'content': content,
    };
  }
}