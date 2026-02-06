import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_pos/models/models.dart';
import 'package:flutter_pos/state/providers.dart';
import 'package:flutter_pos/ui/widgets/pin_input_keypad.dart';
import 'package:flutter_pos/ui/widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final pinController = TextEditingController();
  bool isLoading = false;
  String? errorText;

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      errorText = null;
    });
    try {
      final user = await ref.read(authControllerProvider).login(pinController.text);
      if (!mounted) return;
      context.go(user.role == UserRole.admin ? '/transaksi' : '/pos');
    } catch (e) {
      setState(() => errorText = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.read(repoProvider).settings;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(radius: 32, child: Icon(Icons.storefront, size: 30)),
                  const SizedBox(height: 10),
                  Text(
                    settings.shopName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    'Masuk dengan PIN kasir/admin',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: PinInputKeypad(
                        controller: pinController,
                        errorText: errorText,
                        onChanged: (_) {
                          if (errorText != null) {
                            setState(() => errorText = null);
                          }
                        },
                        onSubmit: _submit,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Masuk',
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Demo PIN: Admin 123456 • Kasir 111111',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
