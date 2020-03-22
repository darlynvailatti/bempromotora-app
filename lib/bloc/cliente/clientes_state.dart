
import 'package:bempromotora_app/model/cliente_model.dart';

abstract class ClientesState {

  List<ClienteModel> _clientes;

  List<ClienteModel> get clientes => _clientes;

}

class ClientesStateInitial extends ClientesState {

  ClientesStateInitial(){
    _clientes = [];
  }

}

class ClientesStateLoading extends ClientesState {

}

class ClientesStateLoaded extends ClientesState {

  ClientesStateLoaded(List<ClienteModel> clientes){
   this._clientes = clientes;
  }

}

