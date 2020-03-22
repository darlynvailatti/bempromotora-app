// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewClienteModel _$NewClienteModelFromJson(Map<String, dynamic> json) {
  return NewClienteModel(
    nome: json['nome'] as String,
    dataNascimento: json['dataNascimento'] == null
        ? null
        : DateTime.parse(json['dataNascimento'] as String),
    cpf: json['cpf'] as String,
    idConvenio: json['idConvenio'] as int,
  );
}

Map<String, dynamic> _$NewClienteModelToJson(NewClienteModel instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'dataNascimento': instance.dataNascimento?.toIso8601String(),
      'cpf': instance.cpf,
      'idConvenio': instance.idConvenio,
    };
