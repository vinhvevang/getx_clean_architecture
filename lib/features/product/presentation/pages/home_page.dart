import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/constant/category.dart';

import 'package:getx_clean_archi/core/widgets/card_product.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFF24E1E),
        onPressed: controller.openAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.findName,
                      onChanged: controller.find,
                     
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF24E1E))
                        ),
                        hintText: 'Tìm sản phẩm...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      icon: Icon(
                        Icons.filter_alt_outlined,
                        color:
                            controller.isFiltering.value
                                ? const Color(0xFFEE4D2D)
                                : Colors.grey,
                      ),
                      onPressed: controller.openFilterDialog,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => GridView.builder(
                itemCount: controller.filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                ),
                itemBuilder: (_, i) {
                  final p = controller.filteredProducts[i];
                  final index = controller.products.indexOf(p);

                  return CardProduct(
                    name: p.name,
                    price: p.price.toInt(),
                    quantity: p.quan.toInt(),
                    imageUrl: p.imageUrl,
                    onDelete: () => controller.remove(context, index),
                    onEdit: () => controller.openEditDialog(p, index),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
