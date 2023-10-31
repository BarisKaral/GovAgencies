import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'kurum.dart';
import 'display_kurum_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ApiCallState createState() => ApiCallState();
}

class ApiCallState extends State<HomePage> {
  List<Kurum> kurumlar = [];
  List<Kurum> filteredKurumlar = [];
  List<Kurum> originalKurumlar = [];
  TextEditingController filterController = TextEditingController();
  bool isSearching = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "İnternet bağlantısı bulunmuyor",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2,
      );

      await Future.delayed(const Duration(seconds: 5));
      checkInternetConnection();
    } else {
      fetchAPI();
    }
  }

  Future<void> fetchAPI() async {
    Dio dio = Dio();
    dio.options.responseType = ResponseType.plain;

    try {
      var response = await dio.get(
          'https://gist.githubusercontent.com/berkanaslan/35511991222bfc0914cd4c2c031057e2/raw/');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.data);
        kurumlar = jsonData.map((json) => Kurum.fromJson(json)).toList();
        originalKurumlar = List.from(kurumlar);
        filteredKurumlar = List.from(kurumlar);
      } else {
        Fluttertoast.showToast(
          msg: "API'dan veri alınamadı. Lütfen daha sonra tekrar deneyin.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Bir hata oluştu. Lütfen daha sonra tekrar deneyin.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  List<Kurum> filterKurumlar(String filterText) {
    if (filterText.isEmpty) {
      return List.from(originalKurumlar);
    }

    return originalKurumlar.where((kurum) {
      return kurum.title!.toLowerCase().contains(filterText.toLowerCase());
    }).toList();
  }

  void startSearching() {
    setState(() {
      isSearching = true;
    });
  }

  void stopSearching() {
    setState(() {
      isSearching = false;
      filterController.clear();
      filteredKurumlar = List.from(originalKurumlar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: buildAppBar(),
      body: buildMainBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black54,
      title: isSearching
          ? TextField(
        controller: filterController,
        onChanged: (String text) {
          setState(() {
            filteredKurumlar = filterKurumlar(text);
          });
        },
        decoration: const InputDecoration(
          hintText: 'Kurum Başlığına Göre Filtrele',
          hintStyle: TextStyle(color: Colors.white),
        ),
      )
          : const Text('T.C. KAMU KURUMLARI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      actions: <Widget>[
        isSearching
            ? IconButton(
          icon: const Icon(Icons.cancel, color: Colors.white),
          onPressed: () {
            stopSearching();
          },
        )
            : IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            startSearching();
          },
        )
      ],
    );
  }

  Widget buildMainBody() {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : filteredKurumlar.isEmpty
        ? const Center(
      child: Text('Sonuç bulunamadı.', style: TextStyle(color: Colors.white)),
    )
        : buildKurumList();
  }

  Widget buildKurumList() {
    return ListView.builder(
      itemCount: filteredKurumlar.length,
      itemBuilder: (BuildContext context, int index) {
        return buildKurumCard(index);
      },
    );
  }

  Widget buildKurumCard(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (context, animation, secondaryAnimation) => buildScaleTransition(index,animation),
          ),
        );
      },
      child: Card(
        color: Colors.black54,
        elevation: 2,
        margin: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(
            '${filteredKurumlar[index].title}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            '${filteredKurumlar[index].adres}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildScaleTransition(int index, animation) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(animation),
      child: DisplayKurumDetails(kurum: filteredKurumlar[index]),
    );
  }
}

