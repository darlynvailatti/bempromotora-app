

import 'dart:ffi';

import 'package:bempromotora_app/bloc/nova_proposta/nova_proposta_bloc.dart';
import 'package:bempromotora_app/common/constants.dart';
import 'package:bempromotora_app/model/cliente_model.dart';
import 'package:bempromotora_app/model/proposta/nova_proposta_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NovaPropostaScreen extends StatefulWidget {

  static const String ROUTE_NAME = "/novaProposta";

  ClienteModel cliente;

  NovaPropostaScreen({this.cliente});

  @override
  _NovaPropostaScreenState createState() => _NovaPropostaScreenState();

}

class _NovaPropostaScreenState extends State<NovaPropostaScreen> {

  ClienteModel _clienteModel;
  final NovaPropostaBloc _novaPropostaBloc = NovaPropostaBloc();
  double _valorProposta = 0;
  final TextEditingController _observacaoTextEditingController = TextEditingController();

  _confirm(){
    var observacao = _observacaoTextEditingController.text;

    NovaPropostaModel novaPropostaModel = NovaPropostaModel();
    novaPropostaModel.clienteModel = _clienteModel;
    novaPropostaModel.valor = _valorProposta;
    novaPropostaModel.descricao = observacao;
    _novaPropostaBloc.dispatch(NovaPropostaEventCreate(novaPropostaModel));
  }

  Widget _buildForm(){

    NovaPropostaStateInitial initialState = _novaPropostaBloc.currentState;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          Container(
            child: Center(
              child: Chip(
                label: Text(
                  initialState.novaPropostaModel.clienteModel.nome,
                  style: TextStyle(
                      fontSize: 30
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child:  Text(
              'R\$ ${NumberFormat.currency(decimalDigits: 0, locale: "PT-BR").format(_valorProposta)}',
              style: TextStyle(
                  fontSize: 30
              ),
            ),
          ),
          Slider(
            min: 0,
            max: Constants.VALOR_MAXIMO_PROPOSTA,
            value: _valorProposta,
            onChanged: (value) {
              setState(() {
                _valorProposta = value.roundToDouble();
              });
            },
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Observação'),
              controller: _observacaoTextEditingController,
            ),
          ),
          SizedBox(height: 10,)
        ],
      ),
    );

  }
  
  @override
  Widget build(BuildContext context) {

    _clienteModel = ModalRoute.of(context).settings.arguments as ClienteModel;


    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Proposta de Crédito"),
      ),
      body: BlocListener(
        bloc: _novaPropostaBloc,
        listener: (ctx, state) {
          if(state is NovaPropostaStateCreated)
            Navigator.of(context).pop();
        },
        child:
        SingleChildScrollView(
          child: BlocBuilder(
            bloc: _novaPropostaBloc,
            builder: (ctx, state){
              if(state is NovaPropostaStateCreating){
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              }else if(state is NovaPropostaStateInitial){
                NovaPropostaStateInitial novaPropostaStateInitial = state;
                novaPropostaStateInitial.novaPropostaModel.clienteModel = _clienteModel;
                return _buildForm();
              }
              return Text("T");
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _confirm,
        child: Icon(Icons.check),
      ),
    );
  }

}