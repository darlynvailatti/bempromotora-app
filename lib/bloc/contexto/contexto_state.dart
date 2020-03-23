
abstract class ContextoState {

  String login;
  String userId;
  String userName;

}

class ContextoStateInitial extends ContextoState {

  ContextoStateInitial(){
    this.userId = "";
    this.userName = "";
  }

}

class ContextoStateLoginSuccess extends ContextoState {

  ContextoStateLoginSuccess(String userId, String userName, String login){
    this.userName = userName;
    this.userId = userId;
    this.login = login;
  }
}

class ContextoStateLoading extends ContextoState {}


class ContextoStateLoginFail extends ContextoState{

  String reason;

  ContextoStateLoginFail({this.reason});

}