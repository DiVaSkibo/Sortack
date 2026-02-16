import 'package:sortack/_tools.dart';
//import 'package:sortack/_logics.dart';
//import 'package:sortack/_widgets.dart';
import 'page/home.dart';
import 'page/kanban.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sortack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: Fonts.RUBIK,
        shadowColor: Colours.o,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colours.TOP,
          selectionColor: Colours.UNTOP,
          selectionHandleColor: Colours.ACTOP,
        ),
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          primary: Colours.FRONT,
          onPrimary: Colours.W,
          secondary: Colours.TOP,
          onSecondary: Colours.BACK,
          surface: Colours.BACK,
          onSurface: Colours.W,
          error: Colours.NOTOK,
          onError: Colours.B,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          filled: false,
          // fillColor: Colours.TOP,
          // hoverColor: Colours.UNTOP,
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colours.FRONT,
          ),
          hintStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: Colours.UNFRONT,
          ),
          helperStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            wordSpacing: 2,
            color: Colours.BOTTOM,
          ),
          prefixStyle: TextStyle(fontSize: 13, color: Colours.UNBOTTOM),
          suffixStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colours.UNBOTTOM,
          ),
          counterStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            color: Colours.BOTTOM,
          ),
          border: InputBorder.none,
          // OutlineInputBorder(
          //   gapPadding: 0.0,
          //   borderSide: BorderSide(color: Colours.o, width: 0),
          //   borderRadius: BorderRadius.all(Radius.circular(4)),
          // ),
          enabledBorder: InputBorder.none,
          // OutlineInputBorder(
          //   gapPadding: 0.0,
          //   borderSide: BorderSide(color: Colours.o, width: 0),
          //   borderRadius: BorderRadius.all(Radius.circular(4)),
          // ),
          focusedBorder: InputBorder.none,
          // OutlineInputBorder(
          //   gapPadding: 0.0,
          //   borderSide: BorderSide(color: Colours.o, width: 0),
          //   borderRadius: BorderRadius.all(Radius.circular(4)),
          // ),
          errorBorder: OutlineInputBorder(
            gapPadding: 0.0,
            borderSide: BorderSide(color: Colours.NOTOK, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            gapPadding: 0.0,
            borderSide: BorderSide(color: Colours.NOTOK, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        textTheme: const TextTheme(labelLarge: TextStyle(fontSize: 20)),
        primaryTextTheme: const TextTheme(labelLarge: TextStyle(fontSize: 20)),
        iconTheme: const IconThemeData(size: 20, color: Colours.BOTTOM),
        primaryIconTheme: const IconThemeData(size: 20, color: Colours.BOTTOM),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colours.TOP,
          hoverColor: Colours.UNTOP,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            iconSize: 20,
            visualDensity: VisualDensity.compact,
            foregroundColor: Colours.CENTER,
            disabledForegroundColor: Colours.UNCENTER,
            hoverColor: Colours.GLOSS,
            highlightColor: Colours.ACCENTER,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            alignment: AlignmentGeometry.centerRight,
            textStyle: const TextStyle(
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            foregroundColor: Colours.TOP,
            overlayColor: Colours.UNTOP,
            iconAlignment: IconAlignment.end,
            iconSize: 16,
            iconColor: Colours.CENTER,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shadowColor: Colours.o,
            foregroundColor: Colours.CENTER,
            backgroundColor: Colours.TOP,
            overlayColor: Colours.UNTOP,
            textStyle: const TextStyle(
              fontSize: 15,
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colours.CENTER,
          backgroundColor: Colours.WARNING,
          focusColor: Colours.W,
          hoverColor: Colours.ACTOP,
          splashColor: Colours.NOTOK,
        ),
        chipTheme: const ChipThemeData(
          side: BorderSide.none,
          shadowColor: Colours.o,
          selectedShadowColor: Colours.o,
          color: WidgetStatePropertyAll(Colours.BOTTOM),
          selectedColor: Colours.ACCENTER,
          secondarySelectedColor: Colours.UNCENTER,
          backgroundColor: Colours.BOTTOM,
          surfaceTintColor: Colours.WARNING,
          deleteIconColor: Colours.NOTOK,
          checkmarkColor: Colours.TOP,
          labelStyle: TextStyle(
            fontSize: 13,
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
          secondaryLabelStyle: TextStyle(
            fontSize: 11,
            fontFamily: Fonts.RUBIK,
            fontStyle: FontStyle.italic,
          ),
          iconTheme: IconThemeData(),
        ),
        listTileTheme: const ListTileThemeData(
          minVerticalPadding: 0.0,
          minTileHeight: 30.0,
          minLeadingWidth: 30.0,
          horizontalTitleGap: 0.0,
          style: ListTileStyle.list,
          visualDensity: VisualDensity.comfortable,
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w600,
            color: Colours.BACK_GLOW,
          ),
          subtitleTextStyle: TextStyle(
            fontSize: 12,
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w500,
            color: Colours.FRONT,
          ),
          leadingAndTrailingTextStyle: TextStyle(
            fontSize: 14,
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: Colours.BOTTOM,
          ),
        ),
        expansionTileTheme: const ExpansionTileThemeData(
          expandedAlignment: Alignment.center,
          collapsedBackgroundColor: Colours.TOP,
          backgroundColor: Colours.ACTOP,
          collapsedTextColor: Colours.BACK_GLOW,
          textColor: Colours.B,
          collapsedIconColor: Colours.CENTER,
          iconColor: Colours.CENTER,
        ),
        dialogTheme: const DialogThemeData(
          alignment: Alignment.bottomRight,
          backgroundColor: Colours.BACK,
          surfaceTintColor: Colours.ACBOTTOM,
          barrierColor: Colours.SHADOW,
          iconColor: Colours.FRONT,
        ),
        popupMenuTheme: const PopupMenuThemeData(
          position: PopupMenuPosition.under,
          color: Colours.BACK_GLOW,
          surfaceTintColor: Colours.BACK,
          shadowColor: Colours.o,
          iconColor: Colours.CENTER,
          iconSize: 20,
          textStyle: TextStyle(color: Colours.CENTER),
          labelTextStyle: WidgetStatePropertyAll(TextStyle(color: Colours.TOP)),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colours.WARNING),
            elevation: WidgetStatePropertyAll(8),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
          ),
          textStyle: TextStyle(
            color: Colours.WARNING,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(false),
          trackVisibility: WidgetStateProperty.all(false),
          thickness: WidgetStateProperty.all(4),
          radius: const Radius.circular(4),
          crossAxisMargin: 2,
          mainAxisMargin: 20,
          minThumbLength: 20,
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.dragged)
                ? Colours.BOTTOM
                : Colours.FRONT,
          ),
          trackColor: WidgetStateProperty.all(Colours.BACK),
        ),
        tabBarTheme: const TabBarThemeData(
          tabAlignment: TabAlignment.fill,
          labelColor: Colours.UNFRONT,
          labelStyle: TextStyle(
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w600,
          ),
          indicatorColor: Colours.FRONT,
          unselectedLabelColor: Colours.GLOSS,
          unselectedLabelStyle: TextStyle(
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w600,
          ),
          dividerHeight: 2.25,
          dividerColor: Colours.WARNING,
        ),
        drawerTheme: const DrawerThemeData(
          width: 200,
          backgroundColor: Colours.o,
          scrimColor: Colours.o,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colours.BACK,
          foregroundColor: Colours.W,
          surfaceTintColor: Colours.GLOSS,
          titleTextStyle: TextStyle(
            letterSpacing: 1.5,
            fontFamily: Fonts.RUBIK_ONE,
            fontSize: 12.5,
            color: Colours.BOTTOM,
          ),
          iconTheme: IconThemeData(color: Colours.TOP),
          actionsIconTheme: IconThemeData(color: Colours.TOP),
        ),
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => const MyHomePage(),
        'kanban': (context) => const KanbanPage(),
      },
    );
  }
}
