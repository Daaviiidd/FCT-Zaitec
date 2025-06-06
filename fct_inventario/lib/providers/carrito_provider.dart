import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarritoProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _productosEnCarrito = [];

  List<Map<String, dynamic>> get productos => _productosEnCarrito;

  void agregarProducto(QueryDocumentSnapshot producto) {
    // Verifica si el producto ya está en el carrito
    final index = _productosEnCarrito.indexWhere((p) => p['id'] == producto.id);

    if (index >= 0) {
      // Si el producto ya está en el carrito, solo incrementa la cantidad
      _productosEnCarrito[index]['cantidad'] +1;
    } else {
      // Si no está en el carrito, lo agrega con cantidad 1
      _productosEnCarrito.add({
        'id': producto.id,
        'nombre': producto['nombre'],
        'precio': producto['precio'],
        'cantidad': 1,  
        'imagen': producto['imagen'],
      });
    }

    notifyListeners();  // Notifica a los listeners para actualizar la interfaz
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
