import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';

import 'production_stop_add.dart';
import 'stop_add_cubit/stop_add_cubit.dart';
import 'stop_add_validation_cubit copy/stop_add_validation_cubit.dart';
import 'stop_claim_cubit/stop_claim_cubit.dart';

class StopBeginTime extends StatefulWidget {
  const StopBeginTime(
      {Key? key,
      required this.productionBasicId,
      required this.selectedStop,
      required this.selectedLineUnit,
      required this.stopAddCallback})
      : super(key: key);

  final int productionBasicId;
  final Stop selectedStop;
  final LineUnit selectedLineUnit;
  final StopAddCallback stopAddCallback;

  @override
  State<StopBeginTime> createState() => _StopBeginTimeState();
}

class _StopBeginTimeState extends State<StopBeginTime> {
  DateTime? beginAtStopBeginAndTimeSpan;
  double? timeSpanAtStopBeginAndTimeSpan;

  bool isValid() =>
      beginAtStopBeginAndTimeSpan != null &&
      timeSpanAtStopBeginAndTimeSpan != null &&
      timeSpanAtStopBeginAndTimeSpan! > 0;

  @override
  Widget build(BuildContext context) {
    context.read<StopAddValidationCubit>().timeValidationState(isValid());
    return BlocListener<StopAddCubit, DateTime>(
      listener: (context, state) async {
        var result = await widget.stopAddCallback(
            lineUnitId: widget.selectedLineUnit.id,
            productionBasicDataId: widget.productionBasicId,
            stopCurrentDefinitionId: widget.selectedStop.id,
            stopType: widget.selectedStop.stopTypeOf,
            averageTimeAtStopQtyAverageTime: widget.selectedStop.averageTime,
            beginAtStopBeginAndTimeSpan: beginAtStopBeginAndTimeSpan,
            timeSpanAtStopBeginAndTimeSpan: timeSpanAtStopBeginAndTimeSpan,
            claims: context.read<StopClaimCubit>().state.stopClaims
          );
        if (result) {
          Navigator.pop(context);
        }
      },
      child: Column(
        children: [
          DateTimePicker(
            label: "Início",
            locale: Localizations.localeOf(context),
            date: beginAtStopBeginAndTimeSpan,
            onChange: (newValue) {
              setState(() {
                beginAtStopBeginAndTimeSpan = newValue;
              });
            },
          ),
          const SizedBox(height: 10),
          NumberInput(
            label: "Tempo Total (min)",
            allowDecimal: true,
            value: timeSpanAtStopBeginAndTimeSpan,
            onChanged: (newValue) {
              setState(() {
                timeSpanAtStopBeginAndTimeSpan = newValue;
              });
            },
          )
        ],
      ),
    );
  }
}
