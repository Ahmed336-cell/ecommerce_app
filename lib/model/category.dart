class Category {
  int id;
  String title; // Assuming the API uses 'title' instead of 'name'
  bool isSelected;

  Category({
    required this.id,
    required this.title,
    this.isSelected = false,
  });
}