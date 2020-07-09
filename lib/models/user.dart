class User {
  int id;
  String email;
  String name;
  String phone;
  int role;
  String thumbnail;
  String timeAdded;

  User(
      {
        this.id,
        this.email,
        this.name,
        this.phone,
        this.role,
        this.thumbnail,
        this.timeAdded});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    role = json['role'];
    thumbnail = json['thumbnail'];
    timeAdded = json['time_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['role'] = this.role;
    data['thumbnail'] = this.thumbnail;
    data['time_added'] = this.timeAdded;
    return data;
  }
}
