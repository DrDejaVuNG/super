part of 'rx.dart';

/// {@template rx_list}
/// A reactive list that extends the functionality of a regular Dart list
/// and notifies its listeners when the list is modified.
///
/// The `RxList` class provides a convenient way to create and manage a
/// list of elements that can be observed for changes. It extends the
/// `ListMixin` class to provide an implementation of the `List` interface
/// and adds reactive behavior by notifying listeners whenever the list is
/// modified.
///
/// Example usage:
///
/// ```dart
/// final numberList = RxList<int>();
///
/// // Adding a listener to the list
/// numberList.addListener(() {
///   print('List changed: $numberList');
/// });
///
/// // Modifying the list
/// numberList.add(1); // This will trigger the listener and print the updated list.
/// numberList.addAll([2, 3, 4]);
///
/// // Accessing the elements
/// print(numberList[0]); // Output: 1
///
/// // Removing an element
/// numberList.remove(3);
/// ```
///
/// **Note:** When using the `RxList` class, it is important to call the
/// `dispose()` method on the object when it is no longer needed to
/// prevent memory leaks.
/// This can be done using the onDisable method of your controller.
/// {@endtemplate}
final class RxList<T> extends Rx<List<T>> with ListMixin<T> {
  /// {@macro rx_list}
  RxList([List<T>? list]) {
    if (list != null) {
      _list = list;
    } else {
      _list = [];
    }
  }

  late List<T> _list;

  @override
  int get length {
    RxListener._read(this);
    return _list.length;
  }

  @override
  T get first {
    RxListener._read(this);
    return _list.first;
  }

  @override
  T get last {
    RxListener._read(this);
    return _list.last;
  }

  @override
  Iterable<T> get reversed {
    return _list.reversed;
  }

  @override
  bool get isEmpty {
    return _list.isEmpty;
  }

  @override
  bool get isNotEmpty {
    return _list.isNotEmpty;
  }

  // @override
  // Iterator<T> get iterator {
  //   return _list.iterator;
  // }

  @override
  T get single {
    RxListener._read(this);
    return _list.single;
  }

  @override
  Iterable<T> getRange(int start, int end) {
    return _list.getRange(start, end);
  }

  @override
  void replaceRange(int start, int end, Iterable<T> newContents) {
    _list.replaceRange(start, end, newContents);
    _notifyListeners();
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _list.setRange(start, end, iterable, skipCount);
    _notifyListeners();
  }

  @override
  void fillRange(int start, int end, [T? fill]) {
    _list.fillRange(start, end, fill);
    _notifyListeners();
  }

  @override
  void add(T element) {
    _list.add(element);
    _notifyListeners();
  }

  @override
  void addAll(Iterable<T> iterable) {
    _list.addAll(iterable);
    _notifyListeners();
  }

  @override
  bool remove(covariant T element) {
    final removed = _list.remove(element);
    if (removed) {
      _notifyListeners();
    }
    return removed;
  }

  @override
  T removeAt(int index) {
    final removed = _list.removeAt(index);
    _notifyListeners();
    return removed;
  }

  @override
  T removeLast() {
    final removed = _list.removeLast();
    _notifyListeners();
    return removed;
  }

  @override
  void removeRange(int start, int end) {
    _list.removeRange(start, end);
    _notifyListeners();
  }

  @override
  void removeWhere(bool Function(T) test) {
    _list.removeWhere(test);
    _notifyListeners();
  }

  @override
  void insert(int index, T element) {
    _list.insert(index, element);
    _notifyListeners();
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _list.insertAll(index, iterable);
    _notifyListeners();
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    _list.setAll(index, iterable);
    _notifyListeners();
  }

  @override
  void shuffle([Random? random]) {
    _list.shuffle(random);
    _notifyListeners();
  }

  @override
  void sort([int Function(T, T)? compare]) {
    _list.sort(compare);
    _notifyListeners();
  }

  @override
  List<T> sublist(int start, [int? end]) {
    return _list.sublist(start, end);
  }

  @override
  T singleWhere(bool Function(T) test, {T Function()? orElse}) {
    RxListener._read(this);
    return _list.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> skip(int count) {
    return _list.skip(count);
  }

  @override
  Iterable<T> skipWhile(bool Function(T) test) {
    return _list.skipWhile(test);
  }

  @override
  void forEach(void Function(T) action) {
    RxListener._read(this);
    _list.forEach(action);
  }

  @override
  void clear() {
    _list.clear();
    _notifyListeners();
  }

  /// Creates an `RxList` from an existing list.
  ///
  /// The `list` argument represents an existing list from which an
  /// `RxList` instance is created. The elements of the `list` are
  /// copied to the `RxList`, and any modifications made to the `RxList`
  /// will not affect the original `list`.
  ///
  /// Example:
  ///
  /// ```dart
  /// final existingList = [1, 2, 3];
  /// final rxList = RxList<int>.of(existingList);
  /// ```
  static RxList<T> of<T>(List<T> list) => RxList<T>(list);

  @override
  List<T> operator +(List<T> other) {
    final newList = _list + other;
    return newList;
  }

  @override
  T operator [](int index) {
    RxListener._read(this);
    return _list[index];
  }

  @override
  void operator []=(int index, T value) {
    _list[index] = value;
    _notifyListeners();
  }

  @override
  set length(int value) {
    _list.length = value;
    _notifyListeners();
  }
}
