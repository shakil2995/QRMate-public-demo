// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qrmate/providers/theme_provider.dart';
import 'package:qrmate/views/wrapper.dart';
import 'constants/app_constants.dart';
import 'constants/hive_constants.dart';
import 'hive/history_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(HiveConstants.boxName);
  Hive.registerAdapter(HistoryDataAdapter());
  await Hive.openBox<HistoryData>('history_item_box');
  // await initNotification();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  static final GlobalKey<NavigatorState> globalNavigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final themeRef = ref.watch(themeNotifierProvider);
    final themeColorRef = ref.watch(themeColorNotifierProvider);

    var filledButtonThemeData = FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );

    var timePickerThemeData = TimePickerThemeData(
      hourMinuteTextStyle: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
    );
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.globalNavigatorKey,
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        colorScheme: getColorScheme(themeColorRef.themeColor),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        timePickerTheme: timePickerThemeData,
        filledButtonTheme: filledButtonThemeData,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: getColorScheme(themeColorRef.themeColor, isDarkMode: true),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
        timePickerTheme: timePickerThemeData,
        filledButtonTheme: filledButtonThemeData,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      themeMode: themeRef.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const Wrapper(),
    );
  }
}

ColorScheme getColorScheme(Color color, {bool isDarkMode = false}) {
  return ColorScheme.fromSeed(
      seedColor: color,
      brightness: isDarkMode ? Brightness.dark : Brightness.light);
}

// Future<void> initNotification() async {
//   await AwesomeNotifications().initialize(
//     'resource://drawable/logo',
//     [
//       getNotificationChannel(
//         key: 'reminder',
//         name: 'Test',
//         description: 'Test',
//       ),
//     ],
//     debug: true,
//   );
// }

// NotificationChannel getNotificationChannel({
//   required String key,
//   required String name,
//   required String description,
// }) {
//   return NotificationChannel(
//     channelKey: key,
//     channelName: name,
//     channelDescription: description,
//     ledColor: Colors.white,
//     enableVibration: true,
//     onlyAlertOnce: true,
//     channelShowBadge: false,
//     playSound: true,
//     importance: NotificationImportance.Max,
//   );
// }
