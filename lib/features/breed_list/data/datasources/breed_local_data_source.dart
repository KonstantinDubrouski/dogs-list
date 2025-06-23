import 'package:hive_flutter/hive_flutter.dart';

import '../models/breed_model.dart';

class BreedLocalDataSource {
  static const _boxName = 'breedsBox';
  static Future<void> initHive() async {
    Hive.registerAdapter(_BreedHiveAdapter());
    await Hive.openBox(_boxName);
  }

  final Box box = Hive.box(_boxName);

  List<BreedModel> getCachedBreeds() {
    final List<dynamic> raw = box.get('breeds', defaultValue: []);
    return raw.map((e) => BreedModel.fromJson(e['name'], e['subBreeds'])).toList();
  }

  Future<void> cacheBreeds(List<BreedModel> breeds) async {
    final List<Map<String, dynamic>> data = breeds
        .map((e) => {'name': e.name, 'subBreeds': e.subBreeds})
        .toList();
    await box.put('breeds', data);
  }
}

// Simple TypeAdapter for BreedModel to store as Map
class _BreedHiveAdapter extends TypeAdapter<Map> {
  @override
  Map read(BinaryReader reader) => reader.readMap();

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, Map obj) => writer.writeMap(obj);
}
