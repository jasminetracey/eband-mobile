import 'package:barcode_scan/barcode_scan.dart';
import 'package:eband/models/event.dart';
import 'package:eband/screens/components/custom_app_bar.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventManagerScreen extends StatefulWidget {
  final Event event;

  const EventManagerScreen({Key key, @required this.event}) : super(key: key);

  @override
  _EventManagerScreenState createState() => _EventManagerScreenState();
}

class _EventManagerScreenState extends State<EventManagerScreen> {
  Event event;
  String barcode = '';

  @override
  void initState() {
    event = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Event Manager'),
      body: SafeArea(
        minimum: kSafeArea,
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            verticalSpaceMedium(context),
            Text(event.name),
            verticalSpaceSmall(context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: event.ticketTypes.map(
                (ticketType) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(ticketType.name),
                      RichText(
                        text: TextSpan(
                          text: 'Total: ',
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${ticketType.quantity}',
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Sold: ',
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${ticketType.sold}',
                            ),
                          ],
                        ),
                      ),
                      verticalSpaceSmall(context),
                    ],
                  );
                },
              ).toList(),
            ),
            verticalSpaceMedium(context),
            const Divider(
              thickness: 3,
            ),
            verticalSpaceMedium(context),
            Center(
              child: Column(
                children: <Widget>[
                  IconButton(
                    onPressed: _scan,
                    icon: FaIcon(
                      FontAwesomeIcons.qrcode,
                    ),
                    iconSize: 128,
                  ),
                  const Text('Tap to Scan Patron’s QR')
                ],
              ),
            ),
            Center(
              child: Text(
                barcode,
                style: const TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _scan() async {
    try {
      final result = await BarcodeScanner.scan();
      setState(() => barcode = result.rawContent);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          barcode = 'The user did not grant the camera '
              'permission!';
        });
      } else {
        setState(() => barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => barcode =
          'null (User returned using the back - button before scanning anything. Result)');
    } catch (e) {
      setState(() => barcode = 'Unknown error: $e');
    }
  }

  Future<void> _checkUserEvent() async {}
}
