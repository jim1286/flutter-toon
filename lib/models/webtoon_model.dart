class WebToonModel {
  final String id, title, thumb;

  WebToonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}

class WebToonDetailModel {
  final String title, about, genre, age;

  WebToonDetailModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        about = json['about'],
        genre = json['genre'],
        age = json['age'];
}

class WebToonEpisodeModel {
  final String id, title, rating, date;

  WebToonEpisodeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        rating = json['rating'],
        date = json['date'];
}
