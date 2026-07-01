import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/features/product/domain/entities/product.dart';
import 'package:getx_clean_archi/features/product/presentation/controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  void _showFilterDialog() {
    final ctrl = Get.find<HomeController>();
    final minCtrl = TextEditingController();
    final maxCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Lọc theo giá'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: minCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(label: Text('Giá tối thiểu')),
            ),
            TextFormField(
              controller: maxCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(label: Text('Giá tối đa')),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ctrl.filter();
              Get.back();
            },
            child: const Text('Xóa lọc'),
          ),
          TextButton(
            onPressed: () {
              ctrl.filter(
                minPrice: int.tryParse(minCtrl.text),
                maxPrice: int.tryParse(maxCtrl.text),
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
    final ctrl = Get.find<HomeController>();

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
                      controller: ctrl.findName,
                      onChanged: ctrl.find,
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
                  itemCount: ctrl.filteredProducts.length,
                  itemBuilder: (context, i) {
                    final actualIndex = ctrl.products.indexOf(
                      ctrl.filteredProducts[i],
                    );

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(ctrl.filteredProducts[i].name),
                            subtitle: Text('${ctrl.filteredProducts[i].price}'),
                            trailing: Text('${ctrl.filteredProducts[i].quan}'),
                          ),

                          // Xóa
                          IconButton(
                            onPressed: () => ctrl.remove(actualIndex),
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
                                      controller: ctrl.editName,
                                      decoration: const InputDecoration(
                                        label: Text('Ten san pham'),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: ctrl.editPrice,
                                      decoration: const InputDecoration(
                                        label: Text('gia'),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: ctrl.editQuan,
                                      decoration: const InputDecoration(
                                        label: Text('so luong'),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ctrl.edit(
                                          Product(
                                            ctrl.editName.text,
                                            int.tryParse(ctrl.editPrice.text) ??
                                                0,
                                            int.tryParse(ctrl.editQuan.text) ??
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
                          controller: ctrl.name,
                          decoration: const InputDecoration(
                            label: Text('Ten san pham'),
                          ),
                        ),
                        TextFormField(
                          controller: ctrl.price,
                          decoration: const InputDecoration(label: Text('gia')),
                        ),
                        TextFormField(
                          controller: ctrl.quan,
                          decoration: const InputDecoration(
                            label: Text('so luong'),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ctrl.add(
                              Product(
                                ctrl.name.text,
                                int.tryParse(ctrl.price.text) ?? 0,
                                int.tryParse(ctrl.quan.text) ?? 0,
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
