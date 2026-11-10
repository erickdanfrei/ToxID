import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'catalog/catalog_screen.dart';
import 'hospitals/hospitals_screen.dart';
import '../theme/app_theme.dart';

/// Barra de navegação principal persistente do ToxID.
/// Possui as 3 abas fundamentais validadas na Unidade I:
/// 1. Emergência
/// 2. Catálogo
/// 3. Hospitais
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _selectedIndex;
  final _emergencyNavigator = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (index == 0 && _selectedIndex == 0) _emergencyNavigator.currentState?.popUntil((r) => r.isFirst);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      NavigatorPopHandler(
        enabled: _selectedIndex == 0,
        onPop: () => _emergencyNavigator.currentState?.maybePop(),
        child: Navigator(key: _emergencyNavigator, onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => HomeScreen(onNavigateToTab: _onItemTapped))),
      ),
      const CatalogScreen(),
      const HospitalsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.borderColor, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: AppTheme.darkBackground,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: AppTheme.textMuted,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.error_outline),
              activeIcon: Icon(Icons.error),
              label: 'Emergência',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Catálogo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital_outlined),
              activeIcon: Icon(Icons.local_hospital),
              label: 'Hospitais',
            ),
          ],
        ),
      ),
    );
  }
}
