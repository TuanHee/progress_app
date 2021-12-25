
class User {
  final int id;
  final String name;
  final String email;
  final String profileUrl;

  User({required this.id, required this.name, required this.email, required this.profileUrl});

  User.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      email = json['email'],
      profileUrl = json['profile_photo_url'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'email' : email,
    'profilePhoto' : profileUrl,
  };

}