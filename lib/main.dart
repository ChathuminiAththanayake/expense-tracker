import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/expense_service.dart';
import 'providers/expense_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

const _seedColor = Color(0xFF2455C9); // professional deep blue

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    sslEnabled: true,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const RootApp(),
    ),
  );
}

ThemeData _buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: _seedColor, brightness: brightness);
  final base = ThemeData(brightness: brightness, useMaterial3: true, colorScheme: scheme);
  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme),
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: _seedColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _seedColor,
      foregroundColor: Colors.white,
      extendedTextStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: const CardThemeData(elevation: 0),
  );
}

/// Watches the login state. Signed out -> login screen.
/// Signed in -> home screen, with the ExpenseProvider wrapping the whole
/// MaterialApp so every screen (including ones opened with Navigator.push)
/// can see it.
class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  late final Stream<User?> _authStream = AuthService().userChanges;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _App(
            key: ValueKey('loading'),
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final user = snapshot.data;
        if (user == null || user.isAnonymous) {
          return const _App(key: ValueKey('auth'), home: AuthScreen());
        }

        return ChangeNotifierProvider(
          key: ValueKey(user.uid),
          create: (_) => ExpenseProvider(ExpenseService(user.uid)),
          child: const _App(key: ValueKey('home'), home: HomeScreen()),
        );
      },
    );
  }
}

class _App extends StatelessWidget {
  final Widget home;
  const _App({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.mode,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: home,
    );
  }
}