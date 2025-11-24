import 'package:flutter/material.dart';
import '../controllers/apiservice.dart';
import '../controllers/loginstore.dart';



class LoginPageStateless extends StatelessWidget {
  LoginPageStateless({super.key});

  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<bool> showPassword = ValueNotifier(false);

  final authService = AuthService();
  final storage = LocalStorage();

  void login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    loading.value = true;

    final result = await authService.login(
      emailCtrl.text,
      passCtrl.text,
    );

    loading.value = false;

    if (result["success"] == true) {
      await storage.saveTokens(result["access_token"], result["refresh_token"]);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Successful!")));

    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (_) => const DashboardPage()),
    //   );
    // } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailCtrl,
                validator: (v) =>
                v!.isEmpty ? "Email is required" : null,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 20),

              ValueListenableBuilder<bool>(
                valueListenable: showPassword,
                builder: (_, value, __) {
                  return TextFormField(
                    controller: passCtrl,
                    obscureText: !value,
                    validator: (v) =>
                    v!.isEmpty ? "Password is required" : null,
                    decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          value ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () =>
                        showPassword.value = !showPassword.value,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              ValueListenableBuilder<bool>(
                valueListenable: loading,
                builder: (_, isLoading, __) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => login(context),
                      child: isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text("Login"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
