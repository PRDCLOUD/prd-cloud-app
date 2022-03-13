import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

typedef NumberInputChanged = void Function(double? newValue);
class NumberInput extends StatelessWidget {
  const NumberInput({
    Key? key,
    this.controller,
    this.value,
    required this.label,
    this.onChanged,
    this.error,
    this.icon,
    this.allowDecimal = false,
    this.disabled = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final double? value;
  final String label;
  final NumberInputChanged? onChanged;
  final String? error;
  final Widget? icon;
  final bool allowDecimal;
  final bool disabled;
  
  void onChangedParse(String? newValue) {
    if (onChanged != null) {
      if (newValue == null || newValue == "") {
        onChanged!(null);
      } else {
        var format = NumberFormat("###.0#", "en_US");
        var newValueDouble = format.parse(newValue);
        onChanged!(newValueDouble.toDouble());
      }
    }
  }

  String? setterParse(double? value) {
    if (value == null) {
      return null;
    } else {
      var format = NumberFormat("##0.##", "en_US");
      return format.format(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: setterParse(value),
      onChanged: onChangedParse,
      readOnly: disabled,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(_getRegexString())),
        TextInputFormatter.withFunction(
          (oldValue, newValue) => newValue.copyWith(
            text: newValue.text.replaceAll(',', ''),
          ),
        ),
      ],
      decoration: InputDecoration(
        label: Text(label),
        errorText: error,
        icon: icon,
      ),
    );
  }
  String _getRegexString() =>
      allowDecimal ? r'[0-9]+[,.]{0,1}[0-9]*' : r'[0-9]';
}
