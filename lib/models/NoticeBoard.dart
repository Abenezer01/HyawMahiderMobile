class NoticeBoard {
  String id;
  String title;
  String author;
  String content;
  String createdAt;
  NoticeBoard(
      {required this.id,
      required this.title,
      required this.author,
      required this.content,
      required this.createdAt});

  factory NoticeBoard.fromMap(Map<String, dynamic> map) {
    return NoticeBoard(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        content: map['content'] ?? '',
        author: map['author'] ?? '',
        createdAt: map['createdAt']);
  }
  @override
  String toString() {
    return 'NoticeBoard: { id: $id, title: $title, ... }';
  }
}
