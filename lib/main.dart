import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/view/homepage.dart';
import 'providers/theme_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(
    child: PocketTasks(),
  ));
}

class PocketTasks extends ConsumerWidget {
  const PocketTasks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Pocket Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: const Color.fromARGB(255, 23, 11, 106)),
        useMaterial3: true,
        fontFamily: 'Open Sans Hebrew',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: const Color.fromARGB(255, 23, 11, 106)),
        fontFamily: 'Open Sans Hebrew',
        useMaterial3: true,
      ),
      themeMode: themeMode,
      home: const HomePage(),
    );
  }
}
