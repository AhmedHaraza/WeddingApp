import 'package:go_router/go_router.dart';
import 'package:wedding/features/home/presentation/views/provider_home/provider_home_page.dart';
import 'package:wedding/features/home/presentation/views/user_home/pages/about_us_page.dart';
import 'package:wedding/features/home/presentation/views/user_home/pages/contact_us_page.dart';

import '../../features/auth/presentation/login/presentation/views/forget_password_page.dart';
import '../../features/auth/presentation/login/presentation/views/login_page.dart';
import '../../features/auth/presentation/signup/presentation/views/select_authorization.dart';
import '../../features/auth/presentation/signup/presentation/views/signup_provider_page.dart';
import '../../features/auth/presentation/signup/presentation/views/signup_user_page.dart';
import '../../features/splash/presentation/views/splash_page.dart';

abstract class AppRouter {
  static const KLoginPage = '/login';
  static const KAuthPath = '/auth';
  static const KSignUpUser = '/signupUser';
  static const KSignUpProvider = '/signupProvider';
  static const KSignUpProvider2 = '/signupProvider2';
  static const KForgerPassword = '/forgetPassword';
  static const KUserHome = '/userHome';
  static const KProviderDetailsPage = '/providerDetailsPage';
  static const KMaximizeImage = '/maximizeImage';
  static const KProviderHomePage = "/providerHomePage";
  static const KVideoDisplayPage = "/displayVideoPage";
  static const KAboutUs = '/aboutUsPage';
  static const kContactUs = "/contactUsPage";

  static final router = GoRouter(routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: KLoginPage,
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: KAuthPath,
      builder: (context, state) => const AuthorizationPage(),
    ),
    GoRoute(
      path: KSignUpUser,
      builder: (context, state) => const SignUpUserPage(),
    ),
    GoRoute(
      path: KSignUpProvider,
      builder: (context, state) => const SignUpProviderPage(),
    ),
    // GoRoute(
    //   path: KSignUpProvider2,
    //   builder: (context , state)=> SignUpProviderPage2()
    // ),
    GoRoute(
      path: KForgerPassword,
      builder: (context, state) => const ForgetPasswordPage(),
    ),

    // GoRoute(
    //   path: KUserHome,
    //   builder: (context, state) => const UserHomePage(),
    // ),
    // GoRoute(
    //   path: KProviderDetailsPage,
    //   builder: (context, state) => const UserToProviderDetailsPage(),
    // ),
    // GoRoute(
    //   path: KMaximizeImage,
    //   builder: (context, state) => const MaxmizeImage(),
    // ),
    GoRoute(
      path: KProviderHomePage,
      builder: (context, state) => const ProviderHomePage(),
    ),
    // GoRoute(
    //   path: KVideoDisplayPage,
    //   builder: (context, state) => const DisplayVideo(),
    // ),

    // GoRoute(
    //   path: KpaymentPage,
    //   builder: (context, state) =>  const PaymentPage(),
    // ),
    GoRoute(
      path: KAboutUs,
      builder: (context, state) => FAQPage(),
    ),
    GoRoute(
      path: kContactUs,
      builder: (context, state) => ContactUsPage(),
    ),
  ]);
}
