import 'package:chincare/chinchilla/chinchilla_model.dart';
import 'package:chincare/my_chinchilla/edit_chinchilla.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChinchillaDetailScreen extends StatefulWidget {
  final Chinchilla chinchilla; // Data ini dipassing dari list

  const ChinchillaDetailScreen({super.key, required this.chinchilla});

  @override
  State<ChinchillaDetailScreen> createState() => _ChinchillaDetailScreenState();
}

class _ChinchillaDetailScreenState extends State<ChinchillaDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Color(0xFFE57373),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Hapus Data?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: "Apakah Anda yakin ingin menghapus ",
                      ),
                      TextSpan(
                        text: widget.chinchilla.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const TextSpan(text: "? Tindakan ini permanen."),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _processDelete(context, widget.chinchilla.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE57373),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Ya, Hapus",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- FUNGSI DELETE (ANTI-CRASH VERSION) ---
  Future<void> _processDelete(BuildContext context, String id) async {
    // 1. Simpan NavigatorState sebelum melakukan await
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // 2. Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF9AA58F)),
      ),
    );

    try {
      final response = await http
          .delete(
            Uri.parse(
              'https://beendapps.site/delete-chinchilla?id=$id',
            ),
          )
          .timeout(
            const Duration(seconds: 10),
          ); // Tambahkan timeout agar tidak gantung

      // 3. Gunakan referensi yang sudah disimpan, tapi cek mounted
      if (!mounted) return;

      // Tutup loading dialog (pop loading)
      navigator.pop();

      if (response.statusCode == 200) {
        // Balik ke list screen
        navigator.pop(true);

        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("Data berhasil dihapus"),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black87,
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text("Gagal: ${response.statusCode}")),
        );
      }
    } catch (e) {
      if (!mounted) return;

      // Tutup loading dialog jika terjadi error network
      navigator.pop();

      debugPrint("Error Delete: $e");
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Koneksi bermasalah: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kita panggil data dari widget agar lebih pendek penulisannya
    final c = widget.chinchilla;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1EA),
      appBar: AppBar(
        title: Text(c.nama),
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F1EA),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              // 1. Pindah ke halaman Edit sambil membawa data chinchilla saat ini
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditChinchillaScreen(chinchilla: widget.chinchilla),
                ),
              );

              // 2. Jika result adalah 'true' (artinya user berhasil update data)
              if (result == true) {
                // Balik ke halaman List dengan membawa sinyal refresh true
                // Ini agar halaman List Chinchilla juga ikutan refresh data terbaru
                if (mounted) Navigator.pop(context, true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _showDeleteConfirmation(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderImage(c),
          _BasicInfo(c),
          _CustomTabBar(_tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_InfoTab(c), _HealthTab(c), _BehaviorTab(c)],
            ),
          ),
          _BottomActions(c),
        ],
      ),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  final Chinchilla c;
  const _HeaderImage(this.c);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          c.imageUrl,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 220,
            color: Colors.grey[300],
            child: const Icon(Icons.pets, size: 50),
          ),
        ),
      ),
    );
  }
}

class _BasicInfo extends StatelessWidget {
  final Chinchilla c;
  const _BasicInfo(this.c);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            c.nama,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '${c.breed} • ${c.gender} • ${c.berat} g',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _CustomTabBar extends StatelessWidget {
  final TabController controller;
  const _CustomTabBar(this.controller);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 48, // Sedikit lebih tinggi biar lega
        decoration: BoxDecoration(
          color: const Color(0xFFEDE6DC), // Warna krem background
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: controller,
          // --- KUNCI BIAR FULL ---
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: const Color(0xFF9AA58F), // Warna hijau indikator
            borderRadius: BorderRadius.circular(10),
          ),
          // -----------------------
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black54,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 13,
          ),
          dividerColor:
              Colors.transparent, // Hapus garis bawah bawaan Material 3
          padding: const EdgeInsets.all(
            4,
          ), // Kasih jarak dikit dari pinggir kontainer krem
          labelPadding:
              EdgeInsets.zero, // Hapus padding bawaan label biar gak kepotong
          tabs: const [
            Tab(text: 'Informasi'),
            Tab(text: 'Kesehatan'),
            Tab(text: 'Perilaku'),
          ],
        ),
      ),
    );
  }
}

