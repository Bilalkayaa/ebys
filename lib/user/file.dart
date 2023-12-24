class file {
  int? id;
  int? fromemployee;
  int? toemployee;
  String? path;
  String? date;
  int flag = 1;

  file({this.fromemployee, this.toemployee, this.path, this.date});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['fromemployee'] = fromemployee;
    map['toemployee'] = toemployee;
    map['path'] = path;
    map['id'] = id;
    map['date'] = date;
    map['flag'] = flag;
    return map;
  }

  file.fromMap(dynamic o) {
    this.id = o["id"];
    this.path = o["path"];
    this.fromemployee = o["fromemployee"];
    this.toemployee = o["toemployee"];
    this.date = o["date"];
    this.flag = o["flag"];
  }
}
