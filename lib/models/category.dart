class Category {
  int id;
  String image;
  String name;
  String timeAdded;

  Category({this.id, this.image, this.name, this.timeAdded});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    timeAdded = json['time_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['time_added'] = this.timeAdded;
    return data;
  }
}