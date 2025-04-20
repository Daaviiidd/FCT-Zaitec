//Serviciso de firestore de la tienda virtual
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  static Stream<QuerySnapshot> obtenerProductos() {
    return FirebaseFirestore.instance.collection('productos').snapshots();
  }
}