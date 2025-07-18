import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_bill/firebase_options.dart';
import 'package:power_bill/pages/account_detail_page.dart';
import 'package:power_bill/pages/home_router.dart';
import 'package:power_bill/pages/router/usc_management_page.dart';
import 'package:power_bill/pages/splash_screen.dart';
import 'package:power_bill/pages/themeswitch.dart';
import 'package:power_bill/provider/account_provider.dart';
import 'package:power_bill/provider/auth_provider.dart';
import 'package:power_bill/provider/bottom_navbarprovider.dart';
import 'package:power_bill/services/Newservicepage.dart';
import 'package:power_bill/services/PowerOutagePage.dart';
import 'package:power_bill/services/SuppyGrievancesPage.dart';
import 'package:power_bill/services/Voltagefluctuationpage.dart';
import 'package:power_bill/services/billingissuesPage.dart';
import 'package:power_bill/services/contactuspage.dart';
import 'package:power_bill/services/greentarifpage.dart';
import 'package:power_bill/services/metterissuesPage.dart';
import 'package:power_bill/services/roofTopSolarpage.dart';
import 'package:power_bill/themes/dark_theme.dart';
import 'package:power_bill/themes/light_theme.dart';
import 'package:power_bill/provider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(384, 854),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
          ChangeNotifierProvider(create: (_) => FirestoreProvider()),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightmode,
              darkTheme: darkmode,
              themeMode: themeProvider.themeMode,
              home: const SplashScreen(),
              routes: {
                '/home': (context) => const Home(),
                '/usc_management': (context) => const UscManagementPage(),
                '/themeswitch': (context) => const ThemeSwitcherScreen(),
                '/account_detail': (context) => const AccountDetailPage(),
                '/voltagefluctuation': (context) => const Voltagefluctuationpage(),
                '/poweroutage': (context) => const PowerOutagePage(),
                '/billingissues': (context) => const billingissuesPage(),
                '/contactus': (context) => const ContactUsPage(),
                '/meterissues': (context) => const metterissuesPage(),
                '/supply grievances': (context) => const SuppyGrievancesPage(),
                '/green tarif': (context) => const greentarifpage(),
                '/new service ': (context) => const Newservicepage(),
                
                '/roof top solar': (context) => const roofTopSolarpage(),
              },
            );
          },
        ),
      ),
    );
  }
}
