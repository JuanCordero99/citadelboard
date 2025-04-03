import 'package:flutter/material.dart';

//Navegación de la aplicación
import 'view/DashboardScreen.dart' as Dashboard;
import 'view/DetailsScreen.dart' as Details;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Citadel Board',
      initialRoute: 'DashboardScreen',
      routes: {
        'DashboardScreen': (context) => Dashboard.Dashboard(),
        'DetailsScreen': (context) {
          final idCharachter = ModalRoute.of(context)?.settings.arguments as int;
          return Details.Details(idCharacter: idCharachter);
        },
      },
    );
  }
}


