import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/production_stop_add_begin_end.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/production_stop_add_begin_time.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/production_stop_add_qty_total_time.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/production_stop_add_total_time.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/stop_add_cubit/stop_add_cubit.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/stop_claim_cubit/stop_claim_cubit.dart';
import 'production_stop_add_qty_average.dart';
import 'production_stop_claim.dart';
import 'stop_add_validation_cubit copy/stop_add_validation_cubit.dart';

enum StopAddStates { stopSelection, lineUnitSelection, stopFill }

typedef StopAddCallback = Future<bool> Function(
    {required int productionBasicDataId,
    required int lineUnitId,
    required int stopCurrentDefinitionId,
    required StopTypeOf stopType,
    required List<StopClaim> claims,
    double? averageTimeAtStopQtyAverageTime,
    int? qtyAtStopQtyAverageTime,
    DateTime? beginAtStopBeginAndTimeSpan,
    double? timeSpanAtStopBeginAndTimeSpan,
    DateTime? beginAtStopBeginEnd,
    DateTime? endAtStopBeginEnd,
    int? qtyAtStopQtyTotalTime,
    double? totalTimeAtStopQtyTotalTime,
    double? stopTimeAtStopTimePerStop});

class StopAdd extends StatefulWidget {
  const StopAdd(
      {Key? key,
      required this.stopOptions,
      required this.lineUnits,
      required this.stopAddCallback,
      required this.productionBasicId})
      : super(key: key);

  final int productionBasicId;
  final List<Stop> stopOptions;
  final List<LineUnit> lineUnits;
  final StopAddCallback stopAddCallback;

  @override
  State<StopAdd> createState() => _StopAddState();
}

class _StopAddState extends State<StopAdd> {
  StopAddStates stopAddStates = StopAddStates.stopSelection;

  Stop? selectedStop;
  LineUnit? selectedLineUnit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text("CADASTRO DE PARADA", style: Theme.of(context).textTheme.headline6),
        Expanded(child: _dialogBody()),
      ],
    );
  }

  Widget _dialogBody() {
    switch (stopAddStates) {
      case StopAddStates.stopSelection:
        return Column(
          children: [
            Expanded(child: _stopSelection()), 
            _flowControlButtons()
          ],
        );
      case StopAddStates.lineUnitSelection:
        return Column(
          children: [
            _selectedLossTopCard(),
            Expanded(child: _lineUnitSelection()),
            _flowControlButtons()
          ],
        );
      case StopAddStates.stopFill:
        return SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => StopClaimCubit(stopClaims: selectedStop!.stopClaims)),
            ],
            child: _FlowBlocProviders(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    _selectedLossTopCard(),
                    const SizedBox(height: 10),
                    _selectedLineUnitCard(),
                    const SizedBox(height: 10),
                    _stopInformationFill(),
                    const SizedBox(height: 10),
                    const StopClaims(),
                    const SizedBox(height: 10),
                    _flowControlButtons()
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }

  Widget _lineUnitSelection() {
    var lineUnits = widget.lineUnits
        .where((lineUnit) => selectedStop!.lineUnitStops.contains(lineUnit.id))
        .toList();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: Text("Selecione o local", style: Theme.of(context).textTheme.titleMedium)),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: lineUnits.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Card(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Text(lineUnits[index].name)
                  )
                ),
                onTap: () => selectLineUnit(lineUnits[index])
              );
            },
          )
        ),
      ],
    );
  }

  Widget _stopSelection() {

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: Text("Selecione a Parada", style: Theme.of(context).textTheme.titleMedium)
        ),
        Expanded(
          child: _ListOfStops(
            stops: widget.stopOptions,
            selectStopCallback: selectStop
          ),
        )
      ],
    );
  }

  void backOneStage() {
    if (stopAddStates == StopAddStates.lineUnitSelection) {
      backToStopSelectionStage();
    } else if (stopAddStates == StopAddStates.stopFill) {
      backToLineUnitSelectionStage();
    }
  }

  void backToStopSelectionStage() {
    setState(() {
      selectedStop = null;
      stopAddStates = StopAddStates.stopSelection;
      selectedLineUnit = null;
    });
  }

  void backToLineUnitSelectionStage() {
    setState(() {
      selectedLineUnit = null;
      stopAddStates = StopAddStates.lineUnitSelection;
    });
  }

  void selectStop(Stop stop) {
    setState(() {
      selectedStop = stop;
      stopAddStates = StopAddStates.lineUnitSelection;
      selectedLineUnit = null;

      var lineUnits = widget.lineUnits
        .where((lineUnit) => selectedStop!.lineUnitStops.contains(lineUnit.id))
        .toList();

      if (lineUnits.length == 1) {
        selectedLineUnit = lineUnits.first;
        stopAddStates = StopAddStates.stopFill;
      }

    });
  }

  void selectLineUnit(LineUnit lineUnit) {
    setState(() {
      selectedLineUnit = lineUnit;
      stopAddStates = StopAddStates.stopFill;
    });
  }

  Widget _stopInformationFill() {
    switch (selectedStop!.stopTypeOf) {
      case StopTypeOf.QtyAverageTime:
        return StopQtyAverageTime(
            productionBasicId: widget.productionBasicId,
            selectedLineUnit: selectedLineUnit!,
            selectedStop: selectedStop!,
            stopAddCallback: widget.stopAddCallback);
      case StopTypeOf.QtyTotalTime:
        return StopQtyTotalTime(
            productionBasicId: widget.productionBasicId,
            selectedLineUnit: selectedLineUnit!,
            selectedStop: selectedStop!,
            stopAddCallback: widget.stopAddCallback);
      case StopTypeOf.TimeBegin:
        return StopBeginTime(
            productionBasicId: widget.productionBasicId,
            selectedLineUnit: selectedLineUnit!,
            selectedStop: selectedStop!,
            stopAddCallback: widget.stopAddCallback);
      case StopTypeOf.TimePerStop:
        return StopTimePerStop(
            productionBasicId: widget.productionBasicId,
            selectedLineUnit: selectedLineUnit!,
            selectedStop: selectedStop!,
            stopAddCallback: widget.stopAddCallback);
      case StopTypeOf.BeginEnd:
        return StopBeginEnd(
            productionBasicId: widget.productionBasicId,
            selectedLineUnit: selectedLineUnit!,
            selectedStop: selectedStop!,
            stopAddCallback: widget.stopAddCallback);
      default:
        throw Exception('Invalid StopTypeOf');
    }
  }

  Widget _flowControlButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        if (stopAddStates != StopAddStates.stopSelection) ...[
          ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text("Voltar"),
              onPressed: () => backOneStage(),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  minimumSize: const Size(1, 50)))
        ] else
          ...[],
        if (stopAddStates == StopAddStates.stopFill) ...[
          BlocBuilder<StopAddValidationCubit, StopAddValidationState>(
            builder: (context, state) {
              return ElevatedButton(
                  child: const Text("Adicionar"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(1, 50),
                      primary: Theme.of(context).colorScheme.primary),
                  onPressed: state.timeValidation == TimeValidation.invalid ?
                    null :
                    () => context.read<StopAddCubit>().addStop()
                  );
            },
          )
        ] else
          ...[],
        ElevatedButton.icon(
            icon: const Icon(Icons.close),
            label: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(1, 50),
                primary: Theme.of(context).colorScheme.error)),
      ]),
    );
  }

  Widget _selectedLossTopCard() {
    var textStyle =
        Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white);
    return InkWell(
      child: Card(
        color: Theme.of(context).primaryColor,
        borderOnForeground: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Row(
            children: [
              Text("Parada:", style: textStyle.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Flexible(child: Text(selectedStop!.codeName, style: textStyle))
            ],
          ),
        )
      ),
      onTap: () => backToStopSelectionStage(),
    );
  }

  Widget _selectedLineUnitCard() {
    var textStyle =
        Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white);
    return InkWell(
      child: Card(
        color: Theme.of(context).primaryColor,
        borderOnForeground: true,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Row(
            children: [
              Text("Local:",
                  style: textStyle.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Text(selectedLineUnit!.name, style: textStyle)
            ],
          ),
        ),
      ),
      onTap: () => backToLineUnitSelectionStage(),
    );
  }
}



