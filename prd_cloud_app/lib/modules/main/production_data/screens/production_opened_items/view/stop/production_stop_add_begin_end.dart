import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/stop_add_validation_cubit%20copy/stop_add_validation_cubit.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';

import 'production_stop_add.dart';
import 'production_stop_claim.dart';
import 'stop_add_cubit/stop_add_cubit.dart';

class StopBeginEnd extends StatefulWidget {
  StopBeginEnd({ 
    Key? key, 
    required this.productionBasicId,
    required this.selectedStop,
    required this.selectedLineUnit,
    required this.stopAddCallback
  }) : super(key: key) {
    editableStopClaim = selectedStop.stopClaims.map((e) => EditableStopClaim(e)).toList();
  }

  final int productionBasicId;
  final Stop selectedStop;
  final LineUnit selectedLineUnit;
  final StopAddCallback stopAddCallback;

  late List<EditableStopClaim> editableStopClaim;

  @override
  State<StopBeginEnd> createState() => _StopBeginEndState();
}

class _StopBeginEndState extends State<StopBeginEnd> {

  DateTime? beginAtStopBeginEnd;
  DateTime? endAtStopBeginEnd;

  bool isValid() => !(beginAtStopBeginEnd == null || endAtStopBeginEnd == null || endAtStopBeginEnd!.isAtSameMomentAs(beginAtStopBeginEnd!) || endAtStopBeginEnd!.isBefore(beginAtStopBeginEnd!));

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
          claims: widget.selectedStop.stopClaims,
          beginAtStopBeginEnd: beginAtStopBeginEnd,
          endAtStopBeginEnd: endAtStopBeginEnd
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
