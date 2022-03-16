import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';

class ProductionDataList extends StatefulWidget {
  const ProductionDataList({Key? key}) : super(key: key);

  @override
  State<ProductionDataList> createState() => _ProductionDataListState();
}

class _ProductionDataListState extends State<ProductionDataList> {
  
  Future<void> loadProductionData(int productionDataId) async {
    context.loaderOverlay.show();
    try {
      await context
          .read<OpenProductionDataCubit>()
          .loadProductionData(productionDataId);
      // This delay is required in order for the cubit update its state
      await Future.delayed(const Duration(milliseconds: 15));
      var prdData = context
          .read<OpenProductionDataCubit>()
          .state
          .loadedItems
          .firstWhere((element) => element.id == productionDataId);
      context
          .read<SelectedProductionDataCubit>()
          .selectProductionData(prdData.id);
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  void initState() {
    var currentFilteredDataState = context.read<ProductionDataCubit>().state;
    if (currentFilteredDataState.status == ProductionDataLoadState.notLoaded) {
      context.read<ProductionDataCubit>().filter(context.read<ProductionListFilterCubit>().state);
    } else if (currentFilteredDataState.status == ProductionDataLoadState.loaded) {
      var filter = context.read<ProductionListFilterCubit>().state;
      if (currentFilteredDataState.filter != filter) {
        context.read<ProductionDataCubit>().filter(context.read<ProductionListFilterCubit>().state);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocListener<ProductionListFilterCubit, ProductionDataFilter>(
        listener: (context, state) {
          if (state != context.read<ProductionDataCubit>().state.filter) {
            context.read<ProductionDataCubit>().filter(state);
          }
        },
        child: BlocConsumer<ProductionDataCubit, ProductionDataState>(
          listener: (context, state) {
            if (state.status == ProductionDataLoadState.loading) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
            }
          },
          builder: (BuildContext context, state) {
            switch (state.status) {
              case ProductionDataLoadState.loading:
                context.loaderOverlay.show();
                return const Center(child: Text("carregando..."));
              case ProductionDataLoadState.loaded:
                return RefreshIndicator(
                  onRefresh: context.read<ProductionDataCubit>().refresh,
                  child: ListView.builder(
                    itemCount: state.loadedResult.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = state.loadedResult[index];
                      return card(item);
                    }
                  )
                );
              case ProductionDataLoadState.notLoaded:
                return const Center(child: Text("Não carregado!"));
            }
          },
        ),
      ),
    );
  }
  
  Card card(ProductionItemOfList item) {
    
    var title = Theme.of(context).textTheme.titleLarge!;
    var bodyMedium = Theme.of(context).textTheme.bodyMedium!;

    return Card(
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [ Text("Linha: ", style: title), Text(item.productionLine ?? "", style: title.copyWith(fontWeight: FontWeight.normal)) ] ),
                    Row(children: [ Text("Produto: ", style: bodyMedium), Text(item.product ?? "", style: bodyMedium) ] ),
                    Row(children: [ Text("Início: ", style: bodyMedium), Text(dateAsString(item.begin), style: bodyMedium) ] ),
                    Row(children: [ Text("Fim: ", style: bodyMedium), Text(dateAsString(item.end), style: bodyMedium) ] )
                  ]
                )
              ),
              Column(
                children: [
                  item.status == ProductionDataStatus.opened ? Icon(Icons.edit) : Icon(Icons.open_in_new)
                ],
              )
            ]
          ),
        ),
        onTap: () => loadProductionData(item.id)
      )
    );
  }

  String dateAsString(DateTime? date) {
    if (date == null) {
      return "";
    } else {
      return DateFormat.yMd(Localizations.localeOf(context).languageCode).add_jm().format(date);
    }
  } 
}
