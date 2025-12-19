/// Model for storing scan history items
class ScanHistoryItem {
  final String id;
  final String className;
  final double confidence;
  final DateTime scanDate;
  final String? imagePath;
  final String category;
  final List<Map<String, dynamic>>? allPredictions;

  ScanHistoryItem({
    required this.id,
    required this.className,
    required this.confidence,
    required this.scanDate,
    this.imagePath,
    required this.category,
    this.allPredictions,
  });

  /// Create from map (for JSON/Firebase deserialization)
  factory ScanHistoryItem.fromMap(Map<String, dynamic> map, String id) {
    List<Map<String, dynamic>>? predictions;
    if (map['allPredictions'] != null) {
      predictions = (map['allPredictions'] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return ScanHistoryItem(
      id: id,
      className: map['className'] ?? '',
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      scanDate: map['scanDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['scanDate'])
          : DateTime.now(),
      imagePath: map['imagePath'],
      category: map['category'] ?? 'Unknown',
      allPredictions: predictions,
    );
  }

  /// Convert to map (for JSON/Firebase serialization)
  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'confidence': confidence,
      'scanDate': scanDate.millisecondsSinceEpoch,
      'imagePath': imagePath,
      'category': category,
      'allPredictions': allPredictions,
    };
  }

  /// Convert to JSON map (includes id for local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'className': className,
      'confidence': confidence,
      'scanDate': scanDate.millisecondsSinceEpoch,
      'imagePath': imagePath,
      'category': category,
      'allPredictions': allPredictions,
    };
  }

  /// Create from JSON map (for local storage)
  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>>? predictions;
    if (json['allPredictions'] != null) {
      predictions = (json['allPredictions'] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return ScanHistoryItem(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      className: json['className'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      scanDate: json['scanDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['scanDate'])
          : DateTime.now(),
      imagePath: json['imagePath'],
      category: json['category'] ?? 'Unknown',
      allPredictions: predictions,
    );
  }

  /// Get predictions sorted by confidence (descending)
  List<Map<String, dynamic>> get sortedPredictions {
    if (allPredictions == null) return [];
    final sorted = List<Map<String, dynamic>>.from(allPredictions!);
    sorted.sort((a, b) =>
        (b['confidence'] as double).compareTo(a['confidence'] as double));
    return sorted;
  }

  /// Get formatted date string
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(scanDate);

    if (difference.inDays == 0) {
      return 'Today, ${_formatTime(scanDate)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${_formatTime(scanDate)}';
    } else {
      return '${_formatDateShort(scanDate)}, ${_formatTime(scanDate)}';
    }
  }

  String _formatTime(DateTime date) {
    final hour =
        date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String _formatDateShort(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  /// Get confidence percentage string
  String get confidencePercent => '${(confidence * 100).toStringAsFixed(0)}%';
}
