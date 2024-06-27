
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedding/features/splash/presentation/views/widgets/sliding_txt.dart';

import '../../../../../core/utils/app_router.dart';
import '../../../../auth/manager/auth_cubit/auth_cubit.dart';
import '../../../../auth/manager/auth_cubit/auth_state.dart';

class SplashBodyView extends StatefulWidget {
  const SplashBodyView({super.key});

  @override
  State<SplashBodyView> createState() => _SplashBodyViewState();
}

class _SplashBodyViewState extends State<SplashBodyView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    initSlidingAnimation();
    navigateToHome();

  }

  @override
  void dispose() {
    super.dispose();
    //when animation finish dispose it
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Welcome to wedding App" , style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),),
          const SizedBox(
            height: 4,
          ),
          const Text("Planning your Session",style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 25,
            color: Colors.white
          ),),
      
          SlidingText(slidingAnimation: slidingAnimation)
        ],
      ),
    );
  }

  void initSlidingAnimation() {
    //controller
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    //animation that change values
    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 3), end: Offset.zero)
            .animate(animationController);
    animationController.forward();
  }

  void navigateToHome() {
    Future.delayed(const Duration(seconds: 2), () {
      GoRouter.of(context).pushReplacement(AppRouter.KLoginPage);

      // Get.to(() => const HomeView(),transition: Transition.rightToLeft,duration: kTransitionDuration);
    });
  }


  void _checkAuthentication() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is signed in
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        // User data exists in Firestore
        final String authorization = snapshot.data()!['authorization'];
        if (authorization == 'photographer') {
          // Navigate to photographer home page
          context.read<AuthenticationCubit>().emit(AuthenticationSuccessPhotographer(user));
        } else {
          // Navigate to user home page
          context.read<AuthenticationCubit>().emit(AuthenticationSuccessUser(user));
        }
      } else {
        // User data does not exist in Firestore
        context.read<AuthenticationCubit>().emit(const AuthenticationFailure(error: 'User data not found'));
      }
    } else {
      // User is not signed in
      GoRouter.of(context).go(AppRouter.KLoginPage);
    }
  }
}