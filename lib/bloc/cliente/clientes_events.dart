import 'package:bempromotora_app/model/cliente_model.dart';

abstract class ClientesEvent {}

class LoadAllClientes extends ClientesEvent {}

class NewCliente extends ClientesEvent {

  final NewClienteModel _newClienteModel;

  NewCliente(this._newClienteModel);

  NewClienteModel get newClienteModel => _newClienteModel;

}

class RemoveCliente extends ClientesEvent {

  final ClienteModel _clienteModel;

  RemoveCliente(this._clienteModel);

  ClienteModel get clienteModel => _clienteModel;

}