class Kurum {
  String? code;
  String? title;
  String? link;
  String? tel;
  String? email;
  String? adres;

  Kurum({this.code, this.title, this.link, this.tel, this.email, this.adres});

  Kurum.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
    link = json['link'];
    tel = json['tel'];
    email = json['email'];
    adres = json['adres'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['title'] = title;
    data['link'] = link;
    data['tel'] = tel;
    data['email'] = email;
    data['adres'] = adres;
    return data;
  }
}