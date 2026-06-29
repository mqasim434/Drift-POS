import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/models/deal_with_items.dart';
import '../../shared/layouts/feature_scaffold.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import 'providers/deals_provider.dart';
import 'widgets/deal_card.dart';

class DealsScreen extends ConsumerWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dealsAsync = ref.watch(dealsWithItemsProvider);

    return FeatureScaffold(
      title: 'Deals',
      actions: [
        ElevatedButton.icon(
          onPressed: () => context.go('/deals/create'),
          icon: const Icon(Icons.add, size: AppSizes.md),
          label: const Text('Create Deal'),
        ),
      ],
      body: dealsAsync.when(
        data: (deals) {
          if (deals.isEmpty) {
            return const EmptyState(
              message: 'No deals yet',
              icon: Icons.local_offer_outlined,
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= AppSizes.breakpointLg
                  ? 4
                  : 3;

              return GridView.builder(
                padding: const EdgeInsets.all(AppSizes.lg),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: AppSizes.md,
                  mainAxisSpacing: AppSizes.md,
                  childAspectRatio: 0.72,
                ),
                itemCount: deals.length,
                itemBuilder: (context, index) {
                  final deal = deals[index];
                  return DealCard(
                    deal: deal,
                    onEdit: () => context.go('/deals/edit/${deal.id}'),
                    onDelete: () => _confirmDelete(context, ref, deal),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: AppColors.danger),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    DealWithItems deal,
  ) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete Deal',
      message: 'Are you sure you want to delete "${deal.name}"?',
      confirmLabel: 'Delete',
    );

    if (confirmed == true) {
      await ref.read(dealsNotifierProvider.notifier).deleteDeal(deal.id);
    }
  }
}
