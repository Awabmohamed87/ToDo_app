import 'package:get_storage/get_storage.dart';

class ImageServices {
  final GetStorage _box = GetStorage();
  final String _key = 'profileImagePath';
  String get profileImagePath => _loadProfileImage();

  String _loadProfileImage() => _box.read<String>(_key) ?? '';

  void saveThemeToBox(path) {
    _box.write(_key, path);
  }
}
