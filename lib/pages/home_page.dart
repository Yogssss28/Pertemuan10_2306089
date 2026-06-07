import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

// Halaman utama — nama class diubah menjadi DashboardPage
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _username = '';
  String _formattedLoginTime = '';

  // Warna utama hijau toska
  static const _primary = Color(0xFF00897B);
  static const _bgColor = Color(0xFFF1F8F6);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Ambil data user dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final rawTime = prefs.getString('loginTime') ?? '';

    String loginStr = '';
    if (rawTime.isNotEmpty) {
      final dt = DateTime.tryParse(rawTime);
      if (dt != null) {
        // Format waktu login: dd/MM/yyyy HH:mm
        loginStr =
            '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}  '
            '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
    }

    setState(() {
      _username = prefs.getString('username') ?? 'Pengguna';
      _formattedLoginTime = loginStr;
    });
  }

  // Logout — hapus semua data sesi
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Yakin ingin keluar?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInPage()),
    );
  }

  // Sapaan dinamis berdasarkan jam (fitur tambahan)
  String get _sapaan {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Selamat Pagi';
    if (hour >= 12 && hour < 15) return 'Selamat Siang';
    if (hour >= 15 && hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  // Data menu fitur di dashboard (fitur tambahan)
  final List<_MenuItem> _menuItems = const [
    _MenuItem(icon: Icons.edit_note_rounded, label: 'Catatan Belajar', color: Color(0xFF26A69A)),
    _MenuItem(icon: Icons.timer_rounded, label: 'Timer Belajar', color: Color(0xFF42A5F5)),
    _MenuItem(icon: Icons.checklist_rounded, label: 'To-Do List', color: Color(0xFFFF7043)),
    _MenuItem(icon: Icons.bar_chart_rounded, label: 'Progres', color: Color(0xFFAB47BC)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Card profil pengguna ===
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Foto avatar diganti URL berbeda dari teman
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: const NetworkImage(
                        'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?w=200',
                      ),
                      backgroundColor: _primary.withOpacity(0.1),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Sapaan berubah sesuai waktu (fitur tambahan)
                          Text(
                            '$_sapaan,',
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  _username,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263238),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(Icons.verified, color: _primary, size: 18),
                            ],
                          ),
                          // Tampilkan waktu login (fitur tambahan)
                          if (_formattedLoginTime.isNotEmpty)
                            Text(
                              'Login: $_formattedLoginTime',
                              style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                            ),
                        ],
                      ),
                    ),
                    // Tombol logout dengan konfirmasi dialog (fitur tambahan)
                    InkWell(
                      onTap: _logout,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.logout_rounded, size: 24, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // === Banner selamat datang ===
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ayo Mulai Belajar!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pantau progres dan catatanmu di sini.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.school_rounded, color: Colors.white, size: 40),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // === Grid menu fitur (fitur tambahan) ===
              const Text(
                'Fitur',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263238),
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: _menuItems.map((item) => _buildMenuCard(item)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget kartu menu fitur
  Widget _buildMenuCard(_MenuItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF37474F),
            ),
          ),
        ],
      ),
    );
  }
}

// Model data untuk item menu
class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  const _MenuItem({required this.icon, required this.label, required this.color});
}
