import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/main/production_data/bloc/main_bloc.dart';

class ProductionOpenedItemsPage extends StatelessWidget {
  const ProductionOpenedItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OpenProductionDataCubit, OpenProductionDataState>(
          builder: (BuildContext context, state) {
            return ListView.builder(
              itemCount: state.loadedItems.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 50,
                  child: Center(child: Text(state.loadedItems[index].begin?.toIso8601String() ?? "null"))
                );
              }
            );
          })
        );
  }
}