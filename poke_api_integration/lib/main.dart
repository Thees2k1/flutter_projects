import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'core/api_client.dart';
import 'core/database/app_database.dart';
import 'core/poke_repo.dart';
import 'pokelist/page.dart';
import 'pokelist/view_model.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = ThemeData(
      primaryColor: Colors.red,
      scaffoldBackgroundColor: Colors.red,
      textTheme: TextTheme().copyWith(
        titleLarge: TextStyle(
          fontSize: 24,
          height: 1.33,
          color: Colors.white,
          fontWeight: .w700,
        ),
      ),
    );
    return Provider<AppDatabase>(
      create: (_) => AppDatabase(),
      dispose: (_, db) => db.close(),
      builder: (context, _) {
        final repo = PokeRepo(
          apiClient: ApiClient(
            dio: Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2')),
          ),
          db: context.read<AppDatabase>(),
        );

        return ChangeNotifierProvider(
          create: (_) => PokeListViewModal(repo: repo)..fetchData(),
          child: MaterialApp(
            theme: appTheme.copyWith(
              textTheme: GoogleFonts.poppinsTextTheme(appTheme.textTheme),
            ),
            home: HomePage(),
          ),
        );
      },
    );
  }
}
