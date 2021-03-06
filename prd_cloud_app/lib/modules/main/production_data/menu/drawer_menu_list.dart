import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/initial/bloc/auth_data_cubit/auth_data_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/authentication/authentication_bloc.dart';
import 'package:prd_cloud_app/modules/main/bloc/menu_item_selected_cubit/menu_item_selected_cubit.dart';

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
        Expanded(child: BlocBuilder<MenuItemSelectedCubit, MenuItemSelectedState>(
          builder: (context, state) {
            return ListView(
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
                  title: _menuTitleItem(
                    context,
                    Icons.list,
                    "Lista de Apontamentos",
                    state.menuItemSelected == MenuItemSelected.productionDataList
                  ),
                  onTap: () {
                    context
                        .read<MenuItemSelectedCubit>()
                        .selectPage(MenuItemSelected.productionDataList);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: _menuTitleItem(
                    context,
                    Icons.file_download_outlined,
                    "Apontamentos Carregados",
                    state.menuItemSelected == MenuItemSelected.productionOpenedItems
                  ),
                  onTap: () {
                    context
                        .read<MenuItemSelectedCubit>()
                        .selectPage(MenuItemSelected.productionOpenedItems);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        )),
        const _User()
      ],
    ));
  }

  Widget _menuTitleItem(BuildContext context, IconData icon, String label, bool isSelected) {
    if (isSelected) {
      return Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
                ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15
                ),
          ),
        ],
      );
    }
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
                  width: 1.0, color: Theme.of(context).colorScheme.primary))),
      height: 70,
      child: Row(children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            Icons.person,
            size: 30.0,
            color: Colors.white,
          ),
        ),
        Expanded(
            child: Text(_authData.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white))),
        IconButton(
          icon: const Icon(
            Icons.logout,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () {
            context
                .read<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested());
          },
        )
      ]),
    );
  }
}
