import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './address_model.dart';

class UserModel {
  String? uid;
  String? displayName;
  String? email;
  String? cpf;
  String? password;
  String? passwordConfirm;
  AddressModel? address;
  bool? admin = false;

  UserModel({
    this.uid,
    this.displayName,
    this.email,
    this.cpf,
    this.password,
    this.passwordConfirm,
    this.address,
    this.admin,
  });

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$uid');

  UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    debugPrint('data: $data');
    uid = snapshot.id;
    displayName = data?['displayName'];
    email = data?['email'];
    cpf = data?['cpf'] ?? '';
    if (data.toString().contains('address')) {
      address = AddressModel.fromMap(data?['address'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'cpf': cpf ?? '',
    };
  }

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  UserModel.fromDocument(DocumentSnapshot document) {
    uid = document.id;
    displayName = document['displayName'];
    email = document['email'];
    cpf = document['cpf'] ?? '';
    if (document.data().toString().contains('address')) {
      address = AddressModel.fromMap(document['address'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      if (address != null) 'address': address!.toMap(),
      if(cpf != null) 'cpf': cpf, 
    };
  }

  Future<void> setAddressModel(AddressModel address) async {
    this.address = address;
    saveData();
  }

  void setCpf(String cpf) {
    this.cpf = cpf;
    saveData();
  }
}
