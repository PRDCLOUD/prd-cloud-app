import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'menu_item_selected_state.dart';

class MenuItemSelectedCubit extends Cubit<MenuItemSelectedState> {
  MenuItemSelectedCubit() : super(const MenuItemSelectedState(MenuItemSelected.productionDataList));

  void selectPage(MenuItemSelected menuItemSelected) {
    emit(MenuItemSelectedState(menuItemSelected));
  }

}
