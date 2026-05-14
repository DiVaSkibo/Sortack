import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ColorExtension on Color {
  String toHex() =>
      '#${toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension DateExtension on DateTime {
  String get ddMMMyyyy => DateFormat('dd MMM yyyy').format(this);
}

mixin Labeling {
  String get label;
}

mixin ComparableEnum<T> on Enum implements Comparable<ComparableEnum> {
  @override
  int compareTo(other) => index - other.index;
}

mixin Pointing on Enum implements Comparable<Pointing> {
  int get value;

  @override
  int compareTo(other) => value - other.value;
}

abstract interface class Artefact {
  String get label;
  IconData get icon;
  Color get colour;
}

abstract interface class Parameters {
  Type type();
  List parameterValues();
}

abstract mixin class Parameterizable<T extends Parameters> {
  dynamic getParameter(T parameter, {bool comparable = false});
  int compareTo(Parameterizable other, T by) {
    final dynamic aValue = getParameter(by, comparable: true);
    final dynamic bValue = other.getParameter(by, comparable: true);
    if (aValue == null) return 0;
    if (bValue == null) return 1;
    return aValue.compareTo(bValue);
  }
}

abstract class Collector<T> with ChangeNotifier {
  List<T> get collection;
  bool listenable;

  Collector({this.listenable = false});

  int get length => collection.length;
  bool get isEmpty => collection.isEmpty;
  bool get isNotEmpty => collection.isNotEmpty;
  T get first => collection.first;

  T operator [](int index) => collection.elementAt(index);

  void push(T what, {bool front = false}) {
    //debugPrint('${what.toString()} is pushed ${front ? 'front' : 'back'} to $this');
    if (front)
      collection.insert(0, what);
    else
      collection.add(what);
    if (listenable) notifyListeners();
  }

  bool pop(T what) {
    //debugPrint('${what.toString()} is poped from $this');
    var poped = collection.remove(what);
    if (listenable) notifyListeners();
    return poped;
  }

  T popAt(int where) {
    return collection.removeAt(where);
  }

  void insert(T what, int where) {
    //debugPrint('${what.toString()} is inserted at $where');
    collection.insert(where, what);
    //debugPrint('$status: ${collection.map((task) => task.title).toString()}');
    if (listenable) notifyListeners();
  }

  void move(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    // var temp = collection[oldIndex];
    // collection[oldIndex] = collection[newIndex];
    // collection[newIndex] = temp;
    collection.insert(newIndex, collection.removeAt(oldIndex));
    if (listenable) notifyListeners();
  }

  void clear() {
    collection.clear();
  }
}

@immutable
interface class Iction {
  final IconData icon;
  final VoidCallback callback;

  const Iction({required this.icon, required this.callback});

  void call() => callback();
}
