import 'dart:math';

class IteratorProcessor<T> {
  late Iterator<T> _iterator;
  int counter = 0;

  IteratorProcessor(Iterable<T> iterable) {
    _iterator = iterable.iterator;
  }

  T get current => _iterator.current;

  bool moveNext() {
    counter++;
    return _iterator.moveNext();
  }

  T takeOut() {
    if (_iterator.current == null) {
      throw Exception("IteratorProcessor.takeOut(): error occur, current counter is: $counter");
    }
    T currentValue = current;
    moveNext();
    return currentValue;
  }

  List<T> takeOutList(int length) {
    List<T> list = [];
    for(int i=0; i<length; i++) {
      list.add(takeOut());
    }
    return list;
  }
}

int byteArrayToSignedInt(List<int> bytes) {
  int value = byteArrayToUnsignedInt(bytes);
  // If the most significant bit of the final byte is set, the value is negative.
  if ((bytes[0] & 0x80) != 0) {
    // Extend the sign bit to fill the entire integer value.
    value = -((pow(256, bytes.length)).toInt() - value);
  }
  return value;
}

int byteArrayToUnsignedInt(List<int> bytes) {
  int value = 0;
  for (int i = 0; i < bytes.length; i++) {
    value = (value << 8) | bytes[i];
  }
  return value;
}

List<int> hexStringToByteArray(String s) {
  int len = s.length;
  List<int> data = [];
  for (int i = 0; i < len; i += 2) {
    data.add(int.parse(s.substring(i, i + 2), radix: 16));
  }
  return data;
}
