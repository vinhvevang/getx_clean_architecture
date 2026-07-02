import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/widgets/card_product.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  void _showAddDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Thêm sản phẩm'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controller.name,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextFormField(
              controller: controller.price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Giá'),
            ),
            TextFormField(
              controller: controller.quan,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Số lượng'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.add(
                Product(
                  controller.name.text,
                  double.tryParse(controller.price.text) ?? 0,
                  double.tryParse(controller.quan.text) ?? 0,
                ),
              );
              Get.back();
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Product old, int index) {
    controller.editName.text = old.name;
    controller.editPrice.text = old.price.toString();
    controller.editQuan.text = old.quan.toString();

    Get.dialog(
      AlertDialog(
        title: const Text('Sửa sản phẩm'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controller.editName,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextFormField(
              controller: controller.editPrice,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Giá'),
            ),
            TextFormField(
              controller: controller.editQuan,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Số lượng'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.edit(
                Product(
                  controller.editName.text,
                  double.tryParse(controller.editPrice.text) ?? 0,
                  double.tryParse(controller.editQuan.text) ?? 0,
                ),
                index,
              );
              Get.back();
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFEE4D2D),
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: controller.findName,
                onChanged: controller.find,
                decoration: const InputDecoration(
                  hintText: 'Tìm sản phẩm...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(
              () => GridView.builder(
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, i) {
                  final product = controller.filteredProducts[i];
                  final realIndex = controller.products.indexOf(product);

                  return CardProduct(
                    name: product.name,
                    price: product.price.toInt(),
                    quantity: product.quan.toInt(),
                    onDelete: () => controller.remove(realIndex),
                    onEdit: () => _showEditDialog(product, realIndex),
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
