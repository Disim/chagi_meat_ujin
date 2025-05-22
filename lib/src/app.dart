import 'package:chagi_meat_ujin/src/auth/presentation/screens/auth_page.dart';
import 'package:chagi_meat_ujin/src/home/presentation/screens/home_page.dart';
import 'package:chagi_meat_ujin/src/map/presentation/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

import 'register/presentation/screens/register_page.dart';
import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

// @Openapi(
//   additionalProperties: DioProperties(pubName: 'chagi_meat_ujin_api'),
//   inputSpec: RemoteSpec(path: 'API_PATH'),
//   generatorName: Generator.dio,
//   runSourceGenOnOutput: true,
//   outputDirectory: 'packages/api',
// )
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color.fromARGB(255, 98, 203, 193),
        contrastLevel: 0,
      ),
    );
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: theme,
          darkTheme: theme,
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case SampleItemDetailsView.routeName:
                    return const SampleItemDetailsView();
                  case SampleItemListView.routeName:
                    return const SampleItemListView();
                  case RegisterPage.routeName:
                    return const RegisterPage();
                  case HomePage.routeName:
                    return const HomePage();
                  case MapPage.routeName:
                    return const MapPage();
                  case AuthPage.routeName:
                  default:
                    return const AuthPage();
                }
              },
            );
          },
        );
      },
    );
  }
}
