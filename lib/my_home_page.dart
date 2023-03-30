import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment() async{

    try{
      paymentIntentData = await createPaymentIntent('20', 'usd');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            // applePay: true,
            // googlePay: true,
            style: ThemeMode.dark,
            merchantDisplayName: 'ishaq'
            // confirmPayment: true,
          ));
      displayPaymentSheet();
    }
    catch(e){
      print('exception'+e.toString());
    }
  }
  createPaymentIntent(String amount, String currency)async {
    try{
      Map<String, dynamic> body = {
        'amount' : calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]' : 'card'
      };

      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
      body: body,
        headers: {
        'Authorization': 'Bearer sk_test_51MqfzUBzrsnpxI7xiPF9JYAP8x1pKfw8udonjIM38phivp5jOtG4DcoqWFBEIxmZ7O3qqsaQy6e779agxndv2l0m00SvNlYtsb',
        'Content-Type' : 'application/x-www-form-urlencoded',
        }
      );
      return jsonDecode(response.body.toString());
    }
    catch(e){
      print('exception'+e.toString());
    }
  }
  displayPaymentSheet()async{
    try{
      await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntentData!['client_secret'],
          confirmPayment: true ,
        ),
      );
      setState(() {
        paymentIntentData = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paid Succesfully')));
    } on StripeException catch(e){
      print(e.toString());
      showDialog(context: context, builder: (_) =>
      const   AlertDialog(
          content: Text('Cancelled')),
      );
    }
  }
  calculateAmount(String amount){
    final price= int.parse(amount) * 100;
    return price.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async{
              await makePayment();
              print('working');
            },
            child: Container(
              height: 50,
              width: 100,
              decoration:const BoxDecoration(
                color: Colors.red
              ),
              child: const Center(
                child: Text('Pay', style: TextStyle(
                  color: Colors.white,
                  fontSize: 25
                ),),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
