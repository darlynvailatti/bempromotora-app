
class ConvenioModel {

  final int idConvenio;
  final String descricao;

  ConvenioModel({this.idConvenio, this.descricao});

  factory ConvenioModel.fromJson(json) {
    return ConvenioModel(
      idConvenio: json["id"],
      descricao: json["descricao"]
    );
  }

}