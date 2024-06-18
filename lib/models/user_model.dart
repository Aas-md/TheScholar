

class Users{

  final String name;
  final String username;
  final String uid;
  String? phone;
  String? imageURL;
  String? about;
  String? courseName;
  String? year;
  String? email;
  int likes;
  int posts;
  List<String> likedPosts;
  String? imagePath;

  Users({
     required this.likedPosts,
    required this.uid,
    required this.username,
    required this.name,
    this.phone,
    this.imageURL,
    this.about,
    this.courseName,
    this.year,
    this.email,
    required this.likes,
   required this.posts,
    this.imagePath
  });

  Map<String, dynamic> toMap() {
    return {
      'likedPosts' : likedPosts,
      'name': name,
      'username': username,
      'uid' : uid,
      'phone': phone,
      'imageURL': imageURL,
      'about': about,
      'courseName': courseName,
      'year': year,
      'email': email,
      'likes': likes,
      'posts': posts,
      'imagePath' : imagePath
    };
  }

   factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
      // likedPosts: data['likedPosts'],
        likedPosts: List<String>.from(data['likedPosts']),
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      username: data['username'],
      phone: data['phone'],
      imageURL: data['imageURL'],
      about: data['about'],
      courseName: data['courseName'],
      year: data['year'],
      likes: data['likes'],
      posts: data['posts'],
      imagePath: data['imagePath']
      // Initialize other fields
    );
  }

}