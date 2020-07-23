import 'package:eband/models/ticket_type.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TicketTypeForm extends StatefulWidget {
  final TicketType ticketType;
  final Function onDelete;
  final state = _TicketTypeFormState();

  TicketTypeForm({
    Key key,
    this.ticketType,
    this.onDelete,
  }) : super(key: key);

  bool isValid() => state.validate();

  @override
  _TicketTypeFormState createState() => state;
}

class _TicketTypeFormState extends State<TicketTypeForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 7.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: widget.onDelete,
                ),
              ),
              TextFormField(
                initialValue: widget.ticketType.name,
                onSaved: (val) => widget.ticketType.name = val,
                validator: Validators.validateName,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter name for ticket type',
                ),
              ),
              verticalSpaceSmall(context),
              TextFormField(
                initialValue: widget.ticketType.quantity.toString(),
                onSaved: (val) => widget.ticketType.quantity = int.parse(val),
                keyboardType: TextInputType.number,
                validator: Validators.validateQuantity,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Number of tickets',
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
              ),
              verticalSpaceSmall(context),
              TextFormField(
                initialValue: widget.ticketType.cost.toStringAsFixed(2),
                onSaved: (val) => widget.ticketType.cost = double.parse(val),
                validator: Validators.validateCost,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Cost of ticket',
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
              ),
              verticalSpaceSmall(context),
            ],
          ),
        ),
      ),
    );
  }

  ///form validator
  bool validate() {
    final valid = _formKey.currentState.validate();
    if (valid) _formKey.currentState.save();
    return valid;
  }
}
