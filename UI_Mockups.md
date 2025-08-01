# UI Mockups: AppManager

## Main Interface Layout

### Header Section
- **App Logo & Name:** Top-left corner
- **Search Bar:** Center-top, expandable
- **Action Buttons:** 
  - Refresh scan
  - Settings/preferences
  - Help/info
- **Sort Controls:** Dropdown menu for selecting sort criteria
  - Last Launched (default)
  - Size
  - Name
  - Creation Date
  - Modified Date
- **View Toggle:** List view / Grid view option

### Main Content Area

#### List View (Default)
- **Column Headers:**
  - Application Icon
  - Name
  - Size
  - Last Launched
  - Created Date
  - Modified Date
  - Actions
- **List Items:**
  - Application icon (48×48px)
  - Application name (primary text)
  - Application size (formatted with appropriate units)
  - Last launched date (relative time format, e.g., "3 months ago")
  - Creation date (short date format)
  - Modified date (short date format)
  - Action button (uninstall/more options)
- **Visual Indicators:**
  - Color-coding based on last launch date
    - Red: Not launched in >1 year
    - Orange: Not launched in 6-12 months
    - Yellow: Not launched in 3-6 months
  - Size visualization (subtle bar or circle indicator)

#### Grid View (Alternative)
- **Card Layout:**
  - Application icon (96×96px)
  - Application name
  - Last launched date
  - Size information
  - Quick action button (uninstall)
- **Cards arranged in a responsive grid (3-5 columns depending on window size)**

### Status Bar
- **Total Apps:** Count of discovered applications
- **Total Size:** Cumulative size of all applications
- **Scan Status:** Last scan timestamp
- **Available Disk Space:** System disk space information

## Detail View
Appears when an application is selected:

### Application Header
- **Large Application Icon:** 128×128px
- **Application Name:** Large, prominent text
- **Bundle Identifier:** Smaller text below name
- **Version:** Application version information

### Metadata Section
- **Location:** Full path to application
- **Size:** Detailed breakdown (application, supporting files, cache)
- **Dates:**
  - Created
  - Modified
  - Last Launched
  - First Discovered by AppManager
- **Usage Statistics:** (if available)
  - Launch frequency
  - Usage duration

### Action Panel
- **Primary Actions:**
  - Uninstall (Move to Trash)
  - Open Application
- **Secondary Actions:**
  - Show in Finder
  - Permanently Delete (with warning)
  - Exclude from future scans

## Uninstallation Flow

### Confirmation Dialog
- **Application Icon & Name**
- **Warning Message:** "Are you sure you want to uninstall [App Name]?"
- **Size Information:** "This will free up [size] of disk space"
- **Options:**
  - Move to Trash (default)
  - Delete Permanently (requires additional confirmation)
  - Cancel

### Progress Indicator
- **Progress Bar:** For larger applications
- **Status Message:** "Moving [App Name] to Trash..."

### Completion Notification
- **Success Message:** "[App Name] has been moved to Trash"
- **Space Reclaimed:** "Freed up [size] of disk space"
- **Undo Option:** Button to restore from Trash

## Settings Dialog

### General Settings
- **Scan Locations:** Customizable list of directories to scan
- **Startup Behavior:** Scan on startup option
- **Appearance:** Light/Dark/System theme selection

### Advanced Settings
- **Metadata Caching:** Enable/disable and clear cache
- **System Applications:** Show/hide system applications
- **File Size Calculation:** Include/exclude specific associated files

## Empty States

### First Launch
- **Welcome Message:** "Welcome to AppManager"
- **Explanation:** Brief description of the app's purpose
- **Primary Action:** "Scan for Applications" button
- **Illustration:** Simple graphic showing the app's functionality

### No Results (After Filtering)
- **Message:** "No applications match your search"
- **Suggestion:** "Try adjusting your filters or search terms"
- **Action:** "Reset Filters" button

## Responsive Design Considerations

### Window Resizing
- **Minimum Window Size:** 800×600px
- **Optimal Window Size:** 1200×800px
- **Column Visibility:** Progressive disclosure of columns based on width
  - Essential columns always visible (Icon, Name, Last Launched, Size)
  - Secondary columns appear as space allows

### Compact Mode
For smaller window sizes:
- **Condensed Header:** Combined search and actions
- **Simplified List Items:** Show only essential metadata
- **Expandable Rows:** Click to show additional details inline

## Color Scheme & Visual Design

### Light Mode
- **Background:** White (#FFFFFF)
- **Primary Elements:** Blue (#0071E3)
- **Text:** Dark gray (#333333)
- **Accent Elements:** Various blues for interactive elements
- **Status Indicators:**
  - Red: #FF3B30
  - Orange: #FF9500
  - Yellow: #FFCC00
  - Green: #34C759

### Dark Mode
- **Background:** Dark gray (#1E1E1E)
- **Primary Elements:** Light blue (#0A84FF)
- **Text:** Light gray (#E5E5E5)
- **Accent Elements:** Various blues for interactive elements
- **Status Indicators:** Same as light mode but slightly adjusted for contrast

## Typography
- **Primary Font:** SF Pro (System font)
- **Headings:** SF Pro Display, Medium
- **Body Text:** SF Pro Text, Regular
- **Monospaced Text:** SF Mono (for paths and technical information)

## Animations & Transitions

### List Sorting
- Smooth reordering animation when changing sort criteria

### Detail View
- Slide-in transition from the right side

### Uninstallation
- Fade-out animation for removed applications

## Accessibility Features

### Keyboard Navigation
- Full keyboard control of all functions
- Keyboard shortcuts for common actions

### Screen Reader Support
- Proper labeling of all UI elements
- Meaningful announcements for state changes

### Visual Accessibility
- Support for system text size adjustments
- High-contrast mode compatibility