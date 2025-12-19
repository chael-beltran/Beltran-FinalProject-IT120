import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';
import 'pages/scan_page.dart';
import 'pages/history_page.dart';
import 'pages/class_details_page.dart';
import 'services/history_service.dart';
import 'data/snack_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize History Service (load persisted data)
  await HistoryService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snack-Pack Chips Varieties',
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/class-details') {
          final snack = settings.arguments as SnackClass?;
          if (snack != null) {
            return MaterialPageRoute(
              builder: (context) => ClassDetailsPage(snack: snack),
            );
          }
        }
        return null;
      },
    );
  }
}

/// Main navigation screen with bottom navigation bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    _ScanPlaceholder(), // Placeholder - actual scan page opens as new screen
    HistoryPage(),
  ];

  void _onNavTap(int index) {
    if (index == 1) {
      // Navigate to scan page as a new screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScanPage()),
      );
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex == 1 ? 0 : _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

/// Placeholder for scan tab in IndexedStack
class _ScanPlaceholder extends StatelessWidget {
  const _ScanPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// Custom bottom navigation bar matching Figma design
class _CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Main navbar background
        Container(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 6),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Home
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  isActive: currentIndex == 0,
                  activeColor: AppColors.primary,
                  onTap: () => onTap(0),
                ),

                // Spacer for scan button
                const SizedBox(width: 80),

                // History
                _NavItem(
                  icon: Icons.access_time_outlined,
                  activeIcon: Icons.access_time_outlined,
                  label: 'History',
                  isActive: currentIndex == 2,
                  activeColor: AppColors.primary,
                  onTap: () => onTap(2),
                ),
              ],
            ),
          ),
        ),

        // Floating Scan button
        Positioned(
          top: -28,
          child: _ScanButton(
            onTap: () => onTap(1),
          ),
        ),
      ],
    );
  }
}

/// Regular navigation item
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive ? activeColor : AppColors.textLight,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? activeColor : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

/// Center scan button with circular teal design and white border
class _ScanButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ScanButton({
    required this.onTap,
  });

  // Teal/Cyan color matching the reference
  static const Color _scanButtonColor = Color(0xFF5FBDBA);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Outer white ring
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _scanButtonColor.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              // Inner teal circle
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: _scanButtonColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Scan',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _scanButtonColor,
            ),
          ),
        ],
      ),
    );
  }
}
