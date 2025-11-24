import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara/core/widgets/admin_app_bottom_navigation.dart';
import 'package:jawara/features/admin/data_warga/data_warga_main_page.dart';
import 'package:jawara/features/admin/kelola_lapak/kelola_lapak_page.dart';
import 'package:jawara/features/admin/keuangan/keuangan_page.dart';
import 'package:jawara/features/common/auth/presentation/pages/warga/lupa_page.dart';

// Common Pages
import 'package:jawara/features/common/splash/splash_page.dart';
import 'package:jawara/features/common/onboarding/onboarding_page.dart';
import 'package:jawara/features/common/pre_auth/pre_auth_page.dart';

// Auth Pages
import 'package:jawara/features/common/auth/presentation/pages/unified_login_page.dart';
import 'package:jawara/features/common/auth/presentation/pages/warga/warga_register_page.dart';
import 'package:jawara/features/common/auth/presentation/pages/warga/kyc_upload_page.dart';

// Status Pages
import 'package:jawara/features/common/auth/presentation/pages/status/pending_approval_page.dart';
import 'package:jawara/features/common/auth/presentation/pages/status/rejected_page.dart';

// Admin Pages
import 'package:jawara/features/admin/dashboard/dashboard_page.dart';

// Warga Pages

// Constants
import 'package:jawara/core/constants/app_routes.dart';
import 'package:jawara/features/warga/warga_main_page.dart';

class AppRouterConfig {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _adminShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'adminShell');
  static final GlobalKey<NavigatorState> _wargaShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'wargaShell');

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    routes: [
      // ========== COMMON ROUTES (No Shell) ==========
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.preAuth,
        name: 'preAuth',
        builder: (context, state) => const PreAuthPage(),
      ),

      // ========== AUTH ROUTES ==========
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return UnifiedLoginPage(
            initialProgress: extra?['initialProgress'] as double? ?? 0.0,
            isForward: extra?['isForward'] as bool? ?? true,
          );
        },
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const LupaPage(),
      ),

      // ========== WARGA ROUTES ==========
      GoRoute(
        path: AppRoutes.wargaRegister,
        name: 'wargaRegister',
        builder: (context, state) => const WargaRegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.wargaKYC,
        name: 'wargaKYC',
        builder: (context, state) => const KYCUploadPage(),
      ),

      // ========== STATUS ROUTES ==========
      GoRoute(
        path: AppRoutes.pending,
        name: 'pending',
        builder: (context, state) => const PendingApprovalPage(),
      ),
      GoRoute(
        path: AppRoutes.rejected,
        name: 'rejected',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return RejectedPage(reason: extra?['reason'] as String?);
        },
      ),

      GoRoute(
        path: AppRoutes.wargaDashboard,
        name: 'wargaDashboard',
        builder: (context, state) => const WargaMainPage(),
      ),

      // ========== ADMIN SHELL WITH BOTTOM NAVIGATION ==========
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppBottomNavigation(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            navigatorKey: _adminShellNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.adminDashboard,
                name: 'adminDashboard',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          // Branch 1: Data Warga
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/data-warga',
                name: 'adminDataWarga',
                builder: (context, state) => const DataWargaMainPage(),
              ),
            ],
          ),
          // Branch 2: Keuangan
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/keuangan',
                name: 'adminKeuangan',
                builder: (context, state) => const KeuanganPage(),
              ),
            ],
          ),
          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/profile',
                name: 'adminProfile',
                builder: (context, state) => const KelolaLapakPage(),
              ),
            ],
          ),
        ],
      ),

      // ========== WARGA SHELL WITH BOTTOM NAVIGATION ==========
      // StatefulShellRoute.indexedStack(
      //   builder: (context, state, navigationShell) {
      //     return WargaShell(navigationShell: navigationShell);
      //   },
      //   branches: [
      //     // Branch 0: Home
      //     StatefulShellBranch(
      //       navigatorKey: _wargaShellNavigatorKey,
      //       routes: [
      //         GoRoute(
      //           path: AppRoutes.wargaDashboard,
      //           name: 'wargaDashboard',
      //           builder: (context, state) => const WargaHomePage(),
      //         ),
      //       ],
      //     ),

      //     StatefulShellBranch(routes: [

      //       ],
      //     ),

      //     StatefulShellBranch(routes: [

      //       ],
      //     ),

      //     StatefulShellBranch(routes: [

      //       ],
      //     ),
      //   ],
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route tidak ditemukan: ${state.uri.path}')),
    ),
  );
}
