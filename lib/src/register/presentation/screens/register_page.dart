import 'package:chagi_meat_ujin/assets/assets.dart';
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
                Spacer(flex: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    AssetsData.brightness(Theme.of(context).brightness)
                        .images
                        .ujin_logo_png,
                    height: 100,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Регистрация аккаунта',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                Spacer(flex: 2),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
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
                        SizedBox(height: 16),
                        FilledButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, MapPage.routeName),
                          child: Text('Регистрация'),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(height: 12.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
