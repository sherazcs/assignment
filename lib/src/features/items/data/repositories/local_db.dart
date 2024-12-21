import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'local_db.g.dart';

@DataClassName('ItemEntity')
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().named('description')();
}

@DriftDatabase(tables: [Items])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<ItemEntity>> getAllItems() => select(items).get();

  Future<int> insertItem(ItemEntity item) => into(items).insert(item);

  Future<int> deleteItem(int id) =>
      (delete(items)..where((tbl) => tbl.id.equals(id))).go();

  Future<bool> updateItem(ItemEntity item) => update(items).replace(item);

  Future<ItemEntity?> getItemById(int id) {
    return (select(items)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
