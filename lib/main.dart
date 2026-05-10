import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '_tools.dart';
import 'root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        shadowColor: Colours.a,
        visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colours.DRIVE,
          selectionColor: Colours.DRIVE_UN,
          selectionHandleColor: Colours.DRIVE_AC,
        ),
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          primary: Colours.INK,
          onPrimary: Colours.F,
          secondary: Colours.DRIVE,
          onSecondary: Colours.CANVAS,
          surface: Colours.CANVAS,
          onSurface: Colours.F,
          error: Colours.NOTOK,
          onError: Colours.O,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          filled: false,
          // fillColor: Colours.DRIVE,
          // hoverColor: Colours.DRIVE_UN,
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colours.INK,
          ),
          hintStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: Colours.INK_UN,
          ),
          helperStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            wordSpacing: 2,
            color: Colours.ANCHOR,
          ),
          prefixStyle: TextStyle(fontSize: 13, color: Colours.ANCHOR_UN),
          suffixStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colours.ANCHOR_UN,
          ),
          counterStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            color: Colours.ANCHOR,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
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
        iconTheme: const IconThemeData(size: 20, color: Colours.ANCHOR),
        primaryIconTheme: const IconThemeData(size: 20, color: Colours.ANCHOR),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          strokeAlign: -1,
          strokeWidth: 20,
          strokeCap: StrokeCap.round,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          stopIndicatorRadius: 40.0,
          color: Colours.SHIFT,
          stopIndicatorColor: Colours.DRIVE,
          linearTrackColor: Colours.CANVAS_AC,
          circularTrackColor: Colours.CANVAS_AC,
          refreshBackgroundColor: Colours.CANVAS_AC,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colours.DRIVE,
          hoverColor: Colours.DRIVE_UN,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
            iconSize: 20,
            foregroundColor: Colours.SHIFT,
            disabledForegroundColor: Colours.SHIFT_UN,
            hoverColor: Colours.GLOSS,
            highlightColor: Colours.SHIFT_AC,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            alignment: AlignmentGeometry.center,
            textStyle: const TextStyle(
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            foregroundColor: Colours.DRIVE,
            overlayColor: Colours.DRIVE_UN,
            iconAlignment: IconAlignment.end,
            iconSize: 16,
            iconColor: Colours.ANCHOR,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shadowColor: Colours.a,
            foregroundColor: Colours.O,
            backgroundColor: Colours.DRIVE,
            overlayColor: Colours.DRIVE_UN,
            textStyle: const TextStyle(
              fontSize: 15,
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              width: 2,
              strokeAlign: 0.1,
              color: Colours.DRIVE,
            ),
            shadowColor: Colours.a,
            foregroundColor: Colours.DRIVE_AC,
            backgroundColor: Colours.CANVAS_UN,
            overlayColor: Colours.DRIVE_UN,
            iconSize: 16,
            iconColor: Colours.ANCHOR,
            textStyle: const TextStyle(
              fontSize: 15,
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          iconSize: 30,
          backgroundColor: Colours.DRIVE,
          foregroundColor: Colours.SHIFT,
          focusColor: Colours.DRIVE_AC,
          hoverColor: Colours.DRIVE_AC,
          splashColor: Colours.DRIVE_UN,
        ),
        chipTheme: ChipThemeData(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: -3.0),
          labelPadding: const EdgeInsets.symmetric(
            horizontal: 4.0,
            vertical: -3.0,
          ),
          showCheckmark: false,
          side: const BorderSide(
            strokeAlign: BorderSide.strokeAlignOutside,
            width: 1.0,
            color: Colours.SHIFT_UN,
          ),
          selectedColor: Colours.SHIFT,
          color: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected))
              return Colours.SHIFT;
            else
              return Colours.a;
          }),
          secondarySelectedColor: Colours.SHIFT,
          backgroundColor: Colours.INK_UN,
          surfaceTintColor: Colours.a,
          deleteIconColor: Colours.NOTOK,
          shadowColor: Colours.a,
          selectedShadowColor: Colours.a,
          labelStyle: const TextStyle(
            fontSize: 10,
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: Colours.F,
          ),
          secondaryLabelStyle: const TextStyle(
            fontSize: 10,
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: Colours.O,
          ),
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 12.5,
          ),
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
            color: Colours.CANVAS_AC,
          ),
          subtitleTextStyle: TextStyle(
            fontSize: 12,
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w500,
            color: Colours.INK,
          ),
          leadingAndTrailingTextStyle: TextStyle(
            fontSize: 14,
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: Colours.ANCHOR,
          ),
        ),
        expansionTileTheme: const ExpansionTileThemeData(
          expandedAlignment: Alignment.center,
          //tilePadding: EdgeInsets.zero,
          // childrenPadding: EdgeInsets.zero,
          collapsedBackgroundColor: Colours.WARNING,
          backgroundColor: Colours.WARNING,
          // collapsedTextColor: Colours.CANVAS_AC,
          // textColor: Colours.B,
          // collapsedIconColor: Colours.SHIFT,
          // iconColor: Colours.SHIFT,
        ),
        popupMenuTheme: const PopupMenuThemeData(
          position: PopupMenuPosition.under,
          color: Colours.CANVAS_AC,
          surfaceTintColor: Colours.a,
          shadowColor: Colours.a,
          iconColor: Colours.SHIFT,
          iconSize: 20,
          textStyle: TextStyle(color: Colours.WARNING),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontFamily: Fonts.RUBIK, color: Colours.F),
          ),
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
        datePickerTheme: DatePickerThemeData(
          backgroundColor: Colours.CANVAS,
          headerBackgroundColor: Colours.CANVAS_AC,
          headerForegroundColor: Colours.F,
          subHeaderForegroundColor: Colours.INK,
          dividerColor: Colours.a,
          shadowColor: Colours.a,
          dayBackgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? Colours.SHIFT : null,
          ),
          dayForegroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? Colours.O : null,
          ),
          yearBackgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? Colours.SHIFT : null,
          ),
          yearForegroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? Colours.O : null,
          ),
          todayBackgroundColor: WidgetStatePropertyAll(Colours.ANCHOR),
          todayForegroundColor: WidgetStatePropertyAll(Colours.O),
          todayBorder: const BorderSide(width: 0, color: Colours.a),
          cancelButtonStyle: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colours.BAD),
            foregroundColor: WidgetStatePropertyAll(Colours.O),
            textStyle: WidgetStatePropertyAll(
              TextStyle(fontFamily: Fonts.RUBIK, fontWeight: FontWeight.w600),
            ),
          ),
          confirmButtonStyle: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colours.GOOD),
            foregroundColor: WidgetStatePropertyAll(Colours.O),
            textStyle: WidgetStatePropertyAll(
              TextStyle(fontFamily: Fonts.RUBIK, fontWeight: FontWeight.w600),
            ),
          ),
          headerHelpStyle: const TextStyle(
            fontSize: 16,
            fontFamily: Fonts.RUBIK,
            fontStyle: FontStyle.italic,
            color: Colours.INK_UN,
          ),
          headerHeadlineStyle: const TextStyle(
            fontSize: 33,
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w700,
            color: Colours.SHIFT,
          ),
          weekdayStyle: const TextStyle(
            fontFamily: Fonts.RUBIK_ONE,
            color: Colours.INK_UN,
          ),
          dayStyle: const TextStyle(
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w500,
          ),
          yearStyle: const TextStyle(
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w500,
          ),
          rangeSelectionOverlayColor: WidgetStatePropertyAll(Colours.SHIFT),
        ),
        dialogTheme: const DialogThemeData(
          alignment: Alignment.centerRight,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
          shadowColor: Colours.a,
          barrierColor: Colours.SHADOW,
          backgroundColor: Colours.a,
          surfaceTintColor: Colours.a,
          iconColor: Colours.DRIVE_UN,
          titleTextStyle: TextStyle(
            fontSize: 17,
            fontFamily: Fonts.RUBIK,
            color: Colours.F,
          ),
        ),
        drawerTheme: const DrawerThemeData(
          width: 200,
          backgroundColor: Colours.a,
          scrimColor: Colours.a,
        ),
        scrollbarTheme: ScrollbarThemeData(
          crossAxisMargin: 2,
          mainAxisMargin: 20,
          radius: const Radius.circular(4),
          minThumbLength: 20,
          thickness: const WidgetStatePropertyAll(4),
          interactive: true,
          thumbVisibility: const WidgetStatePropertyAll(false),
          trackVisibility: const WidgetStatePropertyAll(false),
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.dragged)
                ? Colours.INK
                : Colours.INK_UN,
          ),
          trackColor: WidgetStatePropertyAll(Colours.GLOSS),
        ),
        tabBarTheme: const TabBarThemeData(
          tabAlignment: TabAlignment.fill,
          dividerHeight: 2.25,
          labelColor: Colours.F,
          unselectedLabelColor: Colours.GLOSS,
          indicatorColor: Colours.INK_UN,
          dividerColor: Colours.a,
          labelStyle: TextStyle(
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w500,
          ),
        ),
        appBarTheme: const AppBarTheme(
          actionsPadding: EdgeInsets.symmetric(horizontal: 40.0),
          toolbarHeight: 80.0,
          centerTitle: true,
          backgroundColor: Colours.a,
          foregroundColor: Colours.F,
          surfaceTintColor: Colours.a,
          shadowColor: Colours.a,
          iconTheme: IconThemeData(color: Colours.ANCHOR),
          actionsIconTheme: IconThemeData(size: 25, color: Colours.DRIVE),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontFamily: Fonts.RUBIK_ONE,
            color: Colours.F,
          ),
        ),
      ),
      home: Rooter(),
    );
  }
}
