
import 'package:error_repository/error_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:production_data_repository/production_data_repository.dart';

import 'production_opened_item_navigation.dart';

class ProductionOpenedBlocProvider extends StatelessWidget {
  const ProductionOpenedBlocProvider({Key? key, required int productionBasicDataId}) : _productionBasicDataId = productionBasicDataId, super(key: key);

  final int _productionBasicDataId;

  @override
  Widget build(BuildContext context) {

    var productionData = context.read<OpenProductionDataCubit>().state.loadedItems.firstWhere((element) => element.id == _productionBasicDataId);
    var openProductionDataRepository = context.read<OpenProductionDataRepository>();
    var errorRepository = context.read<ErrorRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FieldBeginCubit(openProductionDataRepository: openProductionDataRepository, productionBasicDataId: _productionBasicDataId, initialValue: productionData.begin)),
        BlocProvider(create: (context) => FieldEndCubit(openProductionDataRepository: openProductionDataRepository, productionBasicDataId: _productionBasicDataId, initialValue: productionData.begin)),
        BlocProvider(create: (context) => FieldCommentsCubit(openProductionDataRepository: openProductionDataRepository, productionBasicDataId: _productionBasicDataId, initialValue: productionData.comments)),
        BlocProvider(create: (context) => FieldProductCubit(openProductionDataRepository: openProductionDataRepository, productionBasicDataId: _productionBasicDataId, initialValue: productionData.productId)),
        BlocProvider(create: (context) => ProductionLossCubit(errorRepository: errorRepository, openProductionDataRepository: openProductionDataRepository, productionBasicDataId: _productionBasicDataId, initialValue: productionData.losses)),
        BlocProvider(create: (context) => ProductionStopCubit(errorRepository: errorRepository, openProductionDataRepository: openProductionDataRepository, productionBasicDataId: _productionBasicDataId, initialValue: productionData.stops))
      ], 
      child: const ProductionOpenedItemNavigation()
    );
  }

}