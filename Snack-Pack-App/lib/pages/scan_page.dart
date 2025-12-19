import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../tflite_helper.dart';
import 'result_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _currentCameraIndex = 0;
  bool _isInitialized = false;
  bool _isFlashOn = false;
  String _status = 'Initializing...';
  final TFLiteHelper _tfliteHelper = TFLiteHelper();
  bool _isModelLoaded = false;
  bool _isProcessing = false;
  final ImagePicker _imagePicker = ImagePicker();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeApp();

    // Pulse animation for scanning indicator
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeApp() async {
    setState(() => _status = 'Loading model...');

    try {
      await _tfliteHelper.loadModel();
      setState(() {
        _isModelLoaded = true;
        _status = 'Model loaded. Initializing camera...';
      });
    } catch (e) {
      setState(() => _status = 'Error loading model: $e');
      return;
    }

    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        setState(() => _status = 'Camera permission denied');
        return;
      }

      _cameras = await availableCameras();
      if (_cameras!.isEmpty) {
        setState(() => _status = 'No cameras found');
        return;
      }

      await _setupCameraController(_currentCameraIndex);
    } catch (e) {
      setState(() => _status = 'Camera error: $e');
    }
  }

  Future<void> _setupCameraController(int cameraIndex) async {
    // Dispose previous controller if exists
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    setState(() {
      _isInitialized = false;
      _status = 'Switching camera...';
    });

    _cameraController = CameraController(
      _cameras![cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();

      // Reset flash when switching cameras
      _isFlashOn = false;

      if (mounted) {
        setState(() {
          _currentCameraIndex = cameraIndex;
          _isInitialized = true;
          _status = 'Ready to scan';
        });
      }
    } catch (e) {
      setState(() => _status = 'Camera error: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2 || _isProcessing) return;

    final newIndex = (_currentCameraIndex + 1) % _cameras!.length;
    await _setupCameraController(newIndex);
  }

  bool get _hasMultipleCameras => _cameras != null && _cameras!.length > 1;

  bool get _isFrontCamera {
    if (_cameras == null || _cameras!.isEmpty) return false;
    return _cameras![_currentCameraIndex].lensDirection ==
        CameraLensDirection.front;
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || _isFrontCamera) return;

    try {
      _isFlashOn = !_isFlashOn;
      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {});
    } catch (e) {
      debugPrint('Flash error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isProcessing || !_isModelLoaded) return;

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (pickedFile == null) return;

      setState(() {
        _isProcessing = true;
        _status = 'Processing image...';
      });

      final imageFile = File(pickedFile.path);
      final predictions = _tfliteHelper.predictImage(imageFile);

      if (mounted && predictions != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              imagePath: pickedFile.path,
              predictions: predictions,
            ),
          ),
        );
        setState(() {
          _isProcessing = false;
          _status = 'Ready to scan';
        });
      } else {
        setState(() {
          _isProcessing = false;
          _status = 'Error processing image';
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process image'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        !_isModelLoaded ||
        _isProcessing) {
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
        _status = 'Processing image...';
      });

      final XFile image = await _cameraController!.takePicture();
      final imageFile = File(image.path);

      final predictions = _tfliteHelper.predictImage(imageFile);

      if (mounted && predictions != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              imagePath: image.path,
              predictions: predictions,
            ),
          ),
        );
        setState(() {
          _isProcessing = false;
          _status = 'Ready to scan';
        });
      } else {
        setState(() {
          _isProcessing = false;
          _status = 'Error processing image';
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process image'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _status = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _tfliteHelper.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Snack Scanner',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            Text(
              'Point camera at chip package',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Camera Preview with Frame
          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Camera Preview
                    _isInitialized && _isModelLoaded
                        ? SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: CameraPreview(_cameraController!),
                          )
                        : Container(
                            color: const Color(0xFF2D3436),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _status,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                    // Dark overlay with scan frame cutout
                    if (_isInitialized)
                      CustomPaint(
                        size: Size.infinite,
                        painter: ScanFramePainter(),
                      ),

                    // Corner Markers
                    if (_isInitialized) _buildCornerMarkers(),

                    // Scanning Indicator Badge
                    if (_isInitialized)
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.55),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.accent
                                            .withOpacity(_pulseAnimation.value),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.accent
                                                .withOpacity(0.4),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Let's Identify the Chip!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Tips Card - Redesigned
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withOpacity(0.08),
                  AppColors.primary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Scanning Tips',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    _TipItem(
                        icon: Icons.center_focus_strong,
                        text: 'Center the package'),
                    SizedBox(width: 16),
                    _TipItem(
                        icon: Icons.wb_sunny_outlined, text: 'Good lighting'),
                    SizedBox(width: 16),
                    _TipItem(
                        icon: Icons.stay_current_portrait, text: 'Hold steady'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Camera Switch, Gallery, and Flash Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Camera Switch Button
                if (_hasMultipleCameras)
                  _ActionButton(
                    icon: _isFrontCamera
                        ? Icons.camera_rear_outlined
                        : Icons.camera_front_outlined,
                    label: _isFrontCamera ? 'Back' : 'Front',
                    color: AppColors.secondary,
                    onTap: _switchCamera,
                  ),
                if (_hasMultipleCameras) const SizedBox(width: 20),
                // Gallery Button
                _ActionButton(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  color: AppColors.accent,
                  onTap: _pickFromGallery,
                ),
                const SizedBox(width: 20),
                // Flash Button (disabled for front camera)
                _ActionButton(
                  icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
                  label: 'Flash',
                  color:
                      _isFrontCamera ? AppColors.textLight : AppColors.primary,
                  isActive: _isFlashOn,
                  onTap: _isFrontCamera ? () {} : _toggleFlash,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Capture Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (_isInitialized && _isModelLoaded && !_isProcessing)
                    ? _takePicture
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isProcessing ? Icons.hourglass_empty : Icons.camera_alt,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isProcessing ? 'Processing...' : 'Capture & Classify',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCornerMarkers() {
    const markerSize = 30.0;
    const markerThickness = 4.0;
    const markerColor = AppColors.accent;
    const margin = 50.0;

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final frameWidth = constraints.maxWidth - margin * 2;
          final frameHeight = constraints.maxHeight - margin * 2;
          final left = margin;
          final top = margin;
          final right = margin + frameWidth;
          final bottom = margin + frameHeight;

          return Stack(
            children: [
              // Top Left
              Positioned(
                left: left,
                top: top,
                child: _CornerMarker(
                  size: markerSize,
                  thickness: markerThickness,
                  color: markerColor,
                  corner: Corner.topLeft,
                ),
              ),
              // Top Right
              Positioned(
                right: constraints.maxWidth - right,
                top: top,
                child: _CornerMarker(
                  size: markerSize,
                  thickness: markerThickness,
                  color: markerColor,
                  corner: Corner.topRight,
                ),
              ),
              // Bottom Left
              Positioned(
                left: left,
                bottom: constraints.maxHeight - bottom,
                child: _CornerMarker(
                  size: markerSize,
                  thickness: markerThickness,
                  color: markerColor,
                  corner: Corner.bottomLeft,
                ),
              ),
              // Bottom Right
              Positioned(
                right: constraints.maxWidth - right,
                bottom: constraints.maxHeight - bottom,
                child: _CornerMarker(
                  size: markerSize,
                  thickness: markerThickness,
                  color: markerColor,
                  corner: Corner.bottomRight,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Tip Item Widget
class _TipItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TipItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMedium,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Action Button Widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isActive ? color.withOpacity(0.2) : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// Corner Marker Widget
enum Corner { topLeft, topRight, bottomLeft, bottomRight }

class _CornerMarker extends StatelessWidget {
  final double size;
  final double thickness;
  final Color color;
  final Corner corner;

  const _CornerMarker({
    required this.size,
    required this.thickness,
    required this.color,
    required this.corner,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: CornerPainter(
        thickness: thickness,
        color: color,
        corner: corner,
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  final double thickness;
  final Color color;
  final Corner corner;

  CornerPainter({
    required this.thickness,
    required this.color,
    required this.corner,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    switch (corner) {
      case Corner.topLeft:
        path.moveTo(0, size.height);
        path.lineTo(0, 0);
        path.lineTo(size.width, 0);
        break;
      case Corner.topRight:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height);
        break;
      case Corner.bottomLeft:
        path.moveTo(0, 0);
        path.lineTo(0, size.height);
        path.lineTo(size.width, size.height);
        break;
      case Corner.bottomRight:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Scan Frame Painter (dark overlay with transparent center)
class ScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    const margin = 50.0;
    const cornerRadius = 16.0;

    // Create the outer rectangle (full size)
    final outerPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create the inner rounded rectangle (scan area)
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          margin, margin, size.width - margin * 2, size.height - margin * 2),
      const Radius.circular(cornerRadius),
    );
    final innerPath = Path()..addRRect(innerRect);

    // Combine paths with difference to create the overlay with hole
    final combinedPath =
        Path.combine(PathOperation.difference, outerPath, innerPath);

    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
