import 'package:bempromotora_app/bloc/cliente/clientes_bloc.dart';
import 'package:bempromotora_app/bloc/cliente/clientes_events.dart';
import 'package:bempromotora_app/bloc/cliente/clientes_state.dart';
import 'package:bempromotora_app/bloc/contexto/contexto_bloc.dart';
import 'package:bempromotora_app/bloc/contexto/contexto_state.dart';
import 'package:bempromotora_app/screen/novo_cliente_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientesScreen extends StatefulWidget {

  static const String ROUTE_NAME = "/clientes";

  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {

  final _clientesBloc = ClientesBloc();

  Widget buildView(BuildContext context, ClientesState state) {
    if (state is ClientesStateLoading) {
      return Center(child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } else if (state is ClientesStateLoaded) {
      return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
          itemBuilder: (context, position) {
            var cliente = _clientesBloc.currentState.clientes[position];
            return ListTile(
                  title: Text(cliente.nome),
                  subtitle: Row(
                    children: <Widget>[
                      Chip(
                        label: Text('CPF: ${cliente.pessoaFisica.cpf}'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Chip(
                        label: Text('${cliente.getIdade().round()} anos'),
                      ),
                    ],
                  ),
                  trailing: ClipOval(
                    child: Material(
                      color: Colors.blue, // button color
                      child: InkWell(
                        splashColor: Theme.of(context).primaryColorLight, // inkwell color
                        child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              Icons.attach_money,
                              color: Colors.white,
                            ),
                        ),
                      ),
                    ),
                  )
            );
          },
          itemCount: _clientesBloc.currentState.clientes.length);
    } else {
      print('Iniciando loading');
      _clientesBloc.dispatch(LoadAllClientes());
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {

    var contextBloc = BlocProvider.of<ContextoBloc>(context);

    return Scaffold(
      body: Container(
          child: BlocListener(
        bloc: _clientesBloc,
        listener: (ctx, state) {
          // Inserir aqui acoes a serem tomadas quando um novo estado for identificado
        },
        child: BlocBuilder(
          bloc: _clientesBloc,
          builder: (context, state) {
            return buildView(context, state);
          },
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(NovoClienteScreen.ROUTE_NAME),
      ),
    );
  }
}
