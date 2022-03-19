import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_data_list/production_data_list.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/production_opened_items.dart';

import 'drawer_menu_list.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  Future<bool> _onWillPop(BuildContext context) async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: BlocBuilder<MenuItemSelectedCubit, MenuItemSelectedState>(
        builder: (context, state) {
          var menuItemSelected = state.menuItemSelected;
          return Scaffold(
            appBar: menuItemAppBar(menuItemSelected),
            drawer: const DrawerMenuList(),
            body: BlocListener<ErrorCubit, ErrorState>(
              listener: snackBarErrorHandler,
              child: menuItemSelectedPage(menuItemSelected),
            ),
          );
        },
      ),
    );
  }



  AppBar menuItemAppBar(MenuItemSelected menuItemSelected) {
    String title = "";
    switch (menuItemSelected) {
      case MenuItemSelected.productionOpenedItems:
        title = "Edição de Apontamentos";
        break;
      default:
        title = "Apontamentos";
        break;
    }

    return AppBar(
          title: Text(title),
          actions: [
            TextButton.icon(
              style: TextButton.styleFrom(primary: Colors.white,),
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Criar Novo Apontamento'),
            ),
          ],
        );
  }

  StatelessWidget menuItemSelectedPage(MenuItemSelected menuItemSelected) {
    switch (menuItemSelected) {
      case MenuItemSelected.productionOpenedItems:
        return const ProductionOpenedItemLayoutPage();
      default:
        return const ProductionDataListPage();
    }
  }

  void snackBarErrorHandler(context, state) {
    String? errorToShow;
    if (state.errorObject != null) {
      if (state is String) {
        errorToShow = state;
      } else if (state.errorObject is DioError) {
        var dioError = state.errorObject as DioError;
        if (dioError.response?.statusCode != null &&
            dioError.response!.statusCode == 400 &&
            dioError.response?.data is Map) {
          errorToShow = (dioError.response!.data as Map)['errorMessage'];
        }
      }
      if (errorToShow != null && errorToShow.isNotEmpty) {
        final snackBar = SnackBar(content: Text(errorToShow));

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
  }
}

