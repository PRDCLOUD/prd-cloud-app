part of 'menu_item_selected_cubit.dart';

enum MenuItemSelected { productionDataList, productionOpenedItems, productionLines }

@immutable
class MenuItemSelectedState extends Equatable {
  final MenuItemSelected menuItemSelected;

  const MenuItemSelectedState(this.menuItemSelected);

  @override
  List<Object> get props => [menuItemSelected];
}
