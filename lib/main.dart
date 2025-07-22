import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish/auth/screens/login_page.dart';
import 'package:stylish/auth/screens/sign_up_page.dart';
import 'package:stylish/colors.dart';
import 'package:stylish/firebase_options.dart';
import 'package:stylish/home/homepage.dart';
import 'package:stylish/pages/cart.dart';
import 'package:stylish/pages/conf/profile_setup.dart';
import 'package:stylish/pages/profile_edit.dart';
import 'package:stylish/pages/search.dart';
import 'package:stylish/pages/settings_page.dart';
import 'package:stylish/pages/vendor_store_view.dart';
import 'package:stylish/pages/wishlist.dart';
// import 'package:stylish/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: child,
          theme: ThemeData(scaffoldBackgroundColor: bkgColor),
          routes: {
            '/home': (context) => const Homepage(),
            '/settings': (context) => const Settings(),
            '/cart': (context) => const Cart(),
            '/wishlist': (context) => const Wishlist(),
            '/search': (context) => const SearchPage(),
            '/login': (context) => const LoginPage(),
            '/setup': (context) => ProfileSetup(),
            '/vendorStore': (context) => VendorStoreView(),
            // '/profileEdit': (context) => ProfileEdit(),
          },
        );
      },
      // child: SignUpPage(),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const Homepage();
          }
          return LoginPage();
        },
      ),
    );
  }
}
