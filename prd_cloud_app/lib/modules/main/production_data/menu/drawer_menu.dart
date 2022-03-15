import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_data_list/production_data_list.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_line_selection/production_line_selection.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/production_opened_items.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Apontamentos')),
        drawer: const DrawerMenuList(),
        body: BlocListener<ErrorCubit, ErrorState>(
          listener: snackBarErrorHandler,
          child: BlocBuilder<MenuItemSelectedCubit, MenuItemSelectedState>(
            builder: (context, state) {
              switch (state.menuItemSelected) {
                case MenuItemSelected.productionOpenedItems:
                  return const ProductionOpenedItemLayoutPage();
                case MenuItemSelected.productionLines:
                  return const ProductionLineSelectionPage();
                default:
                  return const ProductionDataListPage();
              }
            },
          ),
        ),
      );
  }

  void snackBarErrorHandler(context, state) {
          String? errorToShow;
          if (state.errorObject != null) {
            if (state is String) {
              errorToShow = state;
            } else if (state.errorObject is DioError) {
              var dioError = state.errorObject as DioError;
              if (dioError.response?.statusCode != null && dioError.response!.statusCode == 400 && dioError.response?.data is Map) {
                errorToShow = (dioError.response!.data as Map)['errorMessage'];
              }
            }
            if (errorToShow != null && errorToShow.isNotEmpty) {
              final snackBar = SnackBar(
                content: Text(errorToShow)
              );
  
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
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
      child: Column(
        children: [
          Expanded(child: 
            ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    child: Container(
                      decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/img/logotipo.png"),
                          fit: BoxFit.scaleDown)
                      ),
                    ),
                    padding: const EdgeInsets.all(40),
                  ),
                ListTile(
                  title: const Text('Lista de Apontamentos'),
                  onTap: () {
                    context.read<MenuItemSelectedCubit>().selectPage(MenuItemSelected.productionDataList);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Abertos'),
                  onTap: () {
                    context.read<MenuItemSelectedCubit>().selectPage(MenuItemSelected.productionOpenedItems);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Linhas de Produção'),
                  onTap: () {
                    context.read<MenuItemSelectedCubit>().selectPage(MenuItemSelected.productionLines);
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ),
          _User()
        ],
      )
    );
  }
}

class _User extends StatelessWidget {
  const _User({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}