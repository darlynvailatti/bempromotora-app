

import 'package:bempromotora_app/bloc/proposta/propostas_bloc.dart';
import 'package:bempromotora_app/bloc/proposta/propostas_events.dart';
import 'package:bempromotora_app/bloc/proposta/propostas_state.dart';
import 'package:bempromotora_app/screen/nova_proposta_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';

class PropostasScreen extends StatefulWidget {
  static const String ROUTE_NAME = "/propostas";


  @override
  State<StatefulWidget> createState() {
    return _PropostaScreenState();
  }

}

class _PropostaScreenState extends State<PropostasScreen> {

  final _propostasBloc = PropostasBloc();

  Widget buildView(BuildContext context, PropostasState state){

    if(state is PropostasStateLoading){
      return Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          )
      );
    }else if(state is PropostasStateLoaded) {
      return ListView.builder(
          itemBuilder: (context, position) {
            var proposta = _propostasBloc.currentState.propostas[position];
            return Card(
              child: ListTile(
                title: Text('${proposta.clienteModel.nome}'),
                subtitle: Text(
                    '${proposta.convenio} - ${proposta.matriculaConvenio}'),
                leading: Text('${proposta.idProposta}'),
                trailing: Text('R\$ ${proposta.valor}'),
              ),
            );
          },
          itemCount: _propostasBloc.currentState.propostas.length);
    }else if(state is PropostasStateLoadFail){
      PropostasStateLoadFail failState = state;
      Toast.show(failState.messageError, context);
    }else{
      print('Iniciando loading');
      _propostasBloc.dispatch(PropostasEventLoadAll());
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          child: BlocListener(
            bloc: _propostasBloc,
            listener: (ctx, state){
              // Inserir aqui acoes a serem tomadas quando um novo estado for identificado
            },
            child: BlocBuilder(
              bloc: _propostasBloc,
              builder: (context, state) {
                return buildView(context, state);
              },
            ),
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(NovaPropostaScreen.ROUTE_NAME),
      ),
    );
  }

}