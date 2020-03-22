
import 'dart:convert';

import 'package:bempromotora_app/model/pessoa_fisica_model.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cliente_model.g.dart';

class ClienteModel {

  final int idCliente;

  final String nome;

  final DateTime dataNascimento;

  final bool bloqueado;

  final PessoaFisicaModel pessoaFisica;

  ClienteModel({this.idCliente, this.nome, this.dataNascimento, this.bloqueado, this.pessoaFisica});

  factory ClienteModel.fromJson(final json){

    return ClienteModel(
      idCliente: json["idCliente"],
      nome: json["nome"],
      dataNascimento: DateFormat('yyyy-MM-dd').parse(json["dataNascimento"]),
      bloqueado: json["bloqueado"],
      pessoaFisica: json["pessoaFisica"] == null ? null : PessoaFisicaModel.fromJson(json["pessoaFisica"] ),
    );
  }

  double getIdade(){
    return DateTime.now().difference(dataNascimento).inDays / 365;
  }

}

@JsonSerializable()
class NewClienteModel{

  final String nome;

  final DateTime dataNascimento;

  final String cpf;

  final int idConvenio;

  NewClienteModel({this.nome, this.dataNascimento, this.cpf, this.idConvenio});

  factory NewClienteModel.fromJson(Map<String, dynamic> json) => _$NewClienteModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewClienteModelToJson(this);


}