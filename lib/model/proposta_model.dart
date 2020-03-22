

import 'package:bempromotora_app/model/cliente_model.dart';

class PropostaModel {

  final int idProposta;

  final String situacao;

  final ClienteModel clienteModel;

  final String convenio;

  final String matriculaConvenio;

  final double valor;

  final DateTime data;

  final String observacao;

  PropostaModel({this.idProposta, this.situacao, this.clienteModel,
      this.convenio, this.matriculaConvenio, this.valor, this.data,
      this.observacao});

  factory PropostaModel.fromJson(final proposta) {

    return PropostaModel(
      idProposta: proposta['idProposta'],
      situacao: proposta['situacao'],
      clienteModel: ClienteModel.fromJson(proposta['cliente']),
      convenio: proposta['convenio'],
      matriculaConvenio: proposta['matriculaConvenio'],
      valor: proposta['valor'],
      observacao: proposta['observacao']
    );
  }

}