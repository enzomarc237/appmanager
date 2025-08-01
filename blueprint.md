# AppManager Blueprint

## Overview

This document outlines the development plan and feature implementation for AppManager, a macOS application built with Flutter to help users identify and manage unused applications.

## Implemented Features (as of current version)

- **Project Setup & Architecture:**
  - Basic Flutter project structure with clean architecture (`data`, `domain`, `presentation`, `models`).
  - Core dependencies added (`flutter_riverpod`, `sqflite`, `google_fonts`, `path`).
  - Basic UI shell with a `MaterialApp`, placeholder home screen, and Riverpod for state management.
  - Light and dark themes implemented as per UI mockups, using `google_fonts`.
  - "First Launch" empty state UI created.
- **Application Discovery (Mock):**
  - Defined `AppEntity` model.
  - Created `ApplicationDiscoveryService` interface.
  - Implemented a mock service returning hardcoded data for UI development.
  - Integrated the service with the UI using Riverpod, allowing for a "scan" that displays mock data.
  - Created a basic `AppListView` to display the list of applications.

---

## Completed Sprints

### Sprint 1: Project Setup & Architecture

This sprint focused on establishing the foundational structure of the application.

**Steps:**

1.  **✅ Create `blueprint.md`:** Document the project plan and track progress.
2.  **✅ Update `pubspec.yaml`:** Add necessary dependencies for state management, database, and theming.
3.  **✅ Create Directory Structure:** Establish a clean architecture.
4.  **✅ Implement Basic UI Shell:** Create the main application entry point with a `MaterialApp` and `HomePage`.
5.  **✅ Implement Theming:** Set up light and dark themes.
6.  **✅ Create Empty State UI:** Design the "First Launch" screen.

---

## Current Development Plan: Sprint 2 - Application Discovery

This sprint focuses on discovering applications and displaying them to the user. The initial implementation uses a mock service to facilitate UI development.

**Steps:**

1.  **✅ Develop Application Metadata Model:** Created the `AppEntity` class in `lib/models`.
2.  **✅ Create Dart Interface for Discovery:** Defined the `ApplicationDiscoveryService` abstract class in `lib/domain`.
3.  **✅ Implement Mock Scanning Functionality:** Created `ApplicationDiscoveryServiceImpl` in `lib/data` that returns a hardcoded list of apps.
4.  **✅ Create Basic List View:** Implemented the `AppListView` widget to display the applications.
5.  **Integrate with UI:** Connect the discovery service to the UI using Riverpod providers, allowing the user to initiate a scan and view the results. (In Progress - needs refinement)
6.  **Set up SQLite Database:** Implement database caching for application data to improve performance on subsequent launches. (Next)
7.  **Implement Native Code for Discovery:** Replace the mock service with actual native macOS code to discover real applications. (Later in the sprint)
