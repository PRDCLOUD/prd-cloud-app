import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_data_list/production_data_list.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/production_opened_items.dart';
import 'package:production_data_repository/production_data_repository.dart';

class DrawerMenuPage extends StatelessWidget {
  const DrawerMenuPage({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MenuItemSelectedCubit(), lazy: false,),
        BlocProvider(create: (context) => ProductionDataBloc(apontamentosRepository: context.read<ProductionDataRepository>())..add(ApontamentosRefreshEvent(take: 100))),
        BlocProvider(create: (context) => OpenProductionDataCubit(productionDataRepository: context.read<ProductionDataRepository>()), lazy: false,),
        BlocProvider(create: (context) => SelectedProductionDataCubit(), lazy: false,)
      ], child: Scaffold(
        appBar: AppBar(title: const Text('Home')),
        drawer: const DrawerMenuList(),
        body: BlocBuilder<MenuItemSelectedCubit, MenuItemSelectedState>(
          builder: (context, state) {
            switch (state.menuItemSelected) {
              case MenuItemSelected.productionOpenedItems:
                return const ProductionOpenedItemSelectedPage();
              default:
                return const ProductionDataListPage();
            }
          },
        ),
      )
    );
      
  }
}

class DrawerMenuList extends StatelessWidget {
  const DrawerMenuList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 12'),
            onTap: () {
              context.read<MenuItemSelectedCubit>().selectPage(MenuItemSelected.productionDataList);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              context.read<MenuItemSelectedCubit>().selectPage(MenuItemSelected.productionOpenedItems);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}