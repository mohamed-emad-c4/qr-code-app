class QRCode {
  final String content;
  final DateTime timestamp;
  final bool isScanned;

  QRCode({
    required this.content,
    required this.timestamp,
    this.isScanned = true,
  });
}