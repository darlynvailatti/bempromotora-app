

class PessoaFisicaModel {

  final String cpf;

  PessoaFisicaModel({this.cpf});

  factory PessoaFisicaModel.fromJson(final json){
    return PessoaFisicaModel(
        cpf: json["cpf"],
    );
  }

}