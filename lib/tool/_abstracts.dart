mixin ComparableEnum<T> implements Comparable<ComparableEnum> {
  int get index;

  @override
  int compareTo(other) => index - other.index;
}

mixin TaskPointing implements Comparable<TaskPointing> {
  int get value;

  @override
  int compareTo(other) => value - other.value;
}

mixin Collecting<T> {
  List<T> get collection;

  bool isEmpty() => collection.isEmpty;
  bool isNotEmpty() => collection.isNotEmpty;

  void push(T what, {bool front = false}) {
    //debugPrint('${what.toString()} is pushed ${front ? 'front' : 'back'} to $this');
    if (front)
      collection.insert(0, what);
    else
      collection.add(what);
  }

  bool pop(T what) {
    //debugPrint('${what.toString()} is poped from $this');
    return collection.remove(what);
  }

  void insert(T what, int where) {
    //debugPrint('${what.toString()} is inserted at $where');
    collection.insert(where, what);
    //debugPrint('$status: ${collection.map((task) => task.title).toString()}');
  }

  void move(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    var temp = collection[oldIndex];
    collection[oldIndex] = collection[newIndex];
    collection[newIndex] = temp;
  }
}
