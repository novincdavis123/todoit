import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// Controllers for register form
final nameControllerProvider = Provider.autoDispose(
  (ref) => TextEditingController(),
);
final emailRegisterControllerProvider = Provider.autoDispose(
  (ref) => TextEditingController(),
);
final passwordRegisterControllerProvider = Provider.autoDispose(
  (ref) => TextEditingController(),
);

// Controllers for login form
final emailControllerProvider = Provider.autoDispose(
  (ref) => TextEditingController(),
);
final passwordControllerProvider = Provider.autoDispose(
  (ref) => TextEditingController(),
);
