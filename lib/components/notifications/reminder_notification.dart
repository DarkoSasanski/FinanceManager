import 'package:financemanager/services/notifications_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> scheduleReminderNotification(int id, String title, int money, DateTime scheduledTime) async {
  final NotificationService notificationService = NotificationService();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'id',
    'name',
    channelDescription: 'Reminder Notification',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  scheduledTime = DateTime.parse(
        '${scheduledTime.year}-${scheduledTime.month <=9 ? '0${scheduledTime.month}' : scheduledTime.month}-${scheduledTime
            .day<=9 ? '0${scheduledTime.day}' : scheduledTime.day} 12:00:00');


  await notificationService.flutterLocalNotificationsPlugin.schedule(
      id+1, // Notification ID
      'Reminder', // Notification title
      'Your reminder for $title is set for today for the amount of \$$money', // Notification body
      scheduledTime, // Scheduled time
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
}

Future<void> cancelScheduledNotification(int notificationId) async {
  final NotificationService notificationService = NotificationService();
  await notificationService.flutterLocalNotificationsPlugin.cancel(notificationId);
}