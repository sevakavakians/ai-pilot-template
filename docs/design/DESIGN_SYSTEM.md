# Design System Documentation

**Purpose**: Define UI components, patterns, and design principles for consistent user experience.  
**Audience**: Designers, frontend developers, product managers  
**Update Frequency**: On component changes, quarterly review

## Design Principles

### Core Principles
1. **Clarity**: Interface should be self-explanatory
2. **Consistency**: Similar patterns for similar problems
3. **Efficiency**: Minimize steps to complete tasks
4. **Accessibility**: Usable by everyone
5. **Delight**: Thoughtful interactions that feel good

### Design Values
- **Simple over Complex**
- **Familiar over Novel**
- **Inclusive over Exclusive**
- **Performance over Polish**
- **Data-Driven over Opinion**

## Color System

### Brand Colors
```scss
// Primary Palette
$primary-50:  #E3F2FD;
$primary-100: #BBDEFB;
$primary-200: #90CAF9;
$primary-300: #64B5F6;
$primary-400: #42A5F5;
$primary-500: #2196F3; // Main brand color
$primary-600: #1E88E5;
$primary-700: #1976D2;
$primary-800: #1565C0;
$primary-900: #0D47A1;

// Secondary Palette
$secondary-50:  #F3E5F5;
$secondary-100: #E1BEE7;
$secondary-200: #CE93D8;
$secondary-300: #BA68C8;
$secondary-400: #AB47BC;
$secondary-500: #9C27B0;
$secondary-600: #8E24AA;
$secondary-700: #7B1FA2;
$secondary-800: #6A1B9A;
$secondary-900: #4A148C;

// Neutral Palette
$gray-50:  #FAFAFA;
$gray-100: #F5F5F5;
$gray-200: #EEEEEE;
$gray-300: #E0E0E0;
$gray-400: #BDBDBD;
$gray-500: #9E9E9E;
$gray-600: #757575;
$gray-700: #616161;
$gray-800: #424242;
$gray-900: #212121;
```

### Semantic Colors
```scss
// Status Colors
$success: #4CAF50;
$success-light: #81C784;
$success-dark: #388E3C;

$warning: #FF9800;
$warning-light: #FFB74D;
$warning-dark: #F57C00;

$error: #F44336;
$error-light: #E57373;
$error-dark: #D32F2F;

$info: #2196F3;
$info-light: #64B5F6;
$info-dark: #1976D2;

// Functional Colors
$text-primary: rgba(0, 0, 0, 0.87);
$text-secondary: rgba(0, 0, 0, 0.60);
$text-disabled: rgba(0, 0, 0, 0.38);

$background-default: #FFFFFF;
$background-paper: #FAFAFA;
$background-overlay: rgba(0, 0, 0, 0.5);

$border-default: rgba(0, 0, 0, 0.12);
$border-focus: $primary-500;
$border-error: $error;
```

### Color Usage Guidelines
```scss
// Component color mapping
.button-primary {
  background: $primary-500;
  &:hover { background: $primary-600; }
  &:active { background: $primary-700; }
  &:disabled { background: $gray-300; }
}

.alert-success {
  background: $success-light;
  border: 1px solid $success;
  color: $success-dark;
}

// Accessibility contrast ratios
// Background → Text : Ratio
// White → Gray-900 : 21:1 ✓
// Primary-500 → White : 4.5:1 ✓
// Error → White : 4.5:1 ✓
```

## Typography

### Font Stack
```scss
// Font families
$font-primary: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
$font-mono: 'Fira Code', 'Courier New', monospace;

// Font weights
$font-light: 300;
$font-regular: 400;
$font-medium: 500;
$font-semibold: 600;
$font-bold: 700;

// Base font size
$font-size-base: 16px;
$line-height-base: 1.5;
```

