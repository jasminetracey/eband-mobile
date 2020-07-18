import 'package:eband/models/event.dart';
import 'package:eband/models/user.dart';
import 'package:eband/router.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/components/date_time_picker.dart';
import 'package:eband/screens/components/platform_exception_alert_dialog.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddGeneralInfoScreen extends StatefulWidget {
  @override
  _AddGeneralInfoScreenState createState() => _AddGeneralInfoScreenState();
}

class _AddGeneralInfoScreenState extends State<AddGeneralInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name, _type, _venue, _address;
  DateTime _startDate;
  TimeOfDay _startTime;
  DateTime _endDate;
  TimeOfDay _endTime;
  bool _autoValidate = false;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final database = Provider.of<FirestoreDatabase>(context, listen: false);
        final User user = Provider.of<User>(context, listen: false);

        final id = documentIdFromCurrentDate();
        final start = DateTime(_startDate.year, _startDate.month,
            _startDate.day, _startTime.hour, _startTime.minute);
        final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
            _endTime.hour, _endTime.minute);

        final event = Event(
          id: id,
          name: _name,
          venue: _venue,
          address: _address,
          type: _type,
          start: start,
          end: end,
          uid: user.uid,
        );
        await database.setEvent(event);
        await Navigator.of(context).pushNamed(
          Routes.organizerAddEventDetailsRoute,
          arguments: event,
        );
      } catch (e) {
        print(e);
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        );
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final start = DateTime.now().add(const Duration(days: 1));
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = DateTime.now().add(const Duration(days: 1));
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Add Event'),
      body: SafeArea(
        minimum: kSafeArea,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                verticalSpaceTiny(context),
                const Text('General Info'),
                verticalSpaceTiny(context),
                const Text(
                  'Add specific details about your event in order for patrons to know why they should attend. Be as creative as you can.',
                ),
                verticalSpaceSmall(context),
                const Text('Event Title'),
                TextFormField(
                  onSaved: (value) => _name = value,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter event name',
                  ),
                ),
                verticalSpaceSmall(context),
                const Text('Type'),
                TextFormField(
                  onSaved: (value) => _type = value,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Select event type',
                  ),
                ),
                verticalSpaceSmall(context),
                const Text('Location'),
                TextFormField(
                  onSaved: (value) => _venue = value,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Default Venue',
                  ),
                ),
                verticalSpaceTiny(context),
                TextFormField(
                  onSaved: (value) => _address = value,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter event address',
                  ),
                ),
                verticalSpaceSmall(context),
                const Text('Date & Time'),
                DateTimePicker(
                  labelText: 'Start',
                  selectedDate: _startDate,
                  selectedTime: _startTime,
                  onSelectedDate: (date) => setState(() => _startDate = date),
                  onSelectedTime: (time) => setState(() => _startTime = time),
                ),
                verticalSpaceTiny(context),
                DateTimePicker(
                  labelText: 'End',
                  selectedDate: _endDate,
                  selectedTime: _endTime,
                  onSelectedDate: (date) => setState(() => _endDate = date),
                  onSelectedTime: (time) => setState(() => _endTime = time),
                ),
                verticalSpaceMedium(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(8.0),
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
                      onPressed: () => Navigator.pop(context),
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
        ),
      ),
    );
  }
}
