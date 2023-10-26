class Category {
  final String name;
  String userId;

  Category(this.name, this.userId);

  Map<String, dynamic> toJson() => {
        "category_name": name,
        "category_userId": userId,
      };
}
