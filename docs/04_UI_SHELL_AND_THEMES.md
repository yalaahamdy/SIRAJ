# 04 — واجهة المستخدم والسمات البصرية (UI Shell, Design System & Themes)

تُمثل واجهة مستخدم تطبيق **سِراج (SIRAJ)** نموذجاً هندسياً فريداً يجمع بين **الأصالة والسكينة والجماليات الإسلامية** من جهة، و**الأداء التفاعلي فائق النعومة والتجاوب الكامل مع كافة شاشات الهواتف** من جهة أخرى.

---

## 🎨 1. نظام التصميم الإسلامي ولوحة الألوان (Islamic Design System)

تم انتقاء الألوان والزخارف بعناية فائقة لتعزيز التركيز والخشوع أثناء قراءة القرآن وتأدية العبادات:

```mermaid
graph TD
    subgraph Colors["لوحة الألوان المركزية (Palette Architecture)"]
        Emerald["الأخضر الزمردي الإسلامي (#10B981) - اللون الأساسي Primary"]
        Gold["الذهب الأندلسي العتيق (#D97706) - لون التمييز والزخارف Accent"]
        Ivory["العاجي الدافئ (#FDFBF7) - خلفية القراءة النهارية Light"]
        Sepia["ورق المصحف السيبيا (#F4ECD8) - خلفية المصحف النبوي Sepia"]
        Charcoal["الكربوني الليلي الخاشع (#121418) - خلفية القراءة الليلية Dark"]
    end
```

### رموز ودلالات الألوان:
1. **اللون الأساسي (`AppColors.primary` - `#10B981`)**: الزمردي الإسلامي يرمز للنماء والسكينة والحياة.
2. **لون التمييز (`AppColors.accent` - `#D97706`)**: الذهب المعتق يرمز لأصالة المخطوطات والزخارف القرآنية.
3. **ألوان النصوص والتباين**: الالتزام الصارم بمعايير الوصول العالمي (WCAG AAA) مع نسبة تباين تتجاوز `7:1` لضمان قراءة مريحة بدون أي إجهاد بصري.

---

## 🌓 2. السمات البصرية الثلاث المتكيفة (The 3 Visual Themes)

| السمة البصرية | لون الخلفية (HEX) | لون النص القرآني | الاستخدام والتجربة الشعورية |
| :--- | :--- | :--- | :--- |
| **1. السمة الفاتحة (Light Theme)** | `#FDFBF7` (عاجي دافئ) | أسود قرآني فاحم (`#1A1A1A`) | مخصصة للقراءة النهارية والبيئات المضيئة، تحافظ على طاقة العين وتمنع التوهج الأبيض المزعج. |
| **2. سمة ورق المصحف (Sepia Quran)** | `#F4ECD8` (ورق تراثي) | بني مصحفي داكن (`#2C1D11`) | تحاكي ملمس وصفحات المصحف الورقي الشريف ومصاحف المدينة القديمة مع إحساس مريح بالألفة والتراث. |
| **3. السمة الداكنة (Dark Night)** | `#121418` (كربوني عميق) | عاجي هادئ (`#E0E0E0`) | مخصصة لصلاة الليل والتهجد والقراءة في الظلام التام مع استهلاك طاقة شبه معدوم على شاشات OLED. |

---

## 📱 3. هندسة التجاوب والشاشات المرنة (Responsive Mobile Architecture)

صُممت كافة شاشات التطبيق لتتجاوب ديناميكياً مع قياسات الهواتف الذكية بجميع أبعادها (بدءاً من الشاشات الصغيرة جداً بعرض 320px، حتى الهواتف الكبيرة والشاشات القابلة للطي والأجهزة اللوحية):

```mermaid
graph LR
    A[شاشات الهواتف الصغيرة 320px] --> B[هندسة الالتفاف المرن Dynamic Wrap Layout]
    C[الشاشات المتوسطة 375px - 414px] --> B
    D[الشاشات الكبيرة والأجهزة اللوحية] --> B
    B --> E[انعدام تام لأخطاء تجاوز الحدود Zero RenderFlex Overflow]
```

### معايير التجاوب المطبقة:
1. **استبدال الصفوف الصلبة بالأعمدة المرنة والـ Wrap**:
   - استخدام `Wrap(spacing: 6, runSpacing: 6)` في أزرار سرعات التلاوة (`0.75x`, `1.0x`, `1.25x`, `1.5x`, `2.0x`) وخيارات ألوان السمة لضمان التفاف العناصر تلقائياً عند ضيق الشاشة.
2. **احتواء القوائم المنسدلة (Dropdown Expansion & Ellipsis)**:
   - ضبط خاصية `isExpanded: true` و `overflow: TextOverflow.ellipsis` في كافة القوائم المنسدلة (اختيار القراء، والترجمات) لتفادي دفع عناصر التحكم خارج الشاشة.
3. **التصميم العمودي لبطاقات التنزيل والاستيراد**:
   - ترتيب بطاقة استيراد حزم الـ ZIP وأزرار تحميل السور بشكل عمودي مرن يتكيف تلقائياً مع عرض شاشة الهاتف.

---

## 🎛️ 4. متحكم إعدادات المصحف والطباعة (Quran Reader Settings Controller)

- **المسار المصدري**: `lib/shell/quran/controllers/quran_reader_settings_controller.dart`
- **النموذج المعماري**:
  - متحكم أحادي المصدر للحقيقة (Single Source of Truth) يرث من `ChangeNotifier` ويعتمد على نموذج بيانات غير قابل للتعديل (`QuranTypographyConfig`).

