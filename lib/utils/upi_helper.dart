// import 'dart:math';

// import 'package:upi_pay/upi_pay.dart';

// class UPIHelper {
//   Future<List<ApplicationMeta>> getUPIApps() async {
//     return await UpiPay.getInstalledUpiApplications();
//   }

//   Future<UpiTransactionResponse> doUpiTransation(
//       ApplicationMeta appMeta, String amount, String skinName) async {
//     final UpiTransactionResponse response = await UpiPay.initiateTransaction(
//       amount: amount,
//       app: appMeta.upiApplication,
//       receiverName: 'Hoodie',
//       receiverUpiAddress: '7010450504@paytm',
//       transactionRef: Random.secure().nextInt(1 << 32).toString(),
//       transactionNote: skinName,
//     );
//     return response;
//   }
// }
