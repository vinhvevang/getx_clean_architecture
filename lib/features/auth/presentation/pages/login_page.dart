
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_archi/features/auth/presentation/controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _tax  = TextEditingController();
  final _user = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<LoginController>();

    return Scaffold(
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // ── Mã số thuế ──
              TextFormField(
                controller: _tax,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(label: Text('Mã số thuế')),
              ),
              if (ctrl.taxError.value != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    ctrl.taxError.value!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 12),

              // ── Tên đăng nhập ──
              TextFormField(
                controller: _user,
                decoration: const InputDecoration(label: Text('Tên đăng nhập')),
              ),
              if (ctrl.usernameError.value != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    ctrl.usernameError.value!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 12),

              // ── Mật khẩu ──
              TextFormField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(label: Text('Mật khẩu')),
              ),
              if (ctrl.passwordError.value != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    ctrl.passwordError.value!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),

              // ── Nút đăng nhập ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      ctrl.submit(_tax.text, _user.text, _pass.text),
                  child: const Text('Đăng nhập'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
