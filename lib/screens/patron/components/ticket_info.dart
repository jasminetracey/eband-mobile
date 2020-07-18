import 'package:eband/models/ticket_type.dart';
import 'package:eband/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class TicketInfo extends StatelessWidget {
  final TicketType ticketType;
  final int radioValue;
  final Function radioValueChange;

  const TicketInfo({
    Key key,
    @required this.radioValue,
    @required this.radioValueChange,
    @required this.ticketType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: '${ticketType.name} - ',
            style: AppTextStyles.bodyText,
            children: <TextSpan>[
              TextSpan(
                text: '\$${ticketType.cost}',
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
//        Text(
//          '${ticketType.name} - \$ ${ticketType.cost}',
//          style: AppTextStyles.bodyText,
//        ),
        Radio(
          value: ticketType.id,
          groupValue: radioValue,
          onChanged: radioValueChange,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}
