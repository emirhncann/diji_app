import 'package:social_movie_app/models/movie.dart';

List<String> watchList = [];

void addToWatchList(String movieTitle) {
  watchList.add(movieTitle);
  print("Film daha sonra izlenecekler listesine eklendi: $movieTitle");
  print(watchList);
}
