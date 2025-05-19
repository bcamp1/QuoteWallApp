import 'main.dart';
import 'logger.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin notifier = FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  // Time zones
  tz.initializeTimeZones();

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
    iOS: initializationSettingsDarwin,
  );
  await notifier.initialize(initializationSettings);
}

Future<void> notifyImmediately(String title, String body) async {
  final darwinNotificationDetails = DarwinNotificationDetails();
  final notificationDetails = NotificationDetails(iOS: darwinNotificationDetails);
  return notifier.show(0, title, body, notificationDetails);
}

Future<void> notifyAtDate(String title, String body, DateTime date, int id) async {
  // Check that the date is in the future
  if (date.difference(DateTime.now()).isNegative) {
    log.warning("Tried to schedule notification date that occurs in the past.");
    return Future.value();
  }

  final darwinNotificationDetails = DarwinNotificationDetails();
  final notificationDetails = NotificationDetails(iOS: darwinNotificationDetails);
  tz.TZDateTime scheduledDate = tz.TZDateTime.from(date, tz.getLocation('MST'));
  final utcString = scheduledDate.toUtc().toIso8601String();

  log.info("Scheduling future notification, id=$id, utc=$utcString");
  return notifier.zonedSchedule(
    id,
    title,
    body,
    scheduledDate,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exact,
  );
}

Future<void> notifyDailyQuoteOnDate(DateTime date) async {
  Quote? result = await getQuoteFromDate(date);
  Quote quote = Quote("", "", "");
  if (result == null) {
    log.warning("getQuoteFromDate came back null");
    return Future.value();
  }
  quote = result;
  final epoch = DateTime.utc(1970, 1, 1);
  final id = date.toUtc().difference(epoch).inDays; // Use days since epoch as ID
  final title = "Quote of the Day";
  final body = "${quote.quote} - ${quote.author}";
  return notifyAtDate(title, body, date, id);
}

Future<void> registerNQuoteDays(DateTime startDateTime, int numDays) async {
  for (int i = 0; i < numDays; i++) {
    final notifyDate = startDateTime.add(Duration(days: i));
    await notifyDailyQuoteOnDate(notifyDate);
  }
}

Future<void> descheduleAllNotifications() async {
  await notifier.cancelAll();
  log.info("Descheduled all notifications");
}

Future<void> notifyQuoteImmediately(Quote quote) async {
  final title = "Quote of the Day";
  final body = "${quote.quote} - ${quote.author}";
  return notifyImmediately(title, body);
}
