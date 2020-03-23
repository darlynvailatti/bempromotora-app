
import 'package:bempromotora_app/bloc/contexto/contexto_bloc.dart';
import 'package:bempromotora_app/bloc/contexto/contexto_event.dart';
import 'package:bempromotora_app/bloc/contexto/contexto_state.dart';
import 'package:bempromotora_app/screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final _contextoBloc = BlocProvider.of<ContextoBloc>(context);

    return BlocListener(
      bloc: _contextoBloc,
      listener: (ctx, state) {
        if(state is ContextoStateInitial){
          Navigator.of(context).pushReplacementNamed(LoginScreen.ROUTE_NAME);
        }
      },
      child:BlocBuilder(
          bloc: _contextoBloc,
          builder: (ctx, state) {

            String userName = "";
            String login = "";
            if(state is ContextoStateLoginSuccess) {
              ContextoStateLoginSuccess loginSuccess = state;
              userName = state.userName;
              login = state.login;
            }

            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: Theme
                              .of(context)
                              .accentColor,
                          size: 100,
                        ),
                        SizedBox(height: 20,),
                        Text('${login == null ? userName : login}'),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  ListTile(
                    title: Text('Sair'),
                    leading: IconButton(
                      icon: Icon(Icons.transit_enterexit),
                    ),
                    onTap: () {
                      _contextoBloc.dispatch(ContextoEventLogout());
                    },
                  )
                ],
              ),
            );
          }
      )
    );
  }

}