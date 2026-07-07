import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/constant/category.dart';
import 'package:getx_clean_archi/core/widgets/app_color.dart';
import 'package:getx_clean_archi/core/widgets/app_formatter.dart';
import 'package:getx_clean_archi/core/widgets/app_text_field.dart';
import 'package:getx_clean_archi/core/widgets/card_product.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: controller.openAddDialog,
        child: const Icon(Icons.add,color: Colors.white,size: 33,),
      ),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: controller.searchController,
                      label: 'Tìm kiếm',
                      hintText: 'Tìm sản phẩm...',
                      isRequired: false,
                      onChanged: controller.onSearchChanged,
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      icon: Icon(
                        Icons.filter_alt_outlined,
                        color: controller.hasActiveFilter.value
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                      onPressed: controller.openFilterDialog,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _ActiveFilterChips(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.filteredProducts.isEmpty) {
                return const _EmptyProductsState();
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: controller.filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                ),
                itemBuilder: (_, i) {
                  final product = controller.filteredProducts[i];
                  final index = controller.allProducts.indexOf(product);

                  return CardProduct(
                    name: product.name,
                    price: product.price.toInt(),
                    quantity: product.quantity.toInt(),
                    imageUrl: product.imageUrl,
                    onDelete: () => controller.confirmAndRemove(index),
                    onEdit: () => controller.openEditDialog(product, index),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Dải chip hiển thị các điều kiện lọc đang áp dụng, mỗi chip có thể bấm "x"
/// để bỏ riêng điều kiện đó mà không cần mở lại dialog Bộ lọc.
class _ActiveFilterChips extends StatelessWidget {
  final HomeController controller;

  const _ActiveFilterChips({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.hasActiveFilter.value) return const SizedBox.shrink();

      final category = controller.appliedCategory.value;
      final minPrice = controller.appliedMinPrice.value;
      final maxPrice = controller.appliedMaxPrice.value;

      final chips = <Widget>[];

      if (category != Category.all) {
        chips.add(
          _FilterChip(
            label: category.nameVi,
            onRemove: controller.removeCategoryFilter,
          ),
        );
      }

      if (minPrice != null || maxPrice != null) {
        final String label;
        if (minPrice != null && maxPrice != null) {
          label =
              '${AppFormatter.currency(minPrice)} - ${AppFormatter.currency(maxPrice)}';
        } else if (minPrice != null) {
          label = 'Từ ${AppFormatter.currency(minPrice)}';
        } else {
          label = 'Đến ${AppFormatter.currency(maxPrice!)}';
        }
        chips.add(_FilterChip(label: label, onRemove: controller.removePriceFilter));
      }

      if (chips.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Wrap(spacing: 8, runSpacing: 8, children: chips),
      );
    });
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onRemove,
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppColors.border),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Hiển thị khi tìm kiếm/lọc không ra kết quả nào.
class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
          SizedBox(height: 12),
          Text(
            'Không tìm thấy sản phẩm nào',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
