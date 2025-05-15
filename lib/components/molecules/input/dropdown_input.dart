import 'package:flutter/material.dart';
import 'package:tokenai/components/atoms/custom_icon.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';
import 'package:tokenai/components/molecules/input/input_states.dart';
import 'package:tokenai/constants/all.dart';
import 'package:tokenai/utils/widget_utils.dart';

import 'base_input.dart';

class DropdownInput extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final String? helperText;
  final Map<dynamic, String> items;
  final InputState state;
  final dynamic initialValue;
  final Function(dynamic) onValueSelected;
  final int maxItemsVisible;
  final bool disabled;
  final Widget Function(Color)? iconBuilder;
  final Function(dynamic)? onSaved;
  final String? Function(dynamic)? validator;

  const DropdownInput({
    required this.items,
    required this.onValueSelected,
    this.label,
    this.disabled = false,
    this.helperText,
    this.iconBuilder,
    this.initialValue,
    this.maxItemsVisible = 5,
    this.placeholder,
    this.state = InputState.DEFAULT,
    this.onSaved,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> with SingleTickerProviderStateMixin {
  bool _isOpen = false;

  dynamic _selectedValue;

  final GlobalKey _dropdownKey = GlobalKey();

  late final AnimationController _arrowAnimationController;
  final int _animationDuration = 250;
  final double _animationBegin = 0.0;
  final double _animationEnd = 0.5;

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  FormFieldState<dynamic>? _formField;

  @override
  void initState() {
    _arrowAnimationController = AnimationController(
      duration: Duration(milliseconds: _animationDuration),
      vsync: this,
    );
    _selectedValue = widget.initialValue;
    super.initState();
  }

  @override
  void dispose() {
    _arrowAnimationController.dispose();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animateArrowIcon();

    return BaseInput(
      label: widget.label,
      helperText: widget.helperText,
      state: widget.state,
      disabled: widget.disabled,
      focused: _isOpen,
      builder: (BaseInputData data) {
        _formField = data.field;

        return CompositedTransformTarget(
          link: _layerLink,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                key: _dropdownKey,
                onTap: widget.disabled ? null : _showDropdownMenu,
                child: InputDecorator(
                  decoration: data.decoration.copyWith(
                    prefixIcon: widget.iconBuilder?.call(data.mainColor),
                    suffixIcon: _getArrowIcon(data.mainColor),
                    hintText: _selectedValue != null ? widget.items[_selectedValue] : widget.placeholder ?? '',
                  ),
                  child: _selectedValue != null
                      ? CustomText(
                          text: widget.items[_selectedValue] ?? '',
                          style: TypographyStyle.P4,
                          color: Theme.of(context).kTextColor,
                          textOverflow: TextOverflow.ellipsis,
                        )
                      : CustomText(
                          text: widget.placeholder ?? '',
                          style: TypographyStyle.P4,
                          color: Theme.of(context).kNeutralGrayishColor,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _animateArrowIcon() {
    _isOpen
        ? _arrowAnimationController.forward(from: _animationBegin)
        : _arrowAnimationController.reverse(from: _animationEnd);
  }

  OverlayEntry _buildDropdownMenu() {
    final dropdownSize = widgetSize(key: _dropdownKey)!;
    final size = Size(dropdownSize.width, dropdownSize.height);

    return OverlayEntry(
      builder: (context) => _DropdownMenu(
        link: _layerLink,
        onCancel: _closeDropdownMenu,
        parentOffset: widgetPosition(key: _dropdownKey)!,
        parentSize: size,
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: _buildDropdownItems(),
        ),
      ),
    );
  }

  List<Widget> _buildDropdownItems() {
    return widget.items.entries
        .map(
          (entry) => InkWell(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: CustomText(
                text: entry.value,
                style: TypographyStyle.P5,
                color: Theme.of(context).kTextColor,
                textOverflow: TextOverflow.fade,
              ),
            ),
            onTap: () => _onMenuReturns(entry.key),
          ),
        )
        .toList();
  }

  Widget _getArrowIcon(Color color) {
    return RotationTransition(
      turns: Tween(begin: _animationBegin, end: _animationEnd).animate(_arrowAnimationController),
      child: CustomIcon(
        svgIconPath: AppAssets.ARROW_DOWN,
        color: color,
        height: 8,
        width: 32,
      ),
    );
  }

  void _onMenuReturns(dynamic value) {
    _closeDropdownMenu();
    _setSelectedValue(value);
    _formField?.didChange(value);
  }

  void _setIsOpen(bool value) {
    setState(() {
      _isOpen = value;
    });
  }

  void _setSelectedValue(dynamic value) {
    setState(() {
      _selectedValue = value;
      widget.onValueSelected(value);
    });
  }

  void _showDropdownMenu() {
    _setIsOpen(true);
    _overlayEntry = _buildDropdownMenu();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdownMenu() {
    if (_isOpen) {
      _setIsOpen(false);
      _overlayEntry?.remove();
    }
  }
}

class _DropdownMenu extends StatelessWidget {
  final Widget? child;
  final LayerLink link;
  final Function() onCancel;
  final Offset parentOffset;
  final Size parentSize;

  static const double _minHeight = 200;

  const _DropdownMenu({
    required this.link,
    required this.child,
    required this.onCancel,
    required this.parentOffset,
    required this.parentSize,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onCancel,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          width: parentSize.width,
          child: CompositedTransformFollower(
            offset: Offset(0.0, _getYOffset(context)),
            link: link,
            showWhenUnlinked: false,
            child: Material(
              color: Theme.of(context).kBackgroundColor,
              elevation: 2.0,
              child: Scrollbar(
                child: LimitedBox(
                  maxHeight: _getMaxHeight(context),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getYOffset(BuildContext context) {
    const marginTop = 4.0;

    final height = _getHeight(context);

    if (height <= _minHeight) {
      return height - _minHeight;
    } else {
      return parentSize.height + marginTop;
    }
  }

  double _getHeight(BuildContext context) {
    final marginBottom = parentSize.height * 1.7;

    final height = MediaQuery.of(context).size.height - parentOffset.dy - marginBottom;

    return height > 0.0 ? height : (height * -1);
  }

  double _getMaxHeight(BuildContext context) {
    final height = _getHeight(context);

    if (height <= _minHeight) {
      return height + _minHeight;
    }

    return height;
  }
}
