import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/location_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase - commented out for now
  // try {
  //   await Firebase.initializeApp();
  // } catch (e) {
  //   print('Firebase initialization error: $e');
  //   print('Continuing without Firebase for development...');
  // }
  
  runApp(const DriverApp());
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
      ],
      child: MaterialApp(
        title: 'Bus Driver Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          
          // Color scheme based on #4F86C6 (Light Blue)
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4F86C6),
            brightness: Brightness.light,
          ),
          
          // Primary color override
          primaryColor: const Color(0xFF4F86C6),
          
          // App Bar Theme
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF4F86C6),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          
          // Card Theme
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadowColor: Colors.black26,
          ),
          
          // Elevated Button Theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Outlined Button Theme
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: const BorderSide(color: Color(0xFF4F86C6)),
              foregroundColor: const Color(0xFF4F86C6),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Input Decoration Theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4F86C6), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red[600]!, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            labelStyle: TextStyle(color: Colors.grey[600]),
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          
          // Text Theme
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
            headlineSmall: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
            titleLarge: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
            titleMedium: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
            titleSmall: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            bodyLarge: TextStyle(color: Colors.grey[800]),
            bodyMedium: TextStyle(color: Colors.grey[700]),
            bodySmall: TextStyle(color: Colors.grey[600]),
          ),
          
          // Scaffold Background
          scaffoldBackgroundColor: Colors.grey[50],
          
          // Divider Theme
          dividerTheme: DividerThemeData(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading screen while checking auth state
        if (authProvider.isLoading) {
          return const LoadingScreen();
        }
        
        // Navigate based on authentication status
        if (authProvider.isSignedIn) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_bus,
              size: 64,
              color: Color(0xFF4F86C6),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Driver Portal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}