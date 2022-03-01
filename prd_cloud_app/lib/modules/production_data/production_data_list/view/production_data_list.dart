import 'package:apontamentos_repository/apontamento_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/production_data_bloc.dart';

class ProductionDataListPage extends StatelessWidget {
  const ProductionDataListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocProvider(
          create: (context) => ProductionDataBloc(apontamentosRepository: context.read<ApontamentosRepository>())..add(ApontamentosRefreshEvent(take: 100)),
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
                        onTap: () => {}
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