import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../../providers/carrito_provider.dart';

class ProductCard extends StatelessWidget {
  final QueryDocumentSnapshot producto;

  const ProductCard({Key? key, required this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);
    final imagenUrl = producto['imagen'];  // Se utiliza el campo 'imagen' de Firestore

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: imagenUrl != null
            ? Image.network(
                imagenUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.image, size: 60),  // Si no hay imagen, muestra un ícono predeterminado
        title: Text(producto['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Precio: ${producto['precio']} €'),
        trailing: ElevatedButton.icon(
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Añadir'),
          onPressed: () {
            carrito.agregarProducto(producto);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Producto añadido al carrito')),
            );
          },
        ),
      ),
    );
  }
}
