import 'package:assignment_task/src/core/constants/app_strings.dart';
import 'package:assignment_task/src/core/state/app_providers.dart';
import 'package:assignment_task/src/core/widgets/common_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:assignment_task/src/core/services/sync_service.dart'
    as sync_service;

class DetailScreen extends ConsumerWidget {
  final String? itemId;
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
          SnackBar(content: Text('${AppStrings.errorLoadingItem} $e')),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(isEditMode ? AppStrings.editItem : AppStrings.addItem)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: AppStrings.title),
            ),
            TextField(
              controller: descriptionController,
              decoration:
                  const InputDecoration(labelText: AppStrings.description),
            ),
            const SizedBox(height: 20),
            CommonElevatedButton(
              text: isEditMode ? AppStrings.update : AppStrings.add,
              elevation: 0.0,
              borderRadius: 50,
              width: 200,
              height: 45,
              style: TextStyle(fontSize: 18, color: Colors.white),
              onPressed: () async {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();

                if (title.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(AppStrings.pleaseFillInAllFields)),
                  );
                  return;
                }
                try {
                  if (isEditMode) {
                    await ref
                        .read(sync_service.itemRepositoryProvider)
                        .updateItem(
                          itemId!,
                          title,
                          description,
                        );
                  } else {
                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                    await ref.read(sync_service.itemRepositoryProvider).addItem(
                          id,
                          title,
                          description,
                        );
                  }
                  if (!context.mounted) return;
                  // ignore: unused_result
                  ref.refresh(itemsProvider);
                  context.pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${AppStrings.error}: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
