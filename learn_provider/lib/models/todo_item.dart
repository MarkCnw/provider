class TodoItem {
  final String id;
  final String title;
  final bool done;

  TodoItem({required this.id, required this.title, required this.done});

  factory TodoItem.fromMap(Map<String, dynamic> m, String id) =>
      TodoItem(id: id, title: m['title'] ?? '', done: m['done'] ?? false);

  Map<String, dynamic> toMap() => {'title': title, 'done': done};
}
