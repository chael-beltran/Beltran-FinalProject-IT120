import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteHelper {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isLoaded = false;

  // Confidence validation thresholds
  // Below 75% = Image Not Identified
  static const double _minConfidenceThreshold = 0.75;
  static const double _minConfidenceGap = 0.10;
  static const double _maxEntropy = 1.8;
  static const double _absoluteMinConfidence = 0.30;

  // Confidence level thresholds for display
  static const double excellentThreshold = 0.95; // 95-100%
  static const double highThreshold = 0.90; // 90-94%
  static const double goodThreshold = 0.80; // 80-89%
  static const double lowThreshold = 0.76; // 76-79%
  // Below 76% = Not Identified

  bool get isLoaded => _isLoaded;

  /// Get confidence level label based on accuracy
  static String getConfidenceLevel(double confidence) {
    if (confidence >= excellentThreshold) return 'Excellent';
    if (confidence >= highThreshold) return 'High';
    if (confidence >= goodThreshold) return 'Good';
    if (confidence >= lowThreshold) return 'Low';
    return 'Not Identified';
  }

  /// Check if confidence level is low (76-79%)
  static bool isLowConfidence(double confidence) {
    return confidence >= lowThreshold && confidence < goodThreshold;
  }

  /// Calculate entropy of predictions (higher = more uncertain)
  /// For 10 classes, max entropy is log10(10) = 1.0 with natural log it's ~2.3
  double _calculateEntropy(List<double> probabilities) {
    double entropy = 0.0;
    for (final p in probabilities) {
      if (p > 0) {
        entropy -= p * log(p); // natural log
      }
    }
    return entropy;
  }

  /// Validate if prediction is confident enough to be considered a match
  bool _isConfidentPrediction({
    required double topConfidence,
    required double secondConfidence,
    required double entropy,
  }) {
    // Layer 1: Absolute minimum check
    if (topConfidence < _absoluteMinConfidence) return false;

    // Layer 2: Primary confidence threshold (75%)
    if (topConfidence < _minConfidenceThreshold) return false;

    // Layer 3: Gap between top 2 predictions
    final gap = topConfidence - secondConfidence;
    if (gap < _minConfidenceGap) return false;

    // Layer 4: Entropy check (max entropy for 10 uniform classes is ln(10) ≈ 2.3)
    if (entropy > _maxEntropy) return false;

    return true;
  }

  Future<void> loadModel() async {
    try {
      // Load labels
      final labelsData =
          await rootBundle.loadString('assets/model/labels_50.txt');
      _labels = labelsData
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) {
        // Handle format: "0 Label Name" or "Label Name"
        final parts = line.trim().split(' ');
        if (parts.length > 1) {
          return parts.sublist(1).join(' ');
        }
        return line.trim();
      }).toList();

      // Load model
      final options = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset('assets/model/model_50.tflite',
          options: options);

      // Allocate tensors
      _interpreter!.allocateTensors();

      _isLoaded = true;
    } catch (e) {
      print('Error loading model: $e');
      _isLoaded = false;
      rethrow;
    }
  }

  List<Map<String, dynamic>>? predictImage(File imageFile) {
    if (_interpreter == null || !_isLoaded) {
      return null;
    }

    try {
      // Get input and output tensor details
      final inputTensor = _interpreter!.getInputTensor(0);
      final outputTensor = _interpreter!.getOutputTensor(0);
      final inputShape = inputTensor.shape;
      final outputShape = outputTensor.shape;
      final inputHeight = inputShape[1];
      final inputWidth = inputShape[2];

      // Read and decode image
      final imageBytes = imageFile.readAsBytesSync();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        print('Error: Could not decode image.');
        return null;
      }

      // Crop the image to a square in the center
      final size = image.width < image.height ? image.width : image.height;
      final x = (image.width - size) ~/ 2;
      final y = (image.height - size) ~/ 2;
      final croppedImage =
          img.copyCrop(image, x: x, y: y, width: size, height: size);

      // Resize image to model's input dimensions
      final resizedImage = img.copyResize(croppedImage,
          width: inputWidth,
          height: inputHeight,
          interpolation: img.Interpolation.average);

      // Convert image to a Float32List of normalized pixel values
      final inputBuffer =
          _imageToByteListFloat32(resizedImage, inputHeight, inputWidth);

      // Reshape the flat list into the format expected by the model, e.g. [1, 224, 224, 3]
      final reshapedInput = inputBuffer.reshape(inputShape);

      // Prepare output buffer
      final outputBuffer = [List<double>.filled(outputShape[1], 0.0)];

      // Run inference
      _interpreter!.run(reshapedInput, outputBuffer);

      // Process output to get predictions with labels
      final predictions = <Map<String, dynamic>>[];
      final List<double> outputList = outputBuffer[0];

      // Calculate entropy for uncertainty detection
      final entropy = _calculateEntropy(outputList);

      for (int i = 0; i < outputList.length && i < _labels.length; i++) {
        predictions.add({
          'label': _labels[i],
          'confidence': outputList[i],
        });
      }

      // Sort by confidence (descending)
      predictions.sort((a, b) =>
          (b['confidence'] as double).compareTo(a['confidence'] as double));

      // Determine if the image is confidently identified
      final topConfidence =
          predictions.isNotEmpty ? predictions[0]['confidence'] as double : 0.0;
      final secondConfidence =
          predictions.length > 1 ? predictions[1]['confidence'] as double : 0.0;

      final isIdentified = _isConfidentPrediction(
        topConfidence: topConfidence,
        secondConfidence: secondConfidence,
        entropy: entropy,
      );

      // Add identification metadata to each prediction
      for (int i = 0; i < predictions.length; i++) {
        predictions[i]['isIdentified'] = isIdentified;
        predictions[i]['entropy'] = entropy;
        predictions[i]['confidenceGap'] = topConfidence - secondConfidence;
      }

      // Debug logging
      print(
          'Prediction: ${predictions.isNotEmpty ? predictions[0]['label'] : 'none'}');
      print('Top confidence: ${topConfidence.toStringAsFixed(4)}');
      print('Second confidence: ${secondConfidence.toStringAsFixed(4)}');
      print(
          'Confidence gap: ${(topConfidence - secondConfidence).toStringAsFixed(4)}');
      print('Entropy: ${entropy.toStringAsFixed(4)}');
      print('Is Identified: $isIdentified');

      return predictions;
    } catch (e) {
      print('Error predicting image: $e');
      return null;
    }
  }

  Float32List _imageToByteListFloat32(
      img.Image image, int inputSizeH, int inputSizeW) {
    final inputBuffer = Float32List(1 * inputSizeH * inputSizeW * 3);
    int pixelIndex = 0;
    for (int i = 0; i < inputSizeH; i++) {
      for (int j = 0; j < inputSizeW; j++) {
        final pixel = image.getPixel(j, i);
        // Normalize pixel values to [0, 1] range
        inputBuffer[pixelIndex++] = pixel.r / 255.0;
        inputBuffer[pixelIndex++] = pixel.g / 255.0;
        inputBuffer[pixelIndex++] = pixel.b / 255.0;
      }
    }
    return inputBuffer;
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }
}
