import 'package:bempromotora_app/model/proposta/proposta_model.dart';

abstract class PropostasState {

  List<PropostaModel> _propostas;

  List<PropostaModel> get propostas => _propostas;

}

class PropostasStateInitial extends PropostasState {

  PropostasStateInitial(){
    _propostas = [];
  }

}

class PropostasStateLoading extends PropostasState {

}

class PropostasStateLoadFail extends PropostasState {

  final String messageError;

  PropostasStateLoadFail({this.messageError});

}

class PropostasStateLoaded extends PropostasState {

  PropostasStateLoaded(List<PropostaModel> propostas){
   this._propostas = propostas;
  }

}

