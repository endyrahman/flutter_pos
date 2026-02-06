import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInputKeypad extends StatelessWidget {
  const PinInputKeypad({
    required this.controller,
    required this.errorText,
    required this.onChanged,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  void _appendDigit(String digit) {
    if (controller.text.length >= 6) return;
    controller.text = '${controller.text}$digit';
    onChanged(controller.text);
  }

  void _backspace() {
    if (controller.text.isEmpty) return;
    controller.text = controller.text.substring(0, controller.text.length - 1);
    onChanged(controller.text);
  }

  void _clear() {
    controller.clear();
    onChanged(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          key: const Key('pinField'),
          autofocus: true,
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmit(),
          onChanged: onChanged,
          maxLength: 6,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          decoration: InputDecoration(
            labelText: 'PIN',
            hintText: '••••••',
            errorText: errorText,
            counterText: '',
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final d in ['1', '2', '3', '4', '5', '6', '7', '8', '9'])
              _KeypadButton(label: d, onTap: () => _appendDigit(d)),
            _KeypadButton(label: 'C', icon: Icons.clear, onTap: _clear),
            _KeypadButton(label: '0', onTap: () => _appendDigit('0')),
            _KeypadButton(label: '<', icon: Icons.backspace_outlined, onTap: _backspace),
          ],
        ),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({required this.label, required this.onTap, this.icon});

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: OutlinedButton(
        onPressed: onTap,
        child: icon != null ? Icon(icon) : Text(label),
      ),
    );
  }
}
