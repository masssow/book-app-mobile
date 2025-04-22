class SectionModel {
  final String id;
  final String title;
  final String content;

  SectionModel({required this.id, required this.title, required this.content});

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
    id: json['id'],
    title: json['title'],
    content: json['content'],
  );
}
