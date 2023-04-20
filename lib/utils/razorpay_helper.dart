import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class RazorpayHelper {
  static String key = "rzp_test_Hm8FNiTJPMJ0iL";
  static String secret = "QCundH5npucEgCIrBj2L9lZ0";

  static Future<String> generateOrderId(int amount) async {
    var authn = 'Basic ${base64Encode(utf8.encode('$key:$secret'))}';

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data =
        '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!

    var res = await http.post(Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: headers, body: data);
    if (res.statusCode != 200) {
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    }
    log('ORDER ID response => ${res.body}');

    return json.decode(res.body)['id'].toString();
  }

  static Future<String> generatePaymentLink({
    required int amount,
    required String description,
    required String contact,
  }) async {
    var authn = 'Basic ${base64Encode(utf8.encode('$key:$secret'))}';

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data =
        '{"amount": $amount,"currency": "INR","description": $description,"customer": {"contact": $contact,},"notify": {"sms": true, "email": true},"reminder_enable": true,"callback_url": "https://hoodie-bc4c2.web.app/#HomeScreen","callback_method": "get"}';

    var res = await http.post(
        Uri.parse("https://api.razorpay.com/v1/payment_links"),
        headers: headers,
        body: data);
    if (res.statusCode != 200) {
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    }
    log('ORDER ID response => ${res.body}');

    return json.decode(res.body)["short_url"];
  }
}
