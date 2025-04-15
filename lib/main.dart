import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hear_mate_app/data/notifiers.dart';
import 'package:hear_mate_app/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hear_mate_app/modules/echo_parse/screens/echo_parse_settings_page/echo_parse_settings_page.dart';

import 'package:hear_mate_app/modules/echo_parse/screens/echo_parse_welcome_page/echo_parse_welcome_page.dart';
import 'package:hear_mate_app/modules/echo_parse/screens/echo_parse_upload_page/echo_parse_upload_page.dart';
import 'package:hear_mate_app/modules/echo_parse/screens/echo_parse_upload_done_page/echo_parse_upload_done_page.dart';
import 'package:hear_mate_app/modules/echo_parse/screens/echo_parse_collection_page/echo_parse_collection_page.dart';

import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test/hearing_test_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/repositories/hearing_test_sounds_player_repository.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_page/hearing_test_page.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_result_page/hearing_test_result_page.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_welcome_page/hearing_test_welcome_page.dart';
import 'package:hear_mate_app/widgets/locale_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocaleProvider(
      locale: _locale,
      setLocale: _setLocale,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) {
              final hearingTestSoundsPlayerRepository =
                  HearingTestSoundsPlayerRepository();
              hearingTestSoundsPlayerRepository.initialize();
              return hearingTestSoundsPlayerRepository;
            },
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create:
                  (context) => HearingTestBloc(
                    hearingTestSoundsPlayerRepository:
                        context.read<HearingTestSoundsPlayerRepository>(),
                  ),
            ),
          ],
          child: ValueListenableBuilder(
            valueListenable: isDarkModeNotifier,
            builder: (context, value, child) {
              return MaterialApp(
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  Locale('en'), //? English
                  Locale('pl'), //? Polish
                ],
                locale: _locale,
                localeResolutionCallback: (locale, supportedLocales) {
                  if (_locale != null) return _locale;

                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale?.languageCode) {
                      return supportedLocale;
                    }
                  }

                  return const Locale('en');
                },
                debugShowCheckedModeBanner: false,
                routes: {
                  '/hearing_test/welcome':
                      (context) => const HearingTestWelcomePage(),
                  '/hearing_test/start': (context) => const HearingTestPage(),
                  '/hearing_test/result': (context) => HearingTestResultPage(),
                  '/echo_parse/welcome': (context) => EchoParseWelcomeScreen(),
                  '/echo_parse/upload': (context) => EchoParseUploadScreen(),
                  '/echo_parse/upload_done':
                      (context) => EchoParseUploadDoneScreen(),
                  '/echo_parse/collection':
                      (context) => EchoParseCollectScreen(),
                  '/echo_parse/settings': (context) => EchoParseSettingPage(),
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
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.teal,
                    brightness: value ? Brightness.dark : Brightness.light,
                  ),
                ),
                home: HomePage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
