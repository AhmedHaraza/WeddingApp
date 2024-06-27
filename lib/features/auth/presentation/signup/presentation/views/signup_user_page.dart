import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:wedding/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:wedding/features/auth/manager/auth_cubit/auth_state.dart';
import 'package:wedding/features/auth/presentation/signup/presentation/views/widgets/form_input_signup_user.dart';

import '../../../../../../core/utils/app_router.dart';


class SignUpUserPage extends StatelessWidget {
  const SignUpUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: BlocConsumer<AuthenticationCubit,AuthState>(
            listener:(context,state){
              if(state is AuthenticationSuccess){
                // context.read<DataFetchingPhotographersCubit>().fetchData();
                // context.read<DataFetchingCubit>().fetchDataUser(state.user!.uid);
                //
                // Navigator.push(context, MaterialPageRoute(builder: (context){
                //   return UserHomePage(userId:state.user!.uid );
                // }));
                GoRouter.of(context).pushReplacement(AppRouter.KLoginPage);

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
                return const FormInputSignup();
              }
          },
          ),
        ),
      ),
    );
  }
}
