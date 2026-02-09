import 'dart:convert';
import 'dart:io';
import 'package:chincare/chinchilla/chinchilla_model.dart'; // Pastikan import model kamu benar
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditChinchillaScreen extends StatefulWidget {
  final Chinchilla chinchilla; // Data yang dikirim dari Detail Screen

  const EditChinchillaScreen({super.key, required this.chinchilla});

  @override
  State<EditChinchillaScreen> createState() => _EditChinchillaScreenState();
}

class _EditChinchillaScreenState extends State<EditChinchillaScreen> {
  // --- CONTROLLERS (Pre-filled dengan data lama) ---
  late TextEditingController _namaController;
  late TextEditingController _breedController;
  late TextEditingController _warnaController;
  late TextEditingController _tglLahirController;
  late TextEditingController _beratController;
  late TextEditingController _riwayatPenyakitController;
  late TextEditingController _tglCheckupController;
  late TextEditingController _catatanController;

  // --- STATES ---
  late bool isMale;
  bool _isLoading = false;
  File? _imageFile; // Foto baru jika user memilih dari galeri
  final List<String> behaviors = ['Aktif', 'Jinak', 'Pemalu', 'Agresif'];
  List<String> selectedBehaviors = [];

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data dari widget.chinchilla
    final c = widget.chinchilla;
    _namaController = TextEditingController(text: c.nama);
    _breedController = TextEditingController(text: c.breed);
    _warnaController = TextEditingController(text: c.warna);
    _tglLahirController = TextEditingController(text: c.tglLahir);
    _beratController = TextEditingController(text: c.berat.toString());
    _riwayatPenyakitController = TextEditingController(text: c.riwayatPenyakit);
    _tglCheckupController = TextEditingController(text: c.tglCheckup);
    _catatanController = TextEditingController(text: c.catatan);

    isMale = c.gender == "Jantan";
    selectedBehaviors = List<String>.from(c.perilaku);
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } on PlatformException catch (e) {
      debugPrint("Gagal ambil gambar: $e");
    }
  }

  // --- LOGIC: UPDATE DATA KE BACKEND ---
  Future<void> _updateData() async {
    if (_namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama tidak boleh kosong!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      var url = Uri.parse(
        'https://beendapps.site/update-chinchilla',
      );
      var request = http.MultipartRequest('POST', url);

      // 1. Masukkan ID (WAJIB untuk update)
      request.fields['id'] = widget.chinchilla.id;
      
      // 2. Masukkan Data Field
      request.fields['nama'] = _namaController.text;
      request.fields['gender'] = isMale ? "Jantan" : "Betina";
      request.fields['breed'] = _breedController.text;
      request.fields['warna'] = _warnaController.text;
      request.fields['tgl_lahir'] = _tglLahirController.text;
      request.fields['berat'] = _beratController.text;
      request.fields['kondisi_kesehatan'] = widget.chinchilla.kondisiKesehatan;
      request.fields['riwayat_penyakit'] = _riwayatPenyakitController.text;
      request.fields['tgl_checkup'] = _tglCheckupController.text;
      request.fields['perilaku'] = selectedBehaviors.join(',');
      request.fields['catatan'] = _catatanController.text;

      // 3. Tambahkan File Gambar (Hanya jika user memilih gambar baru)
      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', _imageFile!.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data berhasil diperbarui!")),
          );
          Navigator.pop(context, true); // Kirim true agar halaman sebelumnya refresh
        }
      } else {
        throw Exception("Gagal update: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF6F1),
        title: const Text('Edit Chinchilla', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFAF6F1),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// PHOTO PICKER (Menampilkan foto lama atau baru)
                  GestureDetector(
                    onTap: _pickImage,
                    child: Column(
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFEDE7DF),
                            border: Border.all(color: Colors.white, width: 4),
                            image: _imageFile != null
                                ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                                : DecorationImage(
                                    image: NetworkImage(widget.chinchilla.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          child: (_imageFile == null && widget.chinchilla.imageUrl.isEmpty)
                              ? const Icon(Icons.camera_alt, color: Colors.grey)
                              : null,
                        ),
                        const SizedBox(height: 8),
                        const Text('Change Photo', style: TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _card(
                    title: 'Informasi Utama',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Nama Chinchilla'),
                        _input('', _namaController),
                        const SizedBox(height: 16),
                        _label('Jenis Kelamin'),
                        _genderToggle(),
                        const SizedBox(height: 16),
                        _label('Breed / Jenis'),
                        _input('Standard', _breedController),
                        const SizedBox(height: 16),
                        _label('Warna Bulu'),
                        _input('Contoh: abu-abu keperakan', _warnaController),
                        const SizedBox(height: 16),
                        _label('Tanggal Lahir'),
                        _input('YYYY-MM-DD', _tglLahirController),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  _expandableCard(
                    title: 'Detail Tambahan',
                    child: _input('Berat badan (gram)', _beratController),
                  ),

                  const SizedBox(height: 16),
                  _expandableCard(
                    title: 'Kesehatan',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Riwayat Penyakit (Optional)'),
                        _textarea('Isi catatan kesehatan', _riwayatPenyakitController),
                        const SizedBox(height: 12),
                        _label('Terakhir Check-up'),
                        _input('YYYY-MM-DD', _tglCheckupController),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  _expandableCard(
                    title: 'Perilaku & Catatan',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          children: behaviors.map((e) {
                            final selected = selectedBehaviors.contains(e);
                            return ChoiceChip(
                              label: Text(e),
                              selected: selected,
                              selectedColor: const Color(0xFF9FAF9C),
                              onSelected: (_) {
                                setState(() {
                                  selected ? selectedBehaviors.remove(e) : selectedBehaviors.add(e);
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        _textarea('Memo tambahan / catatan khusus', _catatanController),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          /// FIXED SAVE BUTTON
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFFAF6F1),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9FAF9C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                  onPressed: _isLoading ? null : _updateData,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Update Chinchilla',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- REUSABLE HELPERS (Sama seperti Add Screen) ---
  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.info_rounded, size: 20),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }

  Widget _expandableCard({required String title, required Widget child}) {
    return ExpansionTile(
      collapsedBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      children: [Padding(padding: const EdgeInsets.all(16), child: child)],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
  );

  Widget _input(String hint, TextEditingController controller) => TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hint, filled: true, fillColor: const Color(0xFFF5F1EC),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
  );

  Widget _textarea(String hint, TextEditingController controller) => TextField(
    controller: controller,
    maxLines: 3,
    decoration: InputDecoration(
      hintText: hint, filled: true, fillColor: const Color(0xFFF5F1EC),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
  );

  Widget _genderToggle() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF5F1EC), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [_genderItem('Jantan', true), _genderItem('Betina', false)]),
    );
  }

  Widget _genderItem(String text, bool male) {
    final selected = isMale == male;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isMale = male),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF9FAF9C) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(text, style: TextStyle(color: selected ? Colors.white : Colors.black54)),
          ),
        ),
      ),
    );
  }
}