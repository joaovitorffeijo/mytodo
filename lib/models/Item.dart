class Item {
  String title = "";
  bool? done;
  // A interrogação é utilizada para dizer que aquela variável pode ou não
  // ser instanciada.

  Item({required this.title, this.done});

  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }
}
