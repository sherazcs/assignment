import 'package:assignment_task/src/features/items/data/repositories/item_repository.dart';
import 'package:assignment_task/src/features/items/data/repositories/local_db.dart';
import 'package:assignment_task/src/models/item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Mock classes
class MockFirestore extends Mock implements FirebaseFirestore {}

class MockLocalDatabase extends Mock implements LocalDatabase {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirestore mockFirestore;
  late MockLocalDatabase mockLocalDatabase;
  late ItemRepository repository;

  setUp(() {
    mockFirestore = MockFirestore();
    mockLocalDatabase = MockLocalDatabase();
    repository = ItemRepository(mockFirestore, mockLocalDatabase);
  });

  group('ItemRepository', () {
    test('addItem stores data in Firestore and local database', () async {
      final item = Item(id: '1', title: 'Test Item', description: 'Test Desc');

      // Mock Firestore's add() method
      when(mockFirestore.collection('items').add(item.toMap()))
          .thenAnswer((_) async => MockDocumentReference());

      // Mock local database's insertItem() method
      when(mockLocalDatabase.insertItem(ItemEntity(
              id: int.parse(item.id),
              title: item.title,
              description: item.description)))
          .thenAnswer((_) async => 1);

      // Call the repository method
      await repository.addItem(item.id, item.title, item.description);

      // Verify interactions
      verify(mockFirestore.collection('items').add(item.toMap())).called(1);
      verify(mockLocalDatabase.insertItem(ItemEntity(
              id: int.parse(item.id),
              title: item.title,
              description: item.description)))
          .called(1);
    });

    test('getItemById retrieves data from Firestore or local database',
        () async {
      final item = Item(id: '1', title: 'Test Item', description: 'Test Desc');

      // Mock Firestore's doc().get() method
      final mockSnapshot = MockDocumentSnapshot();
      when(mockSnapshot.data()).thenReturn(item.toMap());

      when(mockFirestore.collection('items').doc('1').get())
          .thenAnswer((_) async => mockSnapshot);

      // Mock local database's getItemById() method
      when(mockLocalDatabase.getItemById(1)).thenAnswer((_) async =>
          ItemEntity(id: 1, title: item.title, description: item.description));

      // Call the repository method
      final fetchedItem = await repository.getItemById('1');

      // Verify results
      expect(fetchedItem.title, item.title);
      expect(fetchedItem.description, item.description);
    });
  });
}
