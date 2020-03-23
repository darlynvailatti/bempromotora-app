import 'package:bempromotora_app/bloc/contexto/contexto_event.dart';
import 'package:bempromotora_app/bloc/contexto/contexto_state.dart';
import 'package:bempromotora_app/widget/tab_state_widget.dart';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ContextoBloc extends Bloc<ContextoEvent, ContextoState> {

  static const String ERROR_INVALID_EMAIL = "ERROR_INVALID_EMAIL";
  static const String ERROR_WRONG_PASSWORD = "ERROR_WRONG_PASSWORD";
  static const String ERROR_TOO_MANY_REQUESTS = "ERROR_TOO_MANY_REQUESTS";

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  ContextoState get initialState => ContextoStateInitial();

  @override
  Stream<ContextoState> mapEventToState(ContextoEvent event) async* {
    yield ContextoStateLoading();

    bool _success = true;
    String _userId;
    String _userName;
    String _messageError;

    if(event is ContextoEventLogout){
      yield ContextoStateInitial();
      return;
    } else if (event is ContextoEventLoginGoogle) {
      print('logging...');

      try {
        var firebaseUser = await _handleGoogleSignIn();
        _userId = firebaseUser.uid;
        _userName = firebaseUser.displayName;
      }catch(error){
        _success = false;
        _messageError = error.toString();
      }

    } else if (event is ContextoEventoLoginEmailAndPassword) {
      ContextoEventoLoginEmailAndPassword loginEmailAndPassword = event;
      String email = loginEmailAndPassword.email;
      String password = loginEmailAndPassword.password;

      print(password);


      try {
        var firebaseUser = await _handleFirebaseEmailAndPasswordLogin(email, password);
        _userId = firebaseUser.uid;
        _userName = firebaseUser.displayName;
      }catch(error){
        _success = false;
        var platformException = error as PlatformException;
        var codeResponse = platformException.code.toString();
        bool isInvalidEmail = codeResponse == ERROR_INVALID_EMAIL;
        bool isWrongPassword = codeResponse == ERROR_WRONG_PASSWORD;
        bool isToManyRequests = codeResponse == ERROR_TOO_MANY_REQUESTS;

        if(isInvalidEmail)
          _messageError = "E-mail inválido";
        else if(isWrongPassword)
          _messageError = "Senha incorreta";
        else if(isToManyRequests)
          _messageError = "Muitas requisições realizadas!";
        else
          _messageError = "Houve um erro inesperado: ${platformException.code}";
      }
    }

    if (!_success)
      yield ContextoStateLoginFail(reason: _messageError);
    else
      yield ContextoStateLoginSuccess(_userId, _userName);
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  Future<FirebaseUser> _handleFirebaseEmailAndPasswordLogin(String email, String password) async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    return user;
  }
}
