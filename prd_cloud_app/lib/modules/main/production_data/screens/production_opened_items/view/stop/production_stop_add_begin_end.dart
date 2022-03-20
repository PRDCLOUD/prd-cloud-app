import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/stop_add_validation_cubit%20copy/stop_add_validation_cubit.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/stop_claim_cubit/stop_claim_cubit.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';

import 'production_stop_add.dart';
import 'stop_add_cubit/stop_add_cubit.dart';

class StopBeginEnd extends StatefulWidget {
  const StopBeginEnd({ 
    Key? key, 
    required this.selectedStop,
    required this.selectedLineUnit,
    required this.stopAddCallback
  }) : super(key: key);

  final Stop selectedStop;
  final ProductionLineUnit selectedLineUnit;
  final StopAddCallback stopAddCallback;

  @override
  State<StopBeginEnd> createState() => _StopBeginEndState();
}

class _StopBeginEndState extends State<StopBeginEnd> {

  DateTime? beginAtStopBeginEnd;
  DateTime? endAtStopBeginEnd;

  bool isValid() => beginAtStopBeginEnd != null && endAtStopBeginEnd != null && !endAtStopBeginEnd!.isAtSameMomentAs(beginAtStopBeginEnd!) && endAtStopBeginEnd!.isAfter(beginAtStopBeginEnd!);

  @override
  Widget build(BuildContext context) {
    context.read<StopAddValidationCubit>().timeValidationState(isValid());
    return BlocListener<StopAddCubit, DateTime>(
      listener: (context, state) async {
        var result = await widget.stopAddCallback(
          lineUnitId: widget.selectedLineUnit.lineUnitId,
          productionBasicDataId: widget.selectedLineUnit.productionBasicDataId,
          stopCurrentDefinitionId: widget.selectedStop.id,
          stopType: widget.selectedStop.stopTypeOf,
          averageTimeAtStopQtyAverageTime: widget.selectedStop.averageTime,
          beginAtStopBeginEnd: beginAtStopBeginEnd,
          endAtStopBeginEnd: endAtStopBeginEnd,
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
              date: beginAtStopBeginEnd,
              onChange: (newValue) {
                setState(() {
                  beginAtStopBeginEnd = newValue;
                });
              },
            ),
            const SizedBox(height: 10),
            DateTimePicker(
              label: "Fim",
              locale: Localizations.localeOf(context),
              date: endAtStopBeginEnd,
              onChange: (newValue) {
                setState(() {
                  endAtStopBeginEnd = newValue;
                });
              },
            )
          ],
        ),
    );
  }

}
