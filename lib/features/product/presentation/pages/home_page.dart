import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/constant/category.dart';
import 'package:getx_clean_archi/core/widgets/app_color.dart';
import 'package:getx_clean_archi/core/widgets/app_formatter.dart';
import 'package:getx_clean_archi/core/widgets/card_product.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: controller.openAddDialog,
        child: const Icon(Icons.add,color: Colors.white,size: 26),
      ),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(child: _ProductSearchBar(controller: controller)),
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

/// Ô tìm kiếm dùng SearchAnchor.bar (Material 3) - bấm vào mở rộng thành
/// overlay. Khi ô đang rỗng, overlay hiện LỊCH SỬ TÌM KIẾM GẦN ĐÂY; khi đã
/// gõ từ khóa, overlay đổi sang gợi ý TÊN SẢN PHẨM khớp từ khóa đó.
class _ProductSearchBar extends StatelessWidget {
  final HomeController controller;

  const _ProductSearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      searchController: controller.searchController,
      barHintText: 'Tìm sản phẩm...',
      barLeading: const Icon(Icons.search),
      viewHintText: 'Tìm sản phẩm...',
      // SearchAnchor có bug đã biết: gọi closeView() để điền gợi ý không tự
      // kích hoạt lại logic lọc, nên onSearchChanged/commitSearch còn được
      // gọi thủ công ngay trong onTap của từng gợi ý, không chỉ trông vào
      // onChanged.
      onChanged: controller.onSearchChanged,
      onSubmitted: (value) {
        controller.searchController.closeView(value);
        controller.onSearchChanged(value);
        controller.commitSearch(value);
      },
      suggestionsBuilder: (context, searchController) {
        final query = searchController.text.trim().toLowerCase();

        // Ô đang rỗng (vừa bấm vào, chưa gõ gì) -> hiện lịch sử tìm kiếm gần
        // đây thay vì gợi ý sản phẩm. Bọc trong Obx để khi bấm nút "x" xóa
        // 1 mục, chính widget này tự rebuild lại - không phụ thuộc việc
        // SearchAnchor có gọi lại suggestionsBuilder hay không (né bug ở trên).
        if (query.isEmpty) {
          return [
            Obx(() {
              if (controller.recentSearches.isEmpty) {
                return const ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Chưa có tìm kiếm gần đây'),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: controller.recentSearches.map((term) {
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(term),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      tooltip: 'Xóa khỏi lịch sử',
                      onPressed: () => controller.removeRecentSearch(term),
                    ),
                    onTap: () {
                      searchController.closeView(term);
                      controller.onSearchChanged(term);
                      controller.commitSearch(term);
                    },
                  );
                }).toList(),
              );
            }),
          ];
        }

        // Đã có từ khóa -> hiện gợi ý tên sản phẩm khớp như bình thường.
        final matches = controller.allProducts
            .where((p) => p.name.toLowerCase().contains(query))
            .take(6)
            .toList();

        if (matches.isEmpty) {
          return const [
            ListTile(
              leading: Icon(Icons.search_off),
              title: Text('Không có sản phẩm phù hợp'),
            ),
          ];
        }

        return matches.map((Product p) {
          return ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: Text(p.name),
            subtitle: Text(AppFormatter.currency(p.price)),
            onTap: () {
              searchController.closeView(p.name);
              controller.onSearchChanged(p.name);
              controller.commitSearch(p.name);
            },
          );
        }).toList();
      },
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
