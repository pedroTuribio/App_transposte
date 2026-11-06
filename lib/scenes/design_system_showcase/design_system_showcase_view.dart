import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import 'design_system_showcase_view_model.dart';
import 'server_design_system_showcase.dart';

class DesignSystemShowcaseView extends StatefulWidget {
  const DesignSystemShowcaseView({super.key, required this.viewModel});
  final DesignSystemShowcaseViewModel viewModel;

  @override
  State<DesignSystemShowcaseView> createState() =>
      _DesignSystemShowcaseViewState();
}

class _DesignSystemShowcaseViewState extends State<DesignSystemShowcaseView> {
  DesignSystemShowcaseViewModel get vm => widget.viewModel;

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
      appBar: AppBar(title: const Text('Design System Yellow')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            final data = vm.data;
            if (data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.all(YellowSpacing.lg),
              children: [
                _Section(title: 'Cores', children: [
                  for (final group in data.colorGroups) _ColorGroupView(group),
                ]),
                _Section(title: 'Tipografia', children: [
                  for (final t in data.typography) _TypographyRow(t),
                ]),
                _Section(title: 'Sombras', children: [
                  Wrap(
                    spacing: YellowSpacing.md,
                    runSpacing: YellowSpacing.lg,
                    children: [
                      for (final s in data.shadows) _ShadowBox(s),
                    ],
                  ),
                ]),
                _Section(title: 'Botões', children: [
                  YellowButton(label: 'Primário', onPressed: () {}),
                  const SizedBox(height: YellowSpacing.sm),
                  YellowButton(
                      label: 'Secundário',
                      variant: YellowButtonVariant.secondary,
                      onPressed: () {}),
                  const SizedBox(height: YellowSpacing.sm),
                  YellowButton(
                      label: 'Outline',
                      variant: YellowButtonVariant.outline,
                      icon: Icons.add_rounded,
                      onPressed: () {}),
                  const SizedBox(height: YellowSpacing.sm),
                  YellowButton(
                      label: 'Ghost',
                      variant: YellowButtonVariant.ghost,
                      onPressed: () {}),
                  const SizedBox(height: YellowSpacing.sm),
                  const YellowButton(label: 'Desabilitado', onPressed: null),
                  const SizedBox(height: YellowSpacing.sm),
                  YellowButton(
                    label: 'Toque para ver o loading',
                    isLoading: vm.demoLoading,
                    onPressed: vm.simulateLoading,
                  ),
                ]),
                _Section(title: 'Inputs', children: [
                  YellowInput(
                    label: 'Padrão',
                    hint: 'Digite algo',
                    prefixIcon: Icons.edit_outlined,
                    helperText: 'Texto de ajuda',
                    onChanged: vm.onDemoTextChanged,
                    errorText: vm.demoError,
                  ),
                  const YellowInput(
                    label: 'Senha',
                    hint: '••••••',
                    obscureText: true,
                    prefixIcon: Icons.lock_outline_rounded,
                  ),
                  const YellowInput(
                    label: 'Desabilitado',
                    hint: 'Indisponível',
                    enabled: false,
                  ),
                  const YellowInput(
                    label: 'Com erro',
                    hint: 'Valor inválido',
                    errorText: 'Mensagem de erro',
                  ),
                ]),
                const _Section(title: 'Badges', children: [
                  Wrap(
                    spacing: YellowSpacing.sm,
                    runSpacing: YellowSpacing.sm,
                    children: [
                      CategoryBadge(label: 'Accent'),
                      CategoryBadge(
                          label: 'Ativo',
                          tone: BadgeTone.success,
                          icon: Icons.check_circle_rounded),
                      CategoryBadge(label: 'Info', tone: BadgeTone.info),
                      CategoryBadge(label: 'Neutro', tone: BadgeTone.neutral),
                      CategoryBadge(
                          label: 'Bloqueado',
                          tone: BadgeTone.danger,
                          icon: Icons.block_rounded),
                    ],
                  ),
                ]),
                const _Section(title: 'Balance Card', children: [
                  BalanceCard(
                    balanceText: 'R\$ 42,50',
                    holderName: 'Ana Souza',
                    statusLabel: 'Ativo',
                    cardTypeLabel: 'Estudantil',
                  ),
                ]),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: YellowNavigationBar(
        items: appNavItems,
        currentIndex: 2,
        onTap: vm.onTabSelected,
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: YellowSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: YellowTypography.title2),
          const SizedBox(height: YellowSpacing.xs),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: YellowColors.yellow500,
              borderRadius: BorderRadius.circular(YellowSpacing.radiusPill),
            ),
          ),
          const SizedBox(height: YellowSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _ColorGroupView extends StatelessWidget {
  const _ColorGroupView(this.group);
  final ColorGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: YellowSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(group.title, style: YellowTypography.bodyBold),
          const SizedBox(height: YellowSpacing.sm),
          Wrap(
            spacing: YellowSpacing.sm,
            runSpacing: YellowSpacing.sm,
            children: [
              for (final s in group.samples)
                SizedBox(
                  width: 96,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: s.color,
                          borderRadius:
                              BorderRadius.circular(YellowSpacing.radiusMd),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      ),
                      const SizedBox(height: YellowSpacing.xs),
                      Text(s.name,
                          style: YellowTypography.caption
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text(s.hex, style: YellowTypography.caption),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypographyRow extends StatelessWidget {
  const _TypographyRow(this.sample);
  final TypographySample sample;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: YellowSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${sample.name} · ${sample.spec}',
              style: YellowTypography.caption
                  .copyWith(color: YellowColors.neutral500)),
          Text('Cartão Estudantil', style: sample.style),
        ],
      ),
    );
  }
}

class _ShadowBox extends StatelessWidget {
  const _ShadowBox(this.sample);
  final ShadowSample sample;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(YellowSpacing.radiusMd),
        boxShadow: sample.shadows,
      ),
      child: Text(sample.name, style: YellowTypography.bodyBold),
    );
  }
}
