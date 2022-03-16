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
                      return ListCard(
                        key: ObjectKey(item),
                        productionItemOfList: item
                      );
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
  

}

class ListCard extends StatefulWidget {
  const ListCard({ Key? key, required ProductionItemOfList productionItemOfList }) :
    _productionItemOfList = productionItemOfList,
    super(key: key);

  final ProductionItemOfList _productionItemOfList;

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {

  bool isLoaded = false;

  @override
  void initState() {
    isLoaded = context.read<OpenProductionDataCubit>().state.loadedItems.any((loadedItem) => loadedItem.id == widget._productionItemOfList.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OpenProductionDataCubit, OpenProductionDataState>(
      listener: (context, state) {
        var newStateIsSelected = state.loadedItems.any((loadedItem) => loadedItem.id == widget._productionItemOfList.id);
        if (newStateIsSelected != isLoaded) {
          setState(() {
            isLoaded = newStateIsSelected;
          });
        }
      },
      child: card(widget._productionItemOfList),
    );
  }

  Card card(ProductionItemOfList item) {
    
    var title = Theme.of(context).textTheme.titleLarge!;
    var bodyMedium = Theme.of(context).textTheme.bodyMedium!;
    var bodySmall = Theme.of(context).textTheme.bodySmall!;

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
                    Row(children: [ Text(item.productionLine ?? "", style: title.copyWith(fontWeight: FontWeight.normal)) ] ),
                    Padding(
                      padding: const EdgeInsets.only(left: 7.0),
                      child: Row(children: [ Text(item.product ?? "", style: bodyMedium) ] ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(children: [ Text("Início: ", style: bodyMedium), Text(dateAsString(item.begin), style: bodyMedium) ] ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(children: [ Text("Fim: ", style: bodyMedium), Text(dateAsString(item.end), style: bodyMedium) ] ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                      child: Row(children: [ Text("Criado por: ", style: bodySmall), Text(item.createdBy?.split('@')[0] ?? "", style: bodySmall) ] ),
                    )
                  ]
                )
              ),
              isLoaded ? loadedItemOptions() : unloadedItemOptions()
            ]
          ),
        ),
        onTap: () => isLoaded ? null : loadProductionData(),
        onLongPress: () => isLoaded ? unloadProductionData() : cancelProductionData(),
        onDoubleTap: () => isLoaded ? editProductionData() : null,
      )
    );
  }

  Widget unloadedItemOptions() {
    return Column(
      children: [
        Text("<clique para carregar>", style: Theme.of(context).textTheme.bodySmall),
        Text("<segure para cancelar>", style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }

  Widget loadedItemOptions() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Carregado!", style: Theme.of(context).textTheme.bodyMedium,),
        ),
        Text("<duplo clique para editar>", style: Theme.of(context).textTheme.bodySmall),
        Text("<segure para fechar>", style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }

  Future<void> loadProductionData() async {
    context.loaderOverlay.show();
    try {
      await context
          .read<OpenProductionDataCubit>()
          .loadProductionData(widget._productionItemOfList.id);
      context
          .read<SelectedProductionDataCubit>()
          .selectProductionData(widget._productionItemOfList.id);
    } finally {
      context.loaderOverlay.hide();
    }
  }

  void unloadProductionData() async {
    context.read<OpenProductionDataCubit>().closeProductionData(widget._productionItemOfList.id);
  }

  void editProductionData() async {

    context.read<SelectedProductionDataCubit>().selectProductionData(widget._productionItemOfList.id);

    context
        .read<MenuItemSelectedCubit>()
        .selectPage(MenuItemSelected.productionOpenedItems);
  }


  void cancelProductionData() async {
      context
          .read<ProductionDataCubit>()
          .cancelItem(widget._productionItemOfList.id);
  }

  String dateAsString(DateTime? date) {
    if (date == null) {
      return "";
    } else {
      return DateFormat.yMd(Localizations.localeOf(context).languageCode).add_jm().format(date);
    }
  } 

}
