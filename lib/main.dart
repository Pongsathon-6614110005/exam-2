import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_vision_journal/core/settings/theme_cubit.dart';
import 'package:smart_vision_journal/injection.dart';
import 'package:smart_vision_journal/routes/app_router.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_bloc.dart';
import 'package:smart_vision_journal/features/note/presentation/bloc/note_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await init();

  final appRouter = AppRouter();
  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({required this.appRouter, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => sl<ThemeCubit>()..loadTheme(),
        ),
        BlocProvider<NoteBloc>(
          create: (_) => sl<NoteBloc>()..add(LoadNotes()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            routerConfig: appRouter.config(),
          );
        },
      ),
    );
  }
}
