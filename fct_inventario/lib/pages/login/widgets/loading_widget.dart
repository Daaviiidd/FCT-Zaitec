import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


// WIDGET DE LOADING
class MiWidgetConLoadingPersonalizado extends StatelessWidget {

const MiWidgetConLoadingPersonalizado({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitFadingCube(
          color: Colors.blue,
          size: 50.0,
        ),
      ),
    );
  }
}
