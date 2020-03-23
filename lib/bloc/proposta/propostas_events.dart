import 'package:bempromotora_app/model/proposta/proposta_model.dart';

abstract class PropostasEvent {}

class PropostasEventLoadAll extends PropostasEvent {}

class PropostaEventCreate extends PropostasEvent {

  final PropostaModel _propostaModel;

  PropostaEventCreate(this._propostaModel);

  PropostaModel get propostaModel => _propostaModel;

}

class PropostaEventRemoveOne extends PropostasEvent {

  final PropostaModel _propostaModel;

  PropostaEventRemoveOne(this._propostaModel);

  PropostaModel get propostaModel => _propostaModel;

}