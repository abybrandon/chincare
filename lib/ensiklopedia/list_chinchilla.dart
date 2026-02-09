// import 'package:chincare/chinchilla/chinchilla_model.dart';
// import 'package:flutter/material.dart';

// class EncyclopediaSection extends StatelessWidget {
//   final List<Chinchilla> data;

//   const EncyclopediaSection({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // HEADER SECTION
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               "Chinchilla Varieties",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             TextButton(
//               onPressed: () {},
//               child: const Text("See All", style: TextStyle(color: Colors.grey, fontSize: 12)),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),

//         // LIST OF CARDS
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: data.length,
//           itemBuilder: (context, index) {
//             final chin = data[index];
//             return _buildNanoBananaCard(context, chin);
//           },
//         ),
//       ],
//     );
//   }

//   // BUILDER UNTUK CARD (Gaya Nano Banana)
//   Widget _buildNanoBananaCard(BuildContext context, Chinchilla chin) {
//     return GestureDetector(
//       onTap: () {
//         // Navigasi ke Detail
//         // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailEncyclopedia(chinchilla: chin)));
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 15,
//               offset: const Offset(0, 8),
//             )
//           ],
//         ),
//         child: Row(
//           children: [
//             // IMAGE WITH HERO ANIMATION
//             Hero(
//               tag: chin.name,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Image.network(
//                   chin.image,
//                   width: 90,
//                   height: 90,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     width: 90,
//                     height: 90,
//                     color: Colors.grey[200],
//                     child: const Icon(Icons.pets, color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),

//             // TEXT CONTENT
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // RARITY TAG (Pill Shaped)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFDFF0D8),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Text(
//                       chin.rarity,
//                       style: const TextStyle(
//                         fontSize: 10,
//                         color: Color(0xFF6B8E6B),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     chin.name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold, 
//                       fontSize: 18, 
//                       color: Color(0xFF2D442E),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     chin.description,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }