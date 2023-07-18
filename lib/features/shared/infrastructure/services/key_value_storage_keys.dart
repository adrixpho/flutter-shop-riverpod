enum KeyValueStorageKeys { token }

extension KeyValueStorageKeysRawValues on KeyValueStorageKeys {
  String get rawValue {
    switch (this) {
      case KeyValueStorageKeys.token:
        return 'token';
      default:
        throw UnimplementedError('KeyStorage not implemented ${toString()}');
    }
  }
}
