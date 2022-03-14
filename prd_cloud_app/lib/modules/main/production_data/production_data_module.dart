import 'package:flutter/material.dart';

import 'bloc_setup/bloc_setup.dart';
import 'menu/drawer_menu.dart';

class ProductionDataModule extends StatelessWidget {
  const ProductionDataModule({Key? key}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BlocSetup(
      child: DrawerMenu()
    );
  }
}