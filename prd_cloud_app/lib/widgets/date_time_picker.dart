import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';

typedef DateTimePickerSetter = void Function(DateTime? newValue);

class DateTimePicker extends StatelessWidget {
  DateTimePicker({
    Key? key, 
    DateTime? date, 
    DateTimePickerSetter? onChange, 
    required String label,
    required Locale locale
    }) : 
  _date = date, 
  _onChange = onChange, 
  _label = label,
  _dateController = TextEditingController(text: date == null ? null : DateFormat.yMd(locale.languageCode).add_jm().format(date)),
  super(key: key);

  final DateTime? _date;
  final String _label;
  final DateTimePickerSetter? _onChange;

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

    final TimeOfDay? pickedTime = await showTimePickerSpin(context: context, initialTime: TimeOfDay(hour: _date?.hour ?? 0, minute: _date?.minute ?? 0));

    
    if (pickedTime == null) return;

    var pickedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute, 0);
    
    if (_onChange != null) {
      _onChange!(pickedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        width: 200,

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

Future<TimeOfDay?> showTimePickerSpin({ required BuildContext context, TimeOfDay? initialTime }) async {
  return showDialog<TimeOfDay>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return TimpePickerSpin(initialTime: initialTime);
    },
  );
}



}

class TimpePickerSpin extends StatefulWidget {
  TimpePickerSpin({ 
    Key? key, 
    this.initialTime,
  }) : super(key: key);

  TimeOfDay? initialTime;

  @override
  State<TimpePickerSpin> createState() => _TimpePickerSpinState();
}

class _TimpePickerSpinState extends State<TimpePickerSpin> {

  TimeOfDay? time;

  @override
  void initState() {
    time = widget.initialTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('SELECIONAR HORÁRIO', style: Theme.of(context).textTheme.titleSmall),
        content: TimePickerSpinner(
          is24HourMode: true,
          normalTextStyle: const TextStyle(

          ),
          highlightedTextStyle: const TextStyle(
          ),
          spacing: 30,
          itemHeight: 30,
          time: DateTime(2020, 1, 1, widget.initialTime?.hour ?? 0, widget.initialTime?.minute ?? 0),
          isForce2Digits: true,
          
          onTimeChange: (time) {
            setState(() {
              this.time = TimeOfDay(hour: time.hour, minute: time.minute);
            });
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('CANCELAR'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(time);
            },
          ),
        ],
      );
  }
}
