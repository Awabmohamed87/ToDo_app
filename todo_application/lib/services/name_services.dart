import 'package:get_storage/get_storage.dart';

class NameServices {
  final GetStorage _box = GetStorage();
  final String _key = 'name';
  String get name => _loadName();

  String _loadName() => _box.read<String>(_key) ?? 'Mate';

  void setName(name) {
    _box.write(_key, name);
  }
}
