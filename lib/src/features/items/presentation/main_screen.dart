import 'package:assignment_task/src/core/app_routes.dart';
import 'package:assignment_task/src/core/constants/app_strings.dart';
import 'package:assignment_task/src/core/state/app_providers.dart';
import 'package:assignment_task/src/features/items/presentation/widget/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:assignment_task/src/core/services/sync_service.dart'
    as sync_service;

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncService = ref.watch(sync_service.syncServiceProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(AppStrings.main),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              try {
                await syncService.syncData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data synced successfully!')),
                  );
                }
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sync error: $e')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final itemsFuture = ref.watch(itemsProvider);

          return itemsFuture.when(
            data: (itemsList) => itemsList.isEmpty
                ? const Center(child: Text(AppStrings.noItemsAvailable))
                : ListView.builder(
                    itemCount: itemsList.length,
                    itemBuilder: (context, index) {
                      final item = itemsList[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.description),
                        onTap: () =>
                            context.push('${AppRoutes.details}/${item.id}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            confirmDelete(context, ref, item.id);
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
                  Text('${AppStrings.anErrorOccurred}: $err'),
                  TextButton(
                    onPressed: () => ref.refresh(itemsProvider),
                    child: const Text(AppStrings.retry),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('${AppRoutes.details}/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
