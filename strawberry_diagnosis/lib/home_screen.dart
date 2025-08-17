import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final List<Map<String, dynamic>> recentDiagnoses;

  const HomeScreen({
    super.key,
    required this.username,
    required this.recentDiagnoses,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _handleScanNow() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() => _selectedImage = File(pickedFile.path));
                    print('Camera Image: ${pickedFile.path}');
                    // TODO: Trigger diagnosis upload
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() => _selectedImage = File(pickedFile.path));
                    print('Gallery Image: ${pickedFile.path}');
                    // TODO: Trigger diagnosis upload
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(widget.username),
              const SizedBox(height: 16),
              _buildHeroCard(),
              const SizedBox(height: 24),
              _buildRecentScansHeader(context),
              const SizedBox(height: 12),
              _buildRecentScans(),
              if (_selectedImage != null) ...[
                const SizedBox(height: 20),
                const Text(
                  'Selected Image:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Image.file(_selectedImage!, height: 200),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(String username) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome $username!',
          style: const TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Color(0xFF28824D),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Get insights about plant health instantly',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 16,
            color: Color(0xFF4C4C4C),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      height: 380,
      width: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/hero_card_picture.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Diagnose Your\nPlants!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.white,
            ),
          ),
          ElevatedButton(
            onPressed: _handleScanNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3CA768),
              fixedSize: const Size(280, 48),
              elevation: 4,
            ),
            child: const Text(
              'Scan Now',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFFF9FDF9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScansHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Scans',
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4C4C4C),
          ),
        ),
        TextButton(
          onPressed: () {
            // TODO: Navigate to full history
          },
          child: const Text(
            'View Full History',
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4BB4D6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentScans() {
    if (widget.recentDiagnoses.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 16),
          SvgPicture.asset(
            'assets/illustrations/undraw_no_data_ig65.svg',
            height: 200,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Scans Yet!',
            style: TextStyle(fontSize: 16, color: Color(0xFF4C4C4C)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Start by tapping ‘Scan Now’',
            style: TextStyle(fontSize: 12, color: Color(0xFF707070)),
          ),
        ],
      );
    }

    return Column(
      children: widget.recentDiagnoses.map((scan) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFECECEC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/recent_scan_placeholder.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scan['plantName'] ?? 'Unknown Plant',
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF707070),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${scan['diagnosis'] ?? 'Healthy'} • ${scan['date']} • ${scan['time']}',
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 12,
                        color: Color(0xFF4C4C4C),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF838383),
                size: 20,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFECECEC),
      selectedItemColor: const Color(0xFF68B789),
      unselectedItemColor: const Color(0xFF4C4C4C),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: 0,
      onTap: (index) {
        // TODO: Add navigation logic
      },
    );
  }
}
