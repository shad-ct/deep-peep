# Deep Peep — Multi-Game Expansion & Bilingual Support

You are working on the existing Flutter project **Deep Peep**.

Repository:
`https://github.com/shad-ct/deep-peep`

Your task is to extend the existing application into a simple multi-game conversation app while preserving the current Deep Peep functionality, visual identity, architecture, and interaction style.

## IMPORTANT — BEFORE MODIFYING CODE

First inspect the entire existing project structure and understand:

* Current Flutter architecture
* Routing/navigation
* State management
* Existing question/game models
* Existing swipe/card implementation
* Favorites/history/ban logic
* Persistence layer
* Theme system
* Existing localization/language implementation
* Existing animations
* Existing reusable widgets
* Existing tests, if any

Do NOT immediately rewrite existing code.

Reuse existing components and patterns wherever possible.

Do not introduce a new state-management solution, navigation framework, database, or localization framework unless the existing architecture genuinely requires it.

The existing Deep Peep game must continue working exactly as it does now.

---

# 1. NEW MAIN NAVIGATION

Add a simple navigation bar to allow the user to switch between four games:

1. Deep Peep
2. Truth or Dare
3. Never Have I Ever
4. This or That / Would You Rather

The navigation should be intentionally simple and minimal.

Recommended structure:

* Bottom navigation bar
* Four destinations
* Icon + short label
* Current selected game clearly indicated
* No unnecessarily complicated navigation hierarchy

Example:

`Deep Peep | Truth or Dare | Never Have I Ever | This or That`

Use appropriate simple icons.

The navigation should feel like one application containing multiple conversation games, not four unrelated applications.

### Navigation requirements

* Switching games must preserve each game's state where appropriate.
* Returning to a game should not unnecessarily reset it.
* Avoid rebuilding the entire application unnecessarily.
* Navigation should work naturally with Android back navigation.
* The existing Deep Peep screen should become the first/main game.
* Keep the navbar visually lightweight.

Do not make the navbar oversized.

---

# 2. TRUTH OR DARE

Add a completely new game called **Truth or Dare**.

## Game flow

When entering Truth or Dare, show a simple choice:

### TRUTH

or

### DARE

The user selects one.

After selection, display a random Truth or Dare prompt.

Example:

Truth:
"What is something you've never told your best friend?"

Dare:
"Send the last person you texted a random emoji."

The exact questions/dares should come from a local dataset.

## Skip / completion behavior

Every Truth/Dare item has three possible states:

* Unseen
* Completed
* Skipped

Once an item has been completed OR skipped, it must not appear again during the current game/session.

This is important:

**NO REPETITION.**

If the user has already seen and completed/skipped:

`Truth #12`

it must not be shown again.

The same applies to dares.

The system should select only from remaining unused items.

When the current pool is exhausted:

Display a simple completion state such as:

"You're out of Truths!"

or

"You're out of Dares!"

with an option to restart/reset that category.

Do not silently repeat questions.

## Truth/Dare controls

Provide simple controls such as:

* Truth
* Dare
* Skip
* Done / Completed
* Next

The exact UI should remain minimal.

For example:

`TRUTH`

[Question]

`Done`     `Skip`

After Done or Skip, remove that item from the available pool.

---

# 3. NEVER HAVE I EVER

Add a new game called:

**Never Have I Ever**

This should use the same general interaction philosophy as the existing Deep Peep game.

## Interaction

Display one statement at a time.

Example:

"Never have I ever lied to get out of plans."

Use the existing Tinder-style swipe/card interaction wherever possible.

Swipe:

* Left → next statement
* Right → previous statement/history if that behavior already exists in Deep Peep
* Up → favorite
* Down → ban

However, adapt the behavior appropriately if some existing Deep Peep actions do not make sense for Never Have I Ever.

The most important requirement is:

**Tinder-style swiping.**

The user should feel that this game belongs to the same product.

## No unnecessary repetition

