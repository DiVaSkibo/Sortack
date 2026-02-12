import 'package:flutter/material.dart';
//import 'package:sortack/tool/style.dart';

mixin ComparableEnum<T> implements Comparable<ComparableEnum> {
  int get index;

  @override
  int compareTo(other) => index - other.index;
}

final class FromTo<T extends Comparable> {
  final T from;
  final T to;

  const FromTo({required this.from, required this.to});

  bool check(T value) {
    //if (value == null) return false;
    //if (value is Comparable && from is Comparable && to is Comparable)
    //  return from.compareTo(to) <= 0
    //      ? value.compareTo(from) >= 0 && value.compareTo(to) <= 0
    //      : value.compareTo(from) <= 0 || value.compareTo(to) >= 0;
    //return value == from;
    return from.compareTo(to) <= 0
        ? value.compareTo(from) >= 0 && value.compareTo(to) <= 0
        : value.compareTo(from) <= 0 || value.compareTo(to) >= 0;
  }
}

mixin TaskPointing implements Comparable<TaskPointing> {
  int get value;

  @override
  int compareTo(other) => value - other.value;
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

  bool isEmpty() => collection.isEmpty;
  bool isNotEmpty() => collection.isNotEmpty;

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

  void insert(T what, int where) {
    //debugPrint('${what.toString()} is inserted at $where');
    collection.insert(where, what);
    //debugPrint('$status: ${collection.map((task) => task.title).toString()}');
    if (listenable) notifyListeners();
  }

  void move(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    var temp = collection[oldIndex];
    collection[oldIndex] = collection[newIndex];
    collection[newIndex] = temp;
    if (listenable) notifyListeners();
  }
}
