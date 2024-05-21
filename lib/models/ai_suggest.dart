import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:social_movie_app/constants/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Result>> getAISuggestedMovies() async {
  Map<String, int> categories = {};

  // Fetch categories from Firestore
  String userId =
      FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID
  DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (documentSnapshot.exists) {
    categories = Map<String, int>.from(documentSnapshot.data()!['categories']);
  } else {
    print("Belge mevcut değil.");
    return [];
  }

  // Fetch movie suggestions from AI model
  final aiApiKey = API_keys.gemini_API;
  if (aiApiKey == null) {
    print('AI API key bulunamadı');
    return [];
  }

  List<String> aiSuggestions = [];
  final model = GenerativeModel(model: 'gemini-pro', apiKey: aiApiKey);

  for (var entry in categories.entries) {
    for (int i = 0; i < entry.value; i++) {
      final content = [
        Content.text(
            'Son 10 yılda kesinlikle izlenmesi gereken ${entry.key} kategorisinde rastgele 1 tane film öner. Çıktıyı şu şekilde ver: Film adı')
      ];
      final response = await model.generateContent(content);
      aiSuggestions.add(response.text!);

      // Delay to avoid hitting the rate limit
      await Future.delayed(Duration(seconds: 1));
    }
  }

  // Fetch movie details from TMDB API
  final tmdbApiKey = API_keys.tmdb_API;
  if (tmdbApiKey == null) {
    print('TMDB API key bulunamadı');
    return [];
  }

  List<Result> fetchedMovies = [];

  for (var suggestion in aiSuggestions) {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$tmdbApiKey&query=${Uri.encodeComponent(suggestion)}'));

    if (response.statusCode == 200) {
      final movieone = getFirstResult(response.body);
      fetchedMovies.add(movieone);
    } else {
      print('Film bulunamadı: $suggestion');
    }

    // Delay to avoid hitting the rate limit
    await Future.delayed(Duration(seconds: 1));
  }

  return fetchedMovies;
}

// JSON verisinden Movieone nesnesini oluşturur
Movieone movieoneFromJson(String str) => Movieone.fromJson(json.decode(str));

// Movieone nesnesini JSON formatına çevirir
String movieoneToJson(Movieone data) => json.encode(data.toJson());

class Movieone {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  Movieone({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory Movieone.fromJson(Map<String, dynamic> json) => Movieone(
        page: json["page"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class Result {
  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  DateTime releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  Result({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json["release_date"]);
    } catch (e) {
      // Handle invalid or null date
      parsedDate = DateTime(2000, 1, 1); // Default date
    }

    return Result(
      adult: json["adult"] ?? false,
      backdropPath: json["backdrop_path"] as String?,
      genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
      id: json["id"] ?? 0,
      originalLanguage: json["original_language"] ?? '',
      originalTitle: json["original_title"] ?? '',
      overview: json["overview"] ?? '',
      popularity: (json["popularity"] ?? 0).toDouble(),
      posterPath: json["poster_path"] as String?,
      releaseDate: parsedDate,
      title: json["title"] ?? '',
      video: json["video"] ?? false,
      voteAverage: (json["vote_average"] ?? 0).toDouble(),
      voteCount: json["vote_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}


// JSON verisini çöz ve ilk sonucu al
Result getFirstResult(String jsonString) {
  final movieone = movieoneFromJson(jsonString);
  return movieone.results.first;
}

// İlk sonucu JSON formatına çevir
String firstResultToJson(String jsonString) {
  final firstResult = getFirstResult(jsonString);
  return json.encode(firstResult.toJson());
}
