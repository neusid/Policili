import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/config/app.dart';
import 'app/config/app_config.dart';
import 'core/di/injection_container.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Offline Font Guard: mencegah google_fonts melakukan request HTTP saat offline
  GoogleFonts.config.allowRuntimeFetching = false;

  AppConfig.initialize();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase offline bypass: $e');
  }
  await initializeDateFormatting('id_ID', null);
  await initDependencies();
  runApp(const PoliciliApp());
}