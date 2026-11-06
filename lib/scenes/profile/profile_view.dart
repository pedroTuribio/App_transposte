import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import 'profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, required this.viewModel});
  final ProfileViewModel viewModel;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileViewModel get vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    vm.load();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil e Cartão')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: vm,
          builder: (context, _) => switch (vm.status) {
            ProfileStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            ProfileStatus.error => Center(
                child: Padding(
                  padding: const EdgeInsets.all(YellowSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(vm.errorMessage ?? 'Erro ao carregar.',
                          textAlign: TextAlign.center),
                      const SizedBox(height: YellowSpacing.md),
                      YellowButton(
                        label: 'Tentar novamente',
                        expanded: false,
                        onPressed: vm.load,
                      ),
                    ],
                  ),
                ),
              ),
            ProfileStatus.ready => _buildContent(context),
          },
        ),
      ),
      bottomNavigationBar: YellowNavigationBar(
        items: appNavItems,
        currentIndex: 1,
        onTap: vm.onTabSelected,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    return ListView(
      padding: const EdgeInsets.all(YellowSpacing.lg),
      children: [
        Center(
          child: CircleAvatar(
            radius: 44,
            backgroundColor: YellowColors.yellow500,
            child: Text(vm.initials,
                style: YellowTypography.title1
                    .copyWith(color: YellowColors.blue900)),
          ),
        ),
        const SizedBox(height: YellowSpacing.md),
        Center(child: Text(vm.name, style: YellowTypography.title2)),
        const SizedBox(height: YellowSpacing.xs),
        const Center(child: CategoryBadge(label: 'Aluno · Estudantil')),
        const SizedBox(height: YellowSpacing.lg),
        Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(YellowSpacing.radiusLg),
            boxShadow: YellowShadows.sm,
          ),
          child: Column(
            children: [
              _InfoTile(icon: Icons.badge_outlined, label: 'Nome', value: vm.name),
              const Divider(height: 1),
              _InfoTile(
                  icon: Icons.pin_outlined, label: 'CPF', value: vm.maskedCpf),
              const Divider(height: 1),
              _InfoTile(
                  icon: Icons.school_outlined,
                  label: 'Matrícula',
                  value: vm.registration),
              if (vm.email.isNotEmpty) ...[
                const Divider(height: 1),
                _InfoTile(
                    icon: Icons.mail_outline, label: 'E-mail', value: vm.email),
              ],
            ],
          ),
        ),
        const SizedBox(height: YellowSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(YellowSpacing.radiusLg),
            boxShadow: YellowShadows.sm,
          ),
          child: SwitchListTile(
            secondary: Icon(vm.isDark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded),
            title: const Text('Tema escuro'),
            subtitle: Text(vm.isDark ? 'Escuro' : 'Claro'),
            value: vm.isDark,
            onChanged: vm.toggleTheme,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(YellowSpacing.radiusLg)),
          ),
        ),
        const SizedBox(height: YellowSpacing.xl),
        YellowButton(
          label: 'Sair da Conta',
          icon: Icons.logout_rounded,
          variant: YellowButtonVariant.outline,
          isLoading: vm.isLoggingOut,
          onPressed: vm.logout,
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label, style: YellowTypography.caption),
      subtitle: Text(value, style: YellowTypography.bodyLarge),
    );
  }
}
