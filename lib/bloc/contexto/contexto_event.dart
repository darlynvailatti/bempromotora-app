
abstract class ContextoEvent{}

class ContextoEventLoginGoogle extends ContextoEvent{


}

class ContextoEventLogout extends ContextoEvent{}

class ContextoEventoLoginEmailAndPassword extends ContextoEvent {

  String email;

  String password;

  ContextoEventoLoginEmailAndPassword({this.email, this.password});

}

