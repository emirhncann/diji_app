import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:social_movie_app/constants/api.dart';
import 'package:social_movie_app/models/ai_suggest.dart';

@JsonSerializable()
class Result {
  String backdropPath;
  int id;
  String originalTitle;
  String overview;
  String posterPath;

  bool adult;
  String title;
  String originalLanguage;
  List<int> genreIds;
  double popularity;
  DateTime releaseDate;
  bool video;
  double voteAverage;
  int voteCount;

  Result({
    required this.backdropPath,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.adult,
    required this.title,
    required this.originalLanguage,
    required this.genreIds,
    required this.popularity,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        backdropPath: json["backdrop_path"],
        id: json["id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        adult: json["adult"],
        title: json["title"],
        originalLanguage: json["original_language"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        popularity: json["popularity"]?.toDouble(),
        releaseDate: DateTime.parse(json["release_date"]),
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "id": id,
        "original_title": originalTitle,
        "overview": overview,
        "poster_path": posterPath,
        "adult": adult,
        "title": title,
        "original_language": originalLanguage,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "popularity": popularity,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}

class api {
  static const _trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?language=tr-TR&api_key=0595b8db163ba85f7db71363cc2ceb56';
  static const _upcomingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?language=tr-TR&page=1&api_key=0595b8db163ba85f7db71363cc2ceb56';
  static const _TopRatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?language=tr-TR&page=1&api_key=0595b8db163ba85f7db71363cc2ceb56';

  Future<List<Result>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(_trendingUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)["results"] as List;
      print(decodedData);
      return decodedData.map((movie) => Result.fromJson(movie)).toList();
    } else {
      throw Exception("Hata");
    }
  }

  Future<List<Result>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(_upcomingUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)["results"] as List;
      print(decodedData);
      return decodedData.map((movie) => Result.fromJson(movie)).toList();
    } else {
      throw Exception("Hata");
    }
  }

  Future<List<Result>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(_TopRatedUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)["results"] as List;
      print(decodedData);
      return decodedData.map((movie) => Result.fromJson(movie)).toList();
    } else {
      throw Exception("Hata");
    }
  }

  Future<List<Result>> getAISuggestedMovies() async {
    final response = await http.get(Uri.parse(_TopRatedUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)["results"] as List;
      print(decodedData);
      return decodedData.map((movie) => Result.fromJson(movie)).toList();
    } else {
      throw Exception("Hata");
    }
  }
}
