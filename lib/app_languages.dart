import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/app_language_controller.dart';

class AppLanguages extends StatefulWidget {
  const AppLanguages({super.key});

  @override
  State<AppLanguages> createState() => _AppLanguagesState();
}

class _AppLanguagesState extends State<AppLanguages> {
  final List<Map<String, Locale>> _languages = [
    {'English': const Locale("en")},
    {'Urdu': const Locale("ur")},
    {'Hindi': const Locale("hi")},
    {'Punjabi': const Locale("pa")},
    {'Arabic': const Locale("ar")},
    {'Bengali': const Locale("bn")},
    {'Persian': const Locale("fa")},
    {'Greek': const Locale("el")},
    {'Chinese': const Locale("zh")},
    {'Turkish': const Locale("tr")},
    {'Italian': const Locale("it")},
    {'German': const Locale("de")},
    {'Spanish': const Locale("es")},
    {'French': const Locale("fr")},
    {'Malay': const Locale("ms")},
    {'Bulgarian': const Locale("bg")},
    {'Czech': const Locale("cs")},
    {'Danish': const Locale("da")},
    {'Finnish': const Locale("fi")},
    {'Hebrew': const Locale("he")},
    {'Hungarian': const Locale("hu")},
    {'Indonesian': const Locale("id")},
    {'Japanese': const Locale("ja")},
    {'Korean': const Locale("ko")},
    {'Kazakh': const Locale("kk")},
    {'Dutch': const Locale("nl")},
    {'Polish': const Locale("pl")},
    {'Portuguese': const Locale("pt")},
    {'Romanian': const Locale("ro")},
    {'Russian': const Locale("ru")},
    {'Slovak': const Locale("sk")},
    {'Slovenian': const Locale("sl")},
    {'Serbian': const Locale("sr")},
    {'Swedish': const Locale("sv")},
    {'Tamil': const Locale("ta")},
    {'Thai': const Locale("th")},
    {'Ukrainian': const Locale("uk")},
    {'Vietnamese': const Locale("vi")},
    {'Croatian': const Locale("hr")},
    {'Filipino': const Locale("fil")},
    {'Swahili': const Locale("sw")},
    {'Lithuanian': const Locale("lt")},
    {'Estonian': const Locale("et")},
    {'Kyrgyz': const Locale("ky")},
    {'Albanian': const Locale("sq")},
    {'Somali': const Locale("so")},
    {'Belarusian': const Locale("be")},
    {'Azerbaijani': const Locale("az")},
    {'Armenian': const Locale("hy")},
    {'Uzbek': const Locale("uz")},
    {'Assamese': const Locale("as")},
    {'Afrikaans': const Locale("af")},
    {'Amharic': const Locale("am")},
    {'Bosnian': const Locale("bs")},
    {'Catalan': const Locale("ca")},
    {'Georgian': const Locale("ka")},
    {'Gujarati': const Locale("gu")},
    {'Icelandic': const Locale("is")},
    {'Welsh': const Locale("cy")},
    {'Basque': const Locale("eu")},
    {'Galician': const Locale("gl")},
    {'Swiss German': const Locale("gsw")},
    {'Khmer': const Locale("km")},
    {'Kannada': const Locale("kn")},
    {'Lao': const Locale("lo")},
    {'Macedonian': const Locale("mk")},
    {'Malayalam': const Locale("ml")},
    {'Marathi': const Locale("mr")},
    {'Burmese': const Locale("my")},
    {'Norwegian Bokmål': const Locale("nb")},
    {'Oriya': const Locale("or")},
    {'Pushtu': const Locale("ps")},
    {'Sinhalese': const Locale("si")},
    {'Tagalog': const Locale("tl")},
    {'Telugu': const Locale("te")},
    {'Zulu': const Locale("zu")},
  ];

  void _onLanguageTap(int index, LanguageChangeController lngProvider) {
    Navigator.pop(context);
    final locale = _languages[index].values.first;
    lngProvider.changeLanguage(locale);
    lngProvider.selectLanguage(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('App languages'),
        ),
        body: Consumer<LanguageChangeController>(
          builder: (context, lngProvider, child) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final language = _languages[index].keys.first;

                final selectedLocale = lngProvider.selectedLocale;
                final isSelected =
                    selectedLocale == _languages[index].values.first;
                return Column(
                  children: [
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text(language)),
                            if (isSelected)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).primaryColor,
                              ),
                          ],
                        ),
                      ),
                      onTap: () => _onLanguageTap(index, lngProvider),
                    ),
                    const Divider(
                      height: 5,
                      endIndent: 20,
                      indent: 20,
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
