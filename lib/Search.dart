class Search{
  String title;
  String year;
  String imdbID;
  String type;
  String poster;

  Search(this.title, this.year, this.imdbID, this.type, this.poster);

  factory Search.fromJson(dynamic json)
  {
    return Search(json['title'], json['yeah'],json['imdbl'],json['type'],json['poster'] as String);
  }
  @override
  String toString(){
    return '{ ${this.title}, ${this.year}, ${this.imdbID}, ${this.type}, ${this.poster}';
  }

}