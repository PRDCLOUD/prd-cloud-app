import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/stop_claim_cubit/stop_claim_cubit.dart';

class StopClaims extends StatelessWidget {
  const StopClaims({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var claims = context.read<StopClaimCubit>().state.stopClaims;
    return Column(
      children: claims.map((x) => 
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: StopClaimField(
            key: ValueKey("Stop_Claim_" + x.claim),
            claim: x.claim,
            onTheFly: x.onTheFly,
            initialValue: x.claimValue ?? x.defaultValue,
            valueList: x.valueList,
            onClaimValueChanged: (newValue) => context.read<StopClaimCubit>().updateStopClaim(x.claim, newValue),
          ),
        )
      ).cast<Widget>().toList(),
    );
  }
}

class StopClaimField extends StatefulWidget {
  const StopClaimField(
      {Key? key,
      required this.claim,
      this.initialValue,
      this.valueList,
      required this.onTheFly,
      this.onClaimValueChanged})
      : super(key: key);

  final String claim;
  final String? initialValue;
  final List<String>? valueList;
  final bool onTheFly;
  final Function(String?)? onClaimValueChanged;

  @override
  State<StopClaimField> createState() => _StopClaimFieldState();
}

class _StopClaimFieldState extends State<StopClaimField> {
  @override
  Widget build(BuildContext context) {
    return widget.valueList != null && widget.valueList!.isNotEmpty
        ? _DropdownField(
            label: widget.claim,
            initialValue: widget.initialValue,
            onChanged:widget.onClaimValueChanged,
            options: widget.valueList!
          )

        : _TextField(
            label: widget.claim,
            initialValue: widget.initialValue,
            onChanged: widget.onClaimValueChanged
          );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({Key? key, required this.label, this.initialValue, this.onChanged})
      : super(key: key);

  final String label;
  final String? initialValue;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        label: Text(label),
      ),
    );
  }
}

class _DropdownField extends StatefulWidget {
  const _DropdownField(
      {Key? key, this.initialValue, required this.label, required this.options, this.onChanged})
      : super(key: key);

  final String label;
  final String? initialValue;
  final List<String> options;
  final void Function(String?)? onChanged;

  @override
  State<_DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<_DropdownField> {
  String? value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        label: Text(widget.label),
      ),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      onChanged: (newValue) {
        if (widget.onChanged != null) {
          widget.onChanged!(newValue);
        }
        setState(() {
          value = newValue;
        });
      },
      items: widget.options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class EditableStopClaim {
  final StopClaim stopClaim;

  String? value;

  EditableStopClaim(this.stopClaim) {
    value = stopClaim.claimValue ?? stopClaim.defaultValue;
  }
}
