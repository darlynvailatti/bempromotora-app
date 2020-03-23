import 'package:bempromotora_app/bloc/contexto/contexto_bloc.dart';
import 'package:bempromotora_app/bloc/contexto/contexto_event.dart';
import 'package:bempromotora_app/bloc/contexto/contexto_state.dart';
import 'package:bempromotora_app/widget/tab_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {

  static const String ROUTE_NAME = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  ContextoBloc _contextoBloc;

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 5),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child:  TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
                icon: Icon(Icons.alternate_email),
                labelText: 'Email'
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Obrigatório';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 5),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
                icon: Icon(Icons.vpn_key),
                labelText: 'Senha',
                labelStyle: TextStyle(color: Colors.black),
            ),
            obscureText: true,
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

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Esqueceu sua senha?',
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Theme.of(context).accentColor),
            child: Checkbox(
              value: _rememberMe,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Lembrar-me',
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          var formIsValid = _formKey.currentState.validate();
          if(formIsValid)
            _contextoBloc.dispatch(
                ContextoEventoLoginEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text
                )
            );
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'ENTRAR',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => _contextoBloc.dispatch(ContextoEventLoginGoogle()),
            AssetImage(
              'assets/logos/google.png',
            ),
          ),
        ],
      ),
    );
}

  Widget _buildLoginStatus() {
    return BlocListener(
      bloc: _contextoBloc,
      listener: (ctx, state) {
        print('Listener contexto bloc in LoginScreen: ${state}');
        if(state is ContextoStateLoginSuccess) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.ROUTE_NAME);
        }

        if(state is ContextoStateLoginFail){
          ContextoStateLoginFail loginFailEvent = state;
          Toast.show(loginFailEvent.reason, context, duration: 5);
        }
        
      },
      child: BlocBuilder(
        bloc: _contextoBloc,
        builder: (ctx, state) {
          Widget statusLoginWidget = SizedBox();


          if (state is ContextoStateLoading) {
            statusLoginWidget = Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                )
            );
          }

          return statusLoginWidget;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    _contextoBloc = BlocProvider.of<ContextoBloc>(context);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      Image(
                        image: AssetImage(
                          'assets/logos/logo-bem.png',
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            _buildEmailTF(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildPasswordTF(),
                            _buildForgotPasswordBtn(),
                            _buildRememberMeCheckbox(),
                            _buildLoginBtn()
                          ],
                        ),
                      ),
                      _buildSocialBtnRow(),
                      _buildLoginStatus(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
