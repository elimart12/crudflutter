class Contact {
  int? id;
  String name;
  String phone;

  Contact({this.id, required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'phone': phone,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
    );
  }
}
