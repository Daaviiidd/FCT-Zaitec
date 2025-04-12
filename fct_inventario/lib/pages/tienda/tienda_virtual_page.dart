import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../tienda/widgets/product_card.dart';
import '../../services/product_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login/login_page.dart';

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
    obtenerNombreUsuario();
  }

  Future<void> obtenerNombreUsuario() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      setState(() {
        nombreUsuario = doc.exists ? doc['name'] : "Usuario";
      });
    }
  }

  Future<void> _cerrarSesion(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Has cerrado sesión')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.storefront, color: Colors.white),
            const SizedBox(width: 10),
            Text('Tienda'),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _cerrarSesion(context),
          ),
        ],
      ),
      body: Column(
        children: [ // 👇 Bienvenida al usuario
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '¡Bienvenido, ${nombreUsuario ?? "cargando..."}!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar producto...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
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
                  return nombre.contains(_searchQuery);
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
      ),
    );
  }
}
