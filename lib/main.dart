import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news/loading_news.dart';
import 'package:news/news_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List news = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future getNews() async {
    try {
      setState(() {
        isLoading = true;
      });
      Dio dio = Dio();
      var response;
      response = await dio.get("http://192.46.209.97:8001/api/v1/news/");
      if (response.statusCode == 200) {
        setState(() {
          news = response.data["results"];
          isLoading = false;
        });
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 0);
    PageController _searchPageController = PageController();
    return Scaffold(
      backgroundColor: Colors.black,
      body:isLoading?LoadingShorts(): PageView(
        controller: _searchPageController,
        children: [
          Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                onPageChanged: (page) {},
                controller: _pageController,
                itemCount: news.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (_, index) {
                  return NewsCard(news: news[index]);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
