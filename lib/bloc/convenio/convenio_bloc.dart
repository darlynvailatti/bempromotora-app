
import 'dart:convert';

import 'package:bempromotora_app/common/constants.dart';
import 'package:bempromotora_app/model/convenio_model.dart';
import 'package:bloc/bloc.dart';
import 'convenio_event.dart';
import 'convenio_state.dart';
import 'package:http/http.dart' as http;

class ConvenioBloc extends Bloc<ConvenioEvent, ConvenioState>{

  @override
  ConvenioState get initialState => ConvenioStateInitial([]);

  @override
  Stream<ConvenioState> mapEventToState(ConvenioEvent event) async* {
    if(event is ConvenioEventLoadAll){
      yield ConvenioStateLoading();
      final convenios = await _httpGetConvenios();
      yield ConvenioStateLoaded(convenios);
    }
  }
  
  Future<List<ConvenioModel>> _httpGetConvenios() async {
    final endpointURL = Constants.GET_ALL_CONVENIOS;
    print(endpointURL);
    final response = await http.get(endpointURL);
    Map<String, dynamic> jsonReponse = jsonDecode(response.body);

    var _embedded = jsonReponse["_embedded"];
    var conveniosJson = _embedded["convenios"] as List;

    List<ConvenioModel> convenios = [];
    conveniosJson
        .forEach((convenio) => convenios.add(ConvenioModel.fromJson(convenio)));
    print('Convenios: ${convenios}');
    return convenios;
  }

}