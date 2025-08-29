# Accessibility Guidelines

**Purpose**: Ensure products are usable by people with disabilities and meet accessibility standards.  
**Audience**: Designers, developers, QA, product managers  
**Update Frequency**: Quarterly review, immediate for standard updates

## Accessibility Principles

### Core Principles (POUR)
1. **Perceivable**: Information must be presentable in ways users can perceive
2. **Operable**: Interface components must be operable
3. **Understandable**: Information and UI operation must be understandable
4. **Robust**: Content must be robust enough for various assistive technologies

### Compliance Standards
| Standard | Level | Requirement | Applies To |
|----------|-------|-------------|------------|
| **WCAG 2.1** | AA | Required | All digital products |
| **Section 508** | Revised | Required for government | Government contracts |
| **ADA** | Title III | Required | Public-facing websites |
| **EN 301 549** | - | Required in EU | European market |

## Visual Accessibility

### Color & Contrast

#### Contrast Ratios
| Element Type | Normal Text | Large Text | Graphics | Required Ratio |
|-------------|-------------|------------|----------|----------------|
| **Level AA** | < 18pt | ≥ 18pt | UI components | 4.5:1 / 3:1 / 3:1 |
| **Level AAA** | < 18pt | ≥ 18pt | UI components | 7:1 / 4.5:1 / 3:1 |

#### Color Testing Tools
```javascript
// Contrast ratio calculation
function getContrastRatio(color1, color2) {
  const lum1 = getRelativeLuminance(color1);
  const lum2 = getRelativeLuminance(color2);
  
  const lighter = Math.max(lum1, lum2);
  const darker = Math.min(lum1, lum2);
  
  return (lighter + 0.05) / (darker + 0.05);
}

// Check if contrast meets WCAG AA
function meetsWCAG_AA(ratio, isLargeText = false) {
  return isLargeText ? ratio >= 3 : ratio >= 4.5;
}
```

#### Color Usage Guidelines
- Never use color as the only means of conveying information
- Provide text labels or patterns in addition to color
- Ensure error states use more than just red color
- Test with color blindness simulators

### Typography

#### Readable Fonts
```css
/* Accessible font stack */
.accessible-text {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 
               'Helvetica Neue', Arial, sans-serif;
  font-size: 16px; /* Minimum base size */
  line-height: 1.5; /* Minimum line height */
  letter-spacing: 0.02em; /* Slight spacing for readability */
}

/* Avoid these practices */
.bad-practice {
  font-size: 12px; /* Too small */
  line-height: 1; /* Too tight */
  text-transform: uppercase; /* Harder to read */
  font-style: italic; /* Use sparingly */
}
```

#### Text Spacing Requirements
- Line height: At least 1.5× font size
- Paragraph spacing: At least 2× font size
- Letter spacing: At least 0.12× font size
- Word spacing: At least 0.16× font size

### Focus Indicators

#### Visible Focus Styles
```css
/* Good focus indicator */
:focus {
  outline: 2px solid #2196F3;
  outline-offset: 2px;
  box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.25);
}

/* Never remove focus indicators without replacement */
:focus {
  outline: none; /* ❌ Bad - no alternative provided */
}

/* Custom focus indicator */
.custom-focus:focus {
  outline: none; /* Remove default */
  border: 2px solid #2196F3; /* Add custom */
  box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.25);
}

/* Focus visible only for keyboard users */
.button:focus-visible {
  outline: 2px solid #2196F3;
}
```

## Keyboard Navigation

### Keyboard Support Requirements

#### Essential Keyboard Interactions
| Key | Action | Component |
|-----|--------|-----------|
| **Tab** | Move forward | All interactive elements |
| **Shift + Tab** | Move backward | All interactive elements |
| **Enter** | Activate | Buttons, links |
| **Space** | Toggle/Activate | Checkboxes, buttons |
| **Arrow Keys** | Navigate | Menus, tabs, selects |
| **Escape** | Close/Cancel | Modals, dropdowns |
| **Home/End** | First/Last | Lists, menus |

