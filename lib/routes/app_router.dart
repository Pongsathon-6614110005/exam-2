import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_vision_journal/features/note/presentation/pages/add_note_page.dart';
import 'package:smart_vision_journal/features/note/presentation/pages/home_page.dart';
import 'package:smart_vision_journal/features/note/presentation/pages/note_detail_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: AddNoteRoute.page),
        AutoRoute(page: NoteDetailRoute.page),
      ];
}
