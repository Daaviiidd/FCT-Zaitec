import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController categoriaController;
  final Function(String) onNombreChanged;
  final Function(String) onCategoriaChanged;

  const SearchWidget({
    Key? key,
    required this.nombreController,
    required this.categoriaController,
    required this.onNombreChanged,
    required this.onCategoriaChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Por nombre',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    nombreController.clear();
                    onNombreChanged('');
                  },
                ),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: onNombreChanged,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: TextField(
              controller: categoriaController,
              decoration: InputDecoration(
                labelText: 'Por categoría',
                prefixIcon: Icon(Icons.category),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    categoriaController.clear();
                    onCategoriaChanged('');
                  },
                ),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: onCategoriaChanged,
            ),
          ),
        ],
      ),
    );
  }
}
