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
