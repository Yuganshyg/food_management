
# Food Management – Flutter

## Overview
A Food Management module built using Flutter, strictly following the provided SVG/Figma UI.
The app demonstrates clean architecture, BLoC state management, and JSON-based mock data.

## Features
- Meal Plan creation & editing
- Menu view with meals
- Meal tracking (veg / non-veg counts)
- Feedback module with SVG-matched UI
- Dark mode support
- JSON-based mock backend

## State Management
BLoC pattern is used to:
- Separate UI and business logic
- Maintain scalability
- Ensure predictable state changes

## Project Structure
lib/
 ├── bloc/
 ├── data/
 │   ├── models/
 │   ├── repository/
 ├── presentation/
 │   ├── screens/
 │   ├── widgets/
 ├── core/

## Mock Data
Data is loaded from:
assets/data/meal_data.json

## APK
APK is available at the link provided below.

## Notes
- No backend is used (as per assignment)
- All UI strictly follows provided SVG designs

