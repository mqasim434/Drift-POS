import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/database/app_database.dart';
import '../../shared/layouts/feature_scaffold.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import 'providers/tables_provider.dart';
import 'widgets/table_card.dart';
import 'widgets/table_form_dialog.dart';

class TablesScreen extends ConsumerWidget {
  const TablesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablesAsync = ref.watch(tablesWithStatusProvider);

    return FeatureScaffold(
      title: 'Tables',
      actions: [
        ElevatedButton.icon(
          onPressed: () => TableFormDialog.show(context),
          icon: const Icon(Icons.add, size: AppSizes.md),
          label: const Text('Add Table'),
        ),
      ],
      body: tablesAsync.when(
        data: (tables) {
          if (tables.isEmpty) {
            return const EmptyState(
              message: 'No tables yet',
              icon: Icons.table_restaurant_outlined,
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width >= AppSizes.breakpointXl
                  ? 6
                  : width >= AppSizes.breakpointLg
                      ? 5
                      : width >= AppSizes.breakpointMd
                          ? 4
                          : 3;

              return GridView.builder(
                padding: const EdgeInsets.all(AppSizes.lg),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: AppSizes.md,
                  mainAxisSpacing: AppSizes.md,
                  childAspectRatio: 0.85,
                ),
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  final viewModel = tables[index];
                  return TableCard(
                    viewModel: viewModel,
                    onEdit: () => TableFormDialog.show(
                      context,
                      table: viewModel.table,
                    ),
                    onDelete: () => _confirmDelete(
                      context,
                      ref,
                      viewModel.table,
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: Text('Loading tables...')),
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
    RestaurantTable table,
  ) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete Table',
      message: 'Delete "${table.name}"?',
      confirmLabel: 'Delete',
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(tablesNotifierProvider.notifier).deleteTable(table.id);
    } on TableException catch (error) {
      if (!context.mounted) return;
      await showConfirmationDialog(
        context: context,
        title: 'Cannot Delete Table',
        message: error.message,
        confirmLabel: 'OK',
        cancelLabel: 'Close',
      );
    }
  }
}
