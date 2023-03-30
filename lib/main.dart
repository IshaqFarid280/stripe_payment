import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_payment/my_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey= 'pk_test_51MqfzUBzrsnpxI7xs89qmpttUCOx6UO1UJBavumjRnlYzXy3JN8f019o6Ntw2dUTDl1eGeVtYXOYUGySW2KjyXGY000gkNQErR';

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: HomePage(),
    );
  }
}
