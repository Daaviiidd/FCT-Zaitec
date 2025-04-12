import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/product_service.dart';
import 'product_card.dart';

class ProductGalleryBody extends StatelessWidget {
  final String? nombreUsuario;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const ProductGalleryBody({
    Key? key,
    required this.nombreUsuario,
    required this.searchQuery,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bienvenida
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '¡Bienvenido, ${nombreUsuario ?? "cargando..."}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // Buscador
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Buscar producto...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => onSearchChanged(value.toLowerCase()),
          ),
        ),

        // Lista de productos
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: ProductService.obtenerProductos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No hay productos disponibles'));
              }

              final productos = snapshot.data!.docs.where((doc) {
                final nombre = doc['nombre'].toString().toLowerCase();
                return nombre.contains(searchQuery);
              }).toList();

              if (productos.isEmpty) {
                return const Center(child: Text('No se encontraron productos.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return ProductCard(producto: producto);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
