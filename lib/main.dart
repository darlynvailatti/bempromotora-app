import 'package:bempromotora_app/bloc/contexto/contexto_bloc.dart';
import 'package:bempromotora_app/screen/clientes_screen.dart';
import 'package:bempromotora_app/screen/login_screen.dart';
import 'package:bempromotora_app/screen/nova_proposta_screen.dart';
import 'package:bempromotora_app/screen/novo_cliente_screen.dart';
import 'package:bempromotora_app/screen/propostas_screen.dart';
import 'package:bempromotora_app/widget/tab_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final _contextoBloc = ContextoBloc();

  @override
  Widget build(BuildContext context) {

    return
      BlocProvider<ContextoBloc>(
        bloc: _contextoBloc,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.blue,
            accentColor: Colors.white
          ),
          initialRoute: LoginScreen.ROUTE_NAME,
          routes: {
            LoginScreen.ROUTE_NAME: (ctx) => LoginScreen(),
            HomeScreen.ROUTE_NAME: (ctx) => HomeScreen(),
            NovaPropostaScreen.ROUTE_NAME: (ctx) => NovaPropostaScreen(),
            ClientesScreen.ROUTE_NAME : (ctx) => ClientesScreen(),
            PropostasScreen.ROUTE_NAME : (ctx) => PropostasScreen(),
            NovoClienteScreen.ROUTE_NAME: (ctx) => NovoClienteScreen(),
          },
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => Text('Generated route'));
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => Text('Unknown route'));
          },
        ),
      );
  }
}


