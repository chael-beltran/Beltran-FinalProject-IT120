import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/history_service.dart';
import '../models/scan_history_item.dart';
import '../data/snack_data.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _isEditMode = false;
  final Set<String> _selectedIds = {};
  String? _selectedCategory; // null means "All"

  // Filter categories matching snack data
  static const List<Map<String, dynamic>> _filterCategories = [
    {'name': 'All', 'color': null},
    {'name': 'CHEESE', 'color': AppColors.tagCheese},
    {'name': 'CHEDDAR', 'color': AppColors.tagCheddar},
    {'name': 'BBQ', 'color': AppColors.tagBbq},
    {'name': 'SPICY', 'color': AppColors.tagSpicy},
    {'name': 'SEAFOOD', 'color': AppColors.tagSeafood},
    {'name': 'CLASSIC', 'color': AppColors.tagClassic},
    {'name': 'HAM & CHEESE', 'color': AppColors.tagHamCheese},
  ];

  @override
  Widget build(BuildContext context) {
    final allHistoryItems = HistoryService.getAll();

    // Filter items based on selected category
    final historyItems = _selectedCategory == null
        ? allHistoryItems
        : allHistoryItems
            .where((item) => item.category == _selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - matching Home page style
            _buildHeader(allHistoryItems.length),

            // Stats Cards
            _buildStatsCards(),

            const SizedBox(height: 12),

            // Filter Chips
            _buildFilterChips(),

            const SizedBox(height: 8),

            // Edit/Done Button Row
            if (historyItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Select All (only in edit mode)
                    if (_isEditMode)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            if (_selectedIds.length == historyItems.length) {
                              _selectedIds.clear();
                            } else {
                              _selectedIds.clear();
                              for (final item in historyItems) {
                                _selectedIds.add(item.id);
                              }
                            }
                          });
                        },
                        icon: Icon(
                          _selectedIds.length == historyItems.length
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          _selectedIds.length == historyItems.length
                              ? 'Deselect All'
                              : 'Select All',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),

                    // Edit/Done Button
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          if (_isEditMode && _selectedIds.isEmpty) {
                            _isEditMode = false;
                          } else if (_isEditMode) {
                            _isEditMode = false;
                            _selectedIds.clear();
                          } else {
                            _isEditMode = true;
                          }
                        });
                      },
                      icon: Icon(
                        _isEditMode ? Icons.close : Icons.edit_outlined,
                        size: 18,
                        color: _isEditMode
                            ? AppColors.textMedium
                            : AppColors.primary,
                      ),
                      label: Text(
                        _isEditMode ? 'Cancel' : 'Edit',
                        style: TextStyle(
                          color: _isEditMode
                              ? AppColors.textMedium
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // History List
            Expanded(
              child: historyItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                      itemCount: historyItems.length,
                      itemBuilder: (context, index) {
                        final item = historyItems[index];
                        final isSelected = _selectedIds.contains(item.id);
                        return _HistoryItemCard(
                          item: item,
                          isEditMode: _isEditMode,
                          isSelected: isSelected,
                          onTap: () {
                            if (_isEditMode) {
                              setState(() {
                                if (isSelected) {
                                  _selectedIds.remove(item.id);
                                } else {
                                  _selectedIds.add(item.id);
                                }
                              });
                            } else {
                              _showAnalyticsDetail(context, item);
                            }
                          },
                          onDelete: () {
                            HistoryService.delete(item.id);
                            setState(() {});
                          },
                        );
                      },
                    ),
            ),

            // Delete Selected Button (only in edit mode with selections)
            if (_isEditMode && _selectedIds.isNotEmpty)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Selected'),
                            content: Text(
                              'Are you sure you want to delete ${_selectedIds.length} selected item${_selectedIds.length > 1 ? 's' : ''}?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  for (final id in _selectedIds) {
                                    HistoryService.delete(id);
                                  }
                                  Navigator.pop(context);
                                  setState(() {
                                    _selectedIds.clear();
                                    _isEditMode = false;
                                  });
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: AppColors.error),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline, size: 20),
                      label: Text(
                          'Delete ${_selectedIds.length} Item${_selectedIds.length > 1 ? 's' : ''}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int itemCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title Row with Icon
          Row(
            children: [
              // History Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page Title
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          letterSpacing: -0.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'Scan ',
                            style: TextStyle(color: AppColors.textDark),
                          ),
                          TextSpan(
                            text: 'History',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Subtitle
                    Row(
                      children: [
                        Icon(
                          Icons.folder_open_rounded,
                          size: 13,
                          color: AppColors.textLight.withOpacity(0.7),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            itemCount > 0
                                ? 'View your saved classification results'
                                : 'No saved scans yet',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textLight,
                              letterSpacing: 0.1,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '📁',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Decorative Divider
          Container(
            height: 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.5),
                  AppColors.primary.withOpacity(0.15),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Total Scans Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    AppColors.primaryLight.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${HistoryService.totalScans}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Total Scans',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Avg. Accuracy Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.success.withOpacity(0.1),
                    AppColors.success.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.analytics_outlined,
                      color: AppColors.success,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          HistoryService.averageAccuracyPercent,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Avg. Accuracy',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filterCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _filterCategories[index];
          final categoryName = category['name'] as String;
          final categoryColor = category['color'] as Color?;
          final isSelected = _selectedCategory ==
              (categoryName == 'All' ? null : categoryName);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = categoryName == 'All' ? null : categoryName;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? (categoryColor ?? AppColors.primary)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? (categoryColor ?? AppColors.primary)
                      : AppColors.textLight.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (categoryColor ?? AppColors.primary)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (categoryColor != null && !isSelected) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: categoryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    categoryName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textMedium,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAnalyticsDetail(BuildContext context, ScanHistoryItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AnalyticsDetailSheet(item: item),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_rounded,
              size: 64,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No scan history yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textMedium,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start scanning snacks to see your history here',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItemCard extends StatelessWidget {
  final ScanHistoryItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isEditMode;
  final bool isSelected;

  const _HistoryItemCard({
    required this.item,
    required this.onTap,
    required this.onDelete,
    this.isEditMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final snackInfo = SnackData.getByName(item.className);
    final cardTint = snackInfo?.cardTint ?? AppColors.categoryCheese;
    final categoryColor = snackInfo?.categoryColor ?? AppColors.primary;
    final hasAnalytics = item.allPredictions != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Selection Checkbox (only in edit mode)
            if (isEditMode) ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textLight,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
            ],
            // Thumbnail - show scanned image if available
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: cardTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: item.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(item.imagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => _buildFallbackIcon(
                            snackInfo, categoryColor, cardTint),
                      ),
                    )
                  : _buildFallbackIcon(snackInfo, categoryColor, cardTint),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Class Name
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.className,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasAnalytics)
                        Icon(
                          Icons.analytics_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Date & Time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.formattedDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Confidence Bar
                  Row(
                    children: [
                      Text(
                        item.confidencePercent,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getConfidenceColor(item.confidence),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: item.confidence,
                            minHeight: 6,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getConfidenceColor(item.confidence),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon(
      SnackClass? snackInfo, Color categoryColor, Color cardTint) {
    if (snackInfo != null) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          snackInfo.imagePath,
          fit: BoxFit.contain,
          errorBuilder: (ctx, err, stack) => Icon(
            Icons.fastfood,
            color: categoryColor.withOpacity(0.5),
          ),
        ),
      );
    }
    return Icon(
      Icons.fastfood,
      color: categoryColor.withOpacity(0.5),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) return AppColors.success;
    if (confidence >= 0.8) return const Color(0xFF8BC34A);
    if (confidence >= 0.7) return AppColors.warning;
    if (confidence >= 0.5) return const Color(0xFFFF9800);
    return AppColors.error;
  }
}

class _AnalyticsDetailSheet extends StatelessWidget {
  final ScanHistoryItem item;

  const _AnalyticsDetailSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final snackInfo = SnackData.getByName(item.className);
    final categoryColor = snackInfo?.categoryColor ?? AppColors.primary;
    final predictions = item.sortedPredictions;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.analytics,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Classification Analytics',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [
                    // Image and Summary
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Scanned Image
                        if (item.imagePath != null)
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(item.imagePath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const SizedBox(width: 16),
                        // Summary Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.className,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  snackInfo?.category ?? item.category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: categoryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: AppColors.textLight,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.formattedDate,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${item.confidencePercent} Confidence',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _getConfidenceColor(item.confidence),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Classification Breakdown
                    if (predictions.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.bar_chart_rounded,
                            color: AppColors.primary,
                            size: 20,
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
                      const SizedBox(height: 4),
                      Text(
                        'Probability distribution across all ${predictions.length} classes',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Bar Chart
                      ...predictions.map((prediction) {
                        final label = prediction['label'] as String;
                        final conf = prediction['confidence'] as double;
                        final predSnack = SnackData.getByName(label);
                        final barColor =
                            predSnack?.categoryColor ?? AppColors.textLight;
                        final isTop = label == item.className;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _PredictionBarItem(
                            label: label,
                            confidence: conf,
                            color: barColor,
                            isHighlighted: isTop,
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      // Line Graph Section
                      Row(
                        children: [
                          Icon(
                            Icons.show_chart_rounded,
                            color: AppColors.primary,
                            size: 20,
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
                      const SizedBox(height: 4),
                      const Text(
                        'Visual representation of confidence scores',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Line Graph
                      SizedBox(
                        height: 180,
                        child: _HistoryLineGraph(
                          predictions: predictions,
                          topClassName: item.className,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Legend
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: predictions.take(5).map((prediction) {
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
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'No detailed analytics available for this scan',
                            style: TextStyle(
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return AppColors.success;
    if (confidence >= 0.5) return AppColors.warning;
    return AppColors.error;
  }
}

class _PredictionBarItem extends StatelessWidget {
  final String label;
  final double confidence;
  final Color color;
  final bool isHighlighted;

  const _PredictionBarItem({
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

class _HistoryLineGraph extends StatelessWidget {
  final List<Map<String, dynamic>> predictions;
  final String topClassName;

  const _HistoryLineGraph({
    required this.predictions,
    required this.topClassName,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 180),
      painter: _HistoryLineGraphPainter(
        predictions: predictions,
        topClassName: topClassName,
      ),
    );
  }
}

class _HistoryLineGraphPainter extends CustomPainter {
  final List<Map<String, dynamic>> predictions;
  final String topClassName;

  _HistoryLineGraphPainter({
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

    // Draw gradient fill
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

      canvas.drawCircle(
        point,
        isTop ? 8 : 5,
        Paint()..color = Colors.white,
      );

      canvas.drawCircle(
        point,
        isTop ? 6 : 4,
        Paint()..color = color,
      );
    }
  }

  void _drawXAxisLabels(
      Canvas canvas, Size size, EdgeInsets padding, double graphWidth) {
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
