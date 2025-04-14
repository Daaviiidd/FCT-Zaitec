import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final String nombre;
  final String imagenUrl;
  final double precio;
  final String descripcion;

  const ProductDetailPage({
    super.key,
    required this.nombre,
    required this.imagenUrl,
    required this.precio,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nombre)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imagenUrl.isNotEmpty
                    ? Image.network(
                        imagenUrl,
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      )
                    : Container(
                        height: 200,
                        width: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 100),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Center(  // Centrar el texto del nombre
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  nombre,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,  // Centrado del texto
                ),
              ),
            ),
            Center(  // Centrar el precio
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${precio.toStringAsFixed(2)} €',
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                  textAlign: TextAlign.center,  // Centrado del texto
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(descripcion, textAlign: TextAlign.center),
            ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Producto añadido al carrito.')),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Añadir al carrito'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
