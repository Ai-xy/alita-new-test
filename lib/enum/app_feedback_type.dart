import 'package:alita/translation/app_translation.dart';

enum AppFeedbackType {
  appError(label: AppMessage.appError),
  accountError(label: AppMessage.accountError),
  suggestion(label: AppMessage.suggestion),
  other(label: AppMessage.other),
  ;

  final AppMessage label;
  const AppFeedbackType({required this.label});
}
