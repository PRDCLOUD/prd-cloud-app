import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/production_data/bloc/cubit/open_production_data_cubit.dart';
import 'package:production_data_repository/production_data_repository.dart';
import '../bloc/production_data_bloc.dart';

class ProductionDataListPage extends StatelessWidget {
  const ProductionDataListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ProductionDataBloc(apontamentosRepository: context.read<ProductionDataRepository>())..add(ApontamentosRefreshEvent(take: 100))),
            BlocProvider(create: (context) => OpenProductionDataCubit(productionDataRepository: context.read<ProductionDataRepository>()))
          ],
          child: BlocBuilder<ProductionDataBloc, ProductionDataState>(
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
                        onTap: () => { context.read<OpenProductionDataCubit>().insertProductionData(state.loadedResult[index]['ID'])}
                      );
                    }
                  );
                case ProductionDataLoadState.notLoaded:
                  return const Text("Not Loaded");
              }
            },
          ),
        )
      );
      
  }
}