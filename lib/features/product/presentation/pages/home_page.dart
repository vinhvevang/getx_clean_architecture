import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/core/widgets/card_product.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

 
  void _showAddDialog() {
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: const Text('Thêm sản phẩm'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.name,
                decoration: const InputDecoration(labelText: 'Tên'),
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: controller.price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Giá'),
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: controller.quan,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số lượng'),
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;

              controller.add(
                Product(
                  controller.name.text,
                  double.parse(controller.price.text),
                  double.parse(controller.quan.text),
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
    final formKey = GlobalKey<FormState>();

    controller.editName.text = old.name;
    controller.editPrice.text = old.price.toString();
    controller.editQuan.text = old.quan.toString();

    Get.dialog(
      AlertDialog(
        title: const Text('Sửa sản phẩm'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.editName,
                decoration: const InputDecoration(labelText: 'Tên'),
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: controller.editPrice,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Giá'),
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: controller.editQuan,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số lượng'),
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;

              controller.edit(
                Product(
                  controller.editName.text,
                  double.parse(controller.editPrice.text),
                  double.parse(controller.editQuan.text),
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
