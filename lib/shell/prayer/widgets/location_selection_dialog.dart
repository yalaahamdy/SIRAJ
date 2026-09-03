import 'package:flutter/material.dart';
import '../../../core/location/city_presets.dart';
import '../../../core/location/location_engine.dart';
import '../../../core/location/location_models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

// Re-export CanonicalCityPreset for backwards compatibility
export '../../../core/location/city_presets.dart' show CanonicalCityPreset;

/// Dialog allowing transparent, privacy-preserving location configuration with GPS acquisition and rich search (§10, §11, §39).
class LocationSelectionDialog extends StatefulWidget {
  final GeoCoordinates currentLocation;
  final ValueChanged<GeoCoordinates> onLocationSelected;
  final LocationEngine? locationEngine;

  const LocationSelectionDialog({
    super.key,
    required this.currentLocation,
    required this.onLocationSelected,
    this.locationEngine,
  });

  static List<CanonicalCityPreset> get canonicalPresets => CanonicalCityPreset.canonicalPresets;

  @override
  State<LocationSelectionDialog> createState() => _LocationSelectionDialogState();
}

class _LocationSelectionDialogState extends State<LocationSelectionDialog> {
  bool _isCustomMode = false;
  bool _isAcquiringGps = false;
  String? _gpsStatusMessage;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();
  late LocationEngine _engine;
  List<CanonicalCityPreset> _filteredPresets = CanonicalCityPreset.canonicalPresets;

  @override
  void initState() {
    super.initState();
    _engine = widget.locationEngine ?? LocationEngine(defaultLocation: widget.currentLocation);
    _latController.text = widget.currentLocation.latitude.toStringAsFixed(4);
    _lonController.text = widget.currentLocation.longitude.toStringAsFixed(4);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredPresets = CanonicalCityPreset.search(query);
    });
  }

  Future<void> _acquireGpsLocation() async {
    setState(() {
      _isAcquiringGps = true;
      _gpsStatusMessage = null;
    });

    final res = await _engine.acquireLocation();
    if (!mounted) return;

    setState(() {
      _isAcquiringGps = false;
    });

    if (res.isSuccess) {
      final report = res.valueOrNull!;
      setState(() {
        _gpsStatusMessage = report.statusMessageArabic;
      });
      if (report.isAutomatic) {
        widget.onLocationSelected(report.coordinates);
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        _gpsStatusMessage = res.failureOrNull?.message ?? 'تعذر الحصول على الموقع التلقائي';
      });
    }
  }

  void _selectPreset(CanonicalCityPreset preset) {
    _engine.setManualLocation(preset.coordinates);
    widget.onLocationSelected(preset.coordinates);
    Navigator.of(context).pop();
  }

  void _submitCustomCoordinates() {
    final lat = double.tryParse(_latController.text);
    final lon = double.tryParse(_lonController.text);

    if (lat != null && lon != null && lat >= -90.0 && lat <= 90.0 && lon >= -180.0 && lon <= 180.0) {
      final coords = GeoCoordinates(
        latitude: lat,
        longitude: lon,
        source: LocationSource.manual,
        cityName: 'موقع يدوي مخصص',
        timestamp: DateTime.now(),
      );
      _engine.setManualLocation(coords);
      widget.onLocationSelected(coords);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال إحداثيات جغرافية صحيحة (خط العرض -90..90، خط الطول -180..180)'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.location_on_rounded, color: AppColors.primary),
          SizedBox(width: 8),
          Text('تحديد الموقع الجغرافي'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: _isCustomMode ? 260 : 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mode Switcher
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isCustomMode ? 'إدخال إحداثيات مخصصة' : 'اختيار مدينة من القائمة (${_filteredPresets.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _isCustomMode = !_isCustomMode),
                    icon: Icon(_isCustomMode ? Icons.list_rounded : Icons.edit_location_rounded, size: 16),
                    label: Text(_isCustomMode ? 'قائمة المدن' : 'إدخال يدوي', style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s),

              if (!_isCustomMode) ...[
                // Privacy Disclosure Banner (§10, §11, §39)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  margin: const EdgeInsets.only(bottom: AppSpacing.s),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'حساب مواقيت الصلاة والقبلة بأعلى دقة فلكية ومعايير خصوصية تامة.',
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ),

                // GPS Auto Acquire Action Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.my_location_rounded, color: AppColors.primary, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.currentLocation.source == LocationSource.gps
                                  ? 'الموقع الحالي: محدد تلقائياً عبر GPS'
                                  : 'الموقع الحالي: ${widget.currentLocation.cityName ?? "محدد يدوياً"}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isAcquiringGps ? null : _acquireGpsLocation,
                          icon: _isAcquiringGps
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.gps_fixed_rounded, size: 18),
                          label: Text(_isAcquiringGps ? 'جاري تحديد موقعك...' : 'تحديد موقعي تلقائياً (GPS)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      if (_gpsStatusMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _gpsStatusMessage!,
                          style: TextStyle(
                            fontSize: 11,
                            color: _gpsStatusMessage!.contains('خطأ') || _gpsStatusMessage!.contains('رفض') || _gpsStatusMessage!.contains('معطلة')
                                ? Colors.red.shade700
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
              ],

              if (!_isCustomMode) ...[
                // City Search Field
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'ابحث باسم المدينة أو الدولة...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),

                // Cities List
                SizedBox(
                  height: 240,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _filteredPresets.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final preset = _filteredPresets[index];
                      final isSelected = (preset.coordinates.latitude - widget.currentLocation.latitude).abs() < 0.01 &&
                          (preset.coordinates.longitude - widget.currentLocation.longitude).abs() < 0.01;

                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        leading: Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? AppColors.primary : Colors.grey,
                          size: 18,
                        ),
                        title: Text(preset.cityNameArabic, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        subtitle: Text(preset.countryNameArabic, style: const TextStyle(fontSize: 11)),
                        trailing: Text(
                          '${preset.coordinates.latitude.toStringAsFixed(2)}°, ${preset.coordinates.longitude.toStringAsFixed(2)}°',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        onTap: () => _selectPreset(preset),
                      );
                    },
                  ),
                ),
              ] else ...[
                TextField(
                  controller: _latController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  decoration: const InputDecoration(
                    labelText: 'خط العرض (Latitude) [-90 .. 90]',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.north_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                TextField(
                  controller: _lonController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  decoration: const InputDecoration(
                    labelText: 'خط الطول (Longitude) [-180 .. 180]',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.east_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitCustomCoordinates,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('تطبيق الإحداثيات'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
}
