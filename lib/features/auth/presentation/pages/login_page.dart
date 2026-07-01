import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<LoginController>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mã số thuế (custom error right)
              FormField<String>(
                validator: (value) {
                  if (ctrl.tax.text.isEmpty) {
                    return 'Không được để trống';
                  }
                  return null;
                },
                builder: (state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: ctrl.tax,
                        keyboardType: TextInputType.number,
                        onChanged: state.didChange,
                        decoration: InputDecoration(
                          labelText: 'Mã số thuế',
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: state.hasError ? Colors.red : Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: state.hasError ? Colors.red : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, right: 4.0),
                          child: Text(
                            state.errorText ?? '',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 12),

              // Username 
              FormField<String>(
                validator: (value) {
                  if (ctrl.username.text.isEmpty) {
                    return 'Không được để trống';
                  }
                  return null;
                },
                builder: (state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: ctrl.username,
                        onChanged: state.didChange,
                        decoration: InputDecoration(
                          labelText: 'Tên đăng nhập',
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: state.hasError ? Colors.red : Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: state.hasError ? Colors.red : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, right: 4),
                          child: Text(
                            state.errorText ?? '',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 12),

              // Password
              FormField<String>(
                validator: (value) {
                  if (ctrl.password.text.isEmpty) {
                    return 'Không được để trống';
                  }
                  return null;
                },
                builder: (state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: ctrl.password,
                        obscureText: true,
                        onChanged: state.didChange,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: state.hasError ? Colors.red : Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: state.hasError ? Colors.red : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, right: 4),
                          child: Text(
                            state.errorText ?? '',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Button (Obx đúng chỗ) 
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        ctrl.isLoading.value
                            ? null
                            : () {
                              if (_formKey.currentState!.validate()) {
                                ctrl.submit();
                              }
                            },
                    child:
                        ctrl.isLoading.value
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text('Đăng nhập'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
