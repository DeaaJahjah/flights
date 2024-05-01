import 'package:flights/features/auth/screens/client_profile_screen.dart';
import 'package:flights/features/auth/screens/company_profile_screen.dart';
import 'package:flights/features/auth/screens/create_client_account_screen.dart';
import 'package:flights/features/auth/screens/create_company_account_screen.dart';
import 'package:flights/features/auth/screens/edit_client_account_screen.dart';
import 'package:flights/features/auth/screens/edit_company_account_screen.dart';
import 'package:flights/features/auth/screens/login_page.dart';
import 'package:flights/features/auth/screens/selecte_account_type_screen.dart';
import 'package:flights/features/client/screens/client_home_screen.dart';
import 'package:flights/features/flights/screens/company_flights_screen.dart';
import 'package:flights/features/flights/screens/create_flightt_screen.dart';
import 'package:flights/features/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case LoginPage.routeName:
      return MaterialPageRoute(builder: ((_) => const LoginPage()));
    case SelectAccountTypeScreen.routeName:
      return MaterialPageRoute(builder: ((_) => const SelectAccountTypeScreen()));

    case CreateClientAccountScreen.routeName:
      return MaterialPageRoute(
        builder: ((_) => const CreateClientAccountScreen()),
      );

    case CreateCompanyAccountScreen.routeName:
      return MaterialPageRoute(builder: ((_) => const CreateCompanyAccountScreen()));

    case EditClientAccountScreen.routeName:
      return MaterialPageRoute(builder: ((_) => const EditClientAccountScreen()), settings: settings);

    case EditCompanyAccountScreen.routeName:
      return MaterialPageRoute(builder: ((_) => const EditCompanyAccountScreen()), settings: settings);

    case ClientHomeScreen.routeName:
      return MaterialPageRoute(builder: ((_) => const ClientHomeScreen()));

    case CompanyFlightScreen.routeName:
      return MaterialPageRoute(builder: ((_) => const CompanyFlightScreen()));

    case CreateFlightScreen.routeName:
      return MaterialPageRoute(builder: ((_) => const CreateFlightScreen()));

    case CompanyProfileScreen.routeName:
      return MaterialPageRoute(builder: ((_) => const CompanyProfileScreen()), settings: settings);

    case ClientProfileScreen.routeName:
      return MaterialPageRoute(builder: ((_) => const ClientProfileScreen()), settings: settings);

    // case TravlerScreen.routeName:
    //   return MaterialPageRoute(builder: ((_) => const TravlerScreen()));
  }

  return null;
}
