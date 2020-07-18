import 'package:eband/formatters/card_month_input_formatter.dart';
import 'package:eband/formatters/card_number_input_formatter.dart';
import 'package:eband/models/event.dart';
import 'package:eband/models/payment_card.dart';
import 'package:eband/models/ticket_type.dart';
import 'package:eband/router.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/components/custom_dialog.dart';
import 'package:eband/screens/components/rounded_button.dart';
import 'package:eband/services/firestore_database.dart';
import 'package:eband/utils/app_colors.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:eband/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EventPaymentScreen extends StatefulWidget {
  final Event event;
  final TicketType ticketType;

  const EventPaymentScreen(
      {Key key, @required this.ticketType, @required this.event})
      : super(key: key);

  @override
  _EventPaymentScreenState createState() => _EventPaymentScreenState();
}

class _EventPaymentScreenState extends State<EventPaymentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  TextEditingController numberController = TextEditingController();
  final PaymentCard _paymentCard = PaymentCard();

  List<Widget> cardWidgets = <Widget>[];

  TicketType ticketType;

  @override
  void initState() {
    ticketType = widget.ticketType;
    // TODO: Remove in prod
    numberController.text = '5555 5555 5555 4444';
    _filterCards();
    numberController.addListener(_getCardTypeFrmNumber);
    super.initState();
  }

  @override
  void dispose() {
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    final String input = CardUtils.getCleanedNumber(numberController.text);
    final CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
    _filterCards();
  }

  void _filterCards() {
    cardWidgets.clear();

    if ((_paymentCard.type == null && _paymentCard.number == null) ||
        (_paymentCard.type == CardType.invalid &&
            numberController.text.isEmpty)) {
      for (final CardType type in CardType.values) {
        if (type != CardType.invalid) {
          cardWidgets.add(CardUtils.getCardIcon(type));
        }
      }
    } else {
      cardWidgets.add(CardUtils.getCardIcon(_paymentCard.type));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar('Event Payment'),
      body: SafeArea(
        minimum: kSafeArea,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Payment Summary',
                style: AppTextStyles.headingTextPrimary,
              ),
              verticalSpaceSmall(context),
              Container(
                padding: EdgeInsets.all(kBorderRadius),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textColor),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Access Pass',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(ticketType.name),
                        Text('\$ ${ticketType.cost}')
                      ],
                    ),
                    verticalSpaceSmall(context),
                    const Divider(
                      color: AppColors.textColor,
                      thickness: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text('Total'),
                        Text('\$ ${ticketType.cost}')
                      ],
                    )
                  ],
                ),
              ),
              verticalSpaceMedium(context),
              Text(
                'Payment Info',
                style: AppTextStyles.headingTextPrimary,
              ),
              const Text(
                'Payment Info Description',
              ),
              verticalSpaceMedium(context),
              Text(
                'Payment Method',
                style: AppTextStyles.headingTextPrimary,
              ),
              verticalSpaceTiny(context),
              Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: cardWidgets,
                    ),
                    verticalSpaceSmall(context),
                    TextFormField(
                      onSaved: (value) => _paymentCard.name = value,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        return value.isEmpty ? 'Card Name is required' : null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Name on Card',
                      ),
                    ),
                    verticalSpaceSmall(context),
                    TextFormField(
                      onSaved: (value) => _paymentCard.number =
                          CardUtils.getCleanedNumber(value),
                      keyboardType: TextInputType.number,
                      controller: numberController,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                        CardNumberInputFormatter()
                      ],
                      validator: Validators.validateCardNum,
                      decoration: const InputDecoration(
                        hintText: 'Card Number',
                      ),
                    ),
                    verticalSpaceSmall(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: screenWidth(context) * 0.5,
                          child: TextFormField(
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              CardMonthInputFormatter()
                            ],
                            onSaved: (value) {
                              final List<int> expiryDate =
                                  CardUtils.getExpiryDate(value);
                              _paymentCard.month = expiryDate[0];
                              _paymentCard.year = expiryDate[1];
                            },
                            keyboardType: TextInputType.number,
                            validator: Validators.validateDate,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'MM/YY',
                            ),
                          ),
                        ),
                        Container(
                          width: screenWidth(context) * 0.4,
                          child: TextFormField(
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            onSaved: (value) =>
                                _paymentCard.cvv = int.parse(value),
                            keyboardType: TextInputType.number,
                            validator: Validators.validateCVV,
                            decoration: const InputDecoration(
                              hintText: 'CVV Code',
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceMedium(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: screenWidth(context) * 0.4,
                          child: RoundedButton(
                            text: 'Pay',
                            onPressed: () => purchaseTicket(),
                          ),
                        ),
                        Container(
                          width: screenWidth(context) * 0.4,
                          child: RoundedButton(
                            color: AppColors.iconColor,
                            textColor: AppColors.textColor,
                            text: 'Cancel',
                            onPressed: () => Navigator.popUntil(
                              context,
                              ModalRoute.withName(Routes.patronTabRoute),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> purchaseTicket() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final database = Provider.of<FirestoreDatabase>(context, listen: false);
      await database.patronRegisterPayment(ticketType, widget.event);

      _showDialog(context);
    } else {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
    }
  }

  void _showDialog(BuildContext context) {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomDialog(
        title: 'Payment Successful',
        leftText: 'Ok',
        leftOnPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.patronTabRoute,
          (route) => false,
        ),
        rightText: 'Order Wristband',
        rightOnPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.patronWristbandOrder,
          ModalRoute.withName(Routes.patronTabRoute),
        ),
      ),
    );
  }
}
