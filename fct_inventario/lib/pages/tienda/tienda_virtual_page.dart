import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tienda/widgets/tienda_body.dart';
import '../tienda/models/bienvenida_model.dart';
import '../tienda/models/logout_model.dart';
import '../tienda/cesta/cesta_page.dart';
import '../../providers/carrito_provider.dart';

class ProductGallery extends StatefulWidget {
  const ProductGallery({Key? key}) : super(key: key);

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  String _searchQuery = '';
  String? nombreUsuario;

  @override
  void initState() {
    super.initState();
    cargarNombreUsuario();
  }

  Future<void> cargarNombreUsuario() async {
    final nombre = await BienvenidaModel.obtenerNombreUsuario();
    setState(() {
      nombreUsuario = nombre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.storefront, color: Colors.white),
            SizedBox(width: 10),
            Text('Tienda'),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          // BOTÓN CESTA DE COMPRAS
          Consumer<CarritoProvider>(
            builder: (context, carrito, child) {
              return IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (carrito.productos.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${carrito.productos.length}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                tooltip: 'Cesta de compras',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CestaPage()),
                  );
                },
              );
            },
          ),

          // BOTÓN CERRAR SESIÓN
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Cerrar sesión',
            onPressed: () => LogoutModel.cerrarSesion(context),
          ),
        ],
      ),
      body: ProductGalleryBody(
        nombreUsuario: nombreUsuario,
        searchQuery: _searchQuery,
        onSearchChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }
}