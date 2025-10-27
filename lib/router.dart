import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/auth_gate.dart';
import 'features/auth/sign_in_screen.dart';
import 'features/auth/sign_up_screen.dart';
import 'features/auth/forgot_password.dart';

import 'features/dashboard/home_shell.dart';
import 'features/dashboard/home_screen.dart';

import 'features/services/services_screen.dart';
import 'features/growth/growth_home.dart';
import 'features/community/community_screen.dart';
import 'features/more/more_screen.dart';

import 'features/company_setup/business_setup_screen.dart';
import 'features/company_setup/trade_license_screen.dart';

import 'features/services/service_detail_screen.dart';
import 'features/services/service_category_screen.dart';
import 'features/company_setup/company_formation_screen.dart';
import 'features/trade/trade_license_stepper.dart';

import 'features/docs/document_uploader.dart';
import 'features/docs/document_list.dart';
import 'features/applications/track_application_screen.dart';
import 'features/growth/growth_booking_screen.dart';
import 'features/admin/admin_console.dart';

import 'features/profile/profile_screen.dart';
import 'features/profile/settings_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/admin/admin_shell.dart';


/// In Part 2 we’ll plug the actual HomeShell with bottom nav & pages.
/// For now, we use a simple placeholder Scaffold to prove protected routing.
class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wazeet — Home'),
        actions: const [SizedBox(width: 8)],
      ),
      body: const Center(
        child: Text('You are signed in. (Home shell arrives in Part 2)'),
      ),
    );
  }
}

/// Riverpod integration for GoRouter refresh when auth changes
final _routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/auth/sign-in',
    routes: [
      // Auth
      GoRoute(path: '/auth/sign-in', builder: (_, __) => const SignInScreen()),
      GoRoute(path: '/auth/sign-up', builder: (_, __) => const SignUpScreen()),
      GoRoute(path: '/auth/forgot', builder: (_, __) => const ForgotPasswordScreen()),

      // QuickActions (top-level)
      GoRoute(
        path: '/company-setup',
        builder: (_, __) => const AuthGate(child: BusinessSetupScreen()),
      ),
      GoRoute(
        path: '/company-formation',
        builder: (_, __) => const AuthGate(child: CompanyFormationScreen()),
      ),
      GoRoute(
        path: '/trade-license',
        builder: (_, __) => const AuthGate(child: TradeLicenseScreen()),
      ),
      GoRoute(
        path: '/trade-license/flow',
        builder: (_, st) => const AuthGate(child: TradeLicenseStepper()),
      ),
      GoRoute(
        path: '/track-application', 
        builder: (_, __) => const AuthGate(child: TrackApplicationScreen())
      ),
      GoRoute(
        path: '/docs/upload',
        builder: (_, __) => const AuthGate(child: DocumentUploader()),
      ),
      GoRoute(
        path: '/docs',
        builder: (_, __) => const AuthGate(child: DocumentList()),
      ),
      
      
      // add routes (ensure wrapped by AuthGate and admin check at UI-level):
      GoRoute(
        path: '/profile',
        builder: (_, __) => const AuthGate(child: ProfileScreen()),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => const AuthGate(child: SettingsScreen()),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const AuthGate(child: NotificationsScreen()),
      ),
      GoRoute(
        path: '/admin',
        builder: (_, __) => const AuthGate(child: AdminShell()),
      ),

      // Main shell with tabs
      ShellRoute(
        builder: (context, state, child) => AuthGate(child: HomeShell(child: child)),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/services', builder: (_, __) => const ServicesScreen()),
          GoRoute(path: '/services/category/:id', builder: (_, st) => ServiceCategoryScreen(categoryId: st.pathParameters['id']!)),
          GoRoute(path: '/services/item/:id', builder: (_, st) => ServiceDetailScreen(serviceId: st.pathParameters['id']!)),
          GoRoute(path: '/growth', builder: (_, __) => const GrowthScreen()),
          GoRoute(path: '/growth/booking', builder: (_, __) => const GrowthBookingScreen()),
          GoRoute(path: '/community', builder: (_, __) => const CommunityScreen()),
          GoRoute(path: '/more', builder: (_, __) => const MoreScreen()),
          GoRoute(path: '/admin', builder: (_, __) => const AdminConsole()),
        ],
      ),
    ],
  );
});

GoRouter useRouter(WidgetRef ref) => ref.read(_routerProvider);