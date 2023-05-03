class ImageModal {
  String largeImageURL;
  String tags;

  ImageModal({required this.largeImageURL, required this.tags});

  factory ImageModal.fromMap({required Map Data}) {
    return ImageModal(largeImageURL: Data["largeImageURL"], tags: Data["tags"]);
  }
}