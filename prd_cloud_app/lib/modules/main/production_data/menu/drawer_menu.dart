import 'package:authentication_repository/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/initial/bloc/auth_data_cubit/auth_data_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/authentication/authentication_bloc.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_data_list/production_data_list.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_line_selection/production_line_selection.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/production_opened_items.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuItemSelectedCubit, MenuItemSelectedState>(
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
    );
  }

  AppBar menuItemAppBar(MenuItemSelected menuItemSelected) {
    switch (menuItemSelected) {
      case MenuItemSelected.productionOpenedItems:
        return AppBar(title: const Text('Edição de Apontamentos'));
      case MenuItemSelected.productionLines:
        return AppBar(title: const Text('Linhas de Produção'));
      default:
        return AppBar(title: const Text('Apontamentos'));
    }
  }

  StatelessWidget menuItemSelectedPage(MenuItemSelected menuItemSelected) {
    switch (menuItemSelected) {
      case MenuItemSelected.productionOpenedItems:
        return const ProductionOpenedItemLayoutPage();
      case MenuItemSelected.productionLines:
        return const ProductionLineSelectionPage();
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
        Expanded(
            child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/logotipo.png"),
                      fit: BoxFit.scaleDown)),
              ),
              padding: const EdgeInsets.all(40),
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.list),
                  SizedBox(width: 10,),
                  Text('Lista de Apontamentos'),
                ],
              ),
              onTap: () {
                context
                    .read<MenuItemSelectedCubit>()
                    .selectPage(MenuItemSelected.productionDataList);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.file_download_outlined),
                  SizedBox(width: 10,),
                  Text('Apontamentos Carregados'),
                ],
              ),
              onTap: () {
                context
                    .read<MenuItemSelectedCubit>()
                    .selectPage(MenuItemSelected.productionOpenedItems);
                Navigator.pop(context);
              },
            ),
            ListTile(
             title: Row(
                children: const [
                  Icon(Icons.precision_manufacturing_outlined),
                  SizedBox(width: 10,),
                  Text('Linhas de Produção'),
                ],
              ),
              onTap: () {
                context
                    .read<MenuItemSelectedCubit>()
                    .selectPage(MenuItemSelected.productionLines);
                Navigator.pop(context);
              },
            )
          ],
        )),
        const _User()
      ],
    ));
  }
}

class _User extends StatelessWidget {
  const _User({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthDataCubit, AuthData?>(
      builder: (context, state) {
        if (state == null) {
          return const SizedBox.shrink();
        } else {
          return _LogoutArea(authData: state);
        }
      },
    );
  }
}

class _LogoutArea extends StatelessWidget {
  const _LogoutArea({Key? key, required AuthData authData})
      : _authData = authData,
        super(key: key);

  final AuthData _authData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border(
          top: BorderSide(
            width: 1.0, 
            color: Theme.of(context).colorScheme.primary
          )
        )
      ),
      height: 70,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.person,
              size: 30.0,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              _authData.name, 
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)
            )
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              size: 30.0,
              color: Colors.white,
            ),
            onPressed: () {
              context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
            },
          )
        ]
      ),
    );
  }
}
