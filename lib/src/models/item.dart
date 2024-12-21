class Item {
  final String id;
  final String title;
  final String description;

  Item({required this.id, required this.title, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map, String id) {
    return Item(
      id: id,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }
}
