import 'dart:convert';
import 'package:bempromotora_app/bloc/proposta/propostas_events.dart';
import 'package:bempromotora_app/common/constants.dart';
import 'package:bempromotora_app/model/proposta/proposta_model.dart';
import 'package:bloc/bloc.dart';

import 'propostas_state.dart';
import 'package:http/http.dart' as http;


class PropostasBloc extends Bloc<PropostasEvent, PropostasState> {

  @override
  PropostasState get initialState => PropostasStateInitial();

  @override
  Stream<PropostasState> mapEventToState(PropostasEvent event) async* {
    if(event is PropostasEventLoadAll){

      try{
        yield PropostasStateLoading();
        final propostas = await _httpGetPropostas();

        if(propostas != null) {
          print('Loaded propostas: ${propostas}');
          yield PropostasStateLoaded(propostas);
        }
      }catch(error){
        yield PropostasStateLoadFail(messageError: error);
        print('Propostas are not loaded. Errror: ${error}');
      }

    }
  }

  Future<List<PropostaModel>> _httpGetPropostas() async {
      final endpointURL = Constants.GET_ALL_PROPOSTAS;
      print(endpointURL);
      final response = await http.get(endpointURL);

      var jsonReponse = jsonDecode(response.body);
      print(jsonReponse);

      List<PropostaModel> propostas = [];
      jsonReponse.forEach((proposta) => propostas.add(PropostaModel.fromJson(proposta)));

      return propostas;
  }


}