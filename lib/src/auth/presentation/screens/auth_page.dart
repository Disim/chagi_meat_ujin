import 'package:chagi_meat_ujin/src/home/presentation/screens/home_page.dart';
import 'package:chagi_meat_ujin/src/register/presentation/screens/register_page.dart';
import 'package:flutter/material.dart';

import '../../../../assets/assets.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  static const routeName = '/auth';

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController passwordController = TextEditingController();
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
                  'Личный кабинет',
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
                        SizedBox(height: 16),
                        FilledButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, HomePage.routeName),
                          child: Text('Войти'),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterPage.routeName);
                  },
                  child: Text('Зарегистрироваться'),
                ),
                SizedBox(height: 12.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
