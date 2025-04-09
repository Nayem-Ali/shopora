import 'package:flutter/material.dart';
import 'package:shopora/core/constants/database_credentials.dart';
import 'core/app/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: DatabaseCredentials.databaseUrl,
    anonKey: DatabaseCredentials.anonKey,
  );
  runApp(const App());
}
