import 'package:financemanager/services/notifications_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> showAccountExpenseNotification(String accName, int money) async {
  final NotificationService notificationService = NotificationService();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'id',
    'name',
    channelDescription: 'Income Notification',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await notificationService.flutterLocalNotificationsPlugin.show(
    0,
    'Expense on the account',
    'Your account $accName has been updated. Your new balance is \$$money',
    platformChannelSpecifics,
  );
}
