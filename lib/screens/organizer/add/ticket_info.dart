import 'package:eband/models/event.dart';
import 'package:eband/models/ticket_type.dart';
import 'package:eband/router.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/organizer/components/ticket_type_form.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTicketInfoScreen extends StatefulWidget {
  final Event event;

  const AddTicketInfoScreen({Key key, this.event}) : super(key: key);

  @override
  _AddTicketInfoScreenState createState() => _AddTicketInfoScreenState();
}

class _AddTicketInfoScreenState extends State<AddTicketInfoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<TicketTypeForm> tickets = [];

  @override
  void initState() {
    if (tickets.isEmpty) {
      onAddForm();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar('Add Event Tickets'),
      body: SafeArea(
        minimum: kSafeArea,
        child: Column(
          children: <Widget>[
            verticalSpaceTiny(context),
            Expanded(
              child: ListView.builder(
                addAutomaticKeepAlives: true,
                itemCount: tickets.length,
                itemBuilder: (_, i) => tickets[i],
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              padding: const EdgeInsets.all(8.0),
              onPressed: onAddForm,
              child: const Text(
                'Add Ticket Type +',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: const EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: _submit,
                  child: const Text(
                    'Save & Continue',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                FlatButton(
                  color: Colors.grey,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () {},
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
            verticalSpaceMedium(context),
          ],
        ),
      ),
    );
  }

  ///on form user deleted
  void onDelete(TicketType ticketType) {
    setState(() {
      final find = tickets.firstWhere(
        (it) => it.ticketType == ticketType,
        orElse: () => null,
      );
      if (find != null) tickets.removeAt(tickets.indexOf(find));
    });
  }

  ///on add form
  void onAddForm() {
    setState(() {
      final _ticketType = TicketType();
      tickets.add(TicketTypeForm(
        ticketType: _ticketType,
        onDelete: () => onDelete(_ticketType),
      ));
    });
  }

  ///on save forms
  Future<void> _submit() async {
    if (tickets.isNotEmpty) {
      var allValid = true;
      tickets.forEach((form) => allValid = allValid && form.isValid());
      if (allValid) {
        final data = tickets.map((it) => it.ticketType).toList();

        final database = Provider.of<FirestoreDatabase>(context, listen: false);

        final event = widget.event;
        event.ticketTypes = data;

        await database.setEvent(event);

        await Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.organizerTabRoute,
          (route) => false,
        );
      }
    } else {
      _showSnackBar('Please add at least one ticket type');
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
