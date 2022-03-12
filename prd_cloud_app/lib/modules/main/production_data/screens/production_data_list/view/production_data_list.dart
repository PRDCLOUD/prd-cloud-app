import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';

class ProductionDataListPage extends StatelessWidget {
  const ProductionDataListPage({Key? key}) : super(key: key);

  Future<void> loadProductionData(BuildContext context, int productionDataId) async {
    context.loaderOverlay.show();
    try {
      var result = await context.read<OpenProductionDataCubit>().loadProductionData(productionDataId);
      if (result != null) {
        context.read<SelectedProductionDataCubit>().selectProductionData(result);
      }
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductionDataBloc, ProductionDataState>(
          builder: (BuildContext context, state) {
            switch (state.status) {
              case ProductionDataLoadState.loading:
                return const Text("loading");
              case ProductionDataLoadState.loaded:
                return ListView.builder(
                  itemCount: state.loadedResult.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: SizedBox(
                        height: 50,
                        child: Center(child: Text(state.loadedResult[index]['ProductionLine'])),
                      ),
                      onTap: () => { loadProductionData(context, state.loadedResult[index]['ID']) }
                    );
                  }
                );
              case ProductionDataLoadState.notLoaded:
                return const Text("Not Loaded");
            }
          },
        ),
      );
  }
}