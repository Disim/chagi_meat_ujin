import 'package:chagi_meat_ujin/src/map/presentation/screens/map.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Spacer(),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Введите email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    hintText: 'Введите пароль',
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите пароль';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Подтвердите пароль',
                    hintText: 'Введите пароль еще раз',
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите пароль еще раз';
                    }
                    if (value != passwordController.text) {
                      return 'Пароли не совпадают';
                    }
                    return null;
                  },
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, MapPage.routeName),
                  child: Text('Регистрация'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
