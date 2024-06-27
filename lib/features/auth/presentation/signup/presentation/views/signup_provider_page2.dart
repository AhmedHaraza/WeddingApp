import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedding/core/utils/app_router.dart';
import 'package:wedding/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:wedding/features/auth/manager/auth_cubit/auth_state.dart';
import 'package:wedding/features/auth/presentation/signup/presentation/views/widgets/form_input_signup_photographer2.dart';



class SignUpProviderPage2 extends StatelessWidget {
  const SignUpProviderPage2({super.key, required this.email, required this.password, required this.name, required this.phoneNumber});
  final String email ;
  final String password ;
  final String name;
  final String phoneNumber;


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
              margin: const EdgeInsets.all(16),
              child: BlocConsumer<AuthenticationCubit,AuthState>(
                listener: (context,state){
                  if(state is AuthenticationSuccess){
                    GoRouter.of(context).pushReplacement(AppRouter.KLoginPage);
                    // context.read<DataFetchingCubit>().fetchDataPhotographer(state.user!.uid);
                    // context.read<ImageVideoCubit>().fetchImageURLs(state.user!.uid);
                    // context.read<ImageVideoCubit>().fetchVideosUrls(state.user!.uid);

                  }else if(state is AuthenticationFailure){
                    Future.delayed(Duration.zero,(){
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          title: "Login failed",
                          desc: "Check data please",
                          btnCancelOnPress: (){

                          }
                      ).show();
                    });
                  }
                }, builder: (BuildContext context, AuthState state) {
                  if(state is AuthenticationLoading){
                    return const Center(child: CircularProgressIndicator(),);
                  }else{
                    return SignUpPhotographerForm2(name: name,email: email,password: password,phoneNumber: phoneNumber,);

                  }
              },
              )
          ),
        ),
      ),
    );
  }
}


