import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  final controller = TextEditingController();

  ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Senha')),
      body: Column(
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: 'E-mail cadastrado'),
          ),
          ElevatedButton(
            child: Text('Enviar Link'),
            onPressed: () async {
              await FirebaseAuth.instance.sendPasswordResetEmail(
                email: controller.text,
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Email enviado!')));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