Never repeatedly show the same statement within the active session.

Track consumed/seen items.

If an item has already been used, don't randomly select it again.

When the available pool is exhausted, show an appropriate completion/reset state.

---

# 4. THIS OR THAT / WOULD YOU RATHER

Add another swipe-based game.

Use the name:

**This or That**

You may use "Would You Rather" as a secondary description if appropriate.

Each card contains two choices.

Example:

### THIS OR THAT

"Live without music"

VS

"Live without movies"

The user swipes Tinder-style to make a choice.

For example:

* Swipe Left → Option A
* Swipe Right → Option B

Clearly communicate which direction corresponds to which answer.

The card can also display two visible choices so that the interaction is understandable even before the user swipes.

Example:

`← LIVE WITHOUT MUSIC`

`LIVE WITHOUT MOVIES →`

The exact visual treatment should be determined based on the existing Deep Peep card design.

## Important

This game should feel interactive rather than simply being a two-button questionnaire.

Use the existing swipe/card physics and animations wherever practical.

---

# 5. LANGUAGE SUPPORT — ENGLISH + MALAYALAM

Add bilingual support for:

* English
* Malayalam

The language system should work across the application.

The existing English content must remain available.

## Language selector

Add a simple language switcher in an appropriate location such as:

* Settings
* App bar
* Menu

Do not make language switching complicated.

Languages:

`English`

`മലയാളം`

When Malayalam is selected, the application should display Malayalam content.

---

# 6. BILINGUAL QUESTION DISPLAY

IMPORTANT:

When Malayalam is selected, do NOT simply replace English completely.

For questions/prompts that have Malayalam translations, display:

### Malayalam first

followed by

### English underneath

Example:

"നിങ്ങളുടെ ഏറ്റവും വലിയ ഭയം എന്താണ്?"

"What is your biggest fear?"

The Malayalam text should be the primary/larger text.

The English translation should appear underneath in a visually secondary style.

This allows Malayalam users to understand the original English meaning while keeping the experience bilingual.

Do NOT show Malayalam and English side-by-side if that makes the card too crowded.

Prefer:

Malayalam

English

---

# 7. TRANSLATE BUTTON

For question/prompt cards, add a small translation control.

The user should be able to toggle between:

`Translate to Malayalam`

and

`Show English`

depending on the current language/state.

For example, if the card is currently displaying English:

[ Translate to Malayalam ]

After pressing:

Malayalam becomes visible.

If Malayalam is already the primary language:

[ Show English ]

The button should be subtle and should not compete with the question itself.

## Important

Do not use an online translation API unless explicitly required.

Prefer storing translations locally with each question.

The app should continue functioning completely offline.

---

# 8. DATA MODEL

Refactor/extend the question data model if necessary to support bilingual content.

A question/prompt should conceptually support:

```text
id
englishText
malayalamText
category/type
game
isFavorite
isBanned
isCompleted
isSkipped
```

Do not blindly use these exact fields if the existing architecture has a better model.

The important concept is that every piece of content can have:

* Stable ID
* English version
* Malayalam version
* Game/category
* User interaction state

For This or That / Would You Rather, support two choices:

```text
optionA
optionB
optionAMalayalam
optionBMalayalam
```

Again, adapt this to the existing architecture rather than duplicating models unnecessarily.

---

# 9. PERSISTENCE

The application is intended to remain offline.

Do not add a backend.

Do not add cloud synchronization.

Persist important user state locally.

At minimum, consider persisting:

* Favorites
* Banned questions
* Used/completed Truths
* Skipped Truths
* Used/completed Dares
* Seen Never Have I Ever statements
* Used This or That questions
* Selected language

Use the existing persistence mechanism in the project.

Do not introduce SQLite/Hive/Isar/etc. if SharedPreferences or the existing persistence system is sufficient.

---

# 10. GAME-SPECIFIC STATE

Do not mix the state of different games.

For example:

A Truth question being completed must not affect the Never Have I Ever question pool.

