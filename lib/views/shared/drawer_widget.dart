import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/views/home/home_view.dart';

class CustomDrawer extends StatelessWidget {
  final User? user;
  const CustomDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: UserAccountsDrawerHeader(
              margin: EdgeInsets.only(bottom: 4),
              currentAccountPictureSize: Size(50, 50),
              accountName: Text(user?.displayName ?? 'Nome do usuário'),
              accountEmail: Text(user?.email ?? 'user@example.com'),
              currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
            ),
          ),
          ...[
            'Home / Seguros',
            'Minhas Contratações',
            'Meus Sinistros',
            'Minha Família',
            'Meus Bens',
            'Pagamentos',
            'Coberturas',
            'Validar Boleto',
            'Telefones Importantes',
            'Configurações',
            'SAIR',
          ].map(
            (String item) => ListTile(
              visualDensity: VisualDensity(horizontal: 0, vertical: -0.5),
              leading: item == 'SAIR'
                  ? Icon(Icons.exit_to_app_outlined)
                  : Icon(Icons.settings),
              title: Text(
                item,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0),
              ),
              onTap: () {
                if (item == 'SAIR') {
                  logout(context);
                } else if (item.split(' ').contains('Home')) {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => HomeView()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Future.delayed(const Duration(seconds: 3), () {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
    });
  } on Exception catch (e) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Ocorreu um erro',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () {
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
