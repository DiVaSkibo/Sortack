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
        shadowColor: Colours.o,
        visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        iconTheme: const IconThemeData(size: 20, color: Colours.BOTTOM),
        primaryIconTheme: const IconThemeData(size: 20, color: Colours.BOTTOM),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          strokeAlign: -1,
          strokeWidth: 20,
          strokeCap: StrokeCap.round,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          stopIndicatorRadius: 40.0,
          color: Colours.CENTER,
          stopIndicatorColor: Colours.TOP,
          linearTrackColor: Colours.BACK_GLOW,
          circularTrackColor: Colours.BACK_GLOW,
          refreshBackgroundColor: Colours.BACK_GLOW,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colours.TOP,
          hoverColor: Colours.UNTOP,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
            iconSize: 20,
            foregroundColor: Colours.CENTER,
            disabledForegroundColor: Colours.UNCENTER,
            hoverColor: Colours.GLOSS,
            highlightColor: Colours.ACCENTER,
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
            foregroundColor: Colours.TOP,
            overlayColor: Colours.UNTOP,
            iconAlignment: IconAlignment.end,
            iconSize: 16,
            iconColor: Colours.BOTTOM,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shadowColor: Colours.o,
            foregroundColor: Colours.B,
            backgroundColor: Colours.TOP,
            overlayColor: Colours.UNTOP,
            textStyle: const TextStyle(
              fontSize: 15,
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 2, strokeAlign: 0.1, color: Colours.TOP),
            shadowColor: Colours.o,
            foregroundColor: Colours.ACTOP,
            backgroundColor: Colours.UNBACK,
            overlayColor: Colours.UNTOP,
            iconSize: 16,
            iconColor: Colours.BOTTOM,
            textStyle: const TextStyle(
              fontSize: 15,
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          iconSize: 30,
          backgroundColor: Colours.TOP,
          foregroundColor: Colours.CENTER,
          focusColor: Colours.ACTOP,
          hoverColor: Colours.ACTOP,
          splashColor: Colours.UNTOP,
        ),
        chipTheme: const ChipThemeData(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: -3.0),
          labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: -3.0),
          showCheckmark: false,
          side: BorderSide(
            strokeAlign: BorderSide.strokeAlignOutside,
            width: 1.0,
            color: Colours.UNCENTER,
          ),
          shadowColor: Colours.o,
          selectedShadowColor: Colours.o,
          selectedColor: Colours.CENTER,
          secondarySelectedColor: Colours.CENTER,
          backgroundColor: Colours.UNFRONT,
          surfaceTintColor: Colours.WARNING,
          deleteIconColor: Colours.NOTOK,
          labelStyle: TextStyle(
            fontSize: 10,
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: Colours.CENTER,
          ),
          secondaryLabelStyle: TextStyle(
            fontSize: 10,
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: Colours.B,
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
          //tilePadding: EdgeInsets.zero,
          // childrenPadding: EdgeInsets.zero,
          collapsedBackgroundColor: Colours.WARNING,
          backgroundColor: Colours.WARNING,
          // collapsedTextColor: Colours.BACK_GLOW,
          // textColor: Colours.B,
          // collapsedIconColor: Colours.CENTER,
          // iconColor: Colours.CENTER,
        ),
        popupMenuTheme: const PopupMenuThemeData(
          position: PopupMenuPosition.under,
          color: Colours.BACK_GLOW,
          surfaceTintColor: Colours.o,
          shadowColor: Colours.o,
          iconColor: Colours.CENTER,
          iconSize: 20,
          textStyle: TextStyle(color: Colours.WARNING),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontFamily: Fonts.RUBIK, color: Colours.W),
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
          backgroundColor: Colours.BACK,
          headerBackgroundColor: Colours.BACK_GLOW,
          headerForegroundColor: Colours.W,
          subHeaderForegroundColor: Colours.FRONT,
          dividerColor: Colours.o,
          shadowColor: Colours.o,
          dayBackgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? Colours.CENTER : null,
          ),
          dayForegroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? Colours.B : null,
          ),
          yearBackgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? Colours.CENTER : null,
          ),
          yearForegroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? Colours.B : null,
          ),
          todayBackgroundColor: WidgetStatePropertyAll(Colours.BOTTOM),
          todayForegroundColor: WidgetStatePropertyAll(Colours.B),
          todayBorder: const BorderSide(width: 0, color: Colours.o),
          cancelButtonStyle: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colours.BAD),
            foregroundColor: WidgetStatePropertyAll(Colours.B),
            textStyle: WidgetStatePropertyAll(
              TextStyle(fontFamily: Fonts.RUBIK, fontWeight: FontWeight.w600),
            ),
          ),
          confirmButtonStyle: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colours.GOOD),
            foregroundColor: WidgetStatePropertyAll(Colours.B),
            textStyle: WidgetStatePropertyAll(
              TextStyle(fontFamily: Fonts.RUBIK, fontWeight: FontWeight.w600),
            ),
          ),
          headerHelpStyle: const TextStyle(
            fontSize: 16,
            fontFamily: Fonts.RUBIK,
            fontStyle: FontStyle.italic,
            color: Colours.UNFRONT,
          ),
          headerHeadlineStyle: const TextStyle(
            fontSize: 33,
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w700,
            color: Colours.CENTER,
          ),
          weekdayStyle: const TextStyle(
            fontFamily: Fonts.RUBIK_ONE,
            color: Colours.UNFRONT,
          ),
          dayStyle: const TextStyle(
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w500,
          ),
          yearStyle: const TextStyle(
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w500,
          ),
          rangeSelectionOverlayColor: WidgetStatePropertyAll(Colours.CENTER),
        ),
        dialogTheme: const DialogThemeData(
          alignment: Alignment.centerRight,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
          shadowColor: Colours.o,
          barrierColor: Colours.SHADOW,
          backgroundColor: Colours.o,
          surfaceTintColor: Colours.o,
          iconColor: Colours.UNTOP,
          titleTextStyle: TextStyle(
            fontSize: 17,
            fontFamily: Fonts.RUBIK,
            color: Colours.W,
          ),
        ),
        drawerTheme: const DrawerThemeData(
          width: 200,
          backgroundColor: Colours.o,
          scrimColor: Colours.o,
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
                ? Colours.FRONT
                : Colours.UNFRONT,
          ),
          trackColor: WidgetStatePropertyAll(Colours.GLOSS),
        ),
        tabBarTheme: const TabBarThemeData(
          tabAlignment: TabAlignment.fill,
          dividerHeight: 2.25,
          labelColor: Colours.W,
          unselectedLabelColor: Colours.GLOSS,
          indicatorColor: Colours.UNFRONT,
          dividerColor: Colours.o,
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
          backgroundColor: Colours.o,
          foregroundColor: Colours.W,
          surfaceTintColor: Colours.o,
          shadowColor: Colours.o,
          iconTheme: IconThemeData(color: Colours.BOTTOM),
          actionsIconTheme: IconThemeData(size: 25, color: Colours.TOP),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontFamily: Fonts.RUBIK_ONE,
            color: Colours.W,
          ),
        ),
      ),
      home: Rooter(),
    );
  }
}
