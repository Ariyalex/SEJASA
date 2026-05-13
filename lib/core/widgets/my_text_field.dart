import 'package:flutter/material.dart';

/// A stateful widget for a custom text field
/// Includes features like password obscuring, clear button, and real-time validation.
class MyTextField extends StatefulWidget {
  final String title;

  /// the hint text displayed inside the text field when empty.
  final String hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius;
  final double? fieldWidth;
  final TextStyle? titleStyle;
  final Color fillColor;

  ///Whether the text should be obscured(for password). The default value is false.
  final bool obscureText;
  final Color? obscureIconColor;

  final double gap;

  /// Optional controller for the text field.
  final TextEditingController? controller;

  /// Optional validator function for input validation.
  final FormFieldValidator<String>? validator;

  /// Callback function called when the text changes.
  final void Function(String)? onChanged;

  /// Keyboard type for the text field.
  final TextInputType keyboardType;

  /// Optional focus node for the text field.
  final FocusNode? focusNode;

  /// Autovalidate mode for the text field, (AutovalidateMode.always by default)
  final AutovalidateMode autovalidateMode;

  final bool isClearable;

  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;

  const MyTextField({
    super.key,
    required this.title,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius = 8,
    this.fieldWidth,
    this.titleStyle,
    this.fillColor = const Color(0xFFEEEEEE),
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.gap = 4,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.obscureIconColor,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.isClearable = true,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late TextEditingController _controller;
  late bool _obscureText;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _obscureText = widget.obscureText;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// handles text changes and update validation error.
  void _onTextChanged() {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator?.call(_controller.text);
      });
    } else {
      setState(() {});
    }
  }

  /// Builds the suffix icon based on field state (password toggle or clear button).
  Widget? _buildSuffixIcon(ThemeData theme) {
    if (!widget.isClearable) {
      return widget.suffixIcon;
    }
    if (widget.obscureText) {
      return IconButton.filled(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        color: widget.obscureIconColor,

        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (_controller.text.isNotEmpty && !widget.readOnly) {
      return IconButton.filled(
        icon: Icon(Icons.clear, color: theme.colorScheme.error),
        style: IconButton.styleFrom(backgroundColor: Colors.transparent),
        onPressed: () {
          _controller.clear();
        },
      );
    }
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: widget.fieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title.isNotEmpty) ...[
            Text(
              widget.title,
              style:
                  widget.titleStyle ??
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: widget.gap),
          ],
          TextFormField(
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode,
            keyboardType: widget.keyboardType,
            controller: _controller,
            obscureText: _obscureText,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            onEditingComplete: widget.onEditingComplete,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              suffixIcon: _buildSuffixIcon(theme),
              hintText: widget.hint,
              filled: true,
              fillColor: widget.fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(color: theme.disabledColor),
              errorText: _errorText,
            ),
            onChanged: widget.onChanged,
            focusNode: widget.focusNode,
          ),
        ],
      ),
    );
  }
}
