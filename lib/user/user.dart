class user{
  int? id;
  String? name;
  String? lastName;
  String? email;
  String? password;

  user({this.name,this.lastName,this.email,this.password});
  user.withId({this.id,this.name,this.lastName,this.email,this.password});

  
  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['lastName'] = lastName;
    map['password'] = password;
    map['email'] = email;
    if(id!=null){
      map["id"]=id;
    }
    return map;
  }
  user.fromObject(dynamic o){
    this.id=(o["id"]);
    this.name=o["name"];
    this.lastName=o["lastName"];
    this.password=o["password"];
    this.email=o["email"];
  }

}