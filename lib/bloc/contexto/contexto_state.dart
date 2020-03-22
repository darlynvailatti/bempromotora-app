
abstract class ContextoState {

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

  ContextoStateLoginSuccess(String userId, String userName){
    this.userName = userName;
    this.userId = userId;
  }
}

class ContextoStateLoading extends ContextoState {}


class ContextoStateLoginFail extends ContextoState{

  String reason;

  ContextoStateLoginFail({this.reason});

}