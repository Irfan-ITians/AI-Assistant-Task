
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'initialization.dart/views/initial_wrapper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InitialWrapper());
}
