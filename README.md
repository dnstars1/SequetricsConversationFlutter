
# Sequetrics Conversation (Flutter)

This repository now contains a Flutter implementation of the Sequetrics Conversation experience.  
It mirrors the original React/Vite prototype with equivalent navigation and screen flows:

- `Login` → main entry point
- `Dashboard` with quick actions
- `Upload` workflow that simulates analysis progress
- `Analysis` details screen (parameterised as `/analysis/:id`)
- `History` list with search and drill-down
- `Settings` panel with toggles and dropdowns

## Getting Started

1. [Install Flutter](https://docs.flutter.dev/get-started/install) (3.2.0 or later recommended).
2. Fetch packages:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

The default entry point is `lib/main.dart`. Named routes (`/`, `/dashboard`, `/upload`, `/analysis/<id>`, `/history`, `/settings`) match the original web application. To simulate an analysis completion, open `Upload` and start an analysis—the app transitions to `Analysis` when the mock progress bar completes.
  