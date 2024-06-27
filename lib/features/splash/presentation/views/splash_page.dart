import 'package:flutter/material.dart';
import 'package:wedding/features/splash/presentation/views/widgets/splash_view_body.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Opacity(
      opacity: 0.8,
      child: Scaffold(
          body: SplashBodyView(),
        backgroundColor: Color(0xff107761),
      ),
    );

  }


}