class _InfoTab extends StatelessWidget {
  final Chinchilla c;
  const _InfoTab(this.c);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        _InfoTile(
          title: 'Physical Color',
          value: c.warna,
          icon: Icons.auto_awesome_outlined,
          iconColor: const Color(0xFFB4A68D),
        ),
        _InfoTile(
          title: 'Birthday',
          value: c.tglLahir,
          icon: Icons.cake_outlined,
          iconColor: const Color(0xFF9AA58F),
        ),
        _InfoTile(
          title: 'Current Age',
          value: '${c.ageInMonths} Months Old',
          icon: Icons.history_toggle_off_rounded,
          iconColor: const Color(0xFF7A8C99),
        ),
        _InfoTile(
          title: 'Owner Notes',
          value: c.catatan.isEmpty ? "No special notes" : c.catatan,
          icon: Icons.description_outlined,
          iconColor: const Color(0xFF9AA58F),
        ),
      ],
    );
  }
}

class _HealthTab extends StatelessWidget {
  final Chinchilla c;
  const _HealthTab(this.c);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        _InfoTile(
          title: 'Current Condition',
          value: c.kondisiKesehatan,
          icon: Icons.health_and_safety_outlined,
          iconColor: Colors.teal,
        ),
        _InfoTile(
          title: 'Medical History',
          value: c.riwayatPenyakit,
          icon: Icons.coronavirus_outlined,
          iconColor: Colors.orangeAccent,
        ),
        _InfoTile(
          title: 'Last Professional Check',
          value: c.tglCheckup.isEmpty ? "Not Scheduled" : c.tglCheckup,
          icon: Icons.verified_user_outlined,
          iconColor: Colors.indigoAccent,
        ),
      ],
    );
  }
}

class _BehaviorTab extends StatelessWidget {
  final Chinchilla c;
  const _BehaviorTab(this.c);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8, left: 4),
          child: Text(
            "Sifat & Perilaku:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8,
          children: c.perilaku
              .map(
                (p) => Chip(
                  label: Text(p),
                  backgroundColor: const Color(0xFF9AA58F).withOpacity(0.2),
                  side: BorderSide.none,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor = const Color(0xFF9AA58F),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.4),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon dengan Glass Background Bulat
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 16),
              // Teks Informasi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.2,
                        color: iconColor.withOpacity(0.8),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3E3E3E),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: iconColor.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final Chinchilla c;
  const _BottomActions(this.c);

  void _showScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _ScheduleCheckupDialog(chinchilla: c);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showScheduleDialog(context), // Panggil Dialog
              icon: const Icon(Icons.calendar_month, color: Colors.white),
              label: const Text(
                'Jadwal Checkup Next',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9AA58F),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleCheckupDialog extends StatefulWidget {
  final Chinchilla chinchilla;
  const _ScheduleCheckupDialog({required this.chinchilla});

  @override
  State<_ScheduleCheckupDialog> createState() => _ScheduleCheckupDialogState();
}

class _ScheduleCheckupDialogState extends State<_ScheduleCheckupDialog> {
  // Default set ke 1 bulan dari sekarang
  DateTime selectedDate = DateTime.now().add(const Duration(days: 30));

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ikon Header yang Elegan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF9AA58F).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month,
                color: Color(0xFF9AA58F),
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Schedule Checkup",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Kapan jadwal checkup berikutnya untuk ${widget.chinchilla.nama}?",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 24),

            // Picker Box yang Premium
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    const Duration(days: 730),
                  ), // max 2 thn
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF9AA58F), // header background
                          onPrimary: Colors.white, // header text color
                          onSurface: Color(0xFF2D2D2D), // body text color
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null && picked != selectedDate) {
                  setState(() => selectedDate = picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFBF9),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF9AA58F).withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_note_rounded,
                      color: Color(0xFF9AA58F),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "Ubah",
                      style: TextStyle(
                        color: Color(0xFF9AA58F),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Batal",
                      style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Panggil API Update tgl_checkup disini
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Jadwal ${widget.chinchilla.nama} berhasil diatur!",
                          ),
                          backgroundColor: const Color(0xFF9AA58F),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9AA58F),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Konfirmasi",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
