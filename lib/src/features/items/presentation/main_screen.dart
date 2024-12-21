import 'package:assignment_task/src/core/services/sync_service.dart'
    as sync_service;
import 'package:assignment_task/src/core/state/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: items.when(
        data: (itemsList) => itemsList.isEmpty
            ? const Center(child: Text('No items available.'))
            : ListView.builder(
                itemCount: itemsList.length,
                itemBuilder: (context, index) {
                  final item = itemsList[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.description),
                    onTap: () =>
                        context.push('/details/${item.id}'), // Navigate to edit
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _confirmDelete(context, ref, item.id);
                      },
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('An error occurred: $err'),
              TextButton(
                onPressed: () => ref.refresh(itemsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/details/new'), // Navigate to add form
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(sync_service.itemRepositoryProvider)
                  .deleteItem(itemId);
              ref.refresh(itemsProvider);
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
