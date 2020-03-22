
import 'package:bempromotora_app/screen/clientes_screen.dart';
import 'package:bempromotora_app/screen/propostas_screen.dart';

class ScreenIndex {

  final ClientesScreen clientesScreen;
  final PropostasScreen propostasScreen;


  ScreenIndex({
    this.clientesScreen,
    this.propostasScreen,
  });

  ScreenIndex.defaultPages(
      {this.clientesScreen, this.propostasScreen});
}