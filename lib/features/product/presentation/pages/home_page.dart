import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  void _showFilterDialog() {
   

    Get.dialog(
      AlertDialog(
        title: const Text('Lọc theo giá'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controller.mincontroller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(label: Text('Giá tối thiểu')),
            ),
            TextFormField(
              controller: controller.maxcontroller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(label: Text('Giá tối đa')),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.filter();
              Get.back();
            },
            child: const Text('Xóa lọc'),
          ),
          TextButton(
            onPressed: () {
              controller.filter(
                minPrice: int.tryParse(controller.mincontroller.text),
                maxPrice: int.tryParse(controller.maxcontroller.text),
              );
              Get.back();
            },
            child: const Text('Áp dụng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          // ── Thanh tìm kiếm + nút lọc ──
          SafeArea(
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.findName,
                      onChanged: controller.find,
                      decoration: const InputDecoration(
                        label: Text('Nhap ten sp ...'),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showFilterDialog,
                    icon: const Icon(Icons.filter_list),
                    tooltip: 'Lọc theo giá',
                  ),
                ],
              ),
            ),
          ),

          // ── Grid sản phẩm ──
          Expanded(
            child: Scaffold(
              body: Obx(
                () => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 3,
                    crossAxisCount: 2,
                  ),
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (context, i) {
                    final actualIndex = controller.products.indexOf(
                      controller.filteredProducts[i],
                    );

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(controller.filteredProducts[i].name),
                            subtitle: Text('${controller.filteredProducts[i].price}'),
                            trailing: Text('${controller.filteredProducts[i].quan}'),
                          ),

                          // Xóa
                          IconButton(
                            onPressed: () => controller.remove(actualIndex),
                            icon: const Icon(Icons.delete),
                          ),

                          // Sửa
                          IconButton(
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Sua san pham'),
                                  actions: [
                                    TextFormField(
                                      controller: controller.editName,
                                      decoration: const InputDecoration(
                                        label: Text('Ten san pham'),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: controller.editPrice,
                                      decoration: const InputDecoration(
                                        label: Text('gia'),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: controller.editQuan,
                                      decoration: const InputDecoration(
                                        label: Text('so luong'),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        controller.edit(
                                          Product(
                                            controller.editName.text,
                                            int.tryParse(controller.editPrice.text) ??
                                                0,
                                            int.tryParse(controller.editQuan.text) ??
                                                0,
                                          ),
                                          actualIndex,
                                        );
                                        Get.back();
                                      },
                                      child: const Text('sua'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // FAB thêm sản phẩm
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('nhap thong tin san pham'),
                      actions: [
                        TextFormField(
                          controller: controller.name,
                          decoration: const InputDecoration(
                            label: Text('Ten san pham'),
                          ),
                        ),
                        TextFormField(
                          controller: controller.price,
                          decoration: const InputDecoration(label: Text('gia')),
                        ),
                        TextFormField(
                          controller: controller.quan,
                          decoration: const InputDecoration(
                            label: Text('so luong'),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.add(
                              Product(
                                controller.name.text,
                                int.tryParse(controller.price.text) ?? 0,
                                int.tryParse(controller.quan.text) ?? 0,
                              ),
                            );
                            Get.back();
                          },
                          child: const Text('them'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
