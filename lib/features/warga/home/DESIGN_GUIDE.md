# 📸 Screenshot & Component Guide - Home Warga

## 🎨 Component Breakdown

### 1. App Bar
```
┌─────────────────────────────────────────┐
│  Beranda Warga          🔔  👤          │
└─────────────────────────────────────────┘
```
**Features:**
- App title (Beranda Warga)
- Notification icon button
- Profile picture button
- White background dengan shadow halus

---

### 2. Welcome Card
```
┌─────────────────────────────────────────┐
│                                         │
│  Selamat datang,                        │
│  Ibu Rafa Fadil Aras                    │
│                                         │
└─────────────────────────────────────────┘
```
**Features:**
- Gradient blue background (#2F80ED → #1E6FD9)
- Typography hierarchy (subtitle + main title)
- Rounded corners (20px)
- Shadow dengan opacity

---

### 3. Quick Access Grid (2x2)
```
┌─────────────────┬─────────────────┐
│   📊           │   📢           │
│ Mini Poling    │ Pengumuman     │
└─────────────────┴─────────────────┘
┌─────────────────┬─────────────────┐
│   📅           │   ⚠️           │
│  Kegiatan      │  Pengaduan     │
└─────────────────┴─────────────────┘
```
**Features:**
- 4 menu cards dalam grid 2x2
- Icon dengan background tinted
- White cards dengan border
- Subtle shadow
- Tap animation

---

### 4. Feature List
```
┌─────────────────────────────────────────┐
│  📄  Pengajuan Keringanan          →    │
│      Ajukan keringanan iuran            │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│  📋  Semua Pengumuman              →    │
│      Lihat riwayat pengumuman           │
└─────────────────────────────────────────┘
```
**Features:**
- List item horizontal
- Icon di kiri, content di tengah, chevron di kanan
- Title + subtitle typography
- Tap animation
- White background dengan border

---

### 5. Bottom Navigation Bar
```
┌─────────┬─────────┬─────────┬─────────┐
│  🏠     │  🏪     │  📝     │  👤     │
│  Home   │Marketplace│ Iuran  │  Akun   │
└─────────┴─────────┴─────────┴─────────┘
```
**Features:**
- 4 navigation items
- Active state dengan icon filled & color blue
- Inactive state dengan icon outlined & color gray
- Label text di bawah icon
- Smooth transition animation

---

## 🎨 Color Palette

### Primary Colors
```
Primary:        #2F80ED  ████████
Primary Dark:   #1E6FD9  ████████
Primary Light:  #60A5FA  ████████
```

### Background Colors
```
Background:     #F8F9FD  ████████
Card BG:        #FFFFFF  ████████
Surface Light:  #F8F9FD  ████████
```

### Text Colors
```
Text Primary:   #1F2937  ████████
Text Secondary: #6B7280  ████████
Text Tertiary:  #9CA3AF  ████████
Text White:     #FFFFFF  ████████
```

### Border Colors
```
Border:         #E5E7EB  ████████
Border Light:   #F3F4F6  ████████
```

---

## 📐 Spacing Guide

```
XXS:  4px   ▮
XS:   8px   ▮▮
SM:   12px  ▮▮▮
MD:   16px  ▮▮▮▮
LG:   20px  ▮▮▮▮▮
XL:   24px  ▮▮▮▮▮▮
XXL:  32px  ▮▮▮▮▮▮▮▮
```

---

## 🔤 Typography

### Headers
```
Large Title:   20px / Bold / -0.3 letter spacing
Section Title: 16px / SemiBold / -0.2 letter spacing
Card Title:    15px / SemiBold / -0.2 letter spacing
```

### Body
```
Body Large:    14px / Medium
Body Regular:  14px / Regular
Body Small:    13px / Regular
Caption:       11px / Medium
```

---

## 🎭 UI States

### Card Hover/Tap
- Scale: 0.98
- Shadow increase
- Ripple effect

### Loading State
- Skeleton screens (future)
- CircularProgressIndicator

### Empty State
- Icon + Text
- Call to action button

### Error State
- Error icon + message
- Retry button

---

## 📱 Responsive Breakpoints

```
Mobile:   < 600px  (Default)
Tablet:   600-1024px (Future)
Desktop:  > 1024px (Future)
```

---

## ♿ Accessibility

- ✅ Proper contrast ratios (WCAG AA)
- ✅ Touch targets minimum 48x48px
- ✅ Semantic navigation
- ✅ Screen reader friendly (future enhancement)

---

## 🎬 Animations

### Page Transitions
- Duration: 300ms
- Curve: easeInOut

### Card Tap
- Duration: 150ms
- Scale: 0.98

### Icon Transitions
- Duration: 200ms
- Fade + Scale

### Pull to Refresh
- Native flutter indicator
- Primary color

---

## 🔧 Interactive Elements

### Buttons
- **Primary**: Blue gradient, white text
- **Secondary**: White bg, blue text, blue border
- **Icon**: Transparent, icon only

### Cards
- **Elevated**: White bg, subtle shadow
- **Flat**: White bg, border only
- **Gradient**: Primary gradient background

### Forms (Future)
- **TextField**: White bg, border, rounded
- **Dropdown**: White bg, border, icon
- **Checkbox**: Primary color when checked

---

## 📊 Component Sizing

### Cards
```
Quick Access Card:
- Width: (screen - 56px) / 2
- Height: Same as width (1:1 ratio)
- Padding: 16px
- Border Radius: 16px

Feature List Item:
- Width: Full width
- Height: Auto (min 80px)
- Padding: 16px
- Border Radius: 16px
```

### Icons
```
App Bar Icon:     22px
Card Icon:        24-28px
Bottom Nav Icon:  26px
```

### Avatars
```
App Bar Avatar:   40x40px
Profile Avatar:   80x80px (future)
```

---

## 🎯 Hit Areas

Minimum touch target: **48x48px**

```
✅ Good:  Bottom nav items (48x48)
✅ Good:  Quick access cards (>100px)
✅ Good:  Feature list items (80px height)
```

---

## 🌙 Dark Mode (Future)

Prepared for dark mode implementation:
- Use semantic colors
- Avoid hardcoded colors
- Use Theme.of(context)

```dart
// Future implementation
final isDark = Theme.of(context).brightness == Brightness.dark;
final bgColor = isDark ? Colors.grey[900] : Color(0xFFF8F9FD);
```

---

**Design System Version:** 1.0.0  
**Last Updated:** November 24, 2025  
**Designer:** AI Assistant  
**Developer:** You 😊

