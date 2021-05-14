import 'package:flutter/material.dart';
import 'package:network_request_flutter/models/NewsReponse.dart';
import 'package:network_request_flutter/services/new_services_api.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "News App",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Discover",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                "Find intresting article and news",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Article>>(
                  future: NewsApiServices().fetchNewsArticle(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<Article> newsArticle = snapshot.data;
                      return ListView.builder(
                        itemCount: newsArticle.length,
                        itemBuilder: (context, index) {
                          return NewsTile(article: newsArticle[index]);
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NewsTile extends StatelessWidget {
  final Article article;

  const NewsTile({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: ListTile(
        onTap: () async {
          await canLaunch(article.url)
              ? await launch(article.url)
              : throw 'Could not launch ${article.url}';
        },
        title: Text(
          article.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          article.description,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        leading: article.urlToImage != null
            ? Container(
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(article.urlToImage),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
