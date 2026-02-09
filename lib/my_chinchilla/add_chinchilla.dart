import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class AddChinchillaScreen extends StatefulWidget {
  const AddChinchillaScreen({super.key});

  @override
  State<AddChinchillaScreen> createState() => _AddChinchillaScreenState();
}

class _AddChinchillaScreenState extends State<AddChinchillaScreen> {
  // --- CONTROLLERS ---
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _warnaController = TextEditingController();
  final TextEditingController _tglLahirController = TextEditingController();
  final TextEditingController _beratController = TextEditingController();
  final TextEditingController _riwayatPenyakitController =
      TextEditingController();
  final TextEditingController _tglCheckupController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  // --- STATES ---
  bool isMale = true;
  bool _isLoading = false;
  File? _imageFile;
  final List<String> behaviors = ['Aktif', 'Jinak', 'Pemalu', 'Agresif'];
  List<String> selectedBehaviors = [];

  // --- LOGIC: PICK IMAGE ---
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
      print("Gagal ambil gambar: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Izin akses galeri ditolak atau bermasalah."),
        ),
      );
    }
  }

  String? _ownerId;

  @override
  void initState() {
    super.initState();
    _loadUser(); // Panggil saat screen dibuka
  }


  
_loadUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userDataString = prefs.getString('user_data');
  
  if (userDataString != null) {
    Map<String, dynamic> userMap = jsonDecode(userDataString);
    setState(() {
      _ownerId = userMap['uid'];
    });
  }
}




  // --- LOGIC: SAVE DATA TO BACKEND ---
  Future<void> _saveData() async {
    if (_imageFile == null || _namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lengkapi Nama dan Foto terlebih dahulu!"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // URL Cloud Function kamu
      var url = Uri.parse(
        'https://beendapps.site/add-chinchilla-full',
      );
      var request = http.MultipartRequest('POST', url);

   
      request.fields['owner_id'] = _ownerId ?? ''; 
      request.fields['nama'] = _namaController.text;
      request.fields['gender'] = isMale ? "Jantan" : "Betina";
      request.fields['breed'] = _breedController.text;
      request.fields['warna'] = _warnaController.text;
      request.fields['tgl_lahir'] = _tglLahirController.text;
      request.fields['berat'] = _beratController.text;
      request.fields['kondisi_kesehatan'] = "Sehat";
      request.fields['riwayat_penyakit'] = _riwayatPenyakitController.text;
      request.fields['tgl_checkup'] = _tglCheckupController.text;
      request.fields['perilaku'] = selectedBehaviors.join(
        ',',
      ); // Kirim string dipisah koma
      request.fields['catatan'] = _catatanController.text;

      // 2. Tambahkan File Gambar
      request.files.add(
        await http.MultipartFile.fromPath('file', _imageFile!.path),
      );

      // 3. Kirim Request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Berhasil disimpan!")));
          Navigator.pop(context);
        }
      } else {
        throw Exception("Gagal upload: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF6F1),
        title: const Text(
          'Add New Chinchilla',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
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
                  /// PHOTO PICKER
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
                            image: _imageFile != null
                                ? DecorationImage(
                                    image: FileImage(_imageFile!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: _imageFile == null
                              ? const Icon(Icons.camera_alt, color: Colors.grey)
                              : null,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add Photo',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
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
                        _textarea(
                          'Isi catatan kesehatan',
                          _riwayatPenyakitController,
                        ),
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
                                  selected
                                      ? selectedBehaviors.remove(e)
                                      : selectedBehaviors.add(e);
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        _textarea(
                          'Memo tambahan / catatan khusus',
                          _catatanController,
                        ),
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
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFFAF6F1),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9FAF9C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: _isLoading ? null : _saveData,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Chinchilla',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER COMPONENTS ---

  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_rounded, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _expandableCard({required String title, required Widget child}) {
    return ExpansionTile(
      collapsedBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
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
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5F1EC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  Widget _textarea(String hint, TextEditingController controller) => TextField(
    controller: controller,
    maxLines: 3,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5F1EC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  Widget _genderToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [_genderItem('Jantan', true), _genderItem('Betina', false)],
      ),
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
            child: Text(
              text,
              style: TextStyle(color: selected ? Colors.white : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}
