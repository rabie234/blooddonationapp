mixin AppLocale {
  static const String title = 'title';
  static const String welcome = 'welcome';

  static const String gender = 'Gender';
  static const String bloodType = 'Blood Type';
  static const String requestDonator = 'Request/Donator';
  static const String compatible = 'Compatible';
  static const String all = 'All';

  static const String male = 'male';
  static const String female = 'female';
  static const String requester = 'requester';
  static const String donor = 'donor';
  static const String True = 'true';
  static const String fals = 'flase';
  static const Map<String, dynamic> EN = {
    title: 'Blood Donation App',
    welcome: 'Welcome',
    gender: 'Gender',
    bloodType: 'Blood Type',
    requestDonator: 'Request/Donator',
    compatible: 'Compatible',
    all: "All",
    male: "male",
    female: "female",
    requester: "requester",
    donor: "donor",
    True: "true",
    fals: "false",
  };

  static const Map<String, dynamic> AR = {
    title: 'تطبيق التبرع بالدم',
    welcome: 'مرحبا',
    gender: 'الجنس',
    bloodType: 'فصيلة الدم',
    requestDonator: 'طلب/متبرع',
    compatible: 'متوافق',
    all: "الكل",
  };
}
String translateFilter(String key, String langCode) {
  final map = langCode == 'ar' ? AppLocale.AR : AppLocale.EN;
  return map[key] ?? key;
}
