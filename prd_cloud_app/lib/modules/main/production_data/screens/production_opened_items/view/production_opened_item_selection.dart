import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';

class ProductionOpenedItemSelectionPage extends StatelessWidget {
  const ProductionOpenedItemSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OpenProductionDataCubit, OpenProductionDataState>(
          builder: (BuildContext context, state) {
            return ListView.builder(
              itemCount: state.loadedItems.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: context.read<OpenProductionDataCubit>().selectProductionData(state.loadedItems[index].id),
                  child: const SizedBox(
                    height: 50,
                    child: ProductionOpenedItemSelectionPage()
                  )
                );
              }
            );
          })
        );
  }
}