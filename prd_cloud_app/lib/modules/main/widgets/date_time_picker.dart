import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DateTimePickerSetter = void Function(DateTime? newValue);

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({Key? key, DateTime? date, DateTimePickerSetter? onChange}) : _date = date, _onChange = onChange, super(key: key);

  final DateTime? _date;
  final DateTimePickerSetter? _onChange;

  _DateTimePickerState({DateTime? date, DateTimePickerSetter? onChange});

  final DateTime? _selectedDate;
  final DateTimePickerSetter? _onChange;

  DateTime initialDate;

  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2018, 1, 1),
        lastDate: DateTime.now().add(const Duration(days: 30)));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _timeController.text = formatDate(DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute), [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());
    _timeController.text = formatDate(DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute), [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
          children: [
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                width: 100,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: TextFormField(
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: _dateController,
                  decoration: const InputDecoration(
                      disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                      // labelText: 'Time',
                      contentPadding: EdgeInsets.only(top: 0.0)),
                ),
              ),
            ),
            InkWell(
              onTap: () => _selectTime(context),
              child: Container(
                width: 100,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: TextFormField(
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: _timeController,
                  decoration: const InputDecoration(
                      disabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                      // labelText: 'Time',
                      contentPadding: EdgeInsets.all(5)),
                ),
              ),
            )
          ],
        ),
    );
  }
}