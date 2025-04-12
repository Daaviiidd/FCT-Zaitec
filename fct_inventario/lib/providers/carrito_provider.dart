import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarritoProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _productosEnCarrito = [];

  List<Map<String, dynamic>> get productos => _productosEnCarrito;

  void agregarProducto(QueryDocumentSnapshot producto) {
    final index = _productosEnCarrito.indexWhere((p) => p['id'] == producto.id);
    if (index >= 0) {
      _productosEnCarrito[index]['cantidad'] += 1;
    } else {
      _productosEnCarrito.add({
        'id': producto.id,
        'nombre': producto['nombre'],
        'precio': producto['precio'],
        'cantidad': 1,
      });
    }
    notifyListeners();
  }

  void eliminarProducto(String id) {
    _productosEnCarrito.removeWhere((producto) => producto['id'] == id);
    notifyListeners();
  }

  void cambiarCantidad(String id, int nuevaCantidad) {
    final index = _productosEnCarrito.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      _productosEnCarrito[index]['cantidad'] = nuevaCantidad;
      if (nuevaCantidad <= 0) eliminarProducto(id);
      notifyListeners();
    }
  }
}
