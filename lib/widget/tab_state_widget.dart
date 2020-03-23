
import 'package:bempromotora_app/bloc/contexto/contexto_bloc.dart';
import 'package:bempromotora_app/bloc/contexto/contexto_state.dart';
import 'package:bempromotora_app/screen/clientes_screen.dart';
import 'package:bempromotora_app/screen/propostas_screen.dart';
import 'package:bempromotora_app/widget/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {

  static const String ROUTE_NAME = "/home";

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

}

class _MainPage {

  final String title;
  final Widget pageWidget;

  _MainPage({this.title, this.pageWidget});

}

class _HomeState extends State<HomeScreen> {


  List<_MainPage> _pages = [
    _MainPage(
      title: 'Clientes',
      pageWidget: ClientesScreen(),
    ),
    _MainPage(
      title: 'Propostas',
      pageWidget: PropostasScreen(),
    ),
  ];

  var _selectedPageIndex = 0;

  void _selectPage(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {

    var _currentPage = _pages[_selectedPageIndex];

    return  Scaffold(
      drawer: MenuWidget(),
      appBar: AppBar(
        title: Text('${_currentPage.title}'),
      ),
      body: _currentPage.pageWidget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Clientes"),
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            title: Text("Propostas"),
            icon: Icon(Icons.attach_file),
          ),
        ],

      ),
    );

  }

}
