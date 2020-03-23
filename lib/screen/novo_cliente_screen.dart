import 'package:bempromotora_app/bloc/cliente/clientes_bloc.dart';
import 'package:bempromotora_app/bloc/cliente/clientes_events.dart';
import 'package:bempromotora_app/bloc/convenio/convenio_bloc.dart';
import 'package:bempromotora_app/bloc/convenio/convenio_event.dart';
import 'package:bempromotora_app/bloc/convenio/convenio_state.dart';
import 'package:bempromotora_app/bloc/novo_cliente/new_cliente_bloc.dart';
import 'package:bempromotora_app/model/cliente_model.dart';
import 'package:bempromotora_app/model/convenio_model.dart';
import 'package:bempromotora_app/screen/clientes_screen.dart';
import 'package:bempromotora_app/widget/tab_state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class NovoClienteScreen extends StatefulWidget {

  static final String ROUTE_NAME = "/novoCliente";

  @override
  _NovoClienteScreenState createState() => _NovoClienteScreenState();
}

class _NovoClienteScreenState extends State<NovoClienteScreen> {

  final _convenioBloc = ConvenioBloc();
  final _newClienteBcoc = NewClienteBloc();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();

  final TextEditingController _cpfController = TextEditingController();

  final TextEditingController _matriculaController = TextEditingController();

  List<ConvenioModel> loadedConvenios = [];

  ConvenioModel _selectedConvenio;

  List<_ConvenioChip> conveniosChoices = [];

  DateTime _pickedDate = DateTime.now();

  BuildContext _buildContext;

  _NovoClienteScreenState(){
    _convenioBloc.dispatch(ConvenioEventLoadAll());
  }

  Widget _buildNomeTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 5),
        TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Obrigatório';
              }
              return null;
            },
          ),
      ],
    );
  }

  Widget _buildCpfTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 5),
        TextFormField(
            controller: _cpfController,
            decoration: const InputDecoration(labelText: 'CPF'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Obrigatório';
              }
              return null;
            },
        ),
      ],
    );
  }

  ChoiceChip _buildConvenioChoiceChip(ConvenioModel convenioModel){
    return ChoiceChip(
      label: Text(convenioModel.descricao),
      selected: _selectedConvenio.idConvenio == convenioModel.idConvenio,
      selectedColor: Colors.greenAccent,
      onSelected: (isSelected) {
        print(convenioModel.idConvenio);
        _onSelectConvenio(convenioModel);
      },
    );
  }

  _onSelectConvenio(ConvenioModel convenioModel){
    setState(() {
      _selectedConvenio = convenioModel;
      conveniosChoices.forEach((convenioChoice) {
        convenioChoice.chip = _buildConvenioChoiceChip(convenioChoice.convenioModel);
      });
    });

  }

  Widget _buildConvenioList() {

    return BlocListener(
        bloc: _convenioBloc,
        listener: (ctx, state) {
          if (state is ConvenioStateLoaded) {
            ConvenioStateLoaded convenioStateLoaded = state;
            loadedConvenios = convenioStateLoaded.convenios;

            _selectedConvenio = loadedConvenios.first;
            loadedConvenios.forEach((convenio) {

              var choieChip = _buildConvenioChoiceChip(convenio);
              conveniosChoices.add(
                  _ConvenioChip(
                    chip: choieChip,
                    convenioModel: convenio
                  )
              );
            });
          }
        },
        child: BlocBuilder(
        bloc: _convenioBloc,
        builder: (ctx, state) {
          return Column(
            children: <Widget>[
              Text("Qual o convênio?"),
              SizedBox(height: 10,),
              Wrap(
                spacing: 10,
                children: conveniosChoices.map((convenioChip) =>
                  convenioChip.chip
                ).toList(),
              )
            ],
          );
        },
      )
    );
  }

  Widget _buildConfirm() {

    return BlocListener(
      bloc: _newClienteBcoc,
      listener: (ctx, state){

        if(state is NewClienteStateCreated){
          print("Cliente created ");
          Navigator.of(context).pushNamed(HomeScreen.ROUTE_NAME);
        }else if(state is NewClienteStateError){
          print("Error on creating cliente - screen ");
          Navigator.of(context).pushNamed(HomeScreen.ROUTE_NAME);
          NewClienteStateError error = state;
          Toast.show(error.messageError, context);
        }
      },
      child: BlocBuilder(
        bloc: _newClienteBcoc,
        builder: (ctx, state){

          if(state is NewClienteStateCreating){
              return Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20,),
                    CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              );


          }else if(state is NewClienteStateInitial){
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Confirmar"),
                    color: Theme
                        .of(_buildContext)
                        .primaryColor,
                    onPressed: () {
                      var isFormValid = _formKey.currentState.validate();
                      if(isFormValid) {
                        NewClienteModel newClienteModel = new NewClienteModel(
                            cpf: _cpfController.text,
                            nome: _nomeController.text,
                            dataNascimento: _pickedDate,
                            idConvenio: _selectedConvenio.idConvenio,
                            matriculaConvenico: _matriculaController.text
                        );

                        _newClienteBcoc.dispatch(
                            NewClienteEventCreate(newClienteModel));
                      }
                    },
                  )
                ],
              ),
            );
          }else{
            return SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RaisedButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.date_range),
                    Text("Data nascimento:"),
                  ],
                ),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1940),
                    lastDate: DateTime(2030),
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData.dark(),
                        child: child,
                      );
                    },
                  ).then((pickedDate) {
                    setState(() {
                      if (pickedDate != null)
                        this._pickedDate = pickedDate;
                    });
                  });
                }
            ),
            SizedBox(width: 10,),
            Text(DateFormat.yMMMd().format(_pickedDate))
          ],
        ),
      ),
    );
  }


  Widget _buildMAtriculaConvenioTextField(){

    return TextFormField(
      controller: _matriculaController,
      decoration: const InputDecoration(labelText: 'Matrícula'),
      validator: (String value) {
        if (value.isEmpty) {
        return 'Obrigatório';
        }
        return null;
        },
    );

  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildNomeTextField(),
            SizedBox(
              height: 20.0,
            ),
            _buildCpfTextField(),
            SizedBox(
              height: 20.0,
            ),
            _buildConvenioList(),
            SizedBox(
              height: 20.0,
            ),
            _buildMAtriculaConvenioTextField(),
            SizedBox(
              height: 20.0,
            ),
            _buildDatePicker(),
            _buildConfirm(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return Scaffold(
        appBar: AppBar(
          title: Text("Novo Cliente"),
        ),
        body:
          SingleChildScrollView(
            child: _buildForm(),
          )
    );
  }
}

class _ConvenioChip {

  final ConvenioModel convenioModel;

  ChoiceChip chip;

  _ConvenioChip({this.convenioModel, this.chip});


}
