

import 'dart:typed_data';

int getByteLength(int value) {
  // Count the number of bytes needed to represent the value
  var bytes = 0;
  while (value > 0) {
    value >>= 8; // Right shift by 8 bits
    bytes++;
  }
  return bytes;
}

Uint8List intToBytesLE(int value) {
  final byteLength = getByteLength(value);
  final bytes = Uint8List(byteLength);
  for (var i = 0; i < byteLength; i++) {
    bytes[i] = value & 0xff; // Get the least significant byte
    value >>= 8; // Right shift by 8 bits
  }
  return bytes;
}


Uint8List stringToBytesLE(String value) {
  final byteLength = getByteLength(value.length);
  final bytes = Uint8List(byteLength);

  return bytes;
}