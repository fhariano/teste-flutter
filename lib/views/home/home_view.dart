import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../shared/appbar_widget.dart';
import '../shared/drawer_widget.dart';

class HomeView extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(user: user),
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey, user: user, isHome: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(223, 199, 98, 0.5),
                    Color.fromRGBO(20, 129, 99, 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text(user?.displayName ?? 'Usuário'),
              ),
            ),
            Center(
              child: const Text(
                'Cotar e Contratar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    _MiniCard(
                      icon: Icons.directions_car,
                      label: "Automóvel",
                      tipo: "automovel",
                    ),
                    _MiniCard(
                      icon: Icons.home,
                      label: "Residência",
                      tipo: "residencia",
                    ),
                    _MiniCard(
                      icon: Icons.favorite,
                      label: "Vida",
                      tipo: "vida",
                    ),
                    _MiniCard(
                      icon: Icons.health_and_safety,
                      label: "Acid. Pessoais",
                      tipo: "acidentes",
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            // Seção Minha Família
            Center(
              child: Column(
                children: [
                  const Text(
                    "Minha Família",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Adicionar membro")),
                      );
                    },
                    icon: const Icon(
                      Icons.group_add,
                      size: 36,
                      color: Colors.blue,
                    ),
                    tooltip: "Adicionar Membro",
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Adicione aqui membros de sua família e compartilhe os seguros com eles.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Divider(),
                  // Seção Contratoados
                  const Text(
                    "Contratados",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Adicionar um contrato")),
                      );
                    },
                    icon: const Icon(
                      Icons.sentiment_dissatisfied_outlined,
                      size: 36,
                      color: Colors.blue,
                    ),
                    tooltip: "Adicionar Contrato",
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Você ainda não possui seguros contratados.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tipo;

  const _MiniCard({
    required this.icon,
    required this.label,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    bool isWeb = Theme.of(context).platform == TargetPlatform.windows;
    return SizedBox(
      width: 90,
      height: 110,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (label == "Automóvel") {
            if (isWeb) {
              Navigator.pushNamed(context, '/webview-web');
            } else {
              Navigator.pushNamed(context, '/webview');
            }
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Clicou em $label")));
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: Colors.blue),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
