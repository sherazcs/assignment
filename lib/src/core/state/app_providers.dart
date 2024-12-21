import 'package:assignment_task/src/core/services/sync_service.dart';
import 'package:assignment_task/src/features/items/data/repositories/item_repository.dart';
import 'package:assignment_task/src/features/items/data/repositories/local_db.dart';
import 'package:assignment_task/src/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing the email input field.
final emailProvider = StateProvider<String>((ref) => '');

/// Provider for managing the password input field.
final passwordProvider = StateProvider<String>((ref) => '');
final confirmPasswordProvider = StateProvider<String>((ref) => '');

// Local database provider
final localDBProvider = Provider<LocalDatabase>((ref) => LocalDatabase());

// Item repository provider
final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  final firestore = FirebaseFirestore.instance;
  final localDb = ref.read(localDBProvider);
  return ItemRepository(firestore, localDb);
});

// Items StreamProvider
final itemsProvider = StreamProvider<List<Item>>((ref) {
  final itemRepo = ref.watch(itemRepositoryProvider);
  return itemRepo.watchItems();
});

// Sync service provider (optional)
final syncServiceProvider = Provider((ref) {
  final itemRepo = ref.read(itemRepositoryProvider);
  final localDb = ref.read(localDBProvider);
  return SyncService(itemRepo, localDb);
});

// Define itemProvider to fetch a single item by its ID
final itemProvider = FutureProvider.family<Item, String>((ref, itemId) async {
  final itemRepository = ref.watch(itemRepositoryProvider);
  // Assuming a method exists to fetch a single item by ID
  return await itemRepository.getItemById(itemId);
});
