class TodoModel {
  TodoModel({this.id, required this.title});
  final String? id;
  final String title;

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json["id"],
        title: json["title"],
      );
  Map<String, dynamic> toJson() => {
        "title": title,
      };
}
