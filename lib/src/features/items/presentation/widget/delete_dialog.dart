import 'package:assignment_task/src/core/state/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assignment_task/src/core/services/sync_service.dart'
    as sync_service;

void confirmDelete(BuildContext context, WidgetRef ref, String itemId) {
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
            if (!context.mounted) return;
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
