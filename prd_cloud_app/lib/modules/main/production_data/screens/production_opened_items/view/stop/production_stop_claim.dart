import 'package:flutter/material.dart';
import 'package:models/models.dart';

class StopClaimField extends StatefulWidget {
  const StopClaimField({ Key? key, required this.stopClaim }) : super(key: key);

  final StopClaim stopClaim;

  @override
  State<StopClaimField> createState() => _StopClaimFieldState();
}

class _StopClaimFieldState extends State<StopClaimField> {
  @override
  Widget build(BuildContext context) {
    return widget.stopClaim.valueList.isNotEmpty ? 
      _DropdownField() :
      _TextField(value: widget.stopClaim.claimValue, onChanged: (newValue) => widget.stopClaim.claimValue = newValue,)
  }
}

class _TextField extends StatelessWidget {
  const _TextField({Key? key, this.value, this.onChanged}) : super(key: key);

  final String? value;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }
   
  
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldVariableTextCubit, FieldVariableTextState>(
      builder: (context, state) {
        return DropdownButton<String>(
          value: state.fieldValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: context.read<FieldVariableTextCubit>().updateField,
          items: state.options!.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
    );
  }
}