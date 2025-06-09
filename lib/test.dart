// Future<void> showRepetitiveNotification() async {
//   int randomId = Random().nextInt(1000);

//   final AndroidNotificationDetails _repetitiveAndroidNotificationDetails =
//       const AndroidNotificationDetails(
//         channelRemainderId,
//         channelRemainderName,
//         channelDescription: channelRemainderDescription,
//         importance: Importance.max,
//         priority: Priority.high,
//         playSound: true,
//         enableVibration: true,
//       );

//   final AndroidNotificationChannel _repetitiveNotificationChannel =
//       const AndroidNotificationChannel(
//         channelRemainderId,
//         channelRemainderName,
//         description: channelRemainderDescription,
//         importance: Importance.high,
//         playSound: true,
//         enableVibration: true,
//       );

//   flutterLocalNotificationsPlugin.periodicallyShow(
//     randomId,
//     "Repetitive $randomId",
//     "Testing Zoned Notification $randomId",
//     RepeatInterval.everyMinute,
//     NotificationDetails(android: _repetitiveAndroidNotificationDetails),
//   );
// }

// Dismissible(
//   key: Key('item1'),
//   direction: DismissDirection.endToStart,
//   confirmDismiss: (DismissDirection direction) async {
//     return await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Confirm"),
//           content: Text("Are you sure you want to delete this item?"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               child: Text("Delete"),
//             ),
//           ],
//         );
//       },
//     );
//   },
//   onDismissed: (direction) {
//     // Remove the item from your data source.
//     print("Item dismissed");
//   },
//   background: Container(color: Colors.red),
//   child: ListTile(
//     title: Text('Swipe to delete'),
//   ),
// );
