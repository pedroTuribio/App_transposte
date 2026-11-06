import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.viewModel});
  final LoginViewModel viewModel;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginViewModel get vm => widget.viewModel;

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(YellowSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: ListenableBuilder(
                listenable: vm,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(YellowSpacing.md),
                        decoration: BoxDecoration(
                          color: YellowColors.yellow500,
                          borderRadius:
                              BorderRadius.circular(YellowSpacing.radiusLg),
                          boxShadow: YellowShadows.md,
                        ),
                        child: const Icon(Icons.directions_bus_rounded,
                            size: 36, color: YellowColors.blue900),
                      ),
                    ),
                    const SizedBox(height: YellowSpacing.lg),
                    Text(vm.title, style: YellowTypography.title1),
                    const SizedBox(height: YellowSpacing.sm),
                    Text(vm.subtitle, style: YellowTypography.bodyLarge),
                    const SizedBox(height: YellowSpacing.xl),
                    if (vm.isRegister) ...[
                      YellowInput(
                        label: 'Nome completo',
                        hint: 'Seu nome',
                        controller: _nameController,
                        prefixIcon: Icons.badge_outlined,
                        textInputAction: TextInputAction.next,
                        errorText: vm.nameError,
                        onChanged: vm.onNameChanged,
                        enabled: !vm.isLoading,
                      ),
                      const SizedBox(height: YellowSpacing.sm),
                    ],
                    YellowInput(
                      label: 'CPF do aluno',
                      hint: '000.000.000-00',
                      controller: _cpfController,
                      prefixIcon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: const [CpfInputFormatter()],
                      errorText: vm.cpfError,
                      onChanged: vm.onCpfChanged,
                      enabled: !vm.isLoading,
                    ),
                    const SizedBox(height: YellowSpacing.sm),
                    YellowInput(
                      label: 'Senha',
                      hint: 'Mínimo de 6 caracteres',
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      textInputAction: TextInputAction.done,
                      errorText: vm.passwordError,
                      onChanged: vm.onPasswordChanged,
                      onSubmitted: (_) => vm.submit(),
                      enabled: !vm.isLoading,
                    ),
                    if (vm.formError != null) ...[
                      const SizedBox(height: YellowSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(YellowSpacing.md),
                        decoration: BoxDecoration(
                          color: YellowColors.error.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(YellowSpacing.radiusMd),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: YellowColors.error),
                            const SizedBox(width: YellowSpacing.sm),
                            Expanded(
                              child: Text(vm.formError!,
                                  style: YellowTypography.body
                                      .copyWith(color: YellowColors.error)),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: YellowSpacing.lg),
                    YellowButton(
                      label: vm.submitLabel,
                      isLoading: vm.isLoading,
                      onPressed: vm.submit,
                    ),
                    const SizedBox(height: YellowSpacing.sm),
                    YellowButton(
                      label: vm.toggleLabel,
                      variant: YellowButtonVariant.ghost,
                      onPressed: vm.isLoading ? null : vm.toggleMode,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
