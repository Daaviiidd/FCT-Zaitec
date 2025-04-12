import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BienvenidaModel {
  static Future<String> obtenerNombreUsuario() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc.exists ? doc['name'] : "Usuario";
    }

    return "Usuario";
  }
}
