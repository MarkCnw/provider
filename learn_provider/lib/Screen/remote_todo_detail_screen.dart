import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RemoteTodoDetailScreen extends StatelessWidget {
  final String id; // document id
  const RemoteTodoDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final doc = FirebaseFirestore.instance.collection('todos').doc(id);

    return Scaffold(
      appBar: AppBar(title: const Text('Remote Todo Detail')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: doc.snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || !snap.data!.exists) {
            return const Center(child: Text('Document not found'));
          }
          final data = snap.data!.data()!;
          final title = (data['title'] ?? '') as String;
          final done  = (data['done']  ?? false) as bool;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  onChanged: (v) => doc.update({'title': v}),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: done,
                  title: const Text('Done'),
                  onChanged: (v) => doc.update({'done': v}),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () async {
                    await doc.delete();
                    if (context.mounted) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
