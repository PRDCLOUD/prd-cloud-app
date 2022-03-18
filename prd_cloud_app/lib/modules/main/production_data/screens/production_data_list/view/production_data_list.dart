import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/theme.dart';

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
      child: itemCard(widget._productionItemOfList),
    );
  }

  Card itemCard(ProductionItemOfList item) {
    
    var title = Theme.of(context).textTheme.titleLarge!;
    var bodyMedium = Theme.of(context).textTheme.bodyMedium!;
    var bodySmall = Theme.of(context).textTheme.bodySmall!;

    return Card(
      shape: AppTheme.cardShape,
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productionLine ?? "", style: title.copyWith(fontWeight: FontWeight.normal)),
                    if (item.product == null) 
                      ...[]
                    else ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: Row(children: [ Text(item.product!, style: bodyMedium) ] ),
                      )
                    ],
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(children: [ Text("Início: ", style: bodyMedium), Text(dateTimeAsString(item.begin), style: bodyMedium) ] ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(children: [ Text("Fim: ", style: bodyMedium), Text(dateTimeAsString(item.end), style: bodyMedium) ] ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                      child: Row(children: [ Text("Criado por: ", style: bodySmall), Text(auditoryText(item.createdBy, item.createdDate), style: bodySmall) ] ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                      child: Row(children: [ Text("Editado por: ", style: bodySmall), Text(auditoryText(item.updatedBy, item.updatedDate), style: bodySmall) ] ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                      child: Row(children: [ Text("Status atual: ", style: bodySmall), statusTextWidget(item.status) ] ),
                    )
                  ]
                )
              ),
              cardActions(item, isLoaded)
            ]
          ),
        )
      )
    );
  }

  Widget cardActions(ProductionItemOfList item, bool isLoaded) {
    switch (item.status) {
      case ProductionDataStatus.opened:
        return isLoaded ? openAndLoadedItemOptions() : openAndUnloadedItemOptions();
      case ProductionDataStatus.concluded:
        return concludedOrCanceledItemOptions();
      case ProductionDataStatus.canceled:
        return concludedOrCanceledItemOptions();
    }
  } 

  Future showDeleteAlertDialog() async {
    // set up the button
    Widget okButton = TextButton(
      style: TextButton.styleFrom(primary: Theme.of(context).colorScheme.error),
      child: const Text("Confirmar"),
      onPressed: () { 
        Navigator.of(context).pop();
        cancelProductionData();
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancelar"),
      onPressed: () { 
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmar exclusão"),
      content: const Text("ATENÇÃO: Você tem certeza que deseja excluir o apontamento?"),
      actions: [
        okButton,
        cancelButton
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  
  Widget openAndUnloadedItemOptions() {



    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.file_download_outlined), 
          label: const Text("Carregar"),
          onPressed: () => loadProductionData(),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.error),
          icon: const Icon(Icons.delete_outline), 
          label: const Text("Excluir"),
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Segure o botão para exluir o apontamento')),
              );
          },
          onLongPress: () => showDeleteAlertDialog(),
        )
      ],
    );
  }

  Widget openAndLoadedItemOptions() {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.edit), 
          label: const Text("Editar"),
          onPressed: () => editProductionData(),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary),
          icon: const Icon(Icons.close), 
          label: const Text("Descarregar"),
          onPressed: () => unloadProductionData(),
        )
      ],
    );
  }

  Widget concludedOrCanceledItemOptions() {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.edit), 
          label: const Text("Reabrir e editar"),
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Segure o botão para reabrir e editar o apontamento')),
              );
          },
          onLongPress: () => reopenAndEditProductionData(),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary),
          icon: const Icon(Icons.undo_outlined), 
          label: const Text("Reabrir"),
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Segure o botão para reabrir o apontamento')),
              );
          },
          onLongPress: () => reopenProductionData(),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.error),
          icon: const Icon(Icons.delete_outline), 
          label: const Text("Excluir"),
          onPressed: () => showDeleteAlertDialog(),
        )
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

  void reopenAndEditProductionData() async {

    context.loaderOverlay.show();
    try {
      var reopenSucceded = await context
          .read<ProductionDataCubit>()
          .reOpenItem(widget._productionItemOfList.id);

      if (reopenSucceded) {
        await context
            .read<OpenProductionDataCubit>()
            .loadProductionData(widget._productionItemOfList.id);

        context
            .read<SelectedProductionDataCubit>()
            .selectProductionData(widget._productionItemOfList.id);

        context
          .read<MenuItemSelectedCubit>()
          .selectPage(MenuItemSelected.productionOpenedItems);
      }
    } finally {
      context.loaderOverlay.hide();
    }

  }

  void reopenProductionData() async {

    context.loaderOverlay.show();
    try {
      await context
          .read<ProductionDataCubit>()
          .reOpenItem(widget._productionItemOfList.id);
    } finally {
      context.loaderOverlay.hide();
    }

  }


  void cancelProductionData() async {
      context
          .read<ProductionDataCubit>()
          .cancelItem(widget._productionItemOfList.id);
  }

  String auditoryText(String? by, DateTime? date) {
    if (by == null || by.isEmpty) {
      return "";
    } else if (date == null) {
      return by.split('@')[0];
    } else {
      return by.split('@')[0] + ' (' + dateAsString(date) + ')';
    }
  }

  Widget statusTextWidget(ProductionDataStatus productionDataStatus) {
    switch (productionDataStatus) {
      case ProductionDataStatus.opened:
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))
          ),
          child: Text("Em aberto", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white))
        );
      case ProductionDataStatus.canceled:
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            border: Border.all(
              color: Theme.of(context).colorScheme.error,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))
          ),
          child: Text("Cancelado", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white))
        );
      case ProductionDataStatus.concluded:
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))
          ),
          child: Text("Concluído", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white))
        );
    }
  }

  String dateTimeAsString(DateTime? date) {
    if (date == null) {
      return "";
    } else {
      return DateFormat.yMd(Localizations.localeOf(context).languageCode).add_jm().format(date);
    }
  } 

  String dateAsString(DateTime? date) {
    if (date == null) {
      return "";
    } else {
      return DateFormat.yMd(Localizations.localeOf(context).languageCode).format(date);
    }
  } 

}
