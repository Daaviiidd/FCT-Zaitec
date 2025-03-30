import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Importa el paquete de FCM
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PaginaGestionProductos extends StatefulWidget {
  const PaginaGestionProductos({super.key});

  @override
  _PaginaGestionProductosState createState() => _PaginaGestionProductosState();
}

class _PaginaGestionProductosState extends State<PaginaGestionProductos> {
  final CollectionReference _productos =
      FirebaseFirestore.instance.collection('productos');
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Instancia de FCM

  final TextEditingController _busquedaNombreController = TextEditingController();
  final TextEditingController _busquedaCategoriaController = TextEditingController();
  final TextEditingController _imagenUrlController = TextEditingController(); 

  File? _imagenSeleccionada;

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

    // Verificar si el stock está bajo
    if (cantidadStock <= 5) {
      enviarNotificacionStockBajo(nombre);
    }
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

    // Verificar si el stock está bajo
    if (cantidadStock <= 5) {
      enviarNotificacionStockBajo(nombre);
    }
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

  // Función para enviar la notificación de stock bajo
  Future<void> enviarNotificacionStockBajo(String nombreProducto) async {
    try {
      // Enviar la notificación push utilizando FCM
      await _firebaseMessaging.subscribeToTopic("stock_bajo"); // Se suscribe a un tema para notificaciones de stock bajo
      // Enviar notificación
      // Este código requiere que ya tengas configurada la parte del backend para enviar la notificación real.
      print("Notificación enviada para el producto: $nombreProducto");
    } catch (e) {
      print("Error al enviar la notificación: $e");
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
    _imagenSeleccionada = null; // Reset image
    _imagenUrlController.text = imagenUrl; // Prellenar el campo de URL si ya tiene valor

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
              // Mostrar imagen desde URL si existe
              _imagenSeleccionada != null
                  ? Image.file(_imagenSeleccionada!, height: 100)
                  : imagenUrl.isNotEmpty
                      ? Image.network(imagenUrl, height: 100)
                      : Container(),
              // Campo para ingresar la URL de la imagen
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

              // Usar la URL proporcionada en lugar de subir una imagen
              String? imagenUrl = _imagenUrlController.text.isNotEmpty
                  ? _imagenUrlController.text
                  : null;

              if (id.isEmpty) {
                await agregarProducto(
                    nombre, descripcion, categoria, cantidadStock, precio, imagenUrl);
              } else {
                await editarProducto(
                    id,
                    nombre,
                    descripcion,
                    categoria,
                    cantidadStock,
                    precio,
                    imagenUrl ?? imagenUrl);
              }

              Navigator.pop(context);
            },
            child: Text(id.isEmpty ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false}) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Buscadores
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _busquedaNombreController,
                    decoration: InputDecoration(
                      labelText: 'Por nombre',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _busquedaNombreController.clear();
                          setState(() {});
                        },
                      ),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: _busquedaCategoriaController,
                    decoration: InputDecoration(
                      labelText: 'Por categoría',
                      prefixIcon: Icon(Icons.category),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _busquedaCategoriaController.clear();
                          setState(() {});
                        },
                      ),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          // Botón para agregar producto
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: ElevatedButton(
              onPressed: () => mostrarDialogoProducto(),
              child: Text('Agregar Producto'),
            ),
          ),
          // Lista de productos
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

                final productos = snapshot.data!.docs.where((producto) {
                  final nombre = producto['nombre'].toString().toLowerCase();
                  final categoria = producto['categoria'].toString().toLowerCase();
                  final filtroNombre = _busquedaNombreController.text.toLowerCase();
                  final filtroCategoria = _busquedaCategoriaController.text.toLowerCase();

                  return nombre.contains(filtroNombre) &&
                      categoria.contains(filtroCategoria);
                }).toList();

                if (productos.isEmpty) {
                  return Center(child: Text('No se encontraron productos'));
                }

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
                      margin:
                          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: imagenUrl.isNotEmpty
                            ? Image.network(imagenUrl, width: 50, height: 50, fit: BoxFit.cover)
                            : Icon(Icons.image),
                        title: Text(nombre),
                        subtitle: Text('Categoría: $categoria\nStock: $cantidadStock\nPrecio: \€${precio.toStringAsFixed(2)}'),
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