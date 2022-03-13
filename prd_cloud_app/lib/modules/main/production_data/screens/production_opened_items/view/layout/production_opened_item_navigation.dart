import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/loss/production_loss_main.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/production_edit/production_data_edit.dart';

class ProductionOpenedItemNavigation extends StatefulWidget {
  const ProductionOpenedItemNavigation({Key? key}) : super(key: key);

  @override
  State<ProductionOpenedItemNavigation> createState() => _ProductionOpenedItemNavigation();
}

class _ProductionOpenedItemNavigation extends State<ProductionOpenedItemNavigation> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  
  static const List<Widget> _widgetOptions = <Widget>[
    ProductionDataEdit(),
    ProductionLossMain(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SelectedProductionDataCubit, int?>(
          builder: (BuildContext context, state) {
            return Scaffold(
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Produção',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.business),
                    label: 'Perdas',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.school),
                    label: 'Paradas',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
                onTap: _onItemTapped,
              ),
            );
          })
        );
  }
}