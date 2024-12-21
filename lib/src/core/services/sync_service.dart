import 'package:assignment_task/src/features/items/data/repositories/item_repository.dart';
import 'package:assignment_task/src/features/items/data/repositories/local_db.dart';
import 'package:assignment_task/src/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  final localDb = ref.read(localDBProvider);
  return ItemRepository(firestore, localDb);
});

final localDBProvider = Provider((ref) {
  return LocalDatabase();
});

final syncServiceProvider = Provider((ref) =>
    SyncService(ref.read(itemRepositoryProvider), ref.read(localDBProvider)));

class SyncService {
  final ItemRepository _itemRepo;
  final LocalDatabase _localDB;

  SyncService(this._itemRepo, this._localDB);

  Future<void> syncData() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      try {
        final remoteItems = await _itemRepo.watchItems().first;
        for (var item in remoteItems) {
          await _localDB.insertItem(ItemEntity(
            id: int.parse(item.id),
            title: item.title,
            description: item.description,
          ));
        }
      } catch (e) {
        debugPrint('Error syncing data: $e');
      }
    }
  }

  Future<List<Item>> getItems() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      final localItems = await _localDB.getAllItems();
      return localItems
          .map((e) => Item(
              id: e.id.toString(), title: e.title, description: e.description))
          .toList();
    } else {
      final remoteItems = await _itemRepo.watchItems().first;
      for (var item in remoteItems) {
        await _localDB.insertItem(ItemEntity(
          id: int.parse(item.id),
          title: item.title,
          description: item.description,
        ));
      }
      return remoteItems;
    }
  }
}