### Type Scale
```scss
// Heading styles
.h1 {
  font-size: 2.5rem;    // 40px
  line-height: 1.2;
  font-weight: $font-bold;
  letter-spacing: -0.02em;
  margin-bottom: 1rem;
}

.h2 {
  font-size: 2rem;      // 32px
  line-height: 1.25;
  font-weight: $font-semibold;
  letter-spacing: -0.01em;
  margin-bottom: 0.875rem;
}

.h3 {
  font-size: 1.5rem;    // 24px
  line-height: 1.33;
  font-weight: $font-semibold;
  margin-bottom: 0.75rem;
}

.h4 {
  font-size: 1.25rem;   // 20px
  line-height: 1.4;
  font-weight: $font-medium;
  margin-bottom: 0.5rem;
}

.h5 {
  font-size: 1.125rem;  // 18px
  line-height: 1.44;
  font-weight: $font-medium;
  margin-bottom: 0.5rem;
}

.h6 {
  font-size: 1rem;      // 16px
  line-height: 1.5;
  font-weight: $font-medium;
  margin-bottom: 0.5rem;
}

// Body styles
.body-large {
  font-size: 1.125rem;  // 18px
  line-height: 1.75;
}

.body-regular {
  font-size: 1rem;      // 16px
  line-height: 1.5;
}

.body-small {
  font-size: 0.875rem;  // 14px
  line-height: 1.43;
}

.caption {
  font-size: 0.75rem;   // 12px
  line-height: 1.33;
  color: $text-secondary;
}

.overline {
  font-size: 0.75rem;   // 12px
  line-height: 2;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  font-weight: $font-semibold;
}
```

## Spacing System

### Base Unit
```scss
$spacing-unit: 8px;

// Spacing scale
$spacing-0: 0;
$spacing-1: $spacing-unit * 0.5;   // 4px
$spacing-2: $spacing-unit;         // 8px
$spacing-3: $spacing-unit * 1.5;   // 12px
$spacing-4: $spacing-unit * 2;     // 16px
$spacing-5: $spacing-unit * 3;     // 24px
$spacing-6: $spacing-unit * 4;     // 32px
$spacing-7: $spacing-unit * 5;     // 40px
$spacing-8: $spacing-unit * 6;     // 48px
$spacing-9: $spacing-unit * 7;     // 56px
$spacing-10: $spacing-unit * 8;    // 64px

// Layout spacing
$layout-narrow: 960px;
$layout-default: 1280px;
$layout-wide: 1440px;

// Component spacing
$component-padding-xs: $spacing-2;
$component-padding-sm: $spacing-3;
$component-padding-md: $spacing-4;
$component-padding-lg: $spacing-5;
$component-padding-xl: $spacing-6;
```

## Components

### Buttons
```scss
// Button base styles
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: $spacing-3 $spacing-4;
  font-size: 1rem;
  font-weight: $font-medium;
  line-height: 1.5;
  border-radius: 6px;
  border: none;
  cursor: pointer;
  transition: all 0.2s ease;
  
  &:focus {
    outline: 2px solid $primary-500;
    outline-offset: 2px;
  }
  
  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
}

// Button variants
.btn-primary {
  @extend .btn;
  background: $primary-500;
  color: white;
  
  &:hover { background: $primary-600; }
  &:active { background: $primary-700; }
}

.btn-secondary {
  @extend .btn;
  background: white;
  color: $primary-500;
  border: 1px solid $primary-500;
  
  &:hover { background: $primary-50; }
  &:active { background: $primary-100; }
}

.btn-ghost {
  @extend .btn;
  background: transparent;
  color: $primary-500;
  
  &:hover { background: $primary-50; }
  &:active { background: $primary-100; }
}

// Button sizes
.btn-sm {
  padding: $spacing-2 $spacing-3;
  font-size: 0.875rem;
}

.btn-lg {
  padding: $spacing-4 $spacing-6;
  font-size: 1.125rem;
}

// Button states
.btn-loading {
  position: relative;
  color: transparent;
  
  &::after {
    content: "";
    position: absolute;
    width: 16px;
    height: 16px;
    top: 50%;
    left: 50%;
    margin: -8px 0 0 -8px;
    border: 2px solid white;
    border-radius: 50%;
    border-top-color: transparent;
    animation: spin 0.6s linear infinite;
  }
}
```

