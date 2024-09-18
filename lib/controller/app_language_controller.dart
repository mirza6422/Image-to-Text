import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController with ChangeNotifier {
  Locale? _appLocale;

  Locale? get appLocale => _appLocale;

  void changeLanguage(Locale type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _appLocale = type;

    switch (type.languageCode) {
      case 'ms':
        await sp.setString("language_code", 'ms');
        break;
      case 'ar':
        await sp.setString("language_code", 'ar');
        break;
      case 'bg':
        await sp.setString("language_code", 'bg');
        break;
      case 'bn':
        await sp.setString("language_code", 'bn');
        break;
      case 'cs':
        await sp.setString("language_code", 'cs');
        break;
      case 'da':
        await sp.setString("language_code", 'da');
        break;
      case 'de':
        await sp.setString("language_code", 'el');
        break;
      case 'es':
        await sp.setString("language_code", 'es');
        break;
      case 'fa':
        await sp.setString("language_code", 'fa');
        break;
      case 'fi':
        await sp.setString("language_code", 'fi');
        break;
      case 'fr':
        await sp.setString("language_code", 'fr');
        break;
      case 'he':
        await sp.setString("language_code", 'he');
        break;
      case 'hi':
        await sp.setString("language_code", 'hi');
        break;
      case 'hu':
        await sp.setString("language_code", 'hu');
        break;
      case 'hr':
        await sp.setString("language_code", 'hr');
        break;
      case 'id':
        await sp.setString("language_code", 'id');
        break;
      case 'it':
        await sp.setString("language_code", 'it');
        break;
      case 'ja':
        await sp.setString("language_code", 'ja');
        break;
      case 'kk':
        await sp.setString("language_code", 'kk');
        break;
      case 'ko':
        await sp.setString("language_code", 'ko');
        break;
      case 'nl':
        await sp.setString("language_code", 'nl');
        break;
      case 'pl':
        await sp.setString("language_code", 'pl');
        break;
      case 'pt':
        await sp.setString("language_code", 'pt');
        break;
      case 'ro':
        await sp.setString("language_code", 'ro');
        break;
      case 'ru':
        await sp.setString("language_code", 'ru');
        break;
      case 'sk':
        await sp.setString("language_code", 'sk');
        break;
      case 'sl':
        await sp.setString("language_code", 'sl');
        break;
      case 'sr':
        await sp.setString("language_code", 'sr');
        break;
      case 'sv':
        await sp.setString("language_code", 'sv');
        break;
      case 'ta':
        await sp.setString("language_code", 'ta');
        break;
      case 'th':
        await sp.setString("language_code", 'th');
        break;
      case 'tr':
        await sp.setString("language_code", 'tr');
        break;
      case 'uk':
        await sp.setString("language_code", 'uk');
        break;
      case 'zh':
        await sp.setString("language_code", 'zh');
        break;
      case 'ur':
        await sp.setString("language_code", 'ur');
        break;
      case 'vi':
        await sp.setString("language_code", 'vi');
        break;
      case 'pa':
        await sp.setString("language_code", 'pa');
        break;
      case 'no':
        await sp.setString("language_code", 'no');
        break;
      case 'fil':
        await sp.setString("language_code", 'fil');
        break;
      case 'sw':
        await sp.setString("language_code", 'sw');
        break;
      case 'lt':
        await sp.setString("language_code", 'lt');
        break;
      case 'et':
        await sp.setString("language_code", 'et');
        break;
      case 'hy':
        await sp.setString("language_code", 'hy');
        break;
      case 'az':
        await sp.setString("language_code", 'az');
        break;
      case 'be':
        await sp.setString("language_code", 'be');
        break;
      case 'sq':
        await sp.setString("language_code", 'sq');
        break;
      case 'ky':
        await sp.setString("language_code", 'ky');
        break;
      case 'dv':
        await sp.setString("language_code", 'dv');
        break;
      case 'uz':
        await sp.setString("language_code", 'uz');
        break;
      case 'as':
        await sp.setString("language_code", 'as');
        break;
      case 'af':
        await sp.setString("language_code", 'af');
        break;
      case 'bs':
        await sp.setString("language_code", 'bs');
        break;
      case 'am':
        await sp.setString("language_code", 'am');
        break;
      case 'ca':
        await sp.setString("language_code", 'ca');
        break;
      case 'ka':
        await sp.setString("language_code", 'ka');
        break;
      case 'gu':
        await sp.setString("language_code", 'gu');
        break;
      case 'is':
        await sp.setString("language_code", 'is');
        break;
      case 'cy':
        await sp.setString("language_code", 'cy');
        break;
      case 'eu':
        await sp.setString("language_code", 'eu');
        break;
      case 'gl':
        await sp.setString("language_code", 'gl');
        break;
      case 'gsw':
        await sp.setString("language_code", 'gsw');
        break;
      case 'km':
        await sp.setString("language_code", 'km');
        break;
      case 'kn':
        await sp.setString("language_code", 'kn');
        break;
      case 'lo':
        await sp.setString("language_code", 'lo');
        break;
      case 'mk':
        await sp.setString("language_code", 'mk');
        break;
      case 'ml':
        await sp.setString("language_code", 'ml');
        break;
      case 'mn':
        await sp.setString("language_code", 'mn');
        break;
      case 'my':
        await sp.setString("language_code", 'my');
        break;
      case 'mr':
        await sp.setString("language_code", 'mr');
        break;
      case 'nb':
        await sp.setString("language_code", 'nb');
        break;
      case 'or':
        await sp.setString("language_code", 'or');
        break;
      case 'ps':
        await sp.setString("language_code", 'ps');
        break;
      case 'si':
        await sp.setString("language_code", 'si');
        break;
      case 'tl':
        await sp.setString("language_code", 'tl');
        break;
      case 'te':
        await sp.setString("language_code", 'te');
        break;
      case 'zu':
        await sp.setString("language_code", 'zu');
        break;
      default:
        await sp.setString("language_code", 'en'); // Fallback language
        break;
    }

    notifyListeners();
  }

  Locale _selectedLocale = const Locale('en'); // Default locale

  Locale get selectedLocale => _selectedLocale;

  void selectLanguage(Locale locale) {
    if (_selectedLocale != locale) {
      _selectedLocale = locale;
      notifyListeners(); // Notify listeners to update the UI
    }
  }
}
