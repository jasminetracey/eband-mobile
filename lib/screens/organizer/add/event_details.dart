import 'dart:io';

import 'package:eband/models/event.dart';
import 'package:eband/router.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/screens/components/platform_exception_alert_dialog.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/services/firebase_storage_service.dart';
import 'package:eband/services/firestore_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddEventDetailScreen extends StatefulWidget {
  final Event event;

  const AddEventDetailScreen({Key key, this.event}) : super(key: key);

  @override
  _AddEventDetailScreenState createState() => _AddEventDetailScreenState();
}

class _AddEventDetailScreenState extends State<AddEventDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  PickedFile _imageFile;
  String _description;
  dynamic _pickImageError;
  String _retrieveDataError;

  final _picker = ImagePicker();

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

        final event = widget.event;
        event.description = _description;

        final storage =
            Provider.of<FirebaseStorageService>(context, listen: false);
        final String downloadUrl = await storage.uploadEventImage(
          eventId: event.id,
          file: File(_imageFile.path),
        );

        event.imagePath = downloadUrl;

        await database.setEvent(event);

        await Navigator.pushNamed(
          context,
          Routes.organizerAddEventTicketsRoute,
          arguments: event,
        );
      } catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  Future<void> _getImage() async {
    try {
      await _picker.getImage(source: ImageSource.gallery).then((image) {
        setState(() {
          _imageFile = image;
        });
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Add Event Details'),
      body: SafeArea(
        minimum: kSafeArea,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                verticalSpaceTiny(context),
                const Text('Main Event Image'),
                verticalSpaceTiny(context),
                const Text(
                    'This should be the main flyer or poster for your event. '
                    'Attendees will see this at the top of the this event’s listing. Ensure it is a high quality image:  2160 x 1080 pixels (2:1) ratio.'),
                verticalSpaceSmall(context),
                Center(
                  child: defaultTargetPlatform == TargetPlatform.android
                      ? FutureBuilder<void>(
                          future: retrieveLostData(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return _pickImage();
                              case ConnectionState.done:
                                return _previewImage();
                              default:
                                if (snapshot.hasError) {
                                  return Text(
                                    'Pick image/video error: ${snapshot.error}}',
                                    textAlign: TextAlign.center,
                                  );
                                } else {
                                  return _pickImage();
                                }
                            }
                          },
                        )
                      : _previewImage(),
                ),
                verticalSpaceMedium(context),
                const Text(
                  'Description',
                ),
                verticalSpaceTiny(context),
                const Text(
                  'Provide more details about your event like schedule, sponsors,'
                  ' or Featured guests.',
                ),
                verticalSpaceSmall(context),
                TextFormField(
                  onSaved: (value) => _description = value,
                  keyboardType: TextInputType.multiline,
                  maxLength: null,
                  maxLines: 5,
                ),
                verticalSpaceMedium(context),
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
        ),
      ),
    );
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return _pickImage();
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return _pickImage();
    }
  }

  Widget _pickImage() {
    return GestureDetector(
      onTap: () => _getImage(),
      child: Container(
        height: 230,
        width: screenWidth(context) * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius),
          boxShadow: [
            BoxShadow(
              blurRadius: 5.0,
              offset: const Offset(0, 3),
              color: Colors.grey[300],
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageFile == null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text('Click to add main event image.'),
                  Text('JPEG or PNG'),
                ],
              ),
            ],
            if (_imageFile != null) ...[
              Center(
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.file(
                    File(_imageFile.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
