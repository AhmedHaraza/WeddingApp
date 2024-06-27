import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:wedding/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:wedding/features/auth/manager/auth_cubit/auth_state.dart';
import 'package:wedding/features/home/manager/PhotographersFetchCubit.dart';
import 'package:wedding/features/home/manager/image_fetch_cubit.dart';
import 'package:wedding/features/home/presentation/views/user_home/pages/user_home_page.dart';

import '../../../../../../../core/utils/app_router.dart';
import '../../../../../../home/manager/DataFetchCubit.dart';
import 'form_input_login.dart';


class InputFeilds extends StatelessWidget {
  const InputFeilds({Key? key});

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: BlocConsumer<AuthenticationCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthenticationSuccessPhotographer) {
              context.read<DataFetchingCubit>().fetchDataPhotographer(state.user!.uid);
              context.read<ImageVideoCubit>().fetchImageURLs(state.user!.uid);
              context.read<ImageVideoCubit>().fetchVideosUrls(state.user!.uid);

              GoRouter.of(context).pushReplacement(AppRouter.KProviderHomePage);
            } else if (state is AuthenticationSuccessUser) {
              context.read<DataFetchingPhotographersCubit>().fetchData();
              context.read<DataFetchingCubit>().fetchDataUser(state.user!.uid);

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UserHomePage(userId: state.user!.uid);
              }));
            } else if (state is AuthEmailNotVerified) {
              // Show error dialog for unverified email
              showDialog(
                context: context,
                barrierDismissible: false, // Prevent dismissing the dialog
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Email Not Verified'),
                    content: const Text('Please verify your email to proceed.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Resend email verification
                          context.read<AuthenticationCubit>().sendEmailVerification();
                        },
                        child: const Text('Resend Verification Email'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Resend email verification
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            } else if (state is AuthenticationFailure) {
              // Show error dialog for authentication failure
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(state.error),
                    content: const Text("Invalid email or password"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Try again"),
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (BuildContext context, AuthState state) {
            if (state is AuthenticationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const FormInput();
            }
          },
        ),
      ),
    );
  }
}