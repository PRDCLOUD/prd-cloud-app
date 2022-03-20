import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/stop_add_cubit/stop_add_cubit.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';

import 'production_stop_add.dart';
import 'stop_add_validation_cubit copy/stop_add_validation_cubit.dart';
import 'stop_claim_cubit/stop_claim_cubit.dart';

class StopQtyAverageTime extends StatefulWidget {
  const StopQtyAverageTime(
      {Key? key,
      required this.selectedStop,
      required this.selectedLineUnit,
      required this.stopAddCallback})
      : super(key: key);

  final Stop selectedStop;
  final ProductionLineUnit selectedLineUnit;
  final StopAddCallback stopAddCallback;

  @override
  State<StopQtyAverageTime> createState() => _StopQtyAverageTimeState();
}

class _StopQtyAverageTimeState extends State<StopQtyAverageTime> {
  double? qtyAtStopQtyAverageTime;

  bool isValid() => qtyAtStopQtyAverageTime != null;

  @override
  Widget build(BuildContext context) {
    context.read<StopAddValidationCubit>().timeValidationState(isValid());
    return BlocListener<StopAddCubit, DateTime>(
      listener: (context, state) async {
        var result = await widget.stopAddCallback(
            lineUnitId: widget.selectedLineUnit.id,
            productionBasicDataId: widget.selectedLineUnit.productionBasicDataId,
            stopCurrentDefinitionId: widget.selectedStop.id,
            stopType: widget.selectedStop.stopTypeOf,
            qtyAtStopQtyAverageTime: qtyAtStopQtyAverageTime!.toInt(),
            averageTimeAtStopQtyAverageTime: widget.selectedStop.averageTime,
            claims: context.read<StopClaimCubit>().state.stopClaims
          );
        if (result) {
          Navigator.pop(context);
        }
      },
      child: Column(
        children: [
          NumberInput(
            label: "Quantidade",
            allowDecimal: false,
            value: qtyAtStopQtyAverageTime,
            onChanged: (newValue) {
              setState(() {
                qtyAtStopQtyAverageTime = newValue;
              });
            },
          )
        ],
      ),
    );
  }
}
