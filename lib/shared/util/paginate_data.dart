
class PaginateData<T> {
  final Metadata metadata;
  final List<T> data;

  PaginateData({
    required this.metadata,
    required this.data
  });

  factory PaginateData.fromJson(Map<String, dynamic> json){
    return PaginateData(
      metadata: Metadata.fromJson(json['metaData']),
      data: (json['data'] as List).cast<T>()
    );
  }

}

class Metadata{
  final int total;
  final int currentPage;
  final int totalPages;
  final int currentCount;

  Metadata({
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.currentCount
  });

  factory Metadata.fromJson(Map<String, dynamic> json){
    return Metadata(
      total: json['totalDocuments'],
      currentPage: json['pageNumber'],
      totalPages: json['totalPages'],
      currentCount: json['currentCount']
    );
  }
}