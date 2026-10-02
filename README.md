# Pawly — Dedicated Mobile Companion for Pets & Their Humans 🐾

Pawly is a production-quality, mobile-first pet care and digital health passport application built with **Flutter 3.24.3** & **Dart 3.5.3**.

Rethought from the ground up from the legacy web dashboard into an intimate, warm companion mobile application. Inspired by the editorial elegance, confident typography, full-width photography, and tactile visual cards of modern mobile design references (*Box Box Club*), Pawly creates an original visual identity with deep forest greens, warm clays, creamy tones, and human typography.

---

## 📱 Core Features & User Flows

1. **Splash Screen**: Warm, branded entrance with instant reactivity.
2. **Visual Onboarding**: 3-step editorial walkthrough exploring daily care flow, clinical passport, and emotional companionship.
3. **Authentication & Quick Portfolio Demo**: Focused Login, Registration, and Forgot Password screens with a 1-tap **"Demo Enter"** button for immediate testing.
4. **"Who are we caring for?" (Add Pet)**: Expressive multi-species onboarding (Dog, Cat, Rabbit, Bird, etc.) capturing age, weight, microchip, allergies, and photography.
5. **Personalized Home Experience**:
   - Hero active pet card with status and passport shortcut.
   - Interactive pet switcher ribbon across all family pets.
   - **Today's Care Agenda**: Chronological timeline of feeding, walks, and medications with checkable completions.
   - **Next Vet Visit Hero Card**: Urgent countdown, appointment notes, and direct shortcut to the pre-visit checklist.
   - **Lately Updates Feed**: Dynamic summary tiles highlighting recent weights, vaccine due dates, and new milestones.
6. **My Pets Collection**: Visual photo-forward grid of all pets with quick access to their individual Pet Spaces.
7. **Pet Space (Digital Passport)**: Multi-tab passport covering:
   - **About**: Breed, microchip, biological age, registered weight, allergies, and temperament.
   - **Care**: Recurring routine management by category.
   - **Health**: Chronological veterinary clinical history and procedural events.
   - **Passport**: Certified vaccination statuses (Current, Due Soon, Overdue).
   - **Growth**: Weight tracking curve and weigh-in logging.
   - **Wallet**: Digital clinical document organizer.
8. **Care Agenda & Routine Management**: Create custom routines with categories (Medication, Feeding, Exercise, Grooming, Vaccination, Water), times, priorities, and recurrence.
9. **Health Story Timeline & Logging**: Log clinical checkups, dental cleanings, surgeries, and observations with vet name and clinic attribution.
10. **Weight & Growth Tracking**: Custom Canvas-rendered continuous curve painter with min/max bounds, delta indicators, and history logs.
11. **Vaccination Passport**: Color-coded status badges, administering vet/clinic details, and expiration tracking.
12. **Medication Tracker**: Prescription dosage instructions, daily frequencies, and active/completed states.
13. **Vet Visit Prep Checklist**: Pre-appointment symptom tracking, behavioral reminders, and questions checklist for veterinarian consultations.
14. **Memories & Milestones**: Chronological photo journal preserving milestones, adoption days, and outdoor adventures.
15. **Document Wallet**: Categorized PDF and clinical test organizer (Vaccines, Lab Results, Prescriptions, Insurance, Registration).
16. **Emergency Pet Card**: High-contrast, instantly readable emergency card featuring primary contacts, preferred clinic 24/7 line, and critical notes.
17. **Lost Pet Mode**: Generates an urgent, shareable rescue poster and broadcast alert with microchip and emergency contact information.
18. **Adopt & Foster Discovery**: Dedicated browsing feed for shelter and foster pets (Barnaby, Buster, etc.) with meet-and-greet inquiry modals.
19. **Family & Caregiver Shared Care**: Invite co-owners, pet sitters, or dog walkers into a shared care pack with configurable alert preferences.

---

## 🎨 Design System & Palette

- **Ivory Cream Canvas**: `#FAF7F2` (`PawlyColors.creamBg` / `PawlyColors.background`)
- **Deep Espresso**: `#1E1A18` (`PawlyColors.espresso`)
- **Forest Green**: `#2D5742` (`PawlyColors.forest`) & `#E9F2ED` (`PawlyColors.forestLight`)
- **Warm Clay**: `#C0593B` (`PawlyColors.clay`) & `#FBEFEB` (`PawlyColors.clayLight`)
- **Warm Honey / Amber**: `#B57722` (`PawlyColors.honey`) & `#FDF5E9` (`PawlyColors.honeyLight`)
- **Slate Blue**: `#486E85` (`PawlyColors.slate`)
- **Alert Rose**: `#B83A3A` (`PawlyColors.rose`)

---

## 🏗️ Architecture & Project Structure

```
lib/
├── main.dart                      # Root application widget & routing state machine
├── models/
│   ├── care_routine.dart          # Care routine & category models
│   ├── models.dart                # Health, Weight, Vaccines, Meds, Appts, Memories, Docs, Emergency
│   └── pet.dart                   # Core Pet data entity with JSON serialization
├── navigation/
│   └── bottom_nav_bar.dart        # 5-tab native bottom navigation bar
├── repositories/
│   ├── pawly_repository.dart      # Reactive ChangeNotifier store with SharedPreferences persistence
│   └── sample_data.dart           # Realistic seeded data for Mochi, Luna, Milo, Barnaby, Buster
├── screens/
│   ├── adoption/                  # Adopt & Foster discovery feed + inquiry modal
│   ├── appointments/              # Vet visits, add appointment, and pre-visit prep checklist
│   ├── auth/                      # Login, Signup, and Forgot Password screens
│   ├── care/                      # Care agenda & add care routine screen
│   ├── documents/                 # Digital document wallet & document upload
│   ├── emergency/                 # High-contrast emergency card & lost pet mode poster
│   ├── growth/                    # Weight tracking screen with custom trend curve painter
│   ├── health/                    # Health story timeline & event logging
│   ├── home/                      # Editorial hero home screen & lately updates
│   ├── medication/                # Active prescription manager
│   ├── memories/                  # Milestones photo feed & memory sheet
│   ├── onboarding/                # 3-slide visual onboarding walkthrough
│   ├── pets/                      # Add pet, My Pets collection, and Pet Space passport
│   ├── profile/                   # Caregiver sharing, settings, and units
│   ├── splash/                    # Warm launch splash screen
│   └── vaccination/               # Digital vaccination passport
├── theme/
│   ├── pawly_colors.dart          # Semantic color tokens
│   ├── pawly_theme.dart           # Material 3 ThemeData configuration
│   └── pawly_typography.dart     # Confident mobile-first typographic scale
└── widgets/
    └── widgets.dart               # Reusable PawlyButton, PawlyBadge, PetAvatar, PetSwitcher, EmptyStateView
```

---

## 🚀 Running the Project Locally

### Prerequisites
- Flutter SDK 3.24+ installed and on your PATH.

### Run on iOS Simulator or Android Emulator
```bash
flutter run
```

### Run on Chrome (Web Preview)
```bash
flutter run -d chrome
```

### Run Automated Tests & Static Analysis
```bash
flutter test
flutter analyze
```
*(Both pass with 0 errors, 0 warnings, and 0 lint issues)*
