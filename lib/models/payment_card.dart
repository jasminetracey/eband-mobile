import 'package:flutter/material.dart';

class PaymentCard {
  CardType type;
  String number;
  String name;
  int month;
  int year;
  int cvv;

  PaymentCard({
    this.type,
    this.number,
    this.name,
    this.month,
    this.year,
    this.cvv,
  });
}

enum CardType {
  masterCard,
  visa,
  americanExpress,
  dinersClub,
  discover,
  invalid // We'll use this when the card is invalid
}

class CardUtils {
  static List<int> getExpiryDate(String value) {
    final split = value.split(RegExp(r'(\/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  static Widget getCardIcon(CardType cardType) {
    String img = '';
    Icon icon;
    switch (cardType) {
      case CardType.masterCard:
        img = 'mastercard.png';
        break;
      case CardType.visa:
        img = 'visa.png';
        break;
//      case CardType.Verve:
//        img = 'verve.png';
//        break;
      case CardType.americanExpress:
        img = 'american_express.png';
        break;
      case CardType.discover:
        img = 'discover.png';
        break;
      case CardType.dinersClub:
        img = 'dinners_club.png';
        break;
//      case CardType.Jcb:
//        img = 'jcb.png';
//        break;
//      case CardType.Others:
//        icon = new Icon(
//          Icons.credit_card,
//          size: 40.0,
//          color: Colors.grey[600],
//        );
//        break;
      case CardType.invalid:
        icon = Icon(
          Icons.warning,
          size: 40.0,
          color: Colors.grey[600],
        );
        break;
    }
    Widget widget;
    if (img.isNotEmpty) {
      widget = Image.asset(
        'assets/images/$img',
        width: 40.0,
      );
    } else {
      widget = icon;
    }
    return widget;
  }

  static CardType getCardTypeFrmNumber(String input) {
    CardType cardType;
    if (input.startsWith(RegExp(
        '((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      cardType = CardType.masterCard;
    } else if (input.startsWith(RegExp('[4]'))) {
      cardType = CardType.visa;
//    } else if (input
//        .startsWith(new RegExp(r'((506(0|1))|(507(8|9))|(6500))'))) {
//      cardType = CardType.Verve;
    } else if (input.startsWith(RegExp('((34)|(37))'))) {
      cardType = CardType.americanExpress;
    } else if (input.startsWith(RegExp('((6[45])|(6011))'))) {
      cardType = CardType.discover;
    } else if (input
        .startsWith(RegExp('((30[0-5])|(3[89])|(36)|(3095))'))) {
      cardType = CardType.dinersClub;
//    } else if (input.startsWith(new RegExp(r'(352[89]|35[3-8][0-9])'))) {
//      cardType = CardType.Jcb;
    } else {
      cardType = CardType.invalid;
    }
    return cardType;
  }

  static String getCleanedNumber(String text) {
    final RegExp regExp = RegExp('[^0-9]');
    return text.replaceAll(regExp, '');
  }
}
