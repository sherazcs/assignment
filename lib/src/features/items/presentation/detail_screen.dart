import 'package:assignment_task/src/core/state/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:assignment_task/src/core/services/sync_service.dart'
    as sync_service;

class DetailScreen extends ConsumerWidget {
  final String? itemId; // Null for adding a new item
  const DetailScreen({super.key, this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = itemId == "new" ? false : true;

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    if (isEditMode) {
      ref
          .read(sync_service.itemRepositoryProvider)
          .getItemById(itemId!)
          .then((item) {
        titleController.text = item.title;
        descriptionController.text = item.description;
      }).catchError((e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading item: $e')),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Item' : 'Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();

                if (title.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                try {
                  if (isEditMode) {
                    // Update existing item
                    await ref
                        .read(sync_service.itemRepositoryProvider)
                        .updateItem(
                          itemId!,
                          title,
                          description,
                        );
                  } else {
                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                    // Add new item
                    await ref.read(sync_service.itemRepositoryProvider).addItem(
                          id,
                          title,
                          description,
                        );
                  }
                  if (!context.mounted) return;
                  ref.refresh(itemsProvider);
                  context.pop(); // Navigate back to the main screen
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: Text(isEditMode ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}
