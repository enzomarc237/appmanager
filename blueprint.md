# AppManager Blueprint

## Overview

This document outlines the development plan and feature implementation for AppManager, a macOS application built with Flutter to help users identify and manage unused applications.

## Implemented Features (as of current version)

*   **Project Setup & Architecture:**
    *   Basic Flutter project structure with clean architecture (`data`, `domain`, `presentation`, `models`).
    *   Core dependencies added (`flutter_riverpod`, `sqflite`, `google_fonts`, `path`).
    *   Basic UI shell with a `MaterialApp`, placeholder home screen, and Riverpod for state management.
    *   Light and dark themes implemented as per UI mockups, using `google_fonts`.
    *   "First Launch" empty state UI created.

*   **Application Discovery:**
    *   Implemented native macOS code to discover installed applications using Method Channels.
    *   Defined `AppEntity` model to represent application data.
    *   Created `ApplicationDiscoveryService` to handle the logic.
    *   Integrated the service with the UI using Riverpod, allowing for a "scan" that displays real application data.

*   **Database Caching:**
    *   Set up an SQLite database to cache application metadata.
    *   The app now loads data from the database on subsequent launches, improving performance.
    *   Added a "Clear Cache" option to force a full rescan.

*   **Application List & UI:**
    *   Created an `AppListView` to display the list of applications.
    *   Refactored UI components (`EmptyState`, `AppListItem`, `DetailRow`) for better code organization.
    *   Implemented a color-coded indicator on list items to show how recently an app was launched (Red: >1 year, Orange: 6-12 months, Yellow: 3-6 months, Green: <3 months).

*   **Sorting & Filtering:**
    *   Implemented sorting by name, size, creation date, modification date, and last launched date.
    *   Added a sort menu with visual indicators for the current sort field and direction.
    *   Implemented a search bar to filter applications by name.

*   **Application Details & Uninstallation:**
    *   Created a detailed application view showing all extracted metadata.
    *   Implemented uninstallation functionality to move applications to the macOS Trash.
    *   Added a confirmation dialog to prevent accidental uninstallation.

---

## Completed Sprints

### Sprint 1: Project Setup & Architecture
**Status: ✅ Completed**
- Established the foundational structure, dependencies, theming, and basic UI shell.

### Sprint 2: Application Discovery
**Status: ✅ Completed**
- Implemented the `AppEntity` model and `ApplicationDiscoveryService`.
- Replaced the initial mock service with a real implementation using native Swift code to find applications.
- Set up SQLite database for caching application data.

### Sprint 3: Metadata & Sorting
**Status: ✅ Completed**
- Implemented robust sorting for the application list based on various criteria.
- Added a search/filter feature to the main UI.

### Sprint 4: Uninstallation & UI Refinement
**Status: ✅ Completed**
- Implemented the "Move to Trash" functionality via native code.
- Added a confirmation dialog for uninstallation.
- Developed the detailed application view.

### Sprint 5: Testing & Optimization
**Status: ✅ Completed**
- Refactored UI code into smaller, more manageable widgets (`EmptyState`, `AppListItem`, `DetailRow`) to improve maintainability.

### Sprint 6: Release Preparation
**Status: ✅ Completed**
- Performed final UI polishing, including adding a sort direction indicator and color-coded launch status indicators to the app list.

---

The project is now feature-complete based on the MVP requirements outlined in the project documentation.
