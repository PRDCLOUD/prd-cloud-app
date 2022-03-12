
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/field_begin_cubit/field_begin_cubit.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:production_data_repository/production_data_repository.dart';

import 'production_opened_item_navigation.dart';

class ProductionOpenedBlocProvider extends StatelessWidget {
  const ProductionOpenedBlocProvider({Key? key, required int productionBasicDataId}) : _productionBasicDataId = productionBasicDataId, super(key: key);

  final int _productionBasicDataId;

  @override
  Widget build(BuildContext context) {

    var productionData = context.read<SelectedProductionDataCubit>().state.selectedItem as ProductionBasicData;
    var openProductionDataRepository = context.read<OpenProductionDataRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FieldBeginCubit(openProductionDataRepository: openProductionDataRepository, productionBasicDataId: _productionBasicDataId, initialValue: productionData.begin))
      ], 
      child: ProductionOpenedItemNavigation()
    );
  }

}