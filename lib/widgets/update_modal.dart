import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../providers/update_provider.dart';
import '../theme.dart';

class UpdateModal extends ConsumerStatefulWidget {
  const UpdateModal({super.key});

  @override
  ConsumerState<UpdateModal> createState() => _UpdateModalState();
}

class _UpdateModalState extends ConsumerState<UpdateModal> {
  bool _ignoreVersion = false;

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateProvider);
    final release = updateState.release;

    if (release == null) return const SizedBox.shrink();

    final isDownloading = updateState.status == UpdateStatus.downloading;
    final isReady = updateState.status == UpdateStatus.readyToInstall;
    final isError = updateState.status == UpdateStatus.error;

    return Dialog(
      backgroundColor: SaasTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.system_update_rounded, color: SaasTheme.primary, size: 28),
                const SizedBox(width: 16),
                Text(
                  'Mise à jour disponible',
                  style: SaasTheme.textTheme.displayLarge?.copyWith(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Version ${release.semanticVersion} est disponible. Vous utilisez actuellement la version ${updateState.localVersion ?? "inconnue"}.',
              style: SaasTheme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: SaasTheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: SaasTheme.border),
              ),
              child: Markdown(
                data: release.body,
                styleSheet: MarkdownStyleSheet(
                  p: SaasTheme.textTheme.bodyMedium,
                  h1: SaasTheme.textTheme.headlineMedium?.copyWith(fontSize: 18),
                  h2: SaasTheme.textTheme.headlineMedium?.copyWith(fontSize: 16),
                  listBullet: SaasTheme.textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            if (isError)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  updateState.errorMessage ?? 'Une erreur est survenue.',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),

            if (isDownloading) ...[
              Text(
                'Téléchargement en cours... ${(updateState.progress * 100).toStringAsFixed(1)}%',
                style: SaasTheme.textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: updateState.progress,
                backgroundColor: SaasTheme.border,
                valueColor: const AlwaysStoppedAnimation<Color>(SaasTheme.primary),
              ),
            ] else if (isReady) ...[
              Text(
                'Téléchargement terminé.',
                style: SaasTheme.textTheme.labelLarge?.copyWith(color: Colors.green),
              ),
            ] else ...[
              Row(
                children: [
                  Checkbox(
                    value: _ignoreVersion,
                    activeColor: SaasTheme.primary,
                    onChanged: (val) {
                      setState(() => _ignoreVersion = val ?? false);
                    },
                  ),
                  Text('Ignorer cette version', style: SaasTheme.textTheme.bodyMedium),
                ],
              ),
            ],
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isDownloading && !isReady)
                  TextButton(
                    onPressed: () {
                      if (_ignoreVersion) {
                        ref.read(updateProvider.notifier).ignoreVersion(release.semanticVersion);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('Plus tard', style: SaasTheme.textTheme.bodyMedium),
                  ),
                const SizedBox(width: 16),
                if (isReady)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SaasTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    onPressed: () {
                      ref.read(updateProvider.notifier).runInstaller();
                    },
                    child: const Text('Installer maintenant'),
                  )
                else if (!isDownloading)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SaasTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    onPressed: () {
                      ref.read(updateProvider.notifier).downloadUpdate();
                    },
                    child: const Text('Télécharger'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
