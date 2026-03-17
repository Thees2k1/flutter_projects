import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/services/auth_service.dart';

// ── Pages ────────────────────────────────────────────────────────────────────
import 'features/album/pages/album_page.dart';
import 'features/album/pages/track_page.dart';
import 'features/artist/pages/artist_albums_page.dart';
import 'features/artist/pages/artist_page.dart';
import 'features/artist/pages/artist_top_tracks_page.dart';
import 'features/auth/pages/forgot_password_page.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/pages/register_page.dart';
import 'features/home/pages/featured_playlist_page.dart';
import 'features/home/pages/home_page.dart';
import 'features/library/pages/library_album_detail_page.dart';
import 'features/library/pages/library_albums_page.dart';
import 'features/library/pages/library_artist_detail_page.dart';
import 'features/library/pages/library_artists_page.dart';
import 'features/library/pages/playlist_detail_page.dart';
import 'features/library/pages/playlist_edit_page.dart';
import 'features/library/pages/playlists_page.dart';
import 'features/library/shell/library_shell_page.dart';
import 'features/not_found/pages/not_found_page.dart';
import 'features/onboarding/pages/onboarding_page.dart';
import 'features/player/pages/lyrics_page.dart';
import 'features/player/pages/player_page.dart';
import 'features/player/pages/player_track_page.dart';
import 'features/player/pages/queue_page.dart';
import 'features/playlist/pages/playlist_page.dart';
import 'features/profile/pages/edit_profile_page.dart';
import 'features/profile/pages/notification_settings_page.dart';
import 'features/profile/pages/privacy_settings_page.dart';
import 'features/profile/pages/profile_page.dart';
import 'features/profile/pages/settings_page.dart';
import 'features/profile/pages/subscription_page.dart';
import 'features/search/pages/search_page.dart';
import 'features/search/pages/search_results_page.dart';
import 'features/shell/main_shell_page.dart';
import 'features/splash/pages/splash_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Router
// ─────────────────────────────────────────────────────────────────────────────

