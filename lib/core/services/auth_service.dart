import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/models/user_model.dart';

class AuthService with ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  UserModel? user;
  late int count;

  Future getUserFromFirestore(String cpf) async {
    final data = await db
        .collection("users")
        .where("cpf", isEqualTo: cpf)
        .withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel userModel, _) => userModel.toFirestore(),
        )
        .get();

    count = data.docs.length;
    if (count > 0) {
      user = data.docs.first.data();
    }
  }

  Future<Map<String, String>> tryLoginwithCpfFromFirestore(
    String cpf,
    String password,
  ) async {
    await getUserFromFirestore(cpf);

    if (user?.email != null) {
      return tryLogin(user!.email.toString(), password);
    } else {
      return {"msg": "error"};
    }
  }

  Future<Map<String, String>> tryLogin(
    String emailAddress,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      return {"msg": "success"};
    } on FirebaseAuthException catch (e) {
      debugPrint('firebaseError: ${getFbException(e)}');
      return {"msg": "error"};
    } catch (e) {
      return {"msg": e.toString()};
    }
  }

  Future<Map<String, String>> tryRegister(UserModel userModel) async {
    late Map<String, String> result;

    try {
      await getUserFromFirestore(userModel.cpf.toString());
      if (count == 0) {
        await _auth
            .createUserWithEmailAndPassword(
              email: userModel.email!,
              password: userModel.password!,
            )
            .then((UserCredential credential) async {
              userModel.uid = credential.user!.uid;
              await credential.user?.updateDisplayName(userModel.displayName);
              await userModel.saveData();
              result = {"msg": "success"};
            });
      } else {
        return result = {"msg": "exists"};
      }
    } on FirebaseAuthException catch (e) {
      return {"msg": getFbException(e)};
    } catch (e) {
      result = {"msg": "error"};
    }

    return result;
  }

  Future<Map<String, String>> trySendResetPassword(String cpf) async {
    late Map<String, String> result;

    await getUserFromFirestore(cpf);

    if (count > 0) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: user!.email.toString(),
        );
        result = {"msg": "success"};
      } on FirebaseAuthException catch (e) {
        return {"msg": "error ${getFbException(e)}"};
      } catch (e) {
        result = {"msg": "error"};
      }
    } else {
      result = {"msg": "notExist"};
    }
    return result;
  }

  String getFbException(FirebaseAuthException e) {
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
