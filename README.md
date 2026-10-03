# Pawly

A Flutter companion for people caring for one or several pets. Pawly organizes daily care, health history, veterinary visits, weight records, personal memories, and emergency contacts on the current device.

## Run

```sh
flutter pub get
flutter run
```

For the browser preview:

```sh
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5173
```

Choose **Demo Enter** to explore example pets Maple, Cleo, and Finn. A personal profile starts with an empty pet collection. Existing personal records are preserved when exploring the demo.

## Everyday features

- Multiple pet profiles, personality details, allergies, and optional personal photo URLs.
- Daily care checklist with dated completions, recurrence, category filters, and calendar browsing.
- Today / Upcoming / Completed reminders across the pet family, including booster dates and veterinary visits.
- Health events, owner observation notes, vaccine records, and prescribed medication notes.
- Veterinary appointments and a saved preparation checklist.
- Weight history with a chart and chronological records.
- Memories and a combined timeline of health, vaccination, weight, and personal moments.
- Document metadata notes, per-pet emergency details, and copyable emergency / lost-pet information.
- Saved caregiver contacts and universal record search.
- Persistent light, dark, or system appearance and local owner name.

## Design

Black-and-white is the default: white canvas, black actions, soft gray surfaces, and charcoal dark mode. Users may choose Lavender, Ocean Blue, or Rose accents in Settings, independently of light/dark/system appearance. Both choices persist. Pet photography stays in natural color against neutral backgrounds. Images use contain sizing to show the entire source photograph. Square frames on home and pet collections match the bundled portraits, preventing side bars. The home has a prominent photograph and a separate caption, and pet profiles reserve space for back navigation.

The lightweight paw splash respects reduced-motion settings. Interactive onboarding demonstrates choosing a companion and completing daily care. Shared buttons await asynchronous actions, prevent repeated submission, and provide failure feedback.

## Storage and scope

`PawlyRepository` coordinates the existing models and `AppDatabase`. Mobile platforms use SQLite; web uses SharedPreferences JSON storage. Extra local records and appearance preferences use SharedPreferences. No new dependencies were added.

This is a local application. It does **not** provide remote authentication, account recovery emails, cloud sync, shared caregiver accounts, OS notification delivery, PDF uploads, public lost-pet broadcasts, or real shelter applications. Corresponding tools explain their actual local behavior. Adoption listings are examples; vaccine records are owner-entered, not a certified medical passport. Medication schedules are recorded as prescribed, not generated medical advice.

The `src/` React/Vite frontend and `Project_final/` Java console project are legacy implementations kept in the repository. This improvement targets the Flutter application in `lib/`.

## Verification

```sh
flutter analyze
flutter test
```

Tests cover recurrence, dated completion persistence, data preservation, emergency record isolation, weight ordering, vaccine status, navigation, asynchronous save feedback, keyboard layout, and all 29 Flutter screens at a 320px width in both appearances. Native device QA is still needed before release.

Generated sample portraits are bundled under `assets/pets/`. See `assets/pets/ASSET_MANIFEST.md` for creation details.
