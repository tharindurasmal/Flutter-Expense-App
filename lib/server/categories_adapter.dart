import 'package:hive/hive.dart';
import 'package:expence_app/models/expence.dart';

class CategoriesAdapter extends TypeAdapter<Category> {

  @override
  final int typeId = 2;

  @override
  Category read(BinaryReader reader) {
    final index = reader.readByte();

    if (index < 0 || index >= Category.values.length) {
      return Category.food; // fallback safe value
    }

    return Category.values[index];
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.writeByte(obj.index);
  }
}