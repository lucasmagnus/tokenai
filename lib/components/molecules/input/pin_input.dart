import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tokenai/components/molecules/input/base_input.dart';
import 'package:tokenai/components/molecules/input/input_states.dart';
import 'package:tokenai/constants/sizes.dart';
import 'package:tokenai/utils/validator_utils.dart';

class PinInput extends StatefulWidget {
  final int fields;
  final TextInputType? keyboardType = TextInputType.number;
  final Function(String?)? onSaved;
  final InputDecoration? decoration;
  final bool autoFocus;

  const PinInput({
    Key? key,
    required this.fields,
    this.onSaved,
    this.decoration,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  bool _isFocused = false;
  late List<String> _code;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _code = List.filled(widget.fields, '');
    _controllers = List.generate(
      widget.fields,
      (int index) => TextEditingController(text: _code[index]),
    );
    _focusNodes = List.generate(
      widget.fields,
      (int index) => FocusNode(),
    );
  }

  void _onFocusChange(FocusNode node, bool focus) {
    setState(() {
      _isFocused = focus;
      if (_isFocused) node.requestFocus();
    });
  }

  void _onPinChanged(String value, int index) {
    if (validatePastedPin(value, widget.fields)) {
      for (int i = 0; i < widget.fields; i++) {
        _controllers[i].text = _code[i] = value[i];
        _onFocusChange(_focusNodes[i], true);
      }
      widget.onSaved!(_code.join());
      return;
    }
    if (value.length > 1) {
      _controllers[index].text = _code[index] = value[0];
      return;
    }
    _code[index] = value;
    if (value.isNotEmpty && index + 1 != widget.fields) {
      _onFocusChange(_focusNodes[index + 1], true);
    }
  }

  void _onSubmitted(String value) {
    if (_code.every((String digit) => digit != '')) {
      widget.onSaved!(_code.join());
    }
  }

  Widget buildPinField(int index, BuildContext context) {
    return BaseInput(
      focused: _isFocused,
      onFocusChange: _onFocusChange,
      onSaved: (value) => widget.onSaved?.call(value),
      builder: (BaseInputData data) {
        return SizedBox(
          height: pinInputSize,
          width: pinInputSize,
          child: TextField(
            autofocus: widget.autoFocus,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textInputAction: _code.length - 1 == index
                ? TextInputAction.done
                : TextInputAction.next,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            cursorColor: Theme.of(context).primaryColor,
            decoration: widget.decoration ?? data.decoration,
            onChanged: (String value) => _onPinChanged(value, index),
            onSubmitted: _onSubmitted,
          ),
        );
      },
      state: InputState.DEFAULT,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> inputFields = List.generate(widget.fields, (int index) {
      return buildPinField(index, context);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      verticalDirection: VerticalDirection.down,
      children: inputFields,
    );
  }
}
