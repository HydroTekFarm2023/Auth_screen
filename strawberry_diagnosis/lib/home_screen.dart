import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart'; // for Diagnosis model
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.status,
    required this.diagnoses,
    required this.selectedImage,
    required this.amplifyConfigured,
    required this.onPickImage,
    required this.onUploadImage,
    required this.onDeleteImage,
    required this.onFetchDiagnoses,
  });

  final String status;
  final List<Diagnosis> diagnoses;
  final XFile? selectedImage;
  final bool amplifyConfigured;

  final VoidCallback onPickImage;
  final VoidCallback onUploadImage;
  final VoidCallback onDeleteImage;
  final VoidCallback onFetchDiagnoses;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  // Color palette from design
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF4C4C4C);
  static const Color black2 = Color(0xFF707070);
  static const Color greenDark = Color(0xFF28824D);
  static const Color green1 = Color(0xFF68B789);
  static const Color green2 = Color(0xFF3CA768);
  static const Color lightGray = Color(0xFFECECEC);
  static const Color darkGrey = Color(0xFF838383);
  static const Color blue2 = Color(0xFF4BB4D6);

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          color: white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                color: lightGray,
                child: const Icon(Icons.eco, color: black, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                "HydroTek Farm",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _buildBody(context),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 64,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightGray,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home,
                label: "Home",
                selected: _selectedTab == 0,
                onTap: () => setState(() => _selectedTab = 0),
              ),
              _NavItem(
                icon: Icons.history,
                label: "History",
                selected: _selectedTab == 1,
                onTap: () => setState(() => _selectedTab = 1),
              ),
              _NavItem(
                icon: Icons.person,
                label: "Profile",
                selected: _selectedTab == 2,
                onTap: () => setState(() => _selectedTab = 2),
              ),
              _NavItem(
                icon: Icons.help_outline,
                label: "Help",
                selected: _selectedTab == 3,
                onTap: () => setState(() => _selectedTab = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_selectedTab == 0) {
      // Home
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(children: [
              const TextSpan(
                text: "Welcome ",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: greenDark,
                ),
              ),
              TextSpan(
                text: "UserName!",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: black2,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          const Text(
            "Get insights about plant health instantly",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: black,
            ),
          ),
          const SizedBox(height: 72),
          _buildHeroCard(),
          if (widget.selectedImage != null) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(widget.selectedImage!.path),
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: widget.onUploadImage,
                  child: const Text("Upload"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: widget.onDeleteImage,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Scans",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: black,
                ),
              ),
              GestureDetector(
                onTap: widget.onFetchDiagnoses,
                child: const Text(
                  "view full history",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: blue2,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.diagnoses.isEmpty)
            _EmptyScans()
          else
            Column(
              children: widget.diagnoses.take(3).map((d) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ScanCard(d),
                );
              }).toList(),
            ),
          const SizedBox(height: 24),
          Text(widget.status,
              style: const TextStyle(fontSize: 12, color: black2)),
        ],
      );
    } else if (_selectedTab == 1) {
      // History
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Scan History",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: black,
            ),
          ),
          const SizedBox(height: 12),
          if (widget.diagnoses.isEmpty)
            _EmptyScans()
          else
            Column(
              children: widget.diagnoses.map((d) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ScanCard(d),
                );
              }).toList(),
            ),
        ],
      );
    } else if (_selectedTab == 2) {
      // Profile
      return _buildProfile(context);
    } else {
      // Help placeholder
      return const Center(child: Text("Help section coming soon"));
    }
  }

  Widget _buildHeroCard() {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage("assets/images/hero_card_picture.jpg"),
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 8,
            color: Colors.black26,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            color: lightGray.withOpacity(0.3),
            child: const Text(
              "Diagnose Your\nPlants!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: darkGrey,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 280,
            height: 48,
            child: ElevatedButton(
              onPressed: widget.amplifyConfigured ? widget.onPickImage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: green2,
                foregroundColor: white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              child: const Text("Scan Now"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.logout),
        label: const Text("Logout"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}

class _EmptyScans extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(
          height: 150,
          width: 150,
          child: Icon(Icons.image_outlined, size: 64, color: Colors.grey),
        ),
        SizedBox(height: 12),
        Text(
          "No Scans Yet!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4C4C4C),
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Start by tapping 'Scan Now'",
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF707070),
          ),
        ),
      ],
    );
  }
}

class _ScanCard extends StatelessWidget {
  const _ScanCard(this.diagnosis);
  final Diagnosis diagnosis;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.only(left: 24, right: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/images/recent_scan_placeholder.jpg",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  diagnosis.disease.isNotEmpty
                      ? diagnosis.disease
                      : "Plant Name",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF707070),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      diagnosis.createdAt ?? "Date",
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      diagnosis.result.isNotEmpty
                          ? diagnosis.result
                          : "Diagnosis?",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF838383),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 24 : 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF68B789) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: const Color(0xFF4C4C4C)),
            if (selected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
