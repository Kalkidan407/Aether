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





// import 'package:fitness_tracker_app/enums/workout_type.dart';
// import 'package:flutter/material.dart';

// class WorkoutFormDialog extends StatefulWidget {
//   const WorkoutFormDialog({super.key});

//   @override
//   State<WorkoutFormDialog> createState() => _WorkoutFormDialogState();
// }

// class _WorkoutFormDialogState extends State<WorkoutFormDialog> {
//   final formKey = GlobalKey<FormState>();
//   late final TextEditingController nameController;
//   late final TextEditingController weightController;
//   late final TextEditingController repsController;
//   late final TextEditingController setsController;
//   WorkoutType selectedType = WorkoutType.upperBody;

//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController();
//     weightController = TextEditingController();
//     repsController = TextEditingController();
//     setsController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     weightController.dispose();
//     repsController.dispose();
//     setsController.dispose();
//     super.dispose();
//   }

//   void submitForm() {
//     // Your submit form logic here
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Add Workout'),
//       content: Form(
//         key: formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//               validator: (value) =>
//                   value?.isEmpty ?? true ? 'Please enter a name' : null,
//             ),
//             TextFormField(
//               controller: weightController,
//               decoration: const InputDecoration(labelText: 'Weight (kg)'),
//               keyboardType: TextInputType.number,
//               validator: (value) =>
//                   value?.isEmpty ?? true ? 'Please enter weight' : null,
//             ),
//             TextFormField(
//               controller: repsController,
//               decoration: const InputDecoration(labelText: 'Reps'),
//               keyboardType: TextInputType.number,
//               validator: (value) =>
//                   value?.isEmpty ?? true ? 'Please enter reps' : null,
//             ),
//             TextFormField(
//               controller: setsController,
//               decoration: const InputDecoration(labelText: 'Sets'),
//               keyboardType: TextInputType.number,
//               validator: (value) =>
//                   value?.isEmpty ?? true ? 'Please enter sets' : null,
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<WorkoutType>(
//               value: selectedType,
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() {
//                     selectedType = value;
//                   });
//                 }
//               },
//               items: const [
//                 DropdownMenuItem(
//                   value: WorkoutType.upperBody,
//                   child: Text('Upper Body'),
//                 ),
//                 DropdownMenuItem(
//                   value: WorkoutType.lowerBody,
//                   child: Text('Lower Body'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: submitForm,
//           child: const Text('Add'),
//         ),
//       ],
//     );
//   }
// }


