import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/update_provider.dart';
import '../theme.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateState = ref.watch(updateProvider);
    final isChecking = updateState.status == UpdateStatus.checking;

    // Affiche un toast si on est à jour, ou s'il y a une erreur
    ref.listen<UpdateState>(updateProvider, (previous, next) {
      if (previous?.status == UpdateStatus.checking) {
        if (next.status == UpdateStatus.upToDate) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Vous disposez déjà de la dernière version.'),
              backgroundColor: SaasTheme.primary,
            ),
          );
        } else if (next.status == UpdateStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage ?? 'Erreur de vérification.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('SYSTÈME', style: SaasTheme.textTheme.labelLarge),
            const SizedBox(width: 12),
            const Icon(Icons.settings, size: 14, color: SaasTheme.primary),
          ],
        ),
        Text(
          'Paramètres',
          style: SaasTheme.textTheme.displayLarge,
        ),
        const SizedBox(height: 48),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: SaasTheme.surface,
            borderRadius: BorderRadius.circular(SaasTheme.bentoRadius),
            border: Border.all(color: SaasTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mises à jour',
                style: SaasTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Version actuelle',
                        style: SaasTheme.textTheme.bodyMedium?.copyWith(
                          color: SaasTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        updateState.localVersion ?? 'Chargement...',
                        style: SaasTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SaasTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    onPressed: isChecking
                        ? null
                        : () {
                            ref.read(updateProvider.notifier).checkForUpdates(silent: false);
                          },
                    icon: isChecking
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.refresh, size: 18),
                    label: Text(isChecking ? 'Vérification...' : 'Rechercher une mise à jour'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
