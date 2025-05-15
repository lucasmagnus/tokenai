import 'package:flutter/material.dart';
import 'package:tokenai/components/atoms/text/custom_text.dart';

class CustomForm extends StatefulWidget {
  final String? title;
  final String? description;
  final AutovalidateMode autovalidateMode;
  final List<Widget> Function(GlobalKey<FormState> key) builder;

  const CustomForm({
    Key? key,
    required this.builder,
    this.title,
    this.description,
    this.autovalidateMode = AutovalidateMode.disabled,
  }) : super(key: key);

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: widget.autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _formHeader(),
          const SizedBox(
            height: 16,
          ),
          ...widget.builder(_formKey),
        ],
      ),
    );
  }

  Widget _formHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.title != null)
          CustomText(
            text: widget.title!,
            style: TypographyStyle.H5,
          ),
        if (widget.description != null)
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: CustomText(
              text: widget.description!,
              style: TypographyStyle.P2,
              wrap: true,
            ),
          ),
      ],
    );
  }
}