```mermaid
sequenceDiagram
    actor User as المستخدم
    participant Tab as تبويبة الإعدادات (QuranSettingsTab)
    participant Controller as متحكم الإعدادات (QuranReaderSettingsController)
    participant Storage as التخزين المحلي (KeyValueStore)
    participant Reader as شاشة القارئ (QuranReaderScreen)

    User->>Tab: تغيير حجم الخط / السمة / لغة الترجمة
    Tab->>Controller: updateConfig(newConfig)
    Controller->>Storage: حفظ التعديلات محلياً JSON Persistence
    Controller->>Reader: notifyListeners() (تحديث الواجهة اللحظي)
    Reader-->>User: معاينة حية وفورية للنص القرآني المحدث
```

### الخيارات القابلة للتخصيص الكامل:
- **حجم الخط القرآني**: شريط تمرير سلس من **18px** إلى **38px** مع شاشة معاينة حية وفورية لآية البسملة الشريفة.
- **الفواصل المرجعية المدمجة**: استعراض كافة الآيات والسور المحفوظة بفواصل مرجعية مع إمكانية حذفها أو القفز المباشر إليها.

---

# 💻 الجزء الثاني: التفاصيل التقنية والتنفيذية البرمجية (Technical & Implementation Details)

## 🛠️ 1. نموذج إعدادات الطباعة والسمات (`QuranTypographyConfig`)

```dart
class QuranTypographyConfig {
  final QuranFontFamily fontFamily;
  final double fontSize;
  final double lineHeight;
  final QuranReaderMode readerMode;
  final QuranReaderThemeMode themeMode;
  final bool showTajweed;
  final bool showTranslation;
  final String translationLanguage;
  final String reciter;
  final double playbackSpeed;
  final bool autoScroll;

  const QuranTypographyConfig({
    this.fontFamily = QuranFontFamily.amiri,
    this.fontSize = 24.0,
    this.lineHeight = 2.2,
    this.readerMode = QuranReaderMode.mushaf,
    this.themeMode = QuranReaderThemeMode.light,
    this.showTajweed = false, // معطل افتراضياً للنقاء العثماني
    this.showTranslation = false,
    this.translationLanguage = 'en',
    this.reciter = 'الشيخ عبد الباسط عبد الصمد',
    this.playbackSpeed = 1.0,
    this.autoScroll = true,
  });

  /// استنتاج ألوان الخلفية ديناميكياً بحسب السمة المعتمدة
  Color resolveBackgroundColor(BuildContext context) {
    switch (themeMode) {
      case QuranReaderThemeMode.light:
        return const Color(0xFFFDFBF7); // عاجي ناعم
      case QuranReaderThemeMode.sepia:
        return const Color(0xFFF4ECD8); // ورق مصحفي دافئ
      case QuranReaderThemeMode.dark:
        return const Color(0xFF121418); // كربوني ليلي
    }
  }
}
```

---

## 📱 2. نمط التصميم المتجاوب وخوارزمية احتواء العناصر (`Responsive Layout`)

```dart
Widget buildResponsiveSpeedSelector(QuranTypographyConfig config, Function(double) onSpeedChanged) {
  const speeds = [0.75, 1.0, 1.25, 1.5, 2.0];
  
  // استخدام Wrap بدلاً من Row لمنع حدوث RenderFlex Overflow على الشاشات الصغيرة
  return Wrap(
    spacing: 6.0,
    runSpacing: 6.0,
    alignment: WrapAlignment.start,
    children: speeds.map((speed) {
      final isSelected = (config.playbackSpeed - speed).abs() < 0.01;
      return ChoiceChip(
        label: Text('${speed}x', style: const TextStyle(fontSize: 12)),
        selected: isSelected,
        onSelected: (_) => onSpeedChanged(speed),
      );
    }).toList(),
  );
}
```

---

# ⚖️ الجزء الثالث: الالتزامات والضوابط الإلزامية والمعايير الصارمة (Mandatory Invariants & Compliance Rules)

## 🚨 1. معايير التصميم والوصول والتباين البصري (Accessibility & Contrast Rules)

1. **حظر أخطاء تجاوز الشاشة تماماً (Zero RenderFlex Overflow Invariant)**:
   - يُلزم بفحص كافة الواجهات على شاشات بعرض **320px** و **360px** و **414px** والتأكد من خلوها تماماً من أي خطأ في تجاوز الشاشة أفقياً.
2. **حد أدنى لمساحة اللمس التفاعلية (Touch Target Size $\ge 44 \times 44\text{ dp}$)**:
   - كافة الأزرار والأيقونات وعناصر التنقل وقوائم الآيات يجب ألا يقل حجمها التفاعلي عن 44 بكسل لسهولة الاستخدام لكبار السن.
3. **معايير التباين للنص القرآني (WCAG AAA Compliance)**:
   - يجب ألا تقل نسبة التباين اللوني بين النص القرآني ولون الخلفية عن `7.0:1` في كافة السمات الثلاث لمنع أي إجهاد للعين.

---

## 🛑 2. ضوابط الاتجاه النصي وتكامل الترجمات

1. **العزل التام لاتجاهات النصوص (Directionality Isolation)**:
   - يُلزم بوضع النص القرآني داخل `Directionality(textDirection: TextDirection.rtl)`.
   - يُلزم بوضع الترجمات الإنجليزية والفرنسية والإسبانية والروسية وغيرها داخل `Directionality(textDirection: TextDirection.ltr)` لمنع اختلاط علامات الترقيم أو انقلاب اتجاه الفقرات.


