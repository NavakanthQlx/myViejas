class UsersList {
  final List<User> users;
  UsersList({required this.users});
  factory UsersList.fromJson(List<dynamic> parsedJson) {
    List<User> users = [];
    users = parsedJson.map((i) => User.fromJson(i)).toList();
    return UsersList(users: users);
  }
}

class User {
  final String title;
  final String thumb;
  final String description;
  User({required this.title, required this.thumb, required this.description});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        thumb: json['thumb'],
        title: json['title'],
        description: json['description']);
  }
}
