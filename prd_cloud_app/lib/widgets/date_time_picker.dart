import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DateTimePickerSetter = void Function(DateTime? newValue);

class DateTimePicker extends StatelessWidget {
  DateTimePicker({
    Key? key, 
    DateTime? date,
    double? width,
    DateTimePickerSetter? onChange, 
    required String label,
    required Locale locale,
    required bool enabled
    }) : 
  _date = date, 
  _onChange = onChange, 
  _label = label,
  _disabled = !enabled,
  _width = width,
  _dateController = TextEditingController(text: date == null ? null : DateFormat.yMd(locale.languageCode).add_jm().format(date)),
  super(key: key);

  final DateTime? _date;
  final String _label;
  final DateTimePickerSetter? _onChange;
  final bool _disabled;
  final double? _width;


  final TextEditingController _dateController;

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2018, 1, 1),
      lastDate: DateTime.now().add(const Duration(days: 30))
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay(hour: _date?.hour ?? 0, minute: _date?.minute ?? 0));
    if (pickedTime == null) return;

    var pickedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute, 0);
    
    if (_onChange != null) {
      _onChange!(pickedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _disabled ? null : () => _selectDate(context),
      child: Container(
        width: _width ?? double.infinity,

        alignment: Alignment.center,
        child: TextFormField(
          enabled: false,
          keyboardType: TextInputType.text,
          controller: _dateController,
          decoration: InputDecoration(
            label: Text(_label, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black54)),
            enabled: false,
          ).copyWith(
            disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54))
          ),
        ),
      ),
    );
  }
}

class DatePicker extends StatelessWidget {
  DatePicker({
    Key? key, 
    DateTime? date,
    double? width,
    DateTimePickerSetter? onChange, 
    required String label,
    required Locale locale,
    required bool enabled
    }) : 
  _date = date, 
  _onChange = onChange, 
  _label = label,
  _disabled = !enabled,
  _width = width,
  _dateController = TextEditingController(text: date == null ? null : DateFormat.yMd(locale.languageCode).format(date)),
  super(key: key);

  final DateTime? _date;
  final String _label;
  final DateTimePickerSetter? _onChange;
  final bool _disabled;
  final double? _width;

  final TextEditingController _dateController;

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2018, 1, 1),
      lastDate: DateTime.now().add(const Duration(days: 30))
    );
    if (pickedDate == null) return;

    var pickedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 0, 0, 0);
    
    if (_onChange != null) {
      _onChange!(pickedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _disabled ? null : () => _selectDate(context),
      child: Container(
        width: _width ?? double.infinity,

        alignment: Alignment.center,
        child: TextFormField(
          enabled: false,
          keyboardType: TextInputType.text,
          controller: _dateController,
          decoration: InputDecoration(
            label: Text(_label, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black54)),
            enabled: false,
          ).copyWith(
            disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54))
          ),
        ),
      ),
    );
  }
}

class TimePicker extends StatelessWidget {
  TimePicker({
    Key? key, 
    DateTime? date,
    double? width,
    DateTimePickerSetter? onChange, 
    required String label,
    required Locale locale,
    required bool enabled
    }) : 
  _date = date, 
  _onChange = onChange, 
  _label = label,
  _disabled = !enabled,
  _width = width,
  _dateController = TextEditingController(text: date == null ? null : DateFormat.Hm(locale.languageCode).format(date)),
  super(key: key);

  final DateTime? _date;
  final String _label;
  final DateTimePickerSetter? _onChange;
  final bool _disabled;
  final double? _width;

  final TextEditingController _dateController;

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay(hour: _date?.hour ?? 0, minute: _date?.minute ?? 0));
    if (pickedTime == null) return;

    var pickedDateTime = DateTime(1970, 1, 1, pickedTime.hour, pickedTime.minute, 0);
    
    if (_onChange != null) {
      _onChange!(pickedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _disabled ? null : () => _selectDate(context),
      child: Container(
        width: _width ?? double.infinity,

        alignment: Alignment.center,
        child: TextFormField(
          enabled: false,
          keyboardType: TextInputType.text,
          controller: _dateController,
          decoration: InputDecoration(
            label: Text(_label, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black54)),
            enabled: false,
          ).copyWith(
            disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54))
          ),
        ),
      ),
    );
  }
}

