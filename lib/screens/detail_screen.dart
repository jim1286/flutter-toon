import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen(
      {super.key, required this.title, required this.thumb, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebToonDetailModel> webtoon;
  late Future<List<WebToonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');

    if (likedToons == null) {
      await prefs.setStringList('likedToons', []);
      return;
    }

    if (likedToons.contains(widget.id)) {
      setState(() {
        isLiked = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getEpisodesById(widget.id);
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          title: Text(
            widget.title,
            style: const TextStyle(
                color: Colors.green, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final likedToons = prefs.getStringList('likedToons');
                  setState(() {
                    isLiked = !isLiked;
                  });
                  print(likedToons);
                  if (isLiked) {
                    likedToons!.remove(widget.id);
                    await prefs.setStringList('likedToons', likedToons);
                    return;
                  }

                  likedToons!.add(widget.id);
                  await prefs.setStringList('likedToons', likedToons);
                },
                icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border_outlined))
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(50),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Hero(
              tag: widget.id,
              child: Container(
                  width: 250,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 15,
                            offset: const Offset(10, 10),
                            color: Colors.black.withOpacity(0.5))
                      ]),
                  child: Image.network(
                    widget.thumb,
                    headers: const {
                      'Referer': 'https://comic.naver.com',
                    },
                  )),
            ),
            FutureBuilder(
              future: webtoon,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.about);
                }

                return const Text('...');
              },
            ),
            FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: [
                      for (var episode in snapshot.data!) Text(episode.title)
                    ]);
                  }

                  return Container();
                }),
          ]),
        ));
  }
}
