// import 'package:flutter/material.dart';

// // --- MODEL ---
// class Article {
//   final String id, title, subtitle, category, content, image;
//   final List<String> tips;
//   final Color color;

//   Article({
//     required this.id, required this.title, required this.subtitle,
//     required this.category, required this.content, required this.image,
//     required this.tips, required this.color,
//   });
// }

// // --- DUMMY DATA LENGKAP ---
// final List<Article> chinchillaData = [
//   Article(
//     id: '1',
//     category: 'NUTRITION',
//     title: 'The Golden Diet',
//     subtitle: 'High-fiber essentials for long life.',
//     image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQy3Y2sCmWya2MtYh3zcKt3ct4Pi99AQA8APA&s',
//     color: const Color(0xFFE5D9C3),
//     content: 'Chinchillas require a very specific diet to maintain their sensitive digestive systems and constantly growing teeth. Unlike other rodents, their primary food source must be high-quality hay.',
//     tips: ['80% Timothy Hay', 'Strictly No Nuts/Seeds', 'Fresh Water Daily'],
//   ),
//   Article(
//     id: '2',
//     category: 'HYGIENE',
//     title: 'Volcanic Dust Bath',
//     subtitle: 'The ritual of staying fluffy.',
//     image: 'https://images.unsplash.com/photo-1550461716-dbf266b2a8a7?q=80&w=800',
//     color: const Color(0xFFD0D6D6),
//     content: 'Water is the enemy of chinchilla fur. Because their fur is so dense, moisture can get trapped and lead to fungal growth. Instead, they use volcanic ash to absorb oils.',
//     tips: ['Never use water', '15 Mins Bath Time', 'Special Dust Only'],
//   ),
//   Article(
//     id: '3',
//     category: 'HABITAT',
//     title: 'Vertical Mansion',
//     subtitle: 'Safe space and temperature control.',
//     image: 'https://images.unsplash.com/photo-1534631215163-f27357599057?q=80&w=800',
//     color: const Color(0xFFC3D5E5),
//     content: 'Chinchillas are agile jumpers. Their habitat should be vertical with multiple levels. Crucially, they cannot sweat, so room temperature must be kept below 25°C.',
//     tips: ['Multi-level Cage', 'Keep below 25°C', 'Safe Wood Shelves'],
//   ),
// ];

// // --- DASHBOARD PAGE ---
// class DashboardPageChin extends StatelessWidget {
//   const DashboardPageChin({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 120.0,
//             floating: false,
//             pinned: true,
//             backgroundColor: Colors.white,
//             elevation: 0,
//             flexibleSpace: FlexibleSpaceBar(
//               titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               title: const Text("Encyclopedia", 
//                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.all(20),
//             sliver: SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) => _buildArticleCard(context, chinchillaData[index]),
//                 childCount: chinchillaData.length,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildArticleCard(BuildContext context, Article article) {
//     return GestureDetector(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(article: article))),
//       child: Container(
//         height: 280,
//         margin: const EdgeInsets.only(bottom: 25),
//         child: Stack(
//           children: [
//             Hero(
//               tag: article.id,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   image: DecorationImage(image: NetworkImage(article.image), fit: BoxFit.cover),
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter, end: Alignment.bottomCenter,
//                   colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(25),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(article.category, style: const TextStyle(color: Colors.white70, letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Text(article.title, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 5),
//                   Text(article.subtitle, style: const TextStyle(color: Colors.white60, fontSize: 14)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // --- DETAIL PAGE ---
// class DetailPage extends StatelessWidget {
//   final Article article;
//   const DetailPage({super.key, required this.article});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 400,
//             pinned: true,
//             iconTheme: const IconThemeData(color: Colors.white),
//             flexibleSpace: FlexibleSpaceBar(
//               background: Hero(
//                 tag: article.id,
//                 child: Image.network(article.image, fit: BoxFit.cover),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               padding: const EdgeInsets.all(30),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(article.category, style: TextStyle(color: Colors.brown[400], fontWeight: FontWeight.bold, letterSpacing: 2)),
//                       const Icon(Icons.bookmark_border, color: Colors.grey),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   Text(article.title, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
//                   const SizedBox(height: 25),
//                   Text(article.content, style: const TextStyle(fontSize: 18, height: 1.8, color: Colors.black87, fontStyle: FontStyle.italic)),
//                   const SizedBox(height: 40),
//                   const Text("Essential Guidelines", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 15),
//                   ...article.tips.map((tip) => _buildTipItem(tip)).toList(),
//                   const SizedBox(height: 50),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildTipItem(String tip) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF1F1F1),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.stars_rounded, color: Color(0xFFB4975A)),
//           const SizedBox(width: 15),
//           Text(tip, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
// }