import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/yellow_spacing.dart';
import '../tokens/yellow_typography.dart';

/// Campo de texto do Design System Yellow (label acima + erro/ajuda abaixo).
class YellowInput extends StatefulWidget {
  const YellowInput({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.errorText,
    this.helperText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final IconData? prefixIcon;
  final bool enabled;

  @override
  State<YellowInput> createState() => _YellowInputState();
}

class _YellowInputState extends State<YellowInput> {
  late bool _hidden = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: YellowTypography.bodyBold),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: _hidden,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: YellowTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon:
                widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
            suffixIcon: widget.obscureText
                ? IconButton(
                    tooltip: _hidden ? 'Mostrar senha' : 'Ocultar senha',
                    icon: Icon(_hidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _hidden = !_hidden),
                  )
                : null,
          ),
        ),
        const SizedBox(height: YellowSpacing.xs),
      ],
    );
  }
}
