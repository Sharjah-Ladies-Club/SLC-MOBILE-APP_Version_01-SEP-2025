import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/repo/user_repository.dart';
import 'package:slc/view/login/bloc/bloc.dart';

import 'login_new_form.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  LoginPage({Key key, this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LoginBloc();
      },
      child: LoginForm(
          // analytics, observer
          ),
    );
  }
}