Maintain separate state for:

```text
Deep Peep
Truth
Dare
Never Have I Ever
This or That
```

Each game should have its own consumed/available items.

Favorites and bans should also be associated with the correct question/item IDs.

---

# 11. CONTENT ORGANIZATION

Keep game content separate and maintainable.

Prefer something conceptually like:

```text
lib/
  data/
    deep_peep_questions.dart
    truth_questions.dart
    dare_questions.dart
    never_have_i_ever_questions.dart
    this_or_that_questions.dart
```

Or adapt to the repository's existing organization.

Do not put hundreds of questions directly inside UI widgets.

Question data should be independent from presentation logic.

---

# 12. UI / DESIGN

Keep the existing Deep Peep visual identity.

The new games should feel like extensions of the same app.

Avoid:

* Huge navigation bars
* Excessive gradients
* Excessive shadows
* Complicated menus
* Too many buttons
* Unnecessary onboarding
* Excessive animations
* UI clutter

The overall design should feel:

* Minimal
* Modern
* Playful
* Fast
* Conversation-focused

Reuse the existing card components, typography, spacing, animations, and theme where possible.

---

# 13. SWIPE EXPERIENCE

The swipe experience is one of the defining characteristics of Deep Peep.

Do not create a completely separate swipe implementation for every game.

If possible, extract/reuse the existing swipe-card component.

The component should be configurable enough to support:

* Question cards
* Never Have I Ever cards
* This or That cards

But do not over-engineer it.

Preserve:

* Swipe physics
* Animation
* Direction detection
* Card transitions
* History behavior
* Favorite/ban interactions where applicable

---

# 14. RESPONSIVE UI

The application must work properly on:

* Small Android phones
* Normal Android phones
* Large Android screens

Do not hardcode screen dimensions.

Questions may be long.

Malayalam text may require more vertical space than English.

Make sure:

* Text wraps correctly
* Cards do not overflow
* Buttons remain accessible
* Bottom navigation doesn't cover content
* Long questions remain readable

Test with long Malayalam strings specifically.

---

# 15. ACCESSIBILITY

Ensure:

* Buttons have semantic labels
* Swipe actions have accessible alternatives where reasonable
* Text has sufficient contrast
* Font scaling does not break the layout
* Translation controls have clear labels

Do not make swiping the only way to use the app.

---

# 16. ERROR / EMPTY STATES

Handle empty pools gracefully.

Examples:

If all Truth questions are consumed:

"All Truths completed."

[Restart Truths]

If all Dares are consumed:

"All Dares completed."

[Restart Dares]

If Never Have I Ever is exhausted:

"You've gone through all the statements."

[Play Again]

Do not automatically recycle questions without informing the user.

---

# 17. LANGUAGE STATE

The selected language should persist between app launches.

For example:

User selects Malayalam.

They close the app.

They reopen it.

The app should still use Malayalam.

Do not reset language to English on every launch.

---

# 18. OFFLINE REQUIREMENT

The entire app must work without an internet connection.

All game content should be bundled with the application.

Translation must work offline.

No external API should be necessary for:

* Questions
* Dares
* Translations
* Game state
* Language switching

---

# 19. CODE QUALITY

Follow the existing project's coding conventions.

Avoid unnecessary rewrites.

Avoid duplicated business logic.

Prefer reusable components where there is clear duplication.

Keep game-specific logic separated.

Use immutable models where the existing architecture supports them.

Add comments only where the logic is non-obvious.

Do not add unnecessary dependencies.

---

# 20. TESTING

After implementation, verify:

### Navigation

* Deep Peep opens
* Truth or Dare opens
* Never Have I Ever opens
* This or That opens
* Switching between games works

### Truth or Dare

* Truth selection works
* Dare selection works
* Skip works
* Complete works
* Completed items don't return
* Skipped items don't return
* Exhaustion state works
* Reset works

### Never Have I Ever

