import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/snack_data.dart';
import '../services/history_service.dart';
import '../services/firebase_service.dart';
import '../tflite_helper.dart';

class ResultPage extends StatefulWidget {
  final String imagePath;
  final List<Map<String, dynamic>> predictions;

  const ResultPage({
    super.key,
    required this.imagePath,
    required this.predictions,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late bool _isSaved;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Check if this result is already saved
    _isSaved = HistoryService.isAlreadySaved(widget.imagePath);
  }

  String get imagePath => widget.imagePath;
  List<Map<String, dynamic>> get predictions => widget.predictions;

  @override
  Widget build(BuildContext context) {
    // Get all 10 predictions sorted by confidence (descending)
    final sortedPredictions = List<Map<String, dynamic>>.from(predictions);
    sortedPredictions.sort((a, b) =>
        (b['confidence'] as double).compareTo(a['confidence'] as double));

    // Use multi-layered confidence validation from TFLiteHelper
    // The 'isIdentified' flag is set by the model based on:
    // - Minimum confidence threshold (75%)
    // - Confidence gap between top 2 predictions (10%)
    // - Entropy check (uncertainty measure)
    // - Absolute minimum confidence floor (30%)
    // Confidence Levels: Excellent (95-100%), High (90-94%), Good (80-89%), Low (76-79%)
    // Below 76% = Image Not Identified
    final bool isConfident = sortedPredictions.isNotEmpty &&
        (sortedPredictions[0]['isIdentified'] as bool? ?? false);

    final topPrediction =
        sortedPredictions.isNotEmpty ? sortedPredictions[0] : null;
    final className = isConfident
        ? (topPrediction?['label'] ?? 'Unknown')
        : 'Image Not Identified';
    final confidence = topPrediction?['confidence'] ?? 0.0;
    final snackInfo =
        isConfident ? SnackData.getByName(topPrediction?['label'] ?? '') : null;
    final category = snackInfo?.category ?? 'UNKNOWN';
    final categoryColor = snackInfo?.categoryColor ?? AppColors.primary;

    // Get confidence level and check if it's low
    final confidenceLevel = TFLiteHelper.getConfidenceLevel(confidence);
    final isLowConfidence = TFLiteHelper.isLowConfidence(confidence);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
        titleSpacing: 4,
        title: const Text(
          'Classification Result',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Combined Stacked Card - Image + Identification
            if (isConfident) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: categoryColor.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Section - Scanned Image
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Gradient overlay at bottom for smooth transition
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.9),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // SCANNED Badge
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'MATCHED',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Section - Identification Info
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Identified As label + Category
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Identified as',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textLight,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      className,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Category Tag
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      categoryColor,
                                      categoryColor.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: categoryColor.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Description
                          Text(
                            snackInfo?.description ??
                                'A delicious chip snack perfect for any occasion.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMedium,
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 12),

                          // Confidence Level Badge
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _getConfidenceLevelColor(confidenceLevel)
                                          .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _getConfidenceLevelColor(
                                            confidenceLevel)
                                        .withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getConfidenceLevelIcon(confidenceLevel),
                                      size: 14,
                                      color: _getConfidenceLevelColor(
                                          confidenceLevel),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$confidenceLevel Accuracy',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: _getConfidenceLevelColor(
                                            confidenceLevel),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${(confidence * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      _getConfidenceLevelColor(confidenceLevel),
                                ),
                              ),
                            ],
                          ),

                          // Low Confidence Warning
                          if (isLowConfidence) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.warning.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    size: 18,
                                    color: AppColors.warning,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Low confidence result may not be accurate',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.warning,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 16),

                          // View Full Details Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (snackInfo != null) {
                                  Navigator.pushNamed(
                                    context,
                                    '/class-details',
                                    arguments: snackInfo,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: categoryColor.withOpacity(0.1),
                                foregroundColor: categoryColor,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'View Full Details',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: categoryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 18,
                                    color: categoryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Error State - Stacked Card with Image + Error Info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.error.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Section - Scanned Image
                    Container(
                      height: 180,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // Image with error tint
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.grey.withOpacity(0.3),
                                BlendMode.saturation,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: 180,
                                child: Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // Error overlay
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                              color: AppColors.error.withOpacity(0.1),
                            ),
                          ),
                          // LOW CONFIDENCE Badge
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning_rounded,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'NO MATCH',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Section - Error Info
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 36,
                            color: AppColors.error.withOpacity(0.8),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Image Not Identified',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'The scanned image does not match any of the 10 supported snack classes.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMedium,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: const [
                                Text(
                                  'Supported Snacks:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Piattos • Nova • V-Cut • Chippy • Mr. Chips\nOishi Curls • Onion Rings • Fish Crackers\nCracklings • Clover Chips',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textMedium,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Scan Again Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.camera_alt_outlined, size: 20),
                      label: const Text('Scan Again'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textDark,
                        side: const BorderSide(color: AppColors.textLight),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Save Result Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (isConfident && !_isSaved && !_isSaving)
                          ? () {
                              setState(() => _isSaving = true);

                              // Try to save to local history (synchronous)
                              final bool wasAdded = HistoryService.addScan(
                                className: className,
                                confidence: confidence,
                                category: category,
                                imagePath: imagePath,
                                allPredictions: sortedPredictions,
                              );

                              if (!wasAdded) {
                                // Already saved
                                setState(() {
                                  _isSaved = true;
                                  _isSaving = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            color: Colors.white, size: 20),
                                        SizedBox(width: 12),
                                        Text('Result already saved'),
                                      ],
                                    ),
                                    backgroundColor: AppColors.warning,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }

                              // Local save successful - update UI immediately
                              setState(() {
                                _isSaved = true;
                                _isSaving = false;
                              });

                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.check_circle,
                                          color: Colors.white, size: 20),
                                      SizedBox(width: 12),
                                      Text('Result saved successfully!'),
                                    ],
                                  ),
                                  backgroundColor: AppColors.success,
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              // Sync to Firebase in background (don't wait)
                              FirebaseService.savePrediction(
                                classType: className,
                                accuracyRate: confidence,
                                category: category,
                              ).timeout(
                                const Duration(seconds: 5),
                                onTimeout: () {
                                  debugPrint('Firebase sync timed out');
                                },
                              ).catchError((e) {
                                debugPrint('Firebase sync error: $e');
                              });
                            }
                          : null,
                      icon: Icon(
                        _isSaved
                            ? Icons.check_circle
                            : (_isSaving
                                ? Icons.hourglass_empty
                                : Icons.save_outlined),
                        size: 20,
                      ),
                      label: Text(_isSaved
                          ? 'Saved'
                          : (_isSaving ? 'Saving...' : 'Save Result')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isSaved ? AppColors.success : AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: _isSaved ? 0 : 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Analytics sections - only shown for confident predictions
            if (isConfident) ...[
              // Accuracy Summary Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Accuracy Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Top Match',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              className,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _getConfidenceLabel(confidence),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getConfidenceColor(confidence),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(confidence * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: _getConfidenceColor(confidence),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: confidence,
                        minHeight: 12,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getConfidenceColor(confidence),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Classification Breakdown Card with Bar Chart
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.bar_chart_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Classification Breakdown',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Probability distribution across all ${sortedPredictions.length} classes',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Bar Chart
                    ...sortedPredictions.map((prediction) {
                      final label = prediction['label'] as String;
                      final conf = prediction['confidence'] as double;
                      final predictionSnack = SnackData.getByName(label);
                      final barColor =
                          predictionSnack?.categoryColor ?? AppColors.textLight;
                      final isTopPrediction = label == className;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PredictionBar(
                          label: label,
                          confidence: conf,
                          color: barColor,
                          isHighlighted: isTopPrediction,
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Line Graph Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.show_chart_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Probability Distribution',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Visual representation of confidence scores',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Line Graph
                    SizedBox(
                      height: 180,
                      child: _LineGraph(
                        predictions: sortedPredictions,
                        topClassName: className,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Legend
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: sortedPredictions.take(5).map((prediction) {
                        final label = prediction['label'] as String;
                        final predSnack = SnackData.getByName(label);
                        final color =
                            predSnack?.categoryColor ?? AppColors.textLight;
                        final shortName = label.split(' ').first;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              shortName,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textMedium,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],

            // Metadata Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _MetadataRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: _formatDate(DateTime.now()),
                  ),
                  const Divider(height: 24),
                  _MetadataRow(
                    icon: Icons.access_time_outlined,
                    label: 'Time',
                    value: _formatTime(DateTime.now()),
                  ),
                  const Divider(height: 24),
                  _MetadataRow(
                    icon: Icons.layers_outlined,
                    label: 'Total Classes',
                    value: '${sortedPredictions.length}',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.95) return AppColors.success; // Excellent
    if (confidence >= 0.90)
      return const Color(0xFF2E7D32); // High - darker green
    if (confidence >= 0.80) return AppColors.primary; // Good
    if (confidence >= 0.76) return AppColors.warning; // Low
    return AppColors.error; // Not Identified
  }

  String _getConfidenceLabel(double confidence) {
    if (confidence >= 0.95) return 'Excellent';
    if (confidence >= 0.90) return 'High';
    if (confidence >= 0.80) return 'Good';
    if (confidence >= 0.76) return 'Low';
    return 'Not Identified';
  }

  Color _getConfidenceLevelColor(String level) {
    switch (level) {
      case 'Excellent':
        return AppColors.success;
      case 'High':
        return const Color(0xFF2E7D32); // Darker green
      case 'Good':
        return AppColors.primary;
      case 'Low':
        return AppColors.warning;
      default:
        return AppColors.error;
    }
  }

  IconData _getConfidenceLevelIcon(String level) {
    switch (level) {
      case 'Excellent':
        return Icons.verified_rounded;
      case 'High':
        return Icons.thumb_up_rounded;
      case 'Good':
        return Icons.check_circle_rounded;
      case 'Low':
        return Icons.warning_amber_rounded;
      default:
        return Icons.error_outline_rounded;
    }
  }

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour =
        date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

class _PredictionBar extends StatelessWidget {
  final String label;
  final double confidence;
  final Color color;
  final bool isHighlighted;

  const _PredictionBar({
    required this.label,
    required this.confidence,
    required this.color,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (confidence * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (isHighlighted)
                    Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 10,
                        color: color,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isHighlighted ? FontWeight.bold : FontWeight.normal,
                        color: isHighlighted
                            ? AppColors.textDark
                            : AppColors.textMedium,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isHighlighted ? color : AppColors.textMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: confidence,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isHighlighted ? color : color.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _MetadataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetadataRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textLight),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textMedium,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _LineGraph extends StatelessWidget {
  final List<Map<String, dynamic>> predictions;
  final String topClassName;

  const _LineGraph({
    required this.predictions,
    required this.topClassName,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 180),
      painter: _LineGraphPainter(
        predictions: predictions,
        topClassName: topClassName,
      ),
    );
  }
}

class _LineGraphPainter extends CustomPainter {
  final List<Map<String, dynamic>> predictions;
  final String topClassName;

  _LineGraphPainter({
    required this.predictions,
    required this.topClassName,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (predictions.isEmpty) return;

    final padding =
        const EdgeInsets.only(left: 40, right: 16, top: 16, bottom: 30);
    final graphWidth = size.width - padding.left - padding.right;
    final graphHeight = size.height - padding.top - padding.bottom;

    // Draw background grid
    _drawGrid(canvas, size, padding, graphWidth, graphHeight);

    // Draw Y-axis labels
    _drawYAxisLabels(canvas, padding, graphHeight);

    // Draw line graph with gradient
    _drawLineGraph(canvas, padding, graphWidth, graphHeight);

    // Draw X-axis labels
    _drawXAxisLabels(canvas, size, padding, graphWidth);
  }

  void _drawGrid(Canvas canvas, Size size, EdgeInsets padding,
      double graphWidth, double graphHeight) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    // Horizontal grid lines (5 lines for 0%, 25%, 50%, 75%, 100%)
    for (int i = 0; i <= 4; i++) {
      final y = padding.top + (graphHeight * i / 4);
      canvas.drawLine(
        Offset(padding.left, y),
        Offset(size.width - padding.right, y),
        gridPaint,
      );
    }
  }

  void _drawYAxisLabels(Canvas canvas, EdgeInsets padding, double graphHeight) {
    final labels = ['100%', '75%', '50%', '25%', '0%'];
    for (int i = 0; i < labels.length; i++) {
      final y = padding.top + (graphHeight * i / 4);
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
            padding.left - textPainter.width - 8, y - textPainter.height / 2),
      );
    }
  }

  void _drawLineGraph(Canvas canvas, EdgeInsets padding, double graphWidth,
      double graphHeight) {
    if (predictions.isEmpty) return;

    final points = <Offset>[];
    final colors = <Color>[];

    for (int i = 0; i < predictions.length; i++) {
      final prediction = predictions[i];
      final confidence = prediction['confidence'] as double;
      final label = prediction['label'] as String;
      final snack = SnackData.getByName(label);
      final color = snack?.categoryColor ?? AppColors.primary;

      final x = padding.left +
          (graphWidth *
              i /
              (predictions.length - 1).clamp(1, predictions.length));
      final y = padding.top + graphHeight * (1 - confidence);

      points.add(Offset(x, y));
      colors.add(color);
    }

    // Draw gradient fill under the line
    if (points.length > 1) {
      final path = Path();
      path.moveTo(points.first.dx, padding.top + graphHeight);
      for (final point in points) {
        path.lineTo(point.dx, point.dy);
      }
      path.lineTo(points.last.dx, padding.top + graphHeight);
      path.close();

      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.3),
            AppColors.primary.withOpacity(0.05),
          ],
        ).createShader(
            Rect.fromLTWH(padding.left, padding.top, graphWidth, graphHeight));

      canvas.drawPath(path, gradientPaint);
    }

    // Draw connecting line
    if (points.length > 1) {
      final linePaint = Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // Draw data points
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final color = colors[i];
      final isTop = predictions[i]['label'] == topClassName;

      // Outer circle (white border)
      canvas.drawCircle(
        point,
        isTop ? 8 : 5,
        Paint()..color = Colors.white,
      );

      // Inner colored circle
      canvas.drawCircle(
        point,
        isTop ? 6 : 4,
        Paint()..color = color,
      );
    }
  }

  void _drawXAxisLabels(
      Canvas canvas, Size size, EdgeInsets padding, double graphWidth) {
    // Draw class number labels (1, 2, 3, ... 10)
    for (int i = 0; i < predictions.length; i++) {
      final x = padding.left +
          (graphWidth *
              i /
              (predictions.length - 1).clamp(1, predictions.length));
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: TextStyle(
            color: predictions[i]['label'] == topClassName
                ? AppColors.primary
                : AppColors.textLight,
            fontSize: 10,
            fontWeight: predictions[i]['label'] == topClassName
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - padding.bottom + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
