import 'package:flutter/material.dart';
import '../tienda/widgets/tienda_body.dart';
import '../tienda/models/bienvenida_model.dart';
import '../tienda/models/logout_model.dart';

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
          IconButton(
            icon: const Icon(Icons.exit_to_app),
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
