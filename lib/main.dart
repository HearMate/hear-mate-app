import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hear_mate_app/data/languages.dart';
import 'package:hear_mate_app/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hear_mate_app/modules/headphones_calibration/screens/headphones_calibration_module_page/headphones_calibration_module_page.dart';
import 'package:hear_mate_app/modules/headphones_calibration/screens/headphones_calibration_welcome_page/headphones_calibration_welcome_page.dart';
import 'package:hear_mate_app/modules/hearing_test/blocs/hearing_test_module/hearing_test_module_bloc.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_module_page/hearing_test_module_page.dart';
import 'package:hear_mate_app/repositories/database_repository.dart';
import 'package:hear_mate_app/repositories/headphones_searcher_repository.dart';
import 'package:hear_mate_app/screens/about_page.dart';
import 'package:hear_mate_app/screens/menu_page.dart';
import 'package:hear_mate_app/screens/settings_page.dart';
import 'package:hear_mate_app/modules/echo_parse/screens/echo_parse_welcome_page/echo_parse_welcome_page.dart';
import 'package:hear_mate_app/modules/hearing_test/screens/hearing_test_welcome_page/hearing_test_welcome_page.dart';
import 'package:hear_mate_app/utils/logger.dart';
import 'package:hm_locale/hm_locale.dart';
import 'package:hm_theme/hm_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, String> env = {};

  // This is optional
  if (kDebugMode) {
    await dotenv.load(fileName: '.env.local-supabase', isOptional: true);

    env = Map<String, String>.from(dotenv.env);
  }

  // This is necessary.
  await dotenv.load(fileName: ".env", mergeWith: env);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HeadphonesSearcherRepository>(
          create: (context) => HeadphonesSearcherRepository(),
        ),
        RepositoryProvider<DatabaseRepository>(
          create: (context) => DatabaseRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              final themeBloc = HMThemeBloc();
              themeBloc.add(HMTHemeInitEvent());
              return themeBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              final localeBloc = HMLocaleBloc();
              localeBloc.add(HMLocaleInitEvent());
              return localeBloc;
            },
          ),
        ],
        child: BlocBuilder<HMLocaleBloc, HMLocaleState>(
          builder: (context, localeState) {
            return BlocBuilder<HMThemeBloc, HMThemeState>(
              builder: (context, themeState) {
                return MaterialApp(
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: Languages.supportedLocales,
                  locale: localeState.locale,
                  localeResolutionCallback: (locale, supportedLocales) {
                    if (localeState.locale != null) return localeState.locale;
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                          locale?.languageCode) {
                        return supportedLocale;
                      }
                    }
                    return const Locale('en');
                  },
                  debugShowCheckedModeBanner: false,
                  routes: {
                    //? Global routes
                    '/settings': (context) => SettingsPage(),
                    '/about': (context) => AboutPage(),
                    '/menu': (context) => MenuPage(),

                    //? HearMate routes (hearing test)
                    '/hearing_test/welcome':
                        (context) => const HearingTestModulePage(),

                    //? EchoParse routes
                    '/echo_parse/welcome': (context) => EchoParseWelcomePage(),

                    '/headphones_calibration/welcome':
                        (context) => HeadphonesCalibrationModulePage(),
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
                                  const Text(
                                    'The requested page was not found.',
                                  ),
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
                  theme: buildHearMateTheme(isDarkMode: themeState.isDarkMode),
                  home: HomePage(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
