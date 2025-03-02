import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/home_page.dart';
import 'package:bloc/bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_page/hearing_test_page.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_result_page/hearing_test_result_page.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_welcome_page/hearing_test_welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => HearingTestBloc())],
      child: MaterialApp(
        routes: {
          '/hearing_test': (context) => const HearingTestWelcomePage(),
          '/hearing_test/start': (context) => const HearingTestPage(),
          '/hearing_test/result': (context) => const HearingTestResultPage(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder:
                (context) => Scaffold(
                  appBar: AppBar(title: const Text('Page Not Found')),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('The requested page was not found.'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed:
                              () => Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (route) => false,
                              ),
                          child: const Text('Return to Home'),
                        ),
                      ],
                    ),
                  ),
                ),
          );
        },
        title: 'HearMate',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HomePage(),
      ),
    );
  }
}