### Forms
```scss
// Input styles
.input {
  width: 100%;
  padding: $spacing-3;
  font-size: 1rem;
  line-height: 1.5;
  color: $text-primary;
  background: white;
  border: 1px solid $border-default;
  border-radius: 4px;
  transition: all 0.2s ease;
  
  &:focus {
    outline: none;
    border-color: $primary-500;
    box-shadow: 0 0 0 3px rgba($primary-500, 0.1);
  }
  
  &:disabled {
    background: $gray-50;
    cursor: not-allowed;
  }
  
  &.input-error {
    border-color: $error;
    
    &:focus {
      box-shadow: 0 0 0 3px rgba($error, 0.1);
    }
  }
}

// Label styles
.label {
  display: block;
  margin-bottom: $spacing-2;
  font-size: 0.875rem;
  font-weight: $font-medium;
  color: $text-primary;
  
  &.required::after {
    content: " *";
    color: $error;
  }
}

// Form group
.form-group {
  margin-bottom: $spacing-5;
}

// Error message
.error-message {
  margin-top: $spacing-2;
  font-size: 0.875rem;
  color: $error;
}

// Checkbox & Radio
.checkbox,
.radio {
  display: flex;
  align-items: center;
  margin-bottom: $spacing-3;
  
  input {
    margin-right: $spacing-2;
    width: 18px;
    height: 18px;
    cursor: pointer;
  }
  
  label {
    cursor: pointer;
    user-select: none;
  }
}
```

### Cards
```scss
.card {
  background: white;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12);
  overflow: hidden;
  
  &:hover {
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.15);
  }
}

.card-header {
  padding: $spacing-4 $spacing-5;
  border-bottom: 1px solid $border-default;
  
  h3 {
    margin: 0;
  }
}

.card-body {
  padding: $spacing-5;
}

.card-footer {
  padding: $spacing-4 $spacing-5;
  background: $gray-50;
  border-top: 1px solid $border-default;
}

// Card variants
.card-outlined {
  box-shadow: none;
  border: 1px solid $border-default;
}

.card-elevated {
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}
```

### Tables
```scss
.table {
  width: 100%;
  border-collapse: collapse;
  
  thead {
    background: $gray-50;
    border-bottom: 2px solid $border-default;
    
    th {
      padding: $spacing-3 $spacing-4;
      text-align: left;
      font-weight: $font-semibold;
      font-size: 0.875rem;
      color: $text-secondary;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }
  }
  
  tbody {
    tr {
      border-bottom: 1px solid $border-default;
      
      &:hover {
        background: $gray-50;
      }
    }
    
    td {
      padding: $spacing-4;
      color: $text-primary;
    }
  }
}

// Table variants
.table-striped {
  tbody tr:nth-child(odd) {
    background: $gray-50;
  }
}

.table-compact {
  th, td {
    padding: $spacing-2 $spacing-3;
  }
}
```

## Layout

### Grid System
```scss
.container {
  width: 100%;
  max-width: $layout-default;
  margin: 0 auto;
  padding: 0 $spacing-4;
  
  &.container-narrow { max-width: $layout-narrow; }
  &.container-wide { max-width: $layout-wide; }
  &.container-fluid { max-width: 100%; }
}

.grid {
  display: grid;
  gap: $spacing-5;
  
  &.grid-cols-2 { grid-template-columns: repeat(2, 1fr); }
  &.grid-cols-3 { grid-template-columns: repeat(3, 1fr); }
  &.grid-cols-4 { grid-template-columns: repeat(4, 1fr); }
  
  @media (max-width: 768px) {
    &.grid-cols-2,
    &.grid-cols-3,
    &.grid-cols-4 {
      grid-template-columns: 1fr;
    }
  }
}

.flex {
  display: flex;
  
  &.flex-center {
    align-items: center;
    justify-content: center;
  }
  
  &.flex-between {
    justify-content: space-between;
  }
  
  &.flex-column {
    flex-direction: column;
  }
  
  &.flex-wrap {
    flex-wrap: wrap;
  }
}
```

### Breakpoints
```scss
// Breakpoint variables
$breakpoint-xs: 320px;
$breakpoint-sm: 640px;
$breakpoint-md: 768px;
$breakpoint-lg: 1024px;
$breakpoint-xl: 1280px;
$breakpoint-2xl: 1536px;

// Breakpoint mixins
@mixin xs-up {
  @media (min-width: $breakpoint-xs) { @content; }
}

@mixin sm-up {
  @media (min-width: $breakpoint-sm) { @content; }
}

@mixin md-up {
  @media (min-width: $breakpoint-md) { @content; }
}

@mixin lg-up {
  @media (min-width: $breakpoint-lg) { @content; }
}

@mixin xl-up {
  @media (min-width: $breakpoint-xl) { @content; }
}

// Responsive utilities
.hide-mobile {
  @media (max-width: $breakpoint-md) {
    display: none !important;
  }
}

.show-mobile {
  @media (min-width: $breakpoint-md) {
    display: none !important;
  }
}
```

