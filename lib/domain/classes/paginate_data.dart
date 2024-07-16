class PaginateData<T>{
  final PaginateMetaData metadata;
  final List<T> data;

  PaginateData({
    required this.metadata,
    required this.data
  });

  factory PaginateData.fromJson(Map<String, dynamic> json){
    return PaginateData(
      metadata: PaginateMetaData.fromJson(json['metaData']),
      data: (json['data'] as List).cast<T>()
    );
  }
}

class PaginateMetaData{
  final int total;
  final int currentPage;
  final int totalPages;
  final int currentCount;

  PaginateMetaData({
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.currentCount
  });

  factory PaginateMetaData.fromJson(Map<String, dynamic> json) {
    return PaginateMetaData(
      total: json['totalDocuments'],
      currentPage: json['pageNumber'],
      totalPages: json['totalPages'],
      currentCount: json['currentCount']
    );
  }
}