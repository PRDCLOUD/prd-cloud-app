import 'package:apontamentos_repository/apontamento_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../apontamentos/apontamentos_bloc.dart';

class ProductionDataListPage extends StatelessWidget {
  const ProductionDataListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocProvider(
          create: (context) => ApontamentosBloc(apontamentosRepository: context.read<ApontamentosRepository>())..add(ApontamentosRefreshEvent(take: 100)),
          child: BlocBuilder<ApontamentosBloc, ApontamentosState>(
            builder: (BuildContext context, state) {
              switch (state.status) {
                case ApontamentosLoadState.loading:
                  return const Text("loading");
                case ApontamentosLoadState.loaded:
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
                case ApontamentosLoadState.notLoaded:
                  return const Text("Not Loaded");
              }
            },
          ),
        )
      );
      
  }
}