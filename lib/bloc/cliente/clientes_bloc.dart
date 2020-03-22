import 'dart:convert';

import 'package:bempromotora_app/bloc/cliente/clientes_events.dart';
import 'package:bempromotora_app/common/constants.dart';
import 'package:bempromotora_app/model/cliente_model.dart';
import 'package:bloc/bloc.dart';

import 'clientes_state.dart';
import 'package:http/http.dart' as http;


class ClientesBloc extends Bloc<ClientesEvent, ClientesState> {

  @override
  ClientesState get initialState => ClientesStateInitial();

  @override
  Stream<ClientesState> mapEventToState(ClientesEvent event) async* {

    if(event is LoadAllClientes){
      yield ClientesStateLoading();
      final clientes = await _httpGetClientes();
      yield ClientesStateLoaded(clientes);
    }

  }

  Future<List<ClienteModel>> _httpGetClientes() async {
    final endpointURL = Constants.GET_ALL_CLIENTES;
    print(endpointURL);
    final response = await http.get(endpointURL);
    Map<String, dynamic> jsonReponse = jsonDecode(response.body);

    var _embedded = jsonReponse["_embedded"];
    var clientesJson = _embedded["clientes"] as List;

    List<ClienteModel> clientes = [];
    clientesJson
        .forEach((cliente) => clientes.add(ClienteModel.fromJson(cliente)));
    return clientes;
  }




}