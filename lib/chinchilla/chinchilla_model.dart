class Chinchilla {
  final String id;
  final String ownerId;
  final String nama;
  final String gender;
  final String breed;
  final String warna;
  final String tglLahir;
  final String berat;
  final String kondisiKesehatan;
  final String riwayatPenyakit;
  final String tglCheckup;
  final List<String> perilaku;
  final String catatan;
  final String imageUrl;
  final String createdAt;

  Chinchilla({
    required this.id,
    required this.ownerId,
    required this.nama,
    required this.gender,
    required this.breed,
    required this.warna,
    required this.tglLahir,
    required this.berat,
    required this.kondisiKesehatan,
    required this.riwayatPenyakit,
    required this.tglCheckup,
    required this.perilaku,
    required this.catatan,
    required this.imageUrl,
    required this.createdAt,
  });

  // Factory untuk convert dari JSON API ke Object Flutter
  factory Chinchilla.fromJson(Map<String, dynamic> json) {
    return Chinchilla(
      id: json['id'] ?? '',
      ownerId: json['owner_id'] ?? '',
      nama: json['nama'] ?? 'Unknown',
      gender: json['gender'] ?? 'Unknown',
      breed: json['breed'] ?? '-',
      warna: json['warna'] ?? '-',
      tglLahir: json['tgl_lahir'] ?? '',
      berat: json['berat'] ?? '0',
      kondisiKesehatan: json['kondisi_kesehatan'] ?? 'Sehat',
      riwayatPenyakit: json['riwayat_penyakit'] ?? '-',
      tglCheckup: json['tgl_checkup'] ?? '',
      // Konversi list dinamis ke List<String>
      perilaku: List<String>.from(json['perilaku'] ?? []),
      catatan: json['catatan'] ?? '-',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
      createdAt: json['created_at'] ?? '',
    );
  }

  // Fungsi pembantu untuk hitung umur dalam bulan
  int get ageInMonths {
    if (tglLahir.isEmpty) return 0;
    try {
      DateTime birth = DateTime.parse(tglLahir);
      DateTime now = DateTime.now();
      return (now.year - birth.year) * 12 + (now.month - birth.month);
    } catch (e) {
      return 0;
    }
  }
}




class ChinchillaArticle {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String imageUrl;
  final List<String> safeItems;
  final List<String> forbiddenItems;
  final String content;

  ChinchillaArticle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.imageUrl,
    required this.safeItems,
    required this.forbiddenItems,
    required this.content,
  });
}

List<ChinchillaArticle> dummyChinchillaArticles = [
  ChinchillaArticle(
    id: '1',
    title: 'Diet & Nutrisi',
    subtitle: 'Panduan makanan harian yang tepat',
    category: 'Diet',
    imageUrl: 'https://example.com/chinchilla_eating.jpg',
    safeItems: ['Timothy Hay (Wajib)', 'Pelet Khusus', 'Air Bersih', 'Dried Rose Hips'],
    forbiddenItems: ['Kacang-kacangan', 'Biji-bijian', 'Buah Segar Berlebih', 'Sayuran Basah'],
    content: 'Sistem pencernaan chinchilla sangat sensitif. 80% dari diet mereka harus berupa serat kasar (Hay) untuk mengasah gigi dan menjaga usus.',
  ),
  ChinchillaArticle(
    id: '2',
    title: 'Kesehatan & Kebersihan',
    subtitle: 'Mandi pasir dan perawatan bulu',
    category: 'Health',
    imageUrl: 'https://example.com/chinchilla_bath.jpg',
    safeItems: ['Dust Bath (2-3x seminggu)', 'Sisir Khusus', 'Cek Gigi Mingguan'],
    forbiddenItems: ['Air (Dilarang Mandi Air)', 'Sabun Manusia', 'Ruangan Lembap'],
    content: 'Chinchilla memiliki bulu sangat padat. Mandi air dapat menyebabkan jamur mematikan. Gunakan debu vulkanik khusus untuk membersihkan minyak.',
  ),
  ChinchillaArticle(
    id: '3',
    title: 'Habitat & Kandang',
    subtitle: 'Membangun rumah yang nyaman',
    category: 'Habitat',
    imageUrl: 'https://example.com/chinchilla_cage.jpg',
    safeItems: ['Kandang Bertingkat', 'Roda Lari (Min 38cm)', 'Rumah Kayu', 'Pendingin (AC/Granit)'],
    forbiddenItems: ['Kandang Plastik (Bisa Dimakan)', 'Lantai Kawat', 'Suhu di atas 25°C'],
    content: 'Chinchilla adalah hewan pelompat. Mereka butuh ruang vertikal dan suhu ruangan yang dingin agar tidak terkena Heatstroke.',
  ),
  ChinchillaArticle(
    id: '4',
    title: 'Perilaku & Bonding',
    subtitle: 'Memahami bahasa tubuh mereka',
    category: 'Behavior',
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQy3Y2sCmWya2MtYh3zcKt3ct4Pi99AQA8APA&s',
    safeItems: ['Hand Taming', 'Playtime di Luar Kandang', 'Grooming Lembut'],
    forbiddenItems: ['Suara Keras Mengejutkan', 'Memegang Ekor', 'Memaksa Gendong'],
    content: 'Chinchilla adalah hewan mangsa. Butuh kesabaran ekstra untuk mendapatkan kepercayaan mereka. Jangan pernah menarik ekornya!',
  ),
];