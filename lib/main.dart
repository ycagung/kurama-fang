import 'package:flutter/material.dart';
import 'package:fang/config/environment.dart';
import 'package:fang/cubit/auth_cubit.dart';
import 'package:fang/pages/_pages.dart';
import 'package:fang/services/socket_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set dev environment
  EnvironmentConfig.setEnvironment(Environment.dev);

  runApp(const Fang());
}

class Fang extends StatelessWidget {
  const Fang({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()..init(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.ubuntuTextTheme(
            Theme.of(context).textTheme,
          ).apply(bodyColor: Colors.white, displayColor: Colors.white),
        ),
        title: 'Kurama',
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Show loading while checking auth status
        if (state.status == AuthStatus.initial ||
            state.status == AuthStatus.loading) {
          return Scaffold(
            backgroundColor: Colors.grey[900],
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Show login page if not authenticated
        if (state.status == AuthStatus.unauthenticated) {
          return const LoginPage();
        }

        // Show home page if authenticated
        if (state.status == AuthStatus.authenticated) {
          // Connect socket if not already connected
          if (!SocketService.instance.isConnected) {
            SocketService.instance.connect();
          }
          return const HomePage();
        }

        // Default to login page
        return const LoginPage();
      },
    );
  }
}
