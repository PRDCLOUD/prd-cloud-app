import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/initial/bloc/selected_production_line_and_groups/selected_production_line_and_groups_cubit.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/create_input_data/create_input_data.dart';
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
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: menuItemAppBar(context, menuItemSelected),
              drawer: const DrawerMenuList(),
              body: BlocListener<ErrorCubit, ErrorState>(
                listener: snackBarErrorHandler,
                child: menuItemSelectedPage(menuItemSelected),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar menuItemAppBar(BuildContext context, MenuItemSelected menuItemSelected) {
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
              onPressed: () {
                showSelectionProductionLines(context);
              },
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
        } else if (dioError.response?.statusCode != null &&
            dioError.response!.statusCode == 403 &&
            dioError.response?.data is Map) {
          errorToShow = "Ação não permitida para o usuário";
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

  showSelectionProductionLines(BuildContext context) {
    var selectedProductionLines = context.read<SelectedProductionLineAndGroupsCubit>().state.selectedProductionLinesAndGroups;
    var confirmation = context.read<OpenProductionDataCubit>().openNewProductionData;
    var refresh = context.read<ProductionListFilterCubit>().markForRefresh;

    Future<void> confirmationAndSetRefresh(List<ProductionLineAndGroup> productionLineAndGroups) async {
      await confirmation(productionLineAndGroups);
      refresh();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return CreateInputProductionLineSelectionList(
          allProductionLines: selectedProductionLines,
          initalSelectionProductionLines: const [],
          confirmation: confirmationAndSetRefresh,
          enableCancel: true,
          popAfterConfirm: true,
        );
      }
      )
    );
  }
}

