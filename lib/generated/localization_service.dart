import 'locales.g.dart';

class LocalizationService {
  static const Map<String, Map<String, String>> keys = {
    'en': {
      ...Locales.en_US,
    },
    'fa': {
      ...Locales.fa_IR,
    }
  };
}
