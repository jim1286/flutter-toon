import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toonflix/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = 'today';

  static Future<List<WebToonModel>> getTodaysToons() async {
    List<WebToonModel> webtoonInstances = [];
    final url = Uri.parse(('$baseUrl/$today'));
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);

      for (var webtoon in webtoons) {
        webtoonInstances.add(WebToonModel.fromJson(webtoon));
      }

      return webtoonInstances;
    }

    throw Error();
  }

  static Future<WebToonDetailModel> getToonById(String id) async {
    final url = Uri.parse(('$baseUrl/$id'));
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebToonDetailModel.fromJson(webtoon);
    }

    throw Error();
  }

  static Future<List<WebToonEpisodeModel>> getEpisodesById(String id) async {
    final url = Uri.parse(('$baseUrl/$id/episodes'));
    final response = await http.get(url);
    final List<WebToonEpisodeModel> episodeInstances = [];

    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);

      for (var episode in episodes) {
        episodeInstances.add(WebToonEpisodeModel.fromJson(episode));
      }
      return episodeInstances;
    }

    throw Error();
  }
}
