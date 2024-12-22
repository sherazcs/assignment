import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assignment_task/src/core/state/app_providers.dart';
import 'package:assignment_task/src/models/item.dart';

void main() {
  test('ItemsProvider fetches a list of items', () async {
    final mockItems = [
      Item(id: '1', title: 'Test 1', description: 'Desc 1'),
      Item(id: '2', title: 'Test 2', description: 'Desc 2'),
    ];

    final container = ProviderContainer(
      overrides: [
        itemsProvider.overrideWith((ref) => Stream.value(mockItems)),
      ],
    );

    // Wait for the stream to emit the value
    final items = await container.read(itemsProvider.future);

    // Assertions
    expect(items, isA<List<Item>>());
    expect(items.length, 2);
    expect(items[0].title, 'Test 1');
  });
}
