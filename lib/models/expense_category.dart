class ExpenseCategory {
  final String id;
  final String name;
  final bool isDefault;

  ExpenseCategory({
    required this.id,
    required this.name,
    required this.isDefault
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'],
      name: json['name'],
      isDefault: json['isDefault']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isDefault': isDefault
    };
  }
}