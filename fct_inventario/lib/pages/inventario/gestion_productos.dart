import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../tienda/tienda_virtual_page.dart';
import '../login/login_page.dart';

class PaginaGestionProductos extends StatefulWidget {
  const PaginaGestionProductos({super.key});

  @override
  _PaginaGestionProductosState createState() => _PaginaGestionProductosState();
}

class _PaginaGestionProductosState extends State<PaginaGestionProductos> {
  final CollectionReference _productos = FirebaseFirestore.instance.collection('productos');
  final TextEditingController _imagenUrlController = TextEditingController();
  File? _imagenSeleccionada;
  String _searchQuery = ''; // Controlador de búsqueda

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

  void _navegarAGaleria() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductGallery()),
    );
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

  Stream<QuerySnapshot> obtenerProductos() {
    return _productos.snapshots();
  }

  Future<void> agregarProducto(
    String nombre,
    String descripcion,
    String categoria,
    int cantidadStock,
    double precio,
    String? imagenUrl,
  ) async {
    await _productos.add({
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'cantidadStock': cantidadStock,
      'precio': precio,
      'imagen': imagenUrl ?? "",
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> editarProducto(
    String id,
    String nombre,
    String descripcion,
    String categoria,
    int cantidadStock,
    double precio,
    String? imagenUrl,
  ) async {
    await _productos.doc(id).update({
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'cantidadStock': cantidadStock,
      'precio': precio,
      'imagen': imagenUrl ?? '',
    });
  }

  Future<void> eliminarProducto(String id) async {
    await _productos.doc(id).delete();
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagenSeleccionada = File(pickedFile.path);
      });
    }
  }

  void mostrarDialogoProducto({
    String id = '',
    String nombre = '',
    String descripcion = '',
    String categoria = '',
    int cantidadStock = 0,
    double precio = 0.0,
    String imagenUrl = '',
  }) {
    final _nombreController = TextEditingController(text: nombre);
    final _descripcionController = TextEditingController(text: descripcion);
    final _categoriaController = TextEditingController(text: categoria);
    final _cantidadController = TextEditingController(text: cantidadStock.toString());
    final _precioController = TextEditingController(text: precio.toString());
    _imagenSeleccionada = null;
    _imagenUrlController.text = imagenUrl;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(id.isEmpty ? 'Agregar Producto' : 'Editar Producto'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTextField('Nombre', _nombreController),
              _buildTextField('Descripción', _descripcionController),
              _buildTextField('Categoría', _categoriaController),
              _buildTextField('Cantidad en Stock', _cantidadController, isNumber: true),
              _buildTextField('Precio', _precioController, isNumber: true),
              const SizedBox(height: 16),
              _imagenSeleccionada != null
                  ? Image.file(_imagenSeleccionada!, height: 100)
                  : imagenUrl.isNotEmpty
                      ? Image.network(imagenUrl, height: 100)
                      : Container(),
              TextField(
                controller: _imagenUrlController,
                decoration: InputDecoration(
                  labelText: 'URL de la Imagen (opcional)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _seleccionarImagen,
                icon: Icon(Icons.image),
                label: Text('Seleccionar Imagen'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nombre = _nombreController.text;
              final descripcion = _descripcionController.text;
              final categoria = _categoriaController.text;
              final cantidadStock = int.tryParse(_cantidadController.text) ?? 0;
              final precio = double.tryParse(_precioController.text) ?? 0.0;
              String? imagenUrl = _imagenUrlController.text.isNotEmpty
                  ? _imagenUrlController.text
                  : null;

              if (id.isEmpty) {
                await agregarProducto(nombre, descripcion, categoria, cantidadStock, precio, imagenUrl);
              } else {
                await editarProducto(id, nombre, descripcion, categoria, cantidadStock, precio, imagenUrl);
              }

              Navigator.pop(context);
            },
            child: Text(id.isEmpty ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  // Método para filtrar los productos por nombre y categoría
  List<DocumentSnapshot> _filtrarProductos(List<DocumentSnapshot> productos) {
    return productos.where((producto) {
      final nombre = producto['nombre'].toString().toLowerCase();
      final categoria = producto['categoria'].toString().toLowerCase();
      return nombre.contains(_searchQuery.toLowerCase()) ||
             categoria.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.inventory, color: Colors.white),
            SizedBox(width: 10),
            Text('Inventario'),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.storefront),
            onPressed: _navegarAGaleria,
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _cerrarSesion(context),
          ),
        ],
      ),
      body: Column(
        children: [
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
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: ElevatedButton(
              onPressed: () => mostrarDialogoProducto(),
              child: Text('Agregar Producto'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                labelText: 'Buscar Producto por Nombre o Categoría',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: obtenerProductos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No hay productos disponibles'));
                }

                final productos = _filtrarProductos(snapshot.data!.docs);

                return ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final producto = productos[index];
                    final id = producto.id;
                    final nombre = producto['nombre'];
                    final descripcion = producto['descripcion'];
                    final categoria = producto['categoria'];
                    final cantidadStock = producto['cantidadStock'];
                    final precio = producto['precio'];
                    final imagenUrl = producto['imagen'];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: imagenUrl.isNotEmpty
                            ? Image.network(imagenUrl, width: 50, height: 50, fit: BoxFit.cover)
                            : Icon(Icons.image),
                        title: Text(nombre),
                        subtitle: Text('Categoría: $categoria\nStock: $cantidadStock\nPrecio: ${precio.toStringAsFixed(2)} €'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                mostrarDialogoProducto(
                                  id: id,
                                  nombre: nombre,
                                  descripcion: descripcion,
                                  categoria: categoria,
                                  cantidadStock: cantidadStock,
                                  precio: precio,
                                  imagenUrl: imagenUrl,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await eliminarProducto(id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
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
