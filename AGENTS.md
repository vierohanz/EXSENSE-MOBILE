# Engineering Guidelines & Coding Rules (EXSENSE-MOBILE)

## 1. Zero-Comment Policy (Self-Documenting Code)
- **Do not write explanatory comments**: No inline comments, method explanations, or file headers.
- **Self-explanatory naming**: Names of classes, methods, variables, and parameters must clearly convey intent and responsibility.
- **No dead code**: Never leave commented-out code blocks. If code is unused, remove it.

---

## 2. Architecture & Directory Structure
The project follows **Feature-First Modular Architecture** with **GetX**:

```
lib/
├── app.dart
├── main.dart
├── core/
│   ├── config/          # Environment variables, flavors, app constants
│   ├── network/         # API client, interceptors, endpoints, exceptions
│   ├── routes/          # Navigation routes and GetPage route definitions
│   ├── theme/           # AppTheme, colors, text styles
│   ├── utils/           # Helpers, logger, storage service, validators
│   └── widgets/         # Shared cross-feature UI components
└── features/
    └── <feature_name>/
        ├── data/
        │   ├── models/        # JSON serialization & schema mappers
        │   └── repositories/  # Repository implementations & contracts
        ├── logic/
        │   ├── <feature>_controller.dart  # GetxController implementations
        │   └── <feature>_binding.dart     # Feature dependency bindings
        └── presentation/
            ├── pages/         # Full-screen pages
            └── widgets/       # Feature-specific sub-widgets
```

### Dependency Rules:
- Presentation depends on Logic (`Controllers`) and Core components.
- Logic coordinates Data (`Repositories`) and exposes reactive state to Presentation.
- Data handles data transformation (`Models`) and remote/local operations (`Repositories`).
- Features must not directly import internals of another feature; communicate via shared contracts in `core` or global services.

---

## 3. Performance-First Standards

### Widget Rendering & Build Optimization
- **Enforce `const`**: Always use `const` constructors on widgets and subtrees to eliminate unnecessary rebuilds.
- **Granular Reactivity**: Wrap only the exact target widget in `Obx()`. Never wrap entire pages, `Scaffold`, or large container widgets with `Obx()`.
- **Stateless by Default**: Pages must extend `GetView<TController>` or `StatelessWidget`. Avoid `StatefulWidget` unless strictly managing local ticker/animation state.
- **No heavy computations in `build()`**: Data transformations, filtering, and sorting belong inside controllers, never in the widget build tree.
- **Efficient Lists**: Use `ListView.builder` or `CustomScrollView` with slivers for dynamic lists. Always provide `itemCount` and avoid unconstrained shrink-wrapping where possible.

### State & Memory Management
- **Lazy Initialization**: Register controllers using `Get.lazyPut()` inside feature `Bindings` so instances are created on-demand and disposed when their route is popped.
- **Explicit Cleanup**: Always release system resources inside `GetxController.onClose()`:
  - `TextEditingController.dispose()`
  - `FocusNode.dispose()`
  - `StreamSubscription.cancel()`
  - `Timer.cancel()`
  - Animation and scroll controllers.
- **Immutable State Exposing**: Keep reactive variables private and expose typed getters:
  ```dart
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  ```

---

## 4. Naming & Consistency Conventions

| Component | Suffix / Pattern | Example |
| :--- | :--- | :--- |
| File Names | `snake_case.dart` | `login_controller.dart` |
| Page Class | `PascalCasePage` | `LoginPage` |
| Controller Class | `PascalCaseController` | `LoginController` |
| Binding Class | `PascalCaseBinding` | `AuthBinding` |
| Repository Class | `PascalCaseRepository` | `AuthRepository` |
| Data Model | `PascalCaseModel` | `UserModel` |
| Feature Widget | `PascalCase` | `StatCard` |

---

## 5. Error Handling & Asynchronous Code
- Use `async`/`await` consistently; avoid mixing with `.then()`.
- Handle exceptions in the Data layer, map them to typed exceptions in `core/network/exceptions.dart`, and translate them to user-facing UI messages in Presentation.
- Never use empty `catch` blocks.
