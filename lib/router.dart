import 'package:eband/models/event.dart';
import 'package:eband/models/ticket_type.dart';
import 'package:eband/screens/screens.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String loginRoute = '/login';
  static const String signUpRoute = '/register';
  static const String settingsRoute = '/settings';
  // Organizer
  static const String organizerTabRoute = '/organizer';
  static const String organizerEventsRoute = '/organizer/events';
  static const String organizerAddEventRoute = '/organizer/events/add';
  static const String organizerAddEventDetailsRoute = '/organizer/events/add/'
      'details';
  static const String organizerAddEventTicketsRoute = '/organizer/events/add/'
      'tickets';
  static const String organizerEventManagementRoute = '/organizer/tickets';
  static const String organizerEventManagementScanRoute =
      '/organizer/tickets/scan';
  // Patron
  static const String patronTabRoute = '/patron';
  static const String patronHomeRoute = '/patron/events/upcoming';
  static const String patronEventsRoute = '/patron/events';
  static const String patronEventRegisterRoute = '/patron/events/register';
  static const String patronEventPaymentRoute = '/patron/events/payment';
  static const String patronWristbandOrder = '/patron/wristband/order';
  static const String patronWristbandDetails = '/patron/wristband';
  static const String patronWristbandTopUp = '/patron/wristband/topup';
}

class Router {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
          settings: const RouteSettings(name: Routes.loginRoute),
        );
        break;
      case Routes.signUpRoute:
        return MaterialPageRoute(
          builder: (context) => RegisterScreen(),
          settings: const RouteSettings(name: Routes.signUpRoute),
        );
        break;
      case Routes.settingsRoute:
        return MaterialPageRoute(
          builder: (context) => SettingsScreen(),
          settings: const RouteSettings(name: Routes.settingsRoute),
        );
        break;
      case Routes.organizerTabRoute:
        return MaterialPageRoute(
          builder: (context) => OrganizerTabScreen(),
          settings: const RouteSettings(name: Routes.organizerTabRoute),
        );
        break;
      case Routes.organizerAddEventRoute:
        return MaterialPageRoute(
          builder: (context) => AddGeneralInfoScreen(),
          settings: const RouteSettings(name: Routes.organizerAddEventRoute),
        );
        break;
      case Routes.organizerAddEventDetailsRoute:
        final Event event = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => AddEventDetailScreen(event: event),
          settings:
              const RouteSettings(name: Routes.organizerAddEventDetailsRoute),
        );
        break;
      case Routes.organizerAddEventTicketsRoute:
        final Event event = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => AddTicketInfoScreen(event: event),
          settings:
              const RouteSettings(name: Routes.organizerAddEventTicketsRoute),
        );
        break;
      case Routes.organizerEventManagementScanRoute:
        final Event event = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => ScanScreen(event: event),
          settings: const RouteSettings(
              name: Routes.organizerEventManagementScanRoute),
        );
        break;
      case Routes.organizerEventManagementRoute:
        final Event event = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => EventManagerScreen(event: event),
          settings:
              const RouteSettings(name: Routes.organizerEventManagementRoute),
        );
        break;

      case Routes.patronTabRoute:
        return MaterialPageRoute(
          builder: (context) => const PatronTabScreen(),
          settings: const RouteSettings(name: Routes.patronTabRoute),
        );
        break;
      case Routes.patronEventRegisterRoute:
        final Event event = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => RegisterEventScreen(event: event),
          settings: const RouteSettings(name: Routes.patronEventRegisterRoute),
        );
        break;
      case Routes.patronEventPaymentRoute:
        final dynamic args = settings.arguments;
        final TicketType ticketType = args['ticketType'];
        final Event event = args['event'];
        return MaterialPageRoute(
          builder: (context) => EventPaymentScreen(
            ticketType: ticketType,
            event: event,
          ),
          settings: const RouteSettings(name: Routes.patronEventPaymentRoute),
        );
        break;
      case Routes.patronWristbandOrder:
        return MaterialPageRoute(
          builder: (context) => WristbandOrderScreen(),
          settings: const RouteSettings(name: Routes.patronWristbandOrder),
        );
        break;
      case Routes.patronWristbandTopUp:
        return MaterialPageRoute(
          builder: (context) => WristbandTopUpScreen(),
          settings: const RouteSettings(name: Routes.patronWristbandTopUp),
        );
        break;
      default:
        return null;
    }
  }
}
