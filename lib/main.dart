import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_to_text/state/image_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/app_language_controller.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  final String languageCode = sp.getString("language_code") ?? '';
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ImageState()),
          ChangeNotifierProvider(create: (_) => LanguageChangeController())
        ],
        child: OCRApp(
          locale: languageCode,
        )),
  );
}

class OCRApp extends StatelessWidget {
  final String locale;

  const OCRApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChangeController>(
      builder: (context, lngProvider, child) {
        if (locale.isEmpty) {
          lngProvider.changeLanguage(const Locale('en'));
        }
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: locale == ''
                ? const Locale('en')
                : lngProvider.appLocale ?? const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale("en"),
              Locale("ms"),
              Locale("ar"),
              Locale('bn'),
              Locale("bg"),
              Locale("cs"),
              Locale("da"),
              Locale("as"),
              Locale("af"),
              Locale("bs"),
              Locale("de"),
              Locale("el"),
              Locale("en"),
              Locale("es"),
              Locale("fa"),
              Locale("fi"),
              Locale("fr"),
              Locale("he"),
              Locale("hi"),
              Locale("hu"),
              Locale("id"),
              Locale("it"),
              Locale("ja"),
              Locale("kk"),
              Locale("ko"),
              Locale("nl"),
              Locale("pl"),
              Locale("pt"),
              Locale("ro"),
              Locale("ru"),
              Locale("sk"),
              Locale("sl"),
              Locale("sr"),
              Locale("sv"),
              Locale("ta"),
              Locale("th"),
              Locale("tr"),
              Locale("uk"),
              Locale("ur"),
              Locale("vi"),
              Locale("zh"),
              Locale("hr"),
              Locale("no"),
              Locale("pa"),
              Locale("fil"),
              Locale("sw"),
              Locale("lt"),
              Locale("et"),
              Locale("hy"),
              Locale("az"),
              Locale("be"),
              Locale("sq"),
              Locale("ky"),
              Locale("dv"),
              Locale("uz"),
              Locale("kn"),
              Locale("km"),
              Locale("gsw"),
              Locale("gl"),
              Locale("eu"),
              Locale("cy"),
              Locale("is"),
              Locale("gu"),
              Locale("ka"),
              Locale("ca"),
              Locale("af"),
              Locale("am"),
              Locale("as"),
              Locale("bs"),
              Locale("lo"),
              Locale("mk"),
              Locale("ml"),
              Locale("mn"),
              Locale("mr"),
              Locale("my"),
              Locale("no"),
              Locale("or"),
              Locale("ps"),
              Locale("si"),
              Locale("tl"),
              Locale("te"),
              Locale("zu"),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            title: 'OCR',
            theme: ThemeData(colorSchemeSeed: Colors.blue),
            home: const SplashScreen());
      },
    );
  }
}
