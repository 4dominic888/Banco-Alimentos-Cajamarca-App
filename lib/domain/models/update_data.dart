class UpdateData {
  final String title;
  final String version;
  final String description;
  final AssetData asset;

  UpdateData({required this.title, required this.version, required this.description, required this.asset});

  factory UpdateData.fromJson(Map<String, dynamic> json){
    return UpdateData(
      title: json['title'],
      version: json['version'],
      description: json['desc'],
      asset: AssetData.fromJson(json['links'])
    );
  }
}

class AssetData {
  final String size;
  final String url;

  AssetData({required this.size, required this.url});

  factory AssetData.fromJson(Map<String , dynamic> json){
    return AssetData(
      size: json['size'],
      url: json['browser_download_url']
    );
  }
}