import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/models/user_model.dart';

class AuthService with ChangeNotifier {
  final prefsKey = 'user_model';
  final db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> getUserFromFirestore(String cpf, String password) async {
    late String result;
    await db
        .collection("users")
        .where("cpf", isEqualTo: cpf)
        .get()
        .then(
          (querySnapshot) {
            if (querySnapshot.docs.isEmpty) {
              result = "error";
            }
            for (var docSnapshot in querySnapshot.docs) {
              tryLogin(docSnapshot.data()['email'], password);
              result = "success";
            }
          },
          onError: (e) {
            result = "error";
          },
        );
    return result;
  }

  Future<String> tryLogin(String emailAddress, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      return ('sucesso');
    } on FirebaseAuthException catch (e) {
      return getFBexception(e);
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> tryRegister(UserModel userModel) async {
    late String result;
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(
            email: userModel.email!,
            password: userModel.password!,
          );
      userModel.uid = credential.user!.uid;
      await credential.user?.updateDisplayName(userModel.displayName);

      await userModel.saveData();

      result = "success";
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      result = "error";
    } catch (e) {
      debugPrint(e.toString());
      result = "error";
    }

    return result;
  }

  String getFBexception(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Sua senha é muito fraca.';
      case 'invalid-email':
        return 'Seu e-mail é inválido.';
      case 'email-already-in-use':
        return 'E-mail já está sendo utilizado em outra conta.';
      case 'invalid-credential':
        return 'Seu e-mail é inválido.';
      case 'wrong-password':
        return 'Sua senha está incorreta.';
      case 'user-not-found':
        return 'Não há usuário com este e-mail.';
      case 'user-disabled':
        return 'Este usuário foi desabilitado.';
      case 'too-many-requests':
        return 'Muitas solicitações. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      default:
        return 'Um erro indefinido ocorreu.';
    }
  }
}
