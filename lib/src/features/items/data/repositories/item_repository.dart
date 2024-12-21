import 'dart:async';

import 'package:assignment_task/src/models/item.dart';
import 'package:flutter/material.dart';
import 'local_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemRepository {
  final FirebaseFirestore _firestore;
  final LocalDatabase _localDb;

  ItemRepository(this._firestore, this._localDb);

  final _itemsController = StreamController<List<Item>>.broadcast();
  final List<Item> _items = [];

  Stream<List<Item>> watchAllItems() {
    _itemsController.add(_items);
    return _itemsController.stream;
  }

  /// Watch items from the local database and Firestore
  Stream<List<Item>> watchItems() async* {
    try {
      // Fetch local items
      final localItems = await _localDb.getAllItems();
      yield localItems
          .map((e) => Item(
              id: e.id.toString(), title: e.title, description: e.description))
          .toList();

      // Listen to Firestore updates
      _firestore.collection('items').snapshots().listen((snapshot) async {
        for (var doc in snapshot.docs) {
          final item = Item.fromMap(doc.data(), doc.id);
          await _localDb.insertItem(ItemEntity(
              id: int.parse(item.id),
              title: item.title,
              description: item.description));
        }
      });
    } catch (e) {
      yield [];
    }
  }

  /// Add a new item to Firestore and the local database
  Future<void> addItem(String id, String title, String description) async {
    try {
      final newItem = Item(id: id, title: title, description: description);
      final docRef = await _firestore.collection('items').add(newItem.toMap());
      final itemId = await _localDb.insertItem(ItemEntity(
        id: int.parse(id),
        title: newItem.title,
        description: newItem.description,
      ));
      debugPrint('Added item with ID: $itemId');
    } catch (e) {
      debugPrint('Error adding item: $e');
      throw Exception('Failed to add item: $e');
    }
  }

  /// Update an existing item in Firestore and the local database
  Future<void> updateItem(String id, String title, String description) async {
    try {
      final updatedItem = Item(id: id, title: title, description: description);
      final querySnapshot =
          await _firestore.collection('items').where("id", isEqualTo: id).get();
      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await _firestore
            .collection('items')
            .doc(docId)
            .update(updatedItem.toMap());
        debugPrint("Document updated successfully!");
      }
      await _localDb.updateItem(ItemEntity(
        id: int.parse(id),
        title: updatedItem.title,
        description: updatedItem.description,
      ));
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  /// Fetch an item by its ID from Firestore or fallback to the local database
  Future<Item> getItemById(String id) async {
    try {
      // Attempt to fetch the item from Firestore
      final doc = await _firestore.collection('items').doc(id).get();
      if (doc.exists) {
        return Item.fromMap(doc.data()!, doc.id);
      }
      // Fallback to local database
      final localItem = await _localDb.getItemById(int.parse(id));
      if (localItem != null) {
        return Item(
          id: localItem.id.toString(),
          title: localItem.title,
          description: localItem.description,
        );
      }

      throw Exception('Item not found');
    } catch (e) {
      throw Exception('Error fetching item: $e');
    }
  }

  /// Delete an item from Firestore and the local database
  Future<void> deleteItem(String id) async {
    try {
      final querySnapshot =
          await _firestore.collection('items').where("id", isEqualTo: id).get();
      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await _firestore.collection('items').doc(docId).delete();
        debugPrint("Document deleted successfully!");
      }
      await _localDb.deleteItem(int.parse(id));
      _items.removeWhere((item) => item.id == id);
      _itemsController.add(_items); // Notify listeners
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }
}
