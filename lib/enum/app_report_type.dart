import 'package:alita/translation/app_translation.dart';

enum AppReportType {
  politicalSensitivity(label: AppMessage.politicalSensitivity),
  violentPornography(label: AppMessage.violentPornography),
  advertisingHarassment(label: AppMessage.advertisingHarassment),
  other(label: AppMessage.other),
  ;

  final AppMessage label;
  const AppReportType({required this.label});
}
