
import 'dart:convert';

import 'package:bempromotora_app/common/constants.dart';
import 'package:bempromotora_app/model/cliente_model.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NewClienteBloc extends Bloc<NewClienteEvent, NewClienteState>{

  @override
  NewClienteState get initialState => NewClienteStateInitial();

  @override
  Stream<NewClienteState> mapEventToState(NewClienteEvent event) async*{

    if(event is NewClienteEventCreate){
      try{
        yield NewClienteStateCreating();
        NewClienteEventCreate newClienteEventCreate = event;
        await _httpPostNewCliente(newClienteEventCreate.newClienteModel);
        yield NewClienteStateCreated();
      }catch(error){
        yield NewClienteStateError(error);
        print('Error on creating Cliente. ${error}');
      }
    }

  }

}

Future<List<ClienteModel>> _httpPostNewCliente(NewClienteModel newClienteModel) async {
  final endpointURL = Constants.POST_NEW_CLIENTE;
  print(endpointURL);

  var payload = jsonEncode(<String, dynamic>{
    'idConvenio': newClienteModel.idConvenio,
    'dataNascimento': new DateFormat('yyyy-MM-dd').format(newClienteModel.dataNascimento),
    'nome': newClienteModel.nome,
    'cpf': newClienteModel.cpf,
    'matriculaConvenio': newClienteModel.matriculaConvenico,
  });
  await http.post(
      endpointURL,
      headers: {
        "Content-Type": "application/json"
      },
      body: payload);

}




abstract class NewClienteState{}

class NewClienteStateInitial extends NewClienteState {

}

class NewClienteStateCreated extends NewClienteState {

}

class NewClienteStateCreating extends NewClienteState {

}

class NewClienteStateError extends NewClienteState {

  final String messageError;

  NewClienteStateError(this.messageError);

}


abstract class NewClienteEvent{}


class NewClienteEventCreate extends NewClienteEvent {

  final NewClienteModel newClienteModel;

  NewClienteEventCreate(this.newClienteModel);

}