class _FlowBlocProviders extends StatelessWidget {
  const _FlowBlocProviders({ Key? key, required Widget child }) : _child = child, super(key: key);

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => StopAddValidationCubit(isTimeValid: false, isClaimValid: context.read<StopClaimCubit>().state.isStopClaimFillValid())),
        BlocProvider(create: (context) => StopAddCubit()),
      ],
      child: _FlowBlocListerner(
        child: _child)
      );
  }
}

class _FlowBlocListerner extends StatelessWidget {
  const _FlowBlocListerner({ Key? key, required Widget child }) : _child = child, super(key: key);

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StopClaimCubit, StopClaimState>(
      listener: (context, state) {
        context.read<StopAddValidationCubit>().claimValidationState(state.isStopClaimFillValid());
      },
      child: _child,
    );
  }
}

typedef SelectStopCallback = Function(Stop stop);
class _ListOfStops extends StatefulWidget {
  const _ListOfStops({ Key? key, required List<Stop> stops, required SelectStopCallback selectStopCallback }) : _stops = stops, _selectStopCallback = selectStopCallback, super(key: key);

  final List<Stop> _stops;
  final SelectStopCallback _selectStopCallback;

  @override
  State<_ListOfStops> createState() => _ListOfStopsState();
}

class _ListOfStopsState extends State<_ListOfStops> {

  List<Stop> filteredStops = List.empty();

  void _runFilter(String? searchValue) {

    var lcSearchValue = searchValue?.toLowerCase() ?? "";

    List<Stop> results;
    if (lcSearchValue.isEmpty) {
      results = widget._stops;
    } else {
      results = widget._stops
          .where((user) =>
              user.codeName.toLowerCase().contains(lcSearchValue))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

      // Refresh the UI
    setState(() {
      filteredStops = results;
    });

  }

  @override
  void initState() {
    filteredStops = widget._stops;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 500,
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))),
                labelText: 'Pesquisa', suffixIcon: Icon(Icons.search)
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        Expanded(
          child: filteredStops.isEmpty
            ? const Text('Nenhum resultado', style: TextStyle(fontSize: 24))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredStops.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    key: ValueKey(filteredStops[index].id),
                    title: Card(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(filteredStops[index].codeName)
                      )
                    ),
                    onTap: () => widget._selectStopCallback(filteredStops[index])
                  );
                },
              ),
        ),
      ],
    );
  }
}