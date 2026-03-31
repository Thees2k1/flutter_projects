import 'package:flutter/material.dart';
import 'package:quizler/Controller/quiz_controller.dart';
import 'package:quizler/View/landing_view.dart';
import 'package:quizler/View/quizler_view.dart';
import 'package:quizler/View/report_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

const kSupadupaSecureKey = '111111';

class _MainAppState extends State<MainApp> {
  var themeMode = ThemeMode.system;
  var isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        title: "Quizler",
        themeMode: themeMode,
        isAuthenticated: isAuthenticated,
        onChangeTheme: onChangeTheme,
        onAuthenticationChanged: (newAuthState) {
          setState(() {
            isAuthenticated = newAuthState;
          });
        },
      ),
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }

  void onChangeTheme(ThemeMode newThemeMode) {
    setState(() {
      themeMode = newThemeMode;
    });
  }
}

class AuthModalTrigger extends StatelessWidget {
  AuthModalTrigger({
    super.key,
    required this.isAuthenticated,
    required this.onAuthenticationChanged,
  });

  bool isAuthenticated;
  final void Function(bool) onAuthenticationChanged;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isAuthenticated ? "Logout" : "Login",
      child: IconButton(
        icon: Icon(isAuthenticated ? Icons.lock_open : Icons.lock),
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AuthDialog(isAuthenticated: isAuthenticated),
          );

          if (result != null) {
            onAuthenticationChanged(result);
          }
        },
      ),
    );
  }
}

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key, required this.isAuthenticated});

  final bool isAuthenticated;

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return widget.isAuthenticated
        ? buildLogoutDialog(context)
        : buildLoginDialog(context);
  }

  AlertDialog buildLogoutDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Logout"),
        ),
      ],
    );
  }

  AlertDialog buildLoginDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Login"),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: "Enter secure key",
          errorText: _errorText,
        ),
        obscureText: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text == kSupadupaSecureKey) {
              Navigator.of(context).pop(true);
            } else {
              setState(() {
                _errorText = "Invalid secure key";
              });
            }
          },
          child: const Text("Login"),
        ),
      ],
    );
  }
}

class ThemeModeSwitcher extends StatelessWidget {
  const ThemeModeSwitcher({
    super.key,
    required this.currentThemeMode,
    required this.onChangeTheme,
  });

  final ThemeMode currentThemeMode;
  final void Function(ThemeMode) onChangeTheme;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ThemeMode>(
      icon: Icon(Icons.brightness_6),
      onSelected: onChangeTheme,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeMode.light,
          child: Row(
            children: [
              if (currentThemeMode == ThemeMode.light)
                Icon(Icons.check, size: 16),
              const SizedBox(width: 8),
              const Text("Light Theme"),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: Row(
            children: [
              if (currentThemeMode == ThemeMode.dark)
                Icon(Icons.check, size: 16),
              const SizedBox(width: 8),
              const Text("Dark Theme"),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.system,
          child: Row(
            children: [
              if (currentThemeMode == ThemeMode.system)
                Icon(Icons.check, size: 16),
              const SizedBox(width: 8),
              const Text("System Theme"),
            ],
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
    required this.themeMode,
    this.title = "Quizler",
    this.isAuthenticated = false,
    required this.onChangeTheme,
    required this.onAuthenticationChanged,
  });

  final bool isAuthenticated;
  final ThemeMode themeMode;
  final String title;
  final void Function(ThemeMode) onChangeTheme;
  final void Function(bool) onAuthenticationChanged;

  final quizController = QuizController.instance;

  @override
  Widget build(BuildContext context) {
    final landingView = LandingView(isAuthenticated: isAuthenticated);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ThemeModeSwitcher(
            currentThemeMode: themeMode,
            onChangeTheme: onChangeTheme,
          ),
          AuthModalTrigger(
            isAuthenticated: isAuthenticated,
            onAuthenticationChanged: onAuthenticationChanged,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: quizController,
        builder: (context, child) {
          if (quizController.error != null) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(buildErrorSnackbar(context, quizController.error!));
          }

          if (quizController.currentView == QuizView.landing) {
            return landingView;
          } else if (quizController.currentView == QuizView.report) {
            return buildReportView(
              context,
              quizController.getAllQuizesSync().length,
              quizController.score,
            );
          } else {
            return QuizlerView(
              onAnswered: (answer) => quizController.nextQuiz(),
              quiz: quizController.getQuizById(quizController.currentQuizIndex),
            );
          }
        },
      ),
    );
  }

  Widget buildReportView(
    BuildContext context,
    int totalQuestion,
    int totalCorectAnswer,
  ) {
    return ReportView(
      totalQuestion: totalQuestion,
      totalCorectAnswer: totalCorectAnswer,
      onBackToHome: () => quizController.goToView(QuizView.landing),
    );
  }

  SnackBar buildErrorSnackbar(BuildContext context, String errorMessage) {
    return SnackBar(
      content: Text(
        "Error message",
        style: TextStyle(color: Colors.red.shade900),
      ),
      backgroundColor: Colors.redAccent.withAlpha(20),
    );
  }
}
