import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/carrito_provider.dart';

class CestaPage extends StatelessWidget {
  const CestaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cesta de Compras')),
      body: carrito.productos.isEmpty
          ? const Center(child: Text('Tu cesta está vacía'))
          : ListView.builder(
              itemCount: carrito.productos.length,
              itemBuilder: (context, index) {
                final producto = carrito.productos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(producto['nombre']),
                    subtitle: Text('Precio: ${producto['precio']} €'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            carrito.cambiarCantidad(producto['id'], producto['cantidad'] - 1);
                          },
                        ),
                        Text('${producto['cantidad']}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            carrito.cambiarCantidad(producto['id'], producto['cantidad'] + 1);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            carrito.eliminarProducto(producto['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
