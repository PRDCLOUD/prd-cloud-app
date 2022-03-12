import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DateTimePickerSetter = void Function(DateTime? newValue);

class DateTimePicker extends StatelessWidget {
  DateTimePicker({Key? key, DateTime? date, DateTimePickerSetter? onChange, Locale? locale}) : 
  _date = date, 
  _onChange = onChange, 
  _dateController = TextEditingController(text: date == null ? null : DateFormat.yMd(locale).add_jm().format(date)),
  super(key: key);

  final DateTime? _date;
  final DateTimePickerSetter? _onChange;

  final TextEditingController _dateController;

  Future<void> _selectDate(BuildContext context) async {
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
    return Scaffold(
      body: Row(
          children: [
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                width: 150,
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
            )
          ],
        ),
    );
  }
}