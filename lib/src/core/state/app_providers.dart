import 'package:assignment_task/src/core/services/sync_service.dart';
import 'package:assignment_task/src/features/items/data/repositories/item_repository.dart';
import 'package:assignment_task/src/features/items/data/repositories/local_db.dart';
import 'package:assignment_task/src/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');
final confirmPasswordProvider = StateProvider<String>((ref) => '');

final localDBProvider = Provider<LocalDatabase>((ref) => LocalDatabase());

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  final localDb = ref.read(localDBProvider);
  return ItemRepository(firestore, localDb);
});

final itemsProvider = StreamProvider<List<Item>>((ref) {
  final itemRepo = ref.watch(itemRepositoryProvider);
  return itemRepo.watchItems();
});

final syncServiceProvider = Provider((ref) {
  final itemRepo = ref.read(itemRepositoryProvider);
  final localDb = ref.read(localDBProvider);
  return SyncService(itemRepo, localDb);
});

final itemProvider = FutureProvider.family<Item, String>((ref, itemId) async {
  final itemRepository = ref.watch(itemRepositoryProvider);
  return await itemRepository.getItemById(itemId);
});