/// The application's root [GoRouter].
///
/// Routing scenarios demonstrated:
///   1.  Simple routes           — /splash, /onboarding
///   2.  Auth sub-routes         — /auth/login, /auth/register, /auth/forgot-password
///   3.  Global redirect guard   — unauthenticated → /auth/login?redirect=<path>
///   4.  Outer StatefulShellRoute (bottom nav) with 4 branches
///   5.  Nested StatefulShellRoute inside Library branch (tab bar)
///   6.  Sub-routes with path params   — /home/featured/:playlistId
///   7.  Query parameters              — /search?q=...&genre=...
///   8.  Multiple path params          — /album/:albumId/track/:trackId
///   9.  Extra data (object passing)   — /artist/:artistId with extra: Map
///  10.  Custom page transition        — /player slides up from bottom
///  11.  Deep-link route               — /player/track/:trackId
///  12.  Error page                    — unknown paths → NotFoundPage
///  13.  Named routes (goNamed / pushNamed throughout)
final appRouter = GoRouter(
  initialLocation: '/splash',

  // GoRouter re-evaluates redirect whenever AuthService notifies.
  refreshListenable: authService,

  redirect: _globalRedirect,

  errorBuilder: (context, state) => const NotFoundPage(),

  routes: [
    // ── 1. Splash ──────────────────────────────────────────────────────────
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),

    // ── 2. Onboarding ──────────────────────────────────────────────────────
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),

    // ── 3. Auth group — parent redirect + sub-routes ───────────────────────
    //
    //   /auth          → redirects to /auth/login
    //   /auth/login    → LoginPage (reads ?redirect= query param)
    //   /auth/register
    //   /auth/forgot-password
    //
    GoRoute(
      path: '/auth',
      redirect: (context, state) => '/auth/login',
      routes: [
        GoRoute(
          path: 'login',
          name: 'login',
          builder: (context, state) => LoginPage(
            // Pass where to redirect after successful login
            redirectTo: state.uri.queryParameters['redirect'],
          ),
        ),
        GoRoute(
          path: 'register',
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: 'forgot-password',
          name: 'forgotPassword',
          builder: (context, state) => const ForgotPasswordPage(),
        ),
      ],
    ),

    // ── 4. Main shell — StatefulShellRoute with bottom navigation ──────────
    //
    // StatefulShellRoute.indexedStack preserves each branch's navigation
    // state independently (like BottomNavigationBar + IndexedStack).
    //
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainShellPage(navigationShell: shell),
      branches: [
        // ── Branch 0 : Home ──────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomePage(),
              routes: [
                // Sub-route with a single path param
                GoRoute(
                  path: 'featured/:playlistId',
                  name: 'featuredPlaylist',
                  builder: (context, state) => FeaturedPlaylistPage(
                    playlistId: state.pathParameters['playlistId']!,
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── Branch 1 : Search ─────────────────────────────────────────────
        //
        // Demonstrates query parameters:
        //   /search?q=coldplay&genre=rock
        //   /search/results?q=coldplay&genre=rock
        //
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              name: 'search',
              builder: (context, state) => SearchPage(
                query: state.uri.queryParameters['q'],
                genre: state.uri.queryParameters['genre'],
              ),
              routes: [
                GoRoute(
                  path: 'results',
                  name: 'searchResults',
                  builder: (context, state) => SearchResultsPage(
                    query: state.uri.queryParameters['q'] ?? '',
                    genre: state.uri.queryParameters['genre'],
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── Branch 2 : Library (nested StatefulShellRoute) ────────────────
        //
        // A StatefulShellRoute nested inside a StatefulShellBranch creates
        // a second level of preserved navigation (inner tab bar).
        //
        //   /library/playlists
        //   /library/playlists/:playlistId
        //   /library/playlists/:playlistId/edit
        //   /library/albums
        //   /library/albums/:albumId
        //   /library/artists
        //   /library/artists/:artistId
        //
        StatefulShellBranch(
          routes: [
            StatefulShellRoute.indexedStack(
              builder: (context, state, shell) =>
                  LibraryShellPage(navigationShell: shell),
              branches: [
                // Playlists tab
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/library/playlists',
                      name: 'playlists',
                      builder: (context, state) => const PlaylistsPage(),
                      routes: [
                        GoRoute(
                          path: ':playlistId',
                          name: 'playlistDetail',
                          builder: (context, state) => PlaylistDetailPage(
                            playlistId: state.pathParameters['playlistId']!,
                          ),
                          routes: [
                            GoRoute(
                              path: 'edit',
                              name: 'editPlaylist',
                              builder: (context, state) => PlaylistEditPage(
                                playlistId: state.pathParameters['playlistId']!,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                // Albums tab
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/library/albums',
                      name: 'libraryAlbums',
                      builder: (context, state) => const LibraryAlbumsPage(),
                      routes: [
                        GoRoute(
                          path: ':albumId',
                          name: 'libraryAlbumDetail',
                          builder: (context, state) => LibraryAlbumDetailPage(
                            albumId: state.pathParameters['albumId']!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Artists tab
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/library/artists',
                      name: 'libraryArtists',
                      builder: (context, state) => const LibraryArtistsPage(),
                      routes: [
                        GoRoute(
                          path: ':artistId',
                          name: 'libraryArtistDetail',
                          builder: (context, state) => LibraryArtistDetailPage(
                            artistId: state.pathParameters['artistId']!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // ── Branch 3 : Profile ────────────────────────────────────────────
        //
        //   /profile
        //   /profile/edit
        //   /profile/settings
        //   /profile/settings/notifications
        //   /profile/settings/privacy
        //   /profile/settings/subscription
        //
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: 'edit',
                  name: 'editProfile',
                  builder: (context, state) => const EditProfilePage(),
                ),
                GoRoute(
                  path: 'settings',
                  name: 'settings',
                  builder: (context, state) => const SettingsPage(),
                  routes: [
                    GoRoute(
                      path: 'notifications',
                      name: 'notificationSettings',
                      builder: (context, state) =>
                          const NotificationSettingsPage(),
                    ),
                    GoRoute(
                      path: 'privacy',
                      name: 'privacySettings',
                      builder: (context, state) => const PrivacySettingsPage(),
                    ),
                    GoRoute(
                      path: 'subscription',
                      name: 'subscription',
                      builder: (context, state) => const SubscriptionPage(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // ── 5. Full-screen routes outside the shell ────────────────────────────
    //
    // These routes render on top of (or instead of) the shell, with no
    // bottom navigation bar visible.

    // Artist — path param + 2 sub-routes + extra object passing
    //
    //   /artist/:artistId               (extra: Map<String, dynamic>)
    //   /artist/:artistId/albums
    //   /artist/:artistId/top-tracks
    //
    GoRoute(
      path: '/artist/:artistId',
      name: 'artist',
      builder: (context, state) => ArtistPage(
        artistId: state.pathParameters['artistId']!,
        // extra allows passing rich objects without encoding them in the URL
        extra: state.extra as Map<String, dynamic>?,
      ),
      routes: [
        GoRoute(
          path: 'albums',
          name: 'artistAlbums',
          builder: (context, state) =>
              ArtistAlbumsPage(artistId: state.pathParameters['artistId']!),
        ),
        GoRoute(
          path: 'top-tracks',
          name: 'artistTopTracks',
          builder: (context, state) =>
              ArtistTopTracksPage(artistId: state.pathParameters['artistId']!),
        ),
      ],
    ),

    // Album + nested track — two path params in the same route hierarchy
    //
    //   /album/:albumId
    //   /album/:albumId/track/:trackId     ← two params simultaneously
    //
    GoRoute(
      path: '/album/:albumId',
      name: 'album',
      builder: (context, state) =>
          AlbumPage(albumId: state.pathParameters['albumId']!),
      routes: [
        GoRoute(
          path: 'track/:trackId',
          name: 'albumTrack',
          builder: (context, state) => TrackPage(
            albumId: state.pathParameters['albumId']!,
            trackId: state.pathParameters['trackId']!,
          ),
        ),
      ],
    ),

    // Public playlist + nested track — same two-param pattern, different context
    //
    //   /playlist/:playlistId
    //   /playlist/:playlistId/track/:trackId
    //
    GoRoute(
      path: '/playlist/:playlistId',
      name: 'publicPlaylist',
      builder: (context, state) =>
          PlaylistPage(playlistId: state.pathParameters['playlistId']!),
      routes: [
        GoRoute(
          path: 'track/:trackId',
          name: 'publicPlaylistTrack',
          builder: (context, state) => TrackPage(
            playlistId: state.pathParameters['playlistId'],
            trackId: state.pathParameters['trackId']!,
          ),
        ),
      ],
    ),

    // Player — custom slide-up page transition
    //
    // Uses pageBuilder instead of builder to supply a CustomTransitionPage.
    // Sub-routes inherit the normal MaterialPage transition.
    //
    //   /player                ← slides up from bottom
    //   /player/queue
    //   /player/lyrics
    //   /player/track/:trackId ← deep-link into a specific track
    //
    GoRoute(
      path: '/player',
      name: 'player',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const PlayerPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOutCubic)),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
      routes: [
        GoRoute(
          path: 'queue',
          name: 'playerQueue',
          builder: (context, state) => const QueuePage(),
        ),
        GoRoute(
          path: 'lyrics',
          name: 'playerLyrics',
          builder: (context, state) => const LyricsPage(),
        ),
        // Deep-link: share a URL like melodify://player/track/abc123
        GoRoute(
          path: 'track/:trackId',
          name: 'playerTrack',
          builder: (context, state) =>
              PlayerTrackPage(trackId: state.pathParameters['trackId']!),
        ),
      ],
    ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// Global redirect guard
// ─────────────────────────────────────────────────────────────────────────────

/// Called before every navigation event (and when [authService] notifies).
///
/// Rules:
///  • /splash and /onboarding are always public.
///  • All other routes require the user to be logged in.
///  • Auth pages (/auth/*) redirect logged-in users to /home.
///  • The original destination is preserved in ?redirect= so LoginPage can
///    restore it after a successful login.
String? _globalRedirect(BuildContext context, GoRouterState state) {
  final isLoggedIn = authService.isLoggedIn;
  final location = state.matchedLocation;

  // Always allow public entry-point routes
  if (location == '/splash' || location == '/onboarding') return null;

  final isAuthRoute = location.startsWith('/auth');

  if (!isLoggedIn && !isAuthRoute) {
    // Encode the destination so it survives as a query-param value
    final encoded = Uri.encodeComponent(location);
    return '/auth/login?redirect=$encoded';
  }

  if (isLoggedIn && isAuthRoute) {
    return '/home';
  }

  return null; // no redirect needed
}
