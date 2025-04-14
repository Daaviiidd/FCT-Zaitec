import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final String categoria;
  final int cantidadStock;
  final double precio;
  final String imagenUrl;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.cantidadStock,
    required this.precio,
    required this.imagenUrl,
  });

  // Método para convertir un documento Firestore en un objeto Producto
  factory Producto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Producto(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      categoria: data['categoria'] ?? '',
      cantidadStock: data['cantidadStock'] ?? 0,
      precio: data['precio'] ?? 0.0,
      imagenUrl: data['imagen'] ?? '',
    );
  }

  // Método para convertir un objeto Producto en un Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'cantidadStock': cantidadStock,
      'precio': precio,
      'imagen': imagenUrl,
    };
  }
}
