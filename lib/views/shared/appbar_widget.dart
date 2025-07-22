import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../views/shared/theme_provider.dart';
import '../home/home_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final User? user;
  final bool isHome;

  const CustomAppBar({
    super.key,
    this.scaffoldKey,
    required this.user,
    this.isHome = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botão de menu (Drawer)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => scaffoldKey?.currentState?.openDrawer(),
            ),
            // Logo SVG centralizada
            Expanded(
              child: Center(
                child: !isHome
                    ? GestureDetector(
                        onTap: () => Navigator.pop(
                          context,
                          MaterialPageRoute(builder: (context) => HomeView()),
                        ),
                        child: SvgPicture.asset(
                          !isDarkMode
                              ? 'assets/imgs/logo.svg'
                              : 'assets/imgs/logo-white.svg',
                          height: 32,
                        ),
                      )
                    : SvgPicture.asset(
                        !isDarkMode
                            ? 'assets/imgs/logo.svg'
                            : 'assets/imgs/logo-white.svg',
                        height: 32,
                      ),
              ),
            ),

            // Sino com badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Notificações")),
                    );
                  },
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                themeProvider.toggleTheme(isDarkMode);
              },
            ),
            // Fechar WebView somente em plataforma WEB
            if (!isHome)
              ElevatedButton.icon(
                label: Text('WebView'),
                icon: Icon(Icons.close_outlined),
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => HomeView()),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
