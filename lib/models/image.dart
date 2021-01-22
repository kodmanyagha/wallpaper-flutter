class Image {
  int id;
  int category_id;
  int photographer_id;
  int remote_id;
  int width;
  int height;
  String avg_color;

  String url;
  String original_url;
  String tiny_url;
  String file_name;

  String created_at;
  String updated_at;

  Image({
    this.id,
    this.category_id,
    this.photographer_id,
    this.remote_id,
    this.width,
    this.height,
    this.avg_color,
    this.url,
    this.original_url,
    this.tiny_url,
    this.file_name,
    this.created_at,
    this.updated_at,
  });

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category_id = json['category_id'];
    photographer_id = json['photographer_id'];
    remote_id = json['remote_id'];
    width = json['width'];
    height = json['height'];
    avg_color = json['avg_color'];
    url = json['url'];
    original_url = json['original_url'];
    tiny_url = json['tiny_url'];
    file_name = json['file_name'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
  }
}
