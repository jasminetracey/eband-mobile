import 'package:eband/formatters/card_month_input_formatter.dart';
import 'package:eband/formatters/card_number_input_formatter.dart';
import 'package:eband/models/payment_card.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:eband/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// class PaymentMethodDetails extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Text(
//           'Payment Method',
//           style: AppTextStyles.subheadingText,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: cardWidgets,
//         ),
//         verticalSpaceSmall(context),
//         TextFormField(
//           onSaved: (value) => _paymentCard.name = value,
//           keyboardType: TextInputType.text,
//           validator: (value) {
//             return value.isEmpty ? 'Card Name is required' : null;
//           },
//           decoration: const InputDecoration(
//             hintText: 'Name on Card',
//           ),
//         ),
//         verticalSpaceSmall(context),
//         TextFormField(
//           onSaved: (value) =>
//               _paymentCard.number = CardUtils.getCleanedNumber(value),
//           keyboardType: TextInputType.number,
//           controller: numberController,
//           inputFormatters: [
//             WhitelistingTextInputFormatter.digitsOnly,
//             LengthLimitingTextInputFormatter(19),
//             CardNumberInputFormatter()
//           ],
//           validator: Validators.validateCardNum,
//           decoration: const InputDecoration(
//             hintText: 'Card Number',
//           ),
//         ),
//         verticalSpaceSmall(context),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Container(
//               width: screenWidth(context) * 0.5,
//               child: TextFormField(
//                 inputFormatters: [
//                   WhitelistingTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(4),
//                   CardMonthInputFormatter()
//                 ],
//                 onSaved: (value) {
//                   final List<int> expiryDate = CardUtils.getExpiryDate(value);
//                   _paymentCard.month = expiryDate[0];
//                   _paymentCard.year = expiryDate[1];
//                 },
//                 keyboardType: TextInputType.number,
//                 validator: Validators.validateDate,
//                 textAlign: TextAlign.center,
//                 decoration: const InputDecoration(
//                   hintText: 'MM/YY',
//                 ),
//               ),
//             ),
//             Container(
//               width: screenWidth(context) * 0.4,
//               child: TextFormField(
//                 inputFormatters: [
//                   WhitelistingTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(4),
//                 ],
//                 onSaved: (value) => _paymentCard.cvv = int.parse(value),
//                 keyboardType: TextInputType.number,
//                 validator: Validators.validateCVV,
//                 decoration: const InputDecoration(
//                   hintText: 'CVV Code',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
