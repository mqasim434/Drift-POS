import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/database/app_database.dart';
import '../../shared/layouts/feature_scaffold.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import 'providers/categories_provider.dart';
import 'widgets/category_card.dart';
import 'widgets/category_form_dialog.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesWithCountProvider);

    return FeatureScaffold(
      title: 'Categories',
      actions: [
        ElevatedButton.icon(
          onPressed: () => CategoryFormDialog.show(context),
          icon: const Icon(Icons.add, size: AppSizes.md),
          label: const Text('Add Category'),
        ),
      ],
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const EmptyState(
              message: 'No categories yet',
              icon: Icons.category_outlined,
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= AppSizes.breakpointLg
                  ? 5
                  : 4;

              return GridView.builder(
                padding: const EdgeInsets.all(AppSizes.lg),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: AppSizes.md,
                  mainAxisSpacing: AppSizes.md,
                  childAspectRatio: 1.35,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final viewModel = categories[index];
                  return CategoryCard(
                    viewModel: viewModel,
                    onEdit: () => CategoryFormDialog.show(
                      context,
                      category: viewModel.category,
                    ),
                    onDelete: () => _confirmDelete(
                      context,
                      ref,
                      viewModel.category,
                    ),
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
    Category category,
  ) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Delete Category',
      message: 'Are you sure you want to delete "${category.name}"?',
      confirmLabel: 'Delete',
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(categoriesNotifierProvider.notifier).deleteCategory(
            category.id,
          );
    } on CategoryException catch (error) {
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cannot Delete Category'),
          content: Text(error.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
