class NoticeBoard {
  String id;
  String title;
  String author;
  String content;

  NoticeBoard({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
  });

  factory NoticeBoard.fromMap(Map<String, dynamic> map) {
    return NoticeBoard(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      author: map['author'] ?? '',
    );
  }
  @override
  String toString() {
    return 'NoticeBoard: { id: $id, title: $title, ... }';
  }
}