#### Skip Links
```html
<!-- Skip to main content link -->
<a href="#main" class="skip-link">Skip to main content</a>

<style>
.skip-link {
  position: absolute;
  left: -10000px;
  width: 1px;
  height: 1px;
  overflow: hidden;
}

.skip-link:focus {
  position: fixed;
  top: 0;
  left: 0;
  width: auto;
  height: auto;
  padding: 8px 16px;
  background: #000;
  color: #fff;
  z-index: 10000;
}
</style>
```

#### Tab Order
```html
<!-- Logical tab order -->
<header tabindex="0">Header</header>
<nav tabindex="0">Navigation</nav>
<main tabindex="0">
  <button>First Button</button> <!-- tabindex="0" by default -->
  <button>Second Button</button>
  <button tabindex="-1">Skip this button</button> <!-- Removed from tab order -->
  <button>Third Button</button>
</main>

<!-- Never use positive tabindex -->
<button tabindex="1">Bad Practice</button> <!-- ❌ Avoid -->
```

### Custom Components

#### Accessible Dropdown
```javascript
class AccessibleDropdown {
  constructor(element) {
    this.element = element;
    this.button = element.querySelector('.dropdown-button');
    this.menu = element.querySelector('.dropdown-menu');
    this.items = element.querySelectorAll('.dropdown-item');
    
    this.init();
  }
  
  init() {
    // ARIA attributes
    this.button.setAttribute('aria-expanded', 'false');
    this.button.setAttribute('aria-haspopup', 'true');
    this.menu.setAttribute('role', 'menu');
    
    this.items.forEach(item => {
      item.setAttribute('role', 'menuitem');
      item.setAttribute('tabindex', '-1');
    });
    
    // Event listeners
    this.button.addEventListener('click', () => this.toggle());
    this.button.addEventListener('keydown', (e) => this.handleButtonKeydown(e));
    this.menu.addEventListener('keydown', (e) => this.handleMenuKeydown(e));
  }
  
  toggle() {
    const isOpen = this.button.getAttribute('aria-expanded') === 'true';
    this.button.setAttribute('aria-expanded', !isOpen);
    this.menu.hidden = isOpen;
    
    if (!isOpen) {
      this.items[0].focus();
    }
  }
  
  handleButtonKeydown(e) {
    switch(e.key) {
      case 'Enter':
      case ' ':
      case 'ArrowDown':
        e.preventDefault();
        this.toggle();
        break;
      case 'Escape':
        this.close();
        break;
    }
  }
  
  handleMenuKeydown(e) {
    const currentIndex = Array.from(this.items).indexOf(document.activeElement);
    
    switch(e.key) {
      case 'ArrowDown':
        e.preventDefault();
        this.focusItem((currentIndex + 1) % this.items.length);
        break;
      case 'ArrowUp':
        e.preventDefault();
        this.focusItem((currentIndex - 1 + this.items.length) % this.items.length);
        break;
      case 'Home':
        e.preventDefault();
        this.focusItem(0);
        break;
      case 'End':
        e.preventDefault();
        this.focusItem(this.items.length - 1);
        break;
      case 'Escape':
        this.close();
        this.button.focus();
        break;
    }
  }
  
  focusItem(index) {
    this.items[index].focus();
  }
  
  close() {
    this.button.setAttribute('aria-expanded', 'false');
    this.menu.hidden = true;
  }
}
```

## Screen Reader Support

### ARIA Labels & Descriptions

#### Proper ARIA Usage
```html
<!-- Descriptive labels -->
<button aria-label="Close dialog">✕</button>
<button aria-label="Search">🔍</button>

<!-- Described by -->
<input 
  type="password" 
  aria-describedby="password-help"
  aria-invalid="true"
  aria-errormessage="password-error"
>
<span id="password-help">Must be at least 8 characters</span>
<span id="password-error" role="alert">Password is too short</span>

<!-- Live regions -->
<div aria-live="polite" aria-atomic="true">
  <p>Form saved successfully</p>
</div>

<div aria-live="assertive" role="alert">
  <p>Error: Unable to save</p>
</div>

<!-- Landmark roles -->
<header role="banner">Site Header</header>
<nav role="navigation">Main Navigation</nav>
<main role="main">Main Content</main>
<aside role="complementary">Sidebar</aside>
<footer role="contentinfo">Site Footer</footer>
```

