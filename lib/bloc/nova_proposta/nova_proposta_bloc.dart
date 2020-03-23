
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bempromotora_app/common/constants.dart';
import 'package:bempromotora_app/model/proposta/nova_proposta_model.dart';
import 'package:bempromotora_app/model/proposta/proposta_model.dart';
import 'package:bloc/bloc.dart';

class NovaPropostaBloc extends Bloc<NovaPropostaEvent, NovaPropostaState> {

  @override
  NovaPropostaState get initialState => NovaPropostaStateInitial();

  @override
  Stream<NovaPropostaState> mapEventToState(NovaPropostaEvent event) async*{

    if(event is NovaPropostaEventCreate){
      try{
        yield NovaPropostaStateCreating();
        NovaPropostaEventCreate novaPropostaEventCreate = event;
        await _httpPostNovaProposta(novaPropostaEventCreate.novaPropostaModel);
        yield NovaPropostaStateCreated();
      }catch(error){
        yield NovaPropostaStateCreationFail(messageError: error);
        print('Error on creating Proposta. ${error}');
      }
    }


  }

  Future<void> _httpPostNovaProposta(NovaPropostaModel novaPropostaModel) async {
    final endpointURL = Constants.POST_NEW_PROPOSTA;
    print(endpointURL);

    var payload = jsonEncode(<String, dynamic>{
      'cliente': {
        'idCliente':  novaPropostaModel.clienteModel.id,
      },
      'valor': novaPropostaModel.valor,
      'observacao': novaPropostaModel.descricao,
    });
    await http.post(
        endpointURL,
        headers: {
          "Content-Type": "application/json"
        },
        body: payload);

  }


}


abstract class NovaPropostaState{
}

class NovaPropostaStateInitial extends NovaPropostaState {

  NovaPropostaModel novaPropostaModel;

  NovaPropostaStateInitial(){
   this.novaPropostaModel = NovaPropostaModel(valor: 0, descricao: "");
  }

}

class NovaPropostaStateCreating extends NovaPropostaState {

}

class NovaPropostaStateCreationFail extends NovaPropostaState {

  final String messageError;

  NovaPropostaStateCreationFail({this.messageError});


}

class NovaPropostaStateCreated extends NovaPropostaState {

}

abstract class NovaPropostaEvent{

}

class NovaPropostaEventCreate extends NovaPropostaEvent {

  final NovaPropostaModel novaPropostaModel;

  NovaPropostaEventCreate(this.novaPropostaModel);

}