* Swipe works
* No accidental repetition
* History works if applicable
* Favorites work if applicable
* Banning works if applicable
* Exhaustion state works

### This or That

* Both choices are visible
* Swipe left/right works
* Each direction corresponds to the correct option
* No accidental repetition
* Exhaustion/reset works

### Language

* English works
* Malayalam works
* Malayalam appears first
* English appears underneath when Malayalam mode requires it
* Translation button works
* Language persists after restarting the app

### Existing Deep Peep

Most importantly:

**The existing Deep Peep functionality must not regress.**

Verify its:

* Swiping
* Favorites
* History
* Banning
* Persistence
* UI
* Animations

---

# 21. IMPLEMENTATION STRATEGY

Implement this incrementally.

Recommended order:

1. Inspect existing architecture.
2. Identify reusable navigation/card/state components.
3. Add game models/data.
4. Add Truth or Dare.
5. Add Never Have I Ever.
6. Add This or That.
7. Add bottom navigation.
8. Add language infrastructure.
9. Add Malayalam translations.
10. Add translation toggle.
11. Add persistence for new state.
12. Test all games.
13. Fix responsive/overflow issues.
14. Run formatter.
15. Run analyzer.
16. Run tests.
17. Build/run the Android application.

Do not make massive unrelated changes.

---

# 22. FINAL VALIDATION

Before declaring the work complete, run the appropriate Flutter checks:

```bash
flutter analyze
```

Then:

```bash
flutter test
```

Then verify the application builds/runs:

```bash
flutter run
```

If there are existing warnings unrelated to your changes, distinguish them from errors introduced by your implementation.

At the end, provide a concise summary containing:

1. What was added.
2. Which existing files/components were reused.
3. Which new files were created.
4. How game state is persisted.
5. How bilingual content works.
6. Any limitations or TODOs.
7. Test/build results.

Do not claim something works unless it was actually verified.

## CORE PRODUCT PRINCIPLE

Deep Peep should remain a **simple offline conversation game**, now expanded into a small collection of conversation games.

The experience should feel:

**Open app → choose a game → immediately start playing.**

Keep the interface simple.

Do not turn it into a complicated social network or party-management application.

The most important priorities are:

**simplicity → fun interaction → no repetition → offline support → bilingual English/Malayalam experience → consistency with the existing Deep Peep design.**

# 23. CRITICAL — TRUE OFFLINE FONT SUPPORT

Deep Peep is an offline-first application.

The current application is attempting to fetch the Inter font from `fonts.gstatic.com` at runtime. This must be eliminated.

The application must NOT require an internet connection to render:

* English text
* Malayalam text
* Game UI
* Questions
* Dares
* Navigation
* Buttons
* Dialogs
* Any other UI element

Inspect the current `google_fonts` usage throughout the project.

Replace runtime font fetching with locally bundled fonts.

Choose a font setup that properly supports both:

* Latin / English
* Malayalam

The Malayalam font must have good readability on mobile screens.

Prefer a locally bundled font family with proper Malayalam glyph coverage rather than relying on system fallback.

Add the font files to the project's assets/fonts configuration and configure Flutter to use them locally.

Do NOT simply leave `GoogleFonts.inter()` calls everywhere if doing so causes runtime network requests.

If the existing design uses Inter heavily, preserve the visual appearance as closely as practical while ensuring Malayalam is rendered correctly.

Verify this by running the application with network connectivity unavailable.

The application must still:

1. Start normally.
2. Render all screens.
3. Display English questions.
4. Display Malayalam questions.
5. Switch between languages.
6. Display Malayalam + English together.
7. Render all four games.
8. Render navigation and controls.

There must be zero dependency on `fonts.gstatic.com` at runtime.

Also inspect `pubspec.yaml` and determine whether the `google_fonts` dependency is still necessary after the change. Remove it if it is no longer needed and if doing so does not break anything else.

Do not add a new network-based translation or font service.

This requirement takes priority over preserving the exact Google Fonts implementation.
