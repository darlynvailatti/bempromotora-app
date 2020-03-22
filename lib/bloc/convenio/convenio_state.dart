
import 'package:bempromotora_app/model/convenio_model.dart';

abstract class ConvenioState {

  List<ConvenioModel> convenios;

}

class ConvenioStateInitial extends ConvenioState {

  ConvenioStateInitial(List<ConvenioModel> convenios){
    this.convenios = convenios;
  }

}

class ConvenioStateLoading extends ConvenioState {

}

class ConvenioStateLoaded extends ConvenioState {

  ConvenioStateLoaded(List<ConvenioModel> convenios){
    this.convenios = convenios;
  }

}
