import 'package:flutter/material.dart';
import 'package:tokenai/components/atoms/custom_icon.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';
import 'package:tokenai/components/molecules/input/base_input.dart';
import 'package:tokenai/constants/all.dart';
import 'package:tokenai/utils/date_utils.dart';

import 'input_states.dart';

class DatePickerInput extends StatefulWidget {
  final DateTime? initialDate;
  final DateTimeRange? initialRangeDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool isRangePicker;
  final bool disabled;
  final String datePattern;
  final String label;
  final String? helperText;
  final String placeholder;
  final InputState state;
  final void Function(DateTime?)? onDateSelected;
  final void Function(DateTimeRange?)? onDateRangeSelected;

  const DatePickerInput({
    required this.firstDate,
    required this.lastDate,
    required this.label,
    required this.placeholder,
    required this.datePattern,
    required this.state,
    this.helperText,
    this.initialDate,
    this.initialRangeDate,
    this.isRangePicker = false,
    this.disabled = false,
    this.onDateSelected,
    this.onDateRangeSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerInput> createState() => _DatePickerInputState();
}

class _DatePickerInputState extends State<DatePickerInput> {
  bool _isOpen = false;

  String start = '';
  String end = '';

  @override
  void initState() {
    _setInitialDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseInput(
      label: widget.label,
      helperText: widget.helperText,
      state: widget.state,
      disabled: widget.disabled,
      focused: _isOpen,
      builder: (BaseInputData data) {
        return GestureDetector(
          onTap: widget.disabled ? null : _onTap,
          child: InputDecorator(
            decoration: data.decoration.copyWith(
              suffix: _getCalendarIcon(data.mainColor),
            ),
            child: _getContent(),
          ),
        );
      },
    );
  }

  void _onTap() => widget.isRangePicker ? _showDateRangePicker() : _showDatePicker();

  Widget _getContent() {
    if (start.isNotEmpty && end.isNotEmpty) {
      return CustomText(
        text: '$start - $end',
        style: TypographyStyle.P4,
        color: Theme.of(context).kNeutralBlackishColorLight,
        textOverflow: TextOverflow.ellipsis,
      );
    }
    if (start.isNotEmpty) {
      return CustomText(
        text: start,
        style: TypographyStyle.P4,
        color: Theme.of(context).kNeutralBlackishColorLight,
        textOverflow: TextOverflow.ellipsis,
      );
    }

    return CustomText(
      text: widget.placeholder,
      style: TypographyStyle.P4,
      textOverflow: TextOverflow.ellipsis,
    );
  }

  Widget _getCalendarIcon(Color color) {
    return CustomIcon(
      svgIconPath: AppAssets.CALENDAR,
      color: color,
      height: 14,
      width: 32,
    );
  }

  Widget _buildDatePicker(BuildContext context, Widget? child) {
    return Theme(
      data: ThemeData(
        fontFamily: fontFamily,
        primaryColor: Theme.of(context).kPrimaryColor,
        colorScheme: ColorScheme.light(primary: Theme.of(context).kPrimaryColor),
        primaryIconTheme: IconThemeData(color: Theme.of(context).kTextPrimaryColor),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(TypographyStyle.L1.value),
          ),
        ),
      ),
      child: child ?? Container(),
    );
  }

  void _setInitialDate() {
    if (widget.isRangePicker) {
      start = widget.initialRangeDate != null ? dateToString(widget.datePattern, widget.initialRangeDate!.start) : '';
      end = widget.initialRangeDate != null ? dateToString(widget.datePattern, widget.initialRangeDate!.end) : '';
    } else {
      start = widget.initialDate != null ? dateToString(widget.datePattern, widget.initialDate!) : '';
    }
  }

  void _setIsOpen(bool value) {
    setState(() {
      _isOpen = value;
    });
  }

  void _showDatePicker() async {
    _setIsOpen(true);

    final result = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      builder: _buildDatePicker,
    );

    if (result != null) {
      start = dateToString(widget.datePattern, result);
    }
    widget.onDateSelected?.call(result);

    _setIsOpen(false);
  }

  void _showDateRangePicker() async {
    final result = await showDateRangePicker(
      context: context,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      initialDateRange: widget.initialRangeDate,
      builder: _buildDatePicker,
    );

    if (result != null) {
      start = dateToString(widget.datePattern, result.start);
      end = dateToString(widget.datePattern, result.end);
    }

    widget.onDateRangeSelected?.call(result);
  }
}
