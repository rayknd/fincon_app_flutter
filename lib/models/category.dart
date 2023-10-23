class Category {
  final String name;

  Category(this.name);

  Map<String, dynamic> toJson() => {
        "category_name": name,
      };
}
