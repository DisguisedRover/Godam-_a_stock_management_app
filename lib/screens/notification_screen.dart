import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final IconData icon;
  final Color iconColor;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.icon = Icons.info_outline,
    this.iconColor = Colors.blue,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      icon: icon,
      iconColor: iconColor,
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mock notifications
  List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'notif-1',
      title: 'New Analysis Result Available',
      message:
          'Analysis ID: ANALYSIS-1005 has been completed. Fat: 3.8%, Protein: 3.3%.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      icon: Icons.science,
      iconColor: Colors.teal,
    ),
    NotificationItem(
      id: 'notif-2',
      title: 'Quality Alert: High Fat Content',
      message:
          'Analysis ID: ANALYSIS-1004 shows fat content (4.6%) above standard (4.5%).',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
      icon: Icons.warning_amber,
      iconColor: Colors.orange,
    ),
    NotificationItem(
      id: 'notif-3',
      title: 'System Update Completed',
      message:
          'The Milk Analyzer application has been updated to the latest version.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.system_update_alt,
      iconColor: Colors.blueGrey,
    ),
    NotificationItem(
      id: 'notif-4',
      title: 'Reminder: Check Daily Samples',
      message: 'Don\'t forget to perform your daily milk sample analysis.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.notifications_active,
      iconColor: Colors.purple,
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      _notifications = _notifications.map((notif) {
        return notif.id == id ? notif.copyWith(isRead: true) : notif;
      }).toList();
    });
  }

  void _deleteAllNotifications() {
    setState(() {
      _notifications.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('All notifications deleted!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            tooltip: 'Mark All as Read',
            onPressed: () {
              setState(() {
                _notifications = _notifications
                    .map((notif) => notif.copyWith(isRead: true))
                    .toList();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read!'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Delete All',
            onPressed: _deleteAllNotifications,
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No new notifications.',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return Card(
                    elevation: notification.isRead ? 2 : 5,
                    margin: const EdgeInsets.only(bottom: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: notification.isRead
                        ? Theme.of(context).cardTheme.color?.withOpacity(0.7)
                        : Theme.of(context).cardTheme.color,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () {
                        _markAsRead(notification.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Notification: ${notification.title}',
                            ),
                          ),
                        );
                        // In a real app, navigate to a detailed view or take action
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              notification.icon,
                              size: 30,
                              color: notification.iconColor,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: notification.isRead
                                              ? Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium?.color
                                              : Theme.of(
                                                  context,
                                                ).textTheme.titleMedium?.color,
                                        ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    notification.message,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: notification.isRead
                                              ? Theme.of(
                                                  context,
                                                ).textTheme.bodySmall?.color
                                              : Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium?.color,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      DateFormat(
                                        'MMM d, yyyy HH:mm',
                                      ).format(notification.timestamp),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
