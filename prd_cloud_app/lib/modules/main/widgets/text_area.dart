import 'package:flutter/material.dart';

typedef TextAreaSetter = void Function(String? newValue);

class TextAreaInput extends StatefulWidget {
  const TextAreaInput({Key? key, String? initialValue, TextAreaSetter? onChange}) : _initialValue = initialValue, _onChange = onChange, super(key: key);

  final String? _initialValue;
  final TextAreaSetter? _onChange;

  @override
  State<TextAreaInput> createState() => _TextAreaInputState();
}

class _TextAreaInputState extends State<TextAreaInput> {

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget._initialValue != null) {
      _controller.text = widget._initialValue!;
    }
    
    if (widget._onChange != null) {
      _controller.addListener(() => widget._onChange!(_controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, 
      width: 100,
      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1,),),
      child: TextField(
        controller: _controller,
        maxLines: 8,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration.collapsed(hintText: "comentário..."),
        
      )
    );
  }

    @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }
}