#### Screen Reader Only Content
```css
/* Visually hidden but screen reader accessible */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* Usage */
<span class="sr-only">Loading, please wait...</span>
<span aria-hidden="true">🔄</span> <!-- Hide decorative icon from SR -->
```

### Semantic HTML

#### Proper HTML Structure
```html
<!-- Use semantic elements -->
<nav>
  <ul>
    <li><a href="/">Home</a></li>
    <li><a href="/about">About</a></li>
  </ul>
</nav>

<!-- Proper heading hierarchy -->
<h1>Page Title</h1>
  <h2>Section Title</h2>
    <h3>Subsection Title</h3>
    <h3>Another Subsection</h3>
  <h2>Another Section</h2>

<!-- Form structure -->
<form>
  <fieldset>
    <legend>Personal Information</legend>
    
    <label for="name">Name (required)</label>
    <input type="text" id="name" name="name" required aria-required="true">
    
    <label for="email">Email (required)</label>
    <input type="email" id="email" name="email" required aria-required="true">
  </fieldset>
  
  <button type="submit">Submit</button>
</form>

<!-- Table structure -->
<table>
  <caption>Monthly Sales Report</caption>
  <thead>
    <tr>
      <th scope="col">Month</th>
      <th scope="col">Sales</th>
      <th scope="col">Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">January</th>
      <td>150</td>
      <td>$15,000</td>
    </tr>
  </tbody>
</table>
```

## Forms & Inputs

### Accessible Form Design

#### Label Association
```html
<!-- Explicit label -->
<label for="username">Username</label>
<input type="text" id="username" name="username">

<!-- Implicit label (less flexible) -->
<label>
  Email
  <input type="email" name="email">
</label>

<!-- Multiple labels -->
<label for="month">Expiration Date</label>
<select id="month" aria-label="Expiration month">
  <option>01 - January</option>
</select>

<!-- Required fields -->
<label for="password">
  Password <span aria-label="required">*</span>
</label>
<input 
  type="password" 
  id="password" 
  required 
  aria-required="true"
>
```

#### Error Handling
```html
<!-- Accessible error messages -->
<div class="form-group">
  <label for="email">Email</label>
  <input 
    type="email" 
    id="email"
    aria-invalid="true"
    aria-describedby="email-error"
  >
  <span id="email-error" role="alert" class="error">
    Please enter a valid email address
  </span>
</div>

<!-- Form validation summary -->
<div role="alert" aria-live="assertive">
  <h2>There were 3 errors in your form submission:</h2>
  <ul>
    <li><a href="#email">Email is required</a></li>
    <li><a href="#password">Password is too short</a></li>
    <li><a href="#terms">You must accept the terms</a></li>
  </ul>
</div>
```

#### Input Types & Attributes
```html
<!-- Use appropriate input types -->
<input type="email" autocomplete="email">
<input type="tel" autocomplete="tel">
<input type="url" autocomplete="url">
<input type="date" min="2024-01-01" max="2024-12-31">

<!-- Autocomplete for better UX -->
<input type="text" name="name" autocomplete="name">
<input type="text" name="street" autocomplete="street-address">
<input type="text" name="city" autocomplete="address-level2">
<input type="text" name="state" autocomplete="address-level1">
<input type="text" name="zip" autocomplete="postal-code">
```

## Media Accessibility

### Images

#### Alt Text Guidelines
```html
<!-- Informative images -->
<img src="chart.png" alt="Sales increased 25% from 2023 to 2024">

<!-- Decorative images -->
<img src="decoration.png" alt="" role="presentation">

<!-- Complex images -->
<figure>
  <img src="complex-diagram.png" alt="System architecture diagram">
  <figcaption>
    Detailed description: The system consists of three layers...
    <a href="full-description.html">View full text description</a>
  </figcaption>
</figure>

<!-- Images of text (avoid when possible) -->
<img src="logo.png" alt="Company Name">
```

### Videos

#### Video Accessibility Requirements
```html
<video controls>
  <source src="video.mp4" type="video/mp4">
  
  <!-- Captions -->
  <track kind="captions" src="captions-en.vtt" srclang="en" label="English" default>
  <track kind="captions" src="captions-es.vtt" srclang="es" label="Español">
  
  <!-- Audio descriptions -->
  <track kind="descriptions" src="descriptions-en.vtt" srclang="en" label="English">
  
  <!-- Fallback content -->
  <p>Your browser doesn't support HTML5 video. 
     <a href="video.mp4">Download the video</a>.</p>
</video>

<!-- Transcript link -->
<a href="transcript.html">View transcript</a>
```

### Audio

#### Audio Controls
```html
<audio controls>
  <source src="podcast.mp3" type="audio/mpeg">
  <p>Your browser doesn't support HTML5 audio.
     <a href="podcast.mp3">Download the audio</a>.</p>
</audio>

<!-- Provide transcript -->
<details>
  <summary>Transcript</summary>
  <div class="transcript">
    [Full transcript of audio content]
  </div>
</details>
```

## Mobile Accessibility

### Touch Target Guidelines
```css
/* Minimum touch target size */
.touch-target {
  min-width: 44px;  /* iOS recommendation */
  min-height: 44px;
  /* or */
  min-width: 48px;  /* Material Design */
  min-height: 48px;
}

/* Spacing between targets */
.touch-target + .touch-target {
  margin-left: 8px; /* Minimum spacing */
}
```

### Mobile Screen Reader Support
```html
<!-- iOS VoiceOver hints -->
<button 
  aria-label="Delete item"
  aria-hint="Double tap to delete this item permanently"
>
  🗑️
</button>

<!-- Android TalkBack -->
<button 
  aria-label="Menu"
  aria-describedby="menu-hint"
>
  ☰
</button>
<span id="menu-hint" class="sr-only">
  Double tap to open navigation menu
</span>
```

## Testing & Validation

### Automated Testing

#### Testing Tools
```javascript
// Axe-core integration
import axe from 'axe-core';

async function runAccessibilityTest() {
  const results = await axe.run();
  
  if (results.violations.length > 0) {
    console.error('Accessibility violations found:');
    results.violations.forEach(violation => {
      console.error(`${violation.impact}: ${violation.description}`);
      violation.nodes.forEach(node => {
        console.error(`  - ${node.target}`);
      });
    });
  }
}

// Jest test example
describe('Accessibility Tests', () => {
  it('should have no accessibility violations', async () => {
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });
});
```

### Manual Testing Checklist

#### Keyboard Testing
- [ ] Can reach all interactive elements with Tab
- [ ] Can activate all buttons with Enter/Space
- [ ] Can navigate menus with arrow keys
- [ ] Can close modals with Escape
- [ ] Focus indicator is always visible
- [ ] Tab order is logical
- [ ] No keyboard traps

#### Screen Reader Testing
- [ ] All images have appropriate alt text
- [ ] Form labels are properly associated
- [ ] Error messages are announced
- [ ] Page structure uses proper headings
- [ ] Dynamic content updates are announced
- [ ] Tables have proper headers
- [ ] Links have descriptive text

#### Visual Testing
- [ ] Text has sufficient contrast
- [ ] Focus indicators are visible
- [ ] Errors use more than color
- [ ] Content reflows at 200% zoom
- [ ] No horizontal scrolling at 320px width

### Browser & Assistive Technology Support

#### Testing Matrix
| Platform | Screen Reader | Browser | Priority |
|----------|--------------|---------|----------|
| Windows | NVDA | Chrome/Firefox | High |
| Windows | JAWS | Chrome/Edge | High |
| macOS | VoiceOver | Safari | High |
| iOS | VoiceOver | Safari | High |
| Android | TalkBack | Chrome | High |
| Windows | Narrator | Edge | Medium |

## Resources

### Tools
- **WAVE**: WebAIM's evaluation tool
- **axe DevTools**: Browser extension
- **Lighthouse**: Chrome DevTools audit
- **NVDA**: Free Windows screen reader
- **Color Oracle**: Color blindness simulator

### References
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [ARIA Authoring Practices](https://www.w3.org/TR/wai-aria-practices-1.1/)
- [WebAIM Resources](https://webaim.org/resources/)
- [A11y Project Checklist](https://www.a11yproject.com/checklist/)

### Training
- Screen reader basics
- Keyboard navigation testing
- ARIA best practices
- Accessibility auditing

---
*Last Updated: [Date]*  
*Accessibility Lead: [Name]*  
*Contact: a11y@example.com*