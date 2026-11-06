import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import 'home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.viewModel});
  final HomeViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeViewModel get vm => widget.viewModel;

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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: vm,
          builder: (context, _) => switch (vm.status) {
            HomeStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            HomeStatus.error => _ErrorState(
                message: vm.errorMessage ?? 'Erro ao carregar.',
                onRetry: vm.load,
              ),
            HomeStatus.ready => _buildContent(context),
          },
        ),
      ),
      bottomNavigationBar: YellowNavigationBar(
        items: appNavItems,
        currentIndex: 0,
        onTap: vm.onTabSelected,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final summary = vm.summary!;
    final transactions = vm.transactions;
    return RefreshIndicator(
      onRefresh: vm.refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(YellowSpacing.lg),
        children: [
          Text('Olá, ${vm.greetingName} 👋', style: YellowTypography.title2),
          const SizedBox(height: YellowSpacing.xs),
          const Text('Confira o saldo do seu cartão estudantil.',
              style: YellowTypography.body),
          const SizedBox(height: YellowSpacing.lg),
          BalanceCard(
            balanceText: vm.balanceText,
            holderName: summary.holderName,
            cardNumber: summary.cardNumber,
            statusLabel: summary.isActive
                ? '${summary.cardStatus} · ${summary.cardType}'
                : summary.cardStatus,
            cardTypeLabel: summary.cardType,
            isActive: summary.isActive,
          ),
          const SizedBox(height: YellowSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _Shortcut(
                  icon: Icons.refresh_rounded,
                  label: 'Atualizar',
                  onTap: vm.refresh,
                ),
              ),
              const SizedBox(width: YellowSpacing.sm),
              Expanded(
                child: _Shortcut(
                  icon: Icons.add_card_rounded,
                  label: 'Recarga',
                  onTap: () => _showMessage(vm.onRechargeTap()),
                ),
              ),
              const SizedBox(width: YellowSpacing.sm),
              Expanded(
                child: _Shortcut(
                  icon: Icons.person_rounded,
                  label: 'Perfil',
                  onTap: vm.onProfileTap,
                ),
              ),
            ],
          ),
          const SizedBox(height: YellowSpacing.lg),
          const Text('Histórico', style: YellowTypography.title3),
          const SizedBox(height: YellowSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Todos'),
                  selected: vm.selectedMonth == null,
                  onSelected: (_) => vm.selectMonth(null),
                ),
                for (final month in vm.months) ...[
                  const SizedBox(width: YellowSpacing.sm),
                  ChoiceChip(
                    label: Text(vm.monthLabel(month)),
                    selected: vm.selectedMonth == month,
                    onSelected: (_) => vm.selectMonth(month),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: YellowSpacing.md),
          if (vm.transactionsError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: YellowSpacing.md),
              child: CategoryBadge(
                label: vm.transactionsError!,
                tone: BadgeTone.danger,
                icon: Icons.error_outline,
              ),
            ),
          if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: YellowSpacing.xl),
              child: Center(
                  child: Text('Nenhuma movimentação neste período.')),
            )
          else
            for (final t in transactions)
              _TransactionTile(
                transaction: t,
                amountText: vm.formatAmount(t),
                dateText: vm.formatDate(t),
              ),
        ],
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(YellowSpacing.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(YellowSpacing.radiusLg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: YellowSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(YellowSpacing.radiusLg),
            boxShadow: YellowShadows.sm,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(YellowSpacing.sm),
                decoration: const BoxDecoration(
                    color: YellowColors.yellow100, shape: BoxShape.circle),
                child: Icon(icon, color: YellowColors.orange600),
              ),
              const SizedBox(height: YellowSpacing.sm),
              Text(label, style: YellowTypography.bodyBold),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.transaction,
    required this.amountText,
    required this.dateText,
  });

  final Transaction transaction;
  final String amountText;
  final String dateText;

  @override
  Widget build(BuildContext context) {
    final isRecharge = transaction.isRecharge;
    final color = isRecharge ? YellowColors.success : YellowColors.error;
    return Container(
      margin: const EdgeInsets.only(bottom: YellowSpacing.sm),
      padding: const EdgeInsets.all(YellowSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(YellowSpacing.radiusLg),
        boxShadow: YellowShadows.xs,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(
              isRecharge
                  ? Icons.arrow_downward_rounded
                  : Icons.directions_bus_rounded,
              color: color,
            ),
          ),
          const SizedBox(width: YellowSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: YellowTypography.bodyBold),
                Text(dateText, style: YellowTypography.caption),
              ],
            ),
          ),
          const SizedBox(width: YellowSpacing.sm),
          Text(amountText,
              style: YellowTypography.bodyBold.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(YellowSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 56),
            const SizedBox(height: YellowSpacing.md),
            Text(message,
                textAlign: TextAlign.center, style: YellowTypography.bodyLarge),
            const SizedBox(height: YellowSpacing.lg),
            YellowButton(
              label: 'Tentar novamente',
              expanded: false,
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
