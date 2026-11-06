import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key, required this.viewModel});
  final SplashViewModel viewModel;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.start();
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YellowColors.yellow500,
      body: Center(
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(YellowSpacing.lg),
                decoration: const BoxDecoration(
                  color: YellowColors.blue900,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.directions_bus_rounded,
                    size: 56, color: YellowColors.yellow500),
              ),
              const SizedBox(height: YellowSpacing.lg),
              Text('Meu Transporte',
                  style: YellowTypography.title1
                      .copyWith(color: YellowColors.blue900)),
              const SizedBox(height: YellowSpacing.xs),
              Text('Cartão Estudantil',
                  style: YellowTypography.body
                      .copyWith(color: YellowColors.blue900)),
              const SizedBox(height: YellowSpacing.xl),
              if (widget.viewModel.isChecking)
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                      strokeWidth: 3, color: YellowColors.blue900),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