## Icons

### Icon System
```scss
// Icon sizes
.icon-xs { width: 16px; height: 16px; }
.icon-sm { width: 20px; height: 20px; }
.icon-md { width: 24px; height: 24px; }
.icon-lg { width: 32px; height: 32px; }
.icon-xl { width: 40px; height: 40px; }

// Icon colors
.icon-primary { color: $primary-500; }
.icon-secondary { color: $text-secondary; }
.icon-success { color: $success; }
.icon-warning { color: $warning; }
.icon-error { color: $error; }

// Icon usage
.icon-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: transparent;
  transition: background 0.2s ease;
  
  &:hover {
    background: $gray-100;
  }
}
```

## Animation

### Transitions
```scss
// Timing functions
$ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
$ease-out: cubic-bezier(0, 0, 0.2, 1);
$ease-in: cubic-bezier(0.4, 0, 1, 1);

// Duration scale
$duration-75: 75ms;
$duration-100: 100ms;
$duration-150: 150ms;
$duration-200: 200ms;
$duration-300: 300ms;
$duration-500: 500ms;
$duration-700: 700ms;
$duration-1000: 1000ms;

// Common transitions
.transition-all {
  transition: all $duration-200 $ease-in-out;
}

.transition-opacity {
  transition: opacity $duration-150 $ease-in-out;
}

.transition-transform {
  transition: transform $duration-200 $ease-in-out;
}
```

### Animations
```scss
// Keyframes
@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-25%); }
}

@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slide-up {
  from { transform: translateY(10px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

// Animation classes
.animate-spin {
  animation: spin 1s linear infinite;
}

.animate-pulse {
  animation: pulse 2s $ease-in-out infinite;
}

.animate-bounce {
  animation: bounce 1s infinite;
}

.animate-fade-in {
  animation: fade-in $duration-300 $ease-out;
}

.animate-slide-up {
  animation: slide-up $duration-300 $ease-out;
}
```

## Patterns

### Loading States
```html
<!-- Skeleton loader -->
<div class="skeleton">
  <div class="skeleton-line"></div>
  <div class="skeleton-line skeleton-line-short"></div>
  <div class="skeleton-line"></div>
</div>

<style>
.skeleton-line {
  height: 12px;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 4px;
  margin-bottom: 8px;
}

.skeleton-line-short {
  width: 60%;
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
</style>
```

### Empty States
```html
<div class="empty-state">
  <img src="empty-illustration.svg" alt="No data" class="empty-image">
  <h3 class="empty-title">No results found</h3>
  <p class="empty-description">Try adjusting your search or filter to find what you're looking for.</p>
  <button class="btn-primary">Clear filters</button>
</div>

<style>
.empty-state {
  text-align: center;
  padding: 48px 24px;
}

.empty-image {
  width: 200px;
  height: 200px;
  margin: 0 auto 24px;
  opacity: 0.5;
}

.empty-title {
  margin-bottom: 8px;
  color: #424242;
}

.empty-description {
  color: #757575;
  margin-bottom: 24px;
}
</style>
```

## Component Library

### Implementation Examples
```jsx
// React component example
import React from 'react';
import styles from './Button.module.scss';

const Button = ({
  variant = 'primary',
  size = 'md',
  loading = false,
  disabled = false,
  onClick,
  children,
  ...props
}) => {
  const classNames = [
    styles.btn,
    styles[`btn-${variant}`],
    styles[`btn-${size}`],
    loading && styles['btn-loading'],
  ].filter(Boolean).join(' ');

  return (
    <button
      className={classNames}
      disabled={disabled || loading}
      onClick={onClick}
      {...props}
    >
      {children}
    </button>
  );
};

export default Button;
```

---
*Last Updated: [Date]*  
*Design System Version: 2.0*  
*Maintained By: Design Team*