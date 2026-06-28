# Fast Food POS — Cursor Build Document
**Stack:** Flutter Desktop (Windows) · Drift (SQLite) · Riverpod · fl_chart · printing  
**Design:** Dark-toned modern UI · Left sidebar navigation · Responsive for 1280px–1920px+ desktops  
**Architecture:** Offline-first · Single local SQLite DB · In-memory caching for Menu/Products

---

## Instructions for Cursor

Work through each module in order. Each module is self-contained with its own files, dependencies, and acceptance criteria. Do not skip modules — later modules depend on earlier ones. After completing each module, confirm all acceptance criteria pass before moving to the next.

When generating code:
- Use **Riverpod** for all state management (StateNotifierProvider, FutureProvider, StreamProvider)
- Use **Drift** for all database access — never raw SQL strings
- Follow the **design system** defined in Module 02 for all UI
- Keep business logic in providers/notifiers, not in widgets
- All monetary values stored as integers (paise/cents) in the database

---

## Module 01 — Project Setup & Dependencies

### Goal
Bootstrap the Flutter Desktop project with all dependencies, folder structure, and environment configuration.

### pubspec.yaml dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Database
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.20
  path_provider: ^2.1.3
  path: ^1.9.0

  # UI & Icons
  flutter_svg: ^2.0.10
  google_fonts: ^6.2.1
  lucide_icons: ^0.0.4

  # Charts
  fl_chart: ^0.68.0

  # Printing & PDF
  printing: ^5.12.0
  pdf: ^3.10.8

  # Utilities
  intl: ^0.19.0
  uuid: ^4.4.0
  equatable: ^2.0.5
  collection: ^1.18.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  drift_dev: ^2.18.0
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.3
  custom_lint: ^0.6.4
  riverpod_lint: ^2.3.13
```

### Folder structure to create
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_sizes.dart
│   │   └── app_strings.dart
│   ├── database/
│   │   ├── app_database.dart
│   │   ├── app_database.g.dart          (generated)
│   │   └── daos/
│   │       ├── categories_dao.dart
│   │       ├── products_dao.dart
│   │       ├── deals_dao.dart
│   │       ├── orders_dao.dart
│   │       └── tables_dao.dart
│   ├── models/
│   │   └── (domain models, separate from DB tables)
│   ├── providers/
│   │   └── database_provider.dart
│   └── utils/
│       ├── currency_formatter.dart
│       └── date_formatter.dart
├── features/
│   ├── dashboard/
│   ├── menu/
│   ├── products/
│   ├── categories/
│   ├── deals/
│   ├── orders/
│   ├── tables/
│   ├── analytics/
│   └── settings/
└── shared/
    ├── widgets/
    │   ├── app_sidebar.dart
    │   ├── stat_card.dart
    │   ├── search_bar.dart
    │   ├── confirmation_dialog.dart
    │   └── empty_state.dart
    └── layouts/
        └── main_layout.dart
```

### main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable WAL mode for SQLite
  await driftRuntimeOptions.dontWarnAboutMultipleDatabases();
  
  runApp(
    const ProviderScope(
      child: POSApp(),
    ),
  );
}
```

### Acceptance criteria
- [ ] `flutter pub get` succeeds with no version conflicts
- [ ] `flutter run -d windows` launches a blank window
- [ ] All folders exist and are correctly structured
- [ ] `flutter analyze` returns no errors

---

## Module 02 — Design System & Theme

### Goal
Define the complete visual design system — colors, typography, spacing, and the app theme. All subsequent modules MUST use these tokens only. No hardcoded colors or sizes anywhere else.

### app_colors.dart
```dart
class AppColors {
  // Background layers
  static const Color background       = Color(0xFF0F1117);  // page canvas
  static const Color surface          = Color(0xFF1A1D27);  // cards, panels
  static const Color surfaceElevated  = Color(0xFF21253A);  // modals, popovers
  static const Color sidebar          = Color(0xFF13151F);  // left nav

  // Brand accent
  static const Color accent           = Color(0xFFFF6B35);  // primary CTA (orange)
  static const Color accentLight      = Color(0xFFFF8B5E);  // hover state
  static const Color accentBg         = Color(0x1FFF6B35);  // tinted backgrounds

  // Semantic
  static const Color success          = Color(0xFF22C55E);
  static const Color successBg        = Color(0x1F22C55E);
  static const Color warning          = Color(0xFFF59E0B);
  static const Color warningBg        = Color(0x1FF59E0B);
  static const Color danger           = Color(0xFFEF4444);
  static const Color dangerBg         = Color(0x1FEF4444);
  static const Color info             = Color(0xFF3B82F6);
  static const Color infoBg           = Color(0x1F3B82F6);

  // Text
  static const Color textPrimary      = Color(0xFFF1F5F9);
  static const Color textSecondary    = Color(0xFF94A3B8);
  static const Color textMuted        = Color(0xFF475569);
  static const Color textDisabled     = Color(0xFF334155);

  // Borders
  static const Color border           = Color(0xFF1E2435);
  static const Color borderStrong     = Color(0xFF2A3049);

  // Order type badges
  static const Color dineIn           = Color(0xFF6366F1);  // indigo
  static const Color dineInBg         = Color(0x1F6366F1);
  static const Color takeaway         = Color(0xFF06B6D4);  // cyan
  static const Color takeawayBg       = Color(0x1F06B6D4);
  static const Color delivery         = Color(0xFF8B5CF6);  // violet
  static const Color deliveryBg       = Color(0x1F8B5CF6);
}
```

### app_text_styles.dart
```dart
// Uses Inter font throughout
class AppTextStyles {
  static const String _font = 'Inter';

  // Display
  static TextStyle display = TextStyle(fontFamily: _font, fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.5);
  static TextStyle headline = TextStyle(fontFamily: _font, fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: -0.3);
  static TextStyle title    = TextStyle(fontFamily: _font, fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle subtitle = TextStyle(fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary);

  // Body
  static TextStyle body     = TextStyle(fontFamily: _font, fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.6);
  static TextStyle bodySmall= TextStyle(fontFamily: _font, fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.5);
  static TextStyle caption  = TextStyle(fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMuted);

  // Labels
  static TextStyle label    = TextStyle(fontFamily: _font, fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary, letterSpacing: 0.1);
  static TextStyle labelSmall = TextStyle(fontFamily: _font, fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 0.8);

  // Numeric
  static TextStyle number   = TextStyle(fontFamily: _font, fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontFeatures: [FontFeature.tabularFigures()]);
  static TextStyle numberSm = TextStyle(fontFamily: _font, fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontFeatures: [FontFeature.tabularFigures()]);
  static TextStyle price    = TextStyle(fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.accent, fontFeatures: [FontFeature.tabularFigures()]);
}
```

### app_sizes.dart
```dart
class AppSizes {
  // Sidebar
  static const double sidebarWidth         = 220.0;
  static const double sidebarCollapsed     = 64.0;

  // Layout breakpoints
  static const double breakpointMd        = 1280.0;
  static const double breakpointLg        = 1536.0;
  static const double breakpointXl        = 1920.0;

  // Spacing scale
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 16.0;
  static const double lg   = 24.0;
  static const double xl   = 32.0;
  static const double xxl  = 48.0;

  // Component sizes
  static const double cardRadius          = 12.0;
  static const double buttonRadius        = 8.0;
  static const double inputRadius         = 8.0;
  static const double badgeRadius         = 6.0;
  static const double controlHeight       = 40.0;
  static const double controlHeightLg     = 48.0;

  // Cart panel
  static const double cartPanelWidth      = 360.0;

  // Product card (menu grid)
  static const double productCardWidth    = 180.0;
  static const double productCardHeight   = 200.0;
}
```

### ThemeData
Create `lib/core/theme/app_theme.dart` with a `ThemeData` using `AppColors`, `AppTextStyles`. The theme must cover: `scaffoldBackgroundColor`, `cardTheme`, `inputDecorationTheme`, `elevatedButtonTheme`, `textButtonTheme`, `dividerTheme`, `listTileTheme`, `chipTheme`.

### Acceptance criteria
- [ ] All color, text, and size constants are defined
- [ ] Theme is applied in `app.dart` via `MaterialApp.router(theme: AppTheme.dark)`
- [ ] No hardcoded colors or font sizes exist outside the design system files
- [ ] Google Fonts Inter is loaded correctly in `pubspec.yaml` assets

---

## Module 03 — Database Schema & DAOs

### Goal
Define the complete Drift database schema with all tables, indexes, relationships, and DAOs. This is the foundation — all features depend on this module.

### Tables to define in app_database.dart

#### categories table
```dart
class Categories extends Table {
  IntColumn get id       => integer().autoIncrement()();
  TextColumn get name    => text().withLength(min: 1, max: 50)();
  TextColumn get color   => text().withDefault(const Constant('#FF6B35'))();  // hex color
  TextColumn get icon    => text().withDefault(const Constant('utensils'))(); // icon name
  IntColumn  get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive  => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

#### products table
```dart
class Products extends Table {
  IntColumn  get id          => integer().autoIncrement()();
  TextColumn get name        => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  IntColumn  get priceInPaisa => integer()();                    // store as integer, display as PKR
  IntColumn  get categoryId  => integer().references(Categories, #id)();
  TextColumn get imagePath   => text().nullable()();             // local file path
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeal      => boolean().withDefault(const Constant(false))();
  IntColumn  get sortOrder   => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
```

#### deals table
```dart
class Deals extends Table {
  IntColumn  get id           => integer().autoIncrement()();
  TextColumn get name         => text().withLength(min: 1, max: 100)();
  TextColumn get description  => text().nullable()();
  IntColumn  get priceInPaisa => integer()();                   // override price for the deal
  TextColumn get imagePath    => text().nullable()();
  BoolColumn get isAvailable  => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

#### deal_items table (many products → one deal)
```dart
class DealItems extends Table {
  IntColumn get id        => integer().autoIncrement()();
  IntColumn get dealId    => integer().references(Deals, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity  => integer().withDefault(const Constant(1))();
}
```

#### restaurant_tables table
```dart
class RestaurantTables extends Table {
  IntColumn  get id       => integer().autoIncrement()();
  TextColumn get name     => text().withLength(min: 1, max: 20)();  // "Table 1", "VIP-3"
  IntColumn  get capacity => integer().withDefault(const Constant(4))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
```

#### orders table
```dart
class Orders extends Table {
  IntColumn    get id          => integer().autoIncrement()();
  TextColumn   get orderNumber => text()();                         // "ORD-20240615-001"
  TextColumn   get orderType   => text()();                         // 'dine_in' | 'takeaway' | 'delivery'
  IntColumn    get tableId     => integer().nullable().references(RestaurantTables, #id)();
  TextColumn   get customerName     => text().nullable()();
  TextColumn   get customerContact  => text().nullable()();
  TextColumn   get deliveryAddress  => text().nullable()();
  IntColumn    get subtotalInPaisa  => integer()();
  IntColumn    get taxInPaisa       => integer().withDefault(const Constant(0))();
  IntColumn    get discountInPaisa  => integer().withDefault(const Constant(0))();
  IntColumn    get totalInPaisa     => integer()();
  TextColumn   get status      => text().withDefault(const Constant('completed'))(); // 'completed' | 'cancelled'
  TextColumn   get notes       => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

#### order_items table
```dart
class OrderItems extends Table {
  IntColumn get id          => integer().autoIncrement()();
  IntColumn get orderId     => integer().references(Orders, #id)();
  IntColumn get productId   => integer().nullable().references(Products, #id)();
  IntColumn get dealId      => integer().nullable().references(Deals, #id)();
  TextColumn get itemName   => text()();      // snapshot at time of order (name may change later)
  IntColumn  get quantity   => integer()();
  IntColumn  get unitPriceInPaisa => integer()();
  IntColumn  get totalPriceInPaisa => integer()();
  BoolColumn get isDeal     => boolean().withDefault(const Constant(false))();
}
```

### Critical indexes
Add these to your `@DriftDatabase` class `migration` getter or as `@TableIndex` annotations:
```dart
// In AppDatabase class:
@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) async {
    await m.createAll();
    // Indexes for fast date-based order queries
    await customStatement(
      'CREATE INDEX idx_orders_created_at ON orders(created_at);'
    );
    await customStatement(
      'CREATE INDEX idx_order_items_order_id ON order_items(order_id);'
    );
    await customStatement(
      'CREATE INDEX idx_products_category_id ON products(category_id);'
    );
    await customStatement(
      'CREATE INDEX idx_orders_order_type ON orders(order_type);'
    );
    // Enable WAL mode
    await customStatement('PRAGMA journal_mode=WAL;');
    await customStatement('PRAGMA synchronous=NORMAL;');
  },
);
```

### DAOs to implement

**CategoriesDao** — methods: `watchAllCategories()`, `getAllActive()`, `insertCategory()`, `updateCategory()`, `deleteCategory()`

**ProductsDao** — methods: `watchProductsByCategory(int categoryId)`, `watchAllProducts()`, `searchProducts(String query)`, `getProductById(int id)`, `insertProduct()`, `updateProduct()`, `toggleAvailability(int id)`, `deleteProduct(int id)`

**DealsDao** — methods: `watchAllDeals()`, `getDealWithItems(int dealId)`, `insertDeal()`, `insertDealItem()`, `updateDeal()`, `deleteDeal(int id)`

**OrdersDao** — methods:
```dart
// Date-filtered stream — core query for Orders module
Stream<List<Order>> watchOrdersByDateRange(DateTime from, DateTime to);
Future<int> insertOrder(OrdersCompanion order);
Future<int> insertOrderItem(OrderItemsCompanion item);
Future<List<OrderItem>> getItemsForOrder(int orderId);

// For dashboard — today's stats
Future<DashboardStats> getTodayStats(DateTime today);

// For analytics — aggregated by date
Future<List<DailyRevenue>> getRevenueByDateRange(DateTime from, DateTime to);
Future<List<ProductSalesCount>> getTopProducts(DateTime from, DateTime to, {int limit = 10});
```

**TablesDao** — methods: `watchAllTables()`, `insertTable()`, `updateTable()`, `toggleActive(int id)`, `isTableOccupied(int id)` (checks if there's an open order on this table)

### Acceptance criteria
- [ ] `dart run build_runner build` generates `.g.dart` files with no errors
- [ ] Database opens successfully on app start (check via `debugPrint`)
- [ ] All tables are created on first run (verify with SQLite browser)
- [ ] Indexes exist in the schema (verify: `SELECT name FROM sqlite_master WHERE type='index'`)
- [ ] WAL mode is enabled (verify: `PRAGMA journal_mode`)
- [ ] All DAO methods compile and return correct Drift types

---

## Module 04 — Main Layout & Navigation

### Goal
Build the persistent app shell: left sidebar navigation, content area, and routing. This wraps all feature screens.

### Navigation items
```dart
enum NavItem {
  dashboard(label: 'Dashboard',   icon: Icons.dashboard_outlined,    route: '/'),
  menu     (label: 'Menu',        icon: Icons.restaurant_menu,        route: '/menu'),
  orders   (label: 'Orders',      icon: Icons.receipt_long_outlined,  route: '/orders'),
  products (label: 'Products',    icon: Icons.inventory_2_outlined,   route: '/products'),
  categories(label: 'Categories', icon: Icons.category_outlined,      route: '/categories'),
  deals    (label: 'Deals',       icon: Icons.local_offer_outlined,   route: '/deals'),
  tables   (label: 'Tables',      icon: Icons.table_restaurant_outlined, route: '/tables'),
  analytics(label: 'Analytics',   icon: Icons.bar_chart_outlined,     route: '/analytics'),
  settings (label: 'Settings',    icon: Icons.settings_outlined,      route: '/settings'),
}
```

### AppSidebar widget spec
- Fixed width `AppSizes.sidebarWidth` (220px)
- Background: `AppColors.sidebar`
- Top section: app logo/name ("QuickPOS") with a small flame/restaurant icon
- Navigation items list using `NavItem` enum
- Each item: 40px height, 12px horizontal padding, 8px icon+label gap
- Active item: `AppColors.accent` left border (3px), `AppColors.accentBg` background, `AppColors.accent` icon/text color
- Inactive item: `AppColors.textSecondary` icon/text, hover → `AppColors.surface` background
- Bottom section: current date/time (live, updates every second), settings item
- Right border: 1px `AppColors.border`

### MainLayout widget spec
```
Row(
  children: [
    AppSidebar(currentRoute: ..., onNavigate: ...),
    Expanded(
      child: Column(
        children: [
          PageHeader(title: ..., actions: [...]),  // per-page top bar
          Expanded(child: pageContent),
        ],
      ),
    ),
  ],
)
```

### Router setup
Use `go_router` package (add to pubspec). Define routes for each `NavItem`. The sidebar drives navigation via `context.go(route)`.

### PageHeader widget
- Height: 64px
- Background: `AppColors.background`
- Bottom border: 1px `AppColors.border`
- Left: page title in `AppTextStyles.headline`
- Right: slot for action buttons (varies per page)

### Acceptance criteria
- [ ] Sidebar renders at correct width with all 9 nav items
- [ ] Active state shows accent border and background
- [ ] Clicking any nav item navigates to the correct screen (can be a placeholder)
- [ ] Clock in sidebar updates every second
- [ ] Layout fills the entire window on resize (1280px to 1920px)
- [ ] No overflow errors at any tested resolution

---

## Module 05 — Categories Module

### Goal
Full CRUD for product categories. Categories are used to filter the Menu screen and group products.

### Screens
Single screen: `CategoriesScreen`

### UI layout
- Full-width content area
- PageHeader with title "Categories" and "+ Add Category" button (accent style)
- Body: responsive grid of category cards — 4 columns on 1280px, 5 on 1536px+
- Each card: rounded (12px), `AppColors.surface` background, category color strip on top (8px), icon + name + product count, edit/delete icon buttons

### CategoryCard widget
```
[  Color strip (8px top, full width, category.color)  ]
[  Icon (32px, category.color) | Name (subtitle style) ]
[  "X products" (caption, muted)                       ]
[  ————————————————————————————                        ]
[  Edit icon button     Delete icon button             ]
```

### Add/Edit Category dialog
Fields:
- Name (required, text input)
- Color picker (show 10 preset swatches: the accent color + 9 others)
- Icon selector (show 12 preset icon options as a grid)
- Sort order (number input)

### State (Riverpod)
```dart
// Provider
final categoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(databaseProvider).categoriesDao.watchAllCategories();
});

// Notifier for mutations
class CategoriesNotifier extends AsyncNotifier<void> {
  Future<void> addCategory(CategoriesCompanion category) async { ... }
  Future<void> updateCategory(CategoriesCompanion category) async { ... }
  Future<void> deleteCategory(int id) async { ... }
}
```

### Business rules
- Cannot delete a category that has products assigned to it — show error dialog
- Category name must be unique (check before insert)
- Default categories to seed on first launch: Burgers, Drinks, Fries, Desserts, Extras

### Acceptance criteria
- [ ] Categories list loads from DB and displays in grid
- [ ] Add category opens dialog, saves to DB, grid refreshes reactively
- [ ] Edit pre-fills form with existing values
- [ ] Delete shows confirmation dialog before removing
- [ ] Deleting a category with products shows a blocking error, not a crash
- [ ] Seed data is inserted on first launch

---

## Module 06 — Products Module

### Goal
Full product management with image support, category assignment, and availability toggling.

### Screens
Single screen: `ProductsScreen`

### UI layout
- PageHeader: "Products" title, search input (300px wide), category filter dropdown, "+ Add Product" button
- Body: data table or card grid (user toggle)
  - **Table view** (default): columns — Image thumbnail, Name, Category, Price, Available toggle, Actions
  - **Grid view**: same product cards as in Menu module
- Pagination: load 50 at a time, "Load more" button at bottom

### Add/Edit Product sheet (side panel, not dialog)
Slides in from the right (400px wide). Fields:
- Name (required)
- Category (required, dropdown from categories)
- Price (required, currency input — display as PKR X,XXX, store as paisa)
- Description (optional, multiline)
- Image (optional — file picker, saves to app documents directory, stores relative path)
- Available toggle
- Sort order

### ProductImageWidget
- Shows image from local path if available
- Falls back to category-colored placeholder with product initial
- Handles missing files gracefully (file deleted from disk)

### State (Riverpod)
```dart
// Filtered + searched products
final productsFilterProvider = StateProvider<ProductFilter>((ref) => ProductFilter.all());

@riverpod
Stream<List<Product>> filteredProducts(Ref ref) {
  final filter = ref.watch(productsFilterProvider);
  final db = ref.watch(databaseProvider);
  return db.productsDao.watchFilteredProducts(filter);
}
```

### Currency input widget
Custom `CurrencyInputField` that:
- Accepts numeric input only
- Displays with "PKR" prefix and comma formatting
- Converts display value to paisa on save: `(displayValue * 100).round()`
- Converts paisa to display value on load: `paisa / 100`

### Acceptance criteria
- [ ] Products list loads correctly with category and availability info
- [ ] Search filters products in real time (debounced 300ms)
- [ ] Category filter works
- [ ] Image picker saves image to local documents folder
- [ ] Images display correctly; missing images show placeholder
- [ ] Availability toggle updates DB instantly
- [ ] Add/Edit slide panel opens and closes with animation
- [ ] Price input accepts decimal input and stores as paisa correctly

---

## Module 07 — Deals Module

### Goal
Allow staff to bundle 2+ products into a deal with a fixed combo price. Deals appear on the Menu screen alongside regular products.

### Screens
Single screen: `DealsScreen`

### UI layout
- PageHeader: "Deals" title + "+ Create Deal" button
- Body: card grid of existing deals (3 columns on 1280px, 4 on 1536px+)
- Each deal card shows: image/placeholder, name, deal price, list of included products (small chips), available toggle, edit/delete actions

### DealCard widget
```
[ Deal image or gradient placeholder             ]
[ Deal name (subtitle style)                     ]
[ Included: [Burger] [Fries] [Drink]  (chips)   ]
[ Deal price: PKR 450    Was: PKR 650            ]
[ Available toggle         Edit | Delete         ]
```

### Create/Edit Deal screen (full screen, not dialog)
Navigate to `/deals/create` or `/deals/edit/:id`

Sections:
1. **Deal info** — name, description, image, price
2. **Product selector** — search + list of all products with checkboxes and quantity spinners
3. **Summary** — shows selected products, their individual total vs deal price, savings amount

### Validation
- Minimum 2 products required
- Deal price must be > 0
- Deal name must be unique

### State
```dart
@riverpod
class DealFormNotifier extends _$DealFormNotifier {
  // Holds the in-progress deal being created/edited
  // Selected products as List<DealItemDraft> with quantity
  // Computed: originalTotal, savings
}
```

### Acceptance criteria
- [ ] Deals list loads and displays with included product chips
- [ ] Create deal screen allows searching and selecting products
- [ ] Quantity can be set per product in a deal (e.g., 2x Fries)
- [ ] Savings calculation shown correctly (sum of items - deal price)
- [ ] Deals appear on the Menu screen with a "Deal" badge
- [ ] Editing a deal pre-loads all existing items

---

## Module 08 — Menu & Cart (Core Ordering Flow)

### Goal
The primary operational screen. Left: browsable product/deal grid with category filters and search. Right: persistent cart panel. This is where all orders are placed.

### Layout
```
[Category tabs row — horizontal scrollable]
[                                          ] [ Cart panel  ]
[  Product/Deal grid (auto-fill columns)  ] [ 360px fixed ]
[                                          ] [             ]
```

### Category tabs
- Horizontal scrollable tab row above the product grid
- "All" tab first, then each category
- Active tab: `AppColors.accent` underline + text
- Product count badge on each tab

### Product grid
- Responsive columns: 3 on 1280px, 4 on 1440px, 5 on 1920px
- Shows both Products and Deals (deals have a badge)
- Only shows `isAvailable = true` items
- Loaded once into memory via Riverpod and cached — no DB call per tap

### ProductMenuCard widget
```
[ Image (top half, 100px, rounded top corners)    ]
[ [DEAL badge if deal]                            ]
[ Product name (subtitle, 2 lines max)            ]
[ PKR XXX (price, accent color)                   ]
[ [+] Add button (full width, ghost style)        ]
```
Clicking anywhere on the card (or the + button) adds 1 to cart.

### Cart panel
Fixed 360px right panel, always visible on Menu screen.

Structure:
```
[  Cart (X items)                    [Clear] ]
[————————————————————————————————————————————]
[ Cart item list (scrollable)                ]
[ [Product name]          [−] [2] [+]  PKR X]
[ (deal items shown indented if deal)        ]
[————————————————————————————————————————————]
[ Order type selector:                       ]
[ [Dine In]  [Take Away]  [Delivery]         ]
[                                            ]
[ IF Dine In: Table selector dropdown        ]
[ IF Delivery:                               ]
|   Customer name (input)                    ]
|   Contact number (input)                   ]
|   Delivery address (multiline input)       ]
[————————————————————————————————————————————]
[ Notes (optional, one-line input)           ]
[————————————————————————————————————————————]
[ Subtotal:           PKR X,XXX              ]
[ Tax (X%):           PKR XXX                ]
[ ─────────────────────────────              ]
[ Total:              PKR X,XXX              ]
[  [ Place Order — accent, full width ]      ]
```

### CartState (Riverpod)
```dart
@freezed
class CartItem with _$CartItem {
  factory CartItem({
    required int id,                 // product or deal id
    required String name,
    required int unitPriceInPaisa,
    required int quantity,
    required bool isDeal,
    List<String>? dealItemNames,     // for display only
  }) = _CartItem;
}

@freezed
class CartState with _$CartState {
  factory CartState({
    @Default([]) List<CartItem> items,
    @Default(OrderType.dineIn) OrderType orderType,
    int? selectedTableId,
    @Default('') String customerName,
    @Default('') String customerContact,
    @Default('') String deliveryAddress,
    @Default('') String notes,
  }) = _CartState;

  // Computed
  int get subtotal => items.fold(0, (sum, i) => sum + i.unitPriceInPaisa * i.quantity);
  int get tax => (subtotal * 0.0).round(); // set tax rate in settings
  int get total => subtotal + tax;
  bool get isEmpty => items.isEmpty;
}

class CartNotifier extends Notifier<CartState> {
  void addItem(CartItem item);         // if exists, increment quantity
  void removeItem(int id, bool isDeal);
  void updateQuantity(int id, bool isDeal, int qty);
  void clearCart();
  void setOrderType(OrderType type);
  void setTable(int? tableId);
  Future<int> placeOrder();            // saves to DB, returns orderId, clears cart
}
```

### Place Order logic
```dart
Future<int> placeOrder() async {
  // 1. Validate: cart not empty, delivery fields filled if delivery
  // 2. Generate order number: "ORD-YYYYMMDD-XXX" (incrementing daily)
  // 3. Insert order row
  // 4. Insert order_items rows (snapshot current names + prices)
  // 5. Clear cart state
  // 6. Show success snackbar with order number
  // 7. Optionally trigger receipt print (see Module 13)
  // 8. Return orderId
}
```

### In-memory product cache provider
```dart
// Load once on app start, invalidated only when products/deals change
@riverpod
Future<MenuCatalog> menuCatalog(Ref ref) async {
  final db = ref.watch(databaseProvider);
  final products = await db.productsDao.getAllAvailable();
  final deals = await db.dealsDao.getAllAvailableWithItems();
  return MenuCatalog(products: products, deals: deals);
}
```

### Acceptance criteria
- [ ] Products and deals load into the menu grid
- [ ] Category tabs filter the grid correctly; "All" shows everything
- [ ] Search filters products in real time
- [ ] Tapping a product adds it to cart; tapping again increments quantity
- [ ] Cart shows correct item list, quantities, subtotal, tax, total
- [ ] Quantity can be decremented; reaching 0 removes the item
- [ ] Clear cart button removes all items with confirmation
- [ ] Order type selector switches between Dine In / Take Away / Delivery
- [ ] Dine In shows table selector with list of active tables
- [ ] Delivery shows customer info fields (required validation on Place Order)
- [ ] Place Order saves order + items to DB, generates order number, clears cart
- [ ] Success feedback shown after order placed
- [ ] Menu catalog is served from memory — no DB hit on product tap

---

## Module 09 — Tables Management Module

### Goal
Allow staff to add, name, and manage physical tables. Tables appear in the cart's Dine In flow.

### Screens
Single screen: `TablesScreen`

### UI layout
- PageHeader: "Tables" title + "+ Add Table" button
- Body: grid of table cards (responsive, 4–6 per row)
- Each card shows: table name, capacity, status badge (Available / Occupied), edit/delete

### TableCard widget
```
[ Table icon (32px)                ]
[ "Table 5" (title)                ]
[ Capacity: 4 persons (caption)    ]
[ [Available] or [Occupied] badge  ]
[ Edit btn    Delete btn           ]
```
- Available badge: `AppColors.successBg` + `AppColors.success` text
- Occupied badge: `AppColors.warningBg` + `AppColors.warning` text

### Add/Edit Table dialog
Fields: Name (e.g., "Table 1", "VIP Booth"), Capacity (number), Active toggle

### Business rules
- Cannot delete a table that currently has an open/occupied order
- "Occupied" state is derived — a table is occupied if it appears in a recent completed/open order today (or implement an explicit `isOccupied` flag that is set when an order is placed and cleared manually or on next day)

### Acceptance criteria
- [ ] Tables grid loads from DB
- [ ] Add/Edit dialog works correctly
- [ ] Delete blocked if table is occupied (show dialog)
- [ ] Table appears in cart's Dine In selector
- [ ] Status badge updates based on occupancy

---

## Module 10 — Orders Module

### Goal
View, filter, and inspect all orders. Default view is today's orders. Supports date range filtering.

### Screens
Single screen: `OrdersScreen` with inline order detail panel

### UI layout
```
[ PageHeader: "Orders"          [Today] [Yesterday] [This Week] [This Month] [Custom] ]
[ Stats row: X orders | PKR X revenue | X dine-in | X takeaway | X delivery           ]
[——————————————————————————————————————————————————————————————————————————————————————]
[ Orders table (left 60%)              | Order detail panel (right 40%)               ]
[ #  | Time | Type | Items | Total | ▶ | (shows when an order is selected)            ]
```

### Quick filter tabs
Pill-style tabs row (not full tabs):
- Today (default)
- Yesterday
- This Week
- This Month
- Custom (opens date range picker dialog)

### Orders table columns
| Column | Width | Content |
|---|---|---|
| Order # | 140px | "ORD-20240615-003" |
| Time | 80px | "14:35" |
| Type | 100px | Badge: Dine In / Take Away / Delivery |
| Items | 60px | Count |
| Total | 100px | "PKR 1,250" |
| Actions | 80px | View receipt icon, (cancel if same day) |

### Order detail panel
Slides in on row click (right 40% of screen, or full-width overlay on smaller windows).

Shows:
- Order number + timestamp
- Order type + table name (if dine-in) or customer info (if delivery)
- Item list with quantities and prices
- Subtotal, tax, discount, total
- Notes
- "Print Receipt" button

### Stats row
Computed from the current filter's data:
- Total orders count
- Total revenue (PKR)
- Count per order type

### State
```dart
@riverpod
class OrdersFilterNotifier extends _$OrdersFilterNotifier {
  DateRange get todayRange => DateRange(
    start: DateTime.now().startOfDay,
    end: DateTime.now().endOfDay,
  );
  
  void setQuickFilter(QuickFilter filter);
  void setCustomRange(DateTime from, DateTime to);
}

@riverpod
Stream<List<OrderWithItems>> filteredOrders(Ref ref) {
  final filter = ref.watch(ordersFilterNotifierProvider);
  return ref.watch(databaseProvider).ordersDao.watchOrdersByDateRange(filter.from, filter.to);
}
```

### Acceptance criteria
- [ ] Orders screen defaults to today's orders
- [ ] All quick filter buttons work and update the list
- [ ] Custom date picker works and applies filter
- [ ] Stats row updates with filter changes
- [ ] Clicking an order shows the detail panel
- [ ] Order type badges display with correct colors
- [ ] "Print Receipt" in detail panel triggers receipt (Module 13)

---

## Module 11 — Dashboard Module

### Goal
At-a-glance overview of today's performance. Loaded fresh on every visit. No real-time streaming needed — query on mount.

### Screens
Single screen: `DashboardScreen`

### UI layout
```
[ PageHeader: "Dashboard"          Today: Monday, 15 Jun 2024 ]
[                                                              ]
[ [Today's Revenue]  [Total Orders]  [Avg Order]  [Items Sold]]
[   PKR 45,200          127 orders    PKR 356       412 items  ]
[                                                              ]
[ [Revenue Today (hourly bar chart — last 12 hours)  60%]     ]
[ [Order Types pie chart  38%]                                 ]
[                                                              ]
[ [Top 5 Items Today — ranked list            50%]            ]
[ [Last 5 Orders — mini table                 50%]            ]
```

### StatCard widget (reusable)
```dart
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;       // e.g., "+12% vs yesterday"
  final Color? subtitleColor;   // green for positive, red for negative
  final IconData icon;
  final Color iconColor;
}
```
- Background: `AppColors.surface`
- Border: 1px `AppColors.border`
- Icon in top-right corner, 32px, `AppColors.accentBg` circle background
- Value: `AppTextStyles.number`
- Label: `AppTextStyles.label`

### Charts (fl_chart)
**Hourly revenue bar chart** — BarChart with 12 bars (last 12 hours or 8am–current hour). Bar color: `AppColors.accent`. No Y-axis grid lines — just the bars and X-axis hour labels.

**Order type pie/donut chart** — PieChart with 3 segments. Colors: `AppColors.dineIn`, `AppColors.takeaway`, `AppColors.delivery`. Center text: total orders count. Legend below.

### Top items list
Simple ranked list: rank number, product name, quantity sold today, revenue contributed.

### DashboardStats model
```dart
class DashboardStats {
  final int revenueInPaisa;
  final int totalOrders;
  final int itemsSold;
  final int dineInCount;
  final int takeawayCount;
  final int deliveryCount;
  final List<HourlyRevenue> hourlyRevenue;      // 12 entries
  final List<TopProductStat> topProducts;        // top 5
  final List<Order> recentOrders;               // last 5
}
```

### Acceptance criteria
- [ ] All 4 stat cards load with correct values
- [ ] Hourly revenue chart displays correctly (handle case of 0 revenue hours)
- [ ] Pie chart shows correct split; handles case of only one order type
- [ ] Top items list shows up to 5 items
- [ ] Recent orders mini-table links to Orders module on click
- [ ] Data refreshes when navigating back to Dashboard

---

## Module 12 — Analytics Module

### Goal
Deeper historical reporting across any date range. Revenue trends, product performance, order type breakdown.

### Screens
Single screen: `AnalyticsScreen`

### UI layout
- PageHeader: "Analytics" with date range selector (default: last 30 days)
- Section 1: Revenue over time (line chart, daily totals)
- Section 2: Top 10 products by quantity and by revenue (side by side bar charts)
- Section 3: Order type trend (stacked bar or grouped bar, weekly)
- Section 4: Summary table — each day with orders count, revenue, avg order value

### Date range selector
Compact dropdown/picker in header. Presets: Last 7 days, Last 30 days, Last 90 days, This month, Last month, Custom range.

### Revenue line chart (fl_chart)
- LineChart with daily data points
- Smooth curve (`isCurved: true`)
- Tooltip on hover showing date + PKR amount
- X axis: dates (show every 5th label on 30-day range)
- Y axis: PKR values (formatted as K for thousands)

### Top products bar charts
Two side-by-side `BarChart` widgets:
- Left: "By Quantity" — number of items sold
- Right: "By Revenue" — PKR earned
- Horizontal bars, sorted descending
- Product name on Y axis (truncated to 20 chars)

### Summary table
Scrollable data table: Date | Orders | Revenue | Avg Order Value | Dine In | Take Away | Delivery

### Acceptance criteria
- [ ] Date range selector changes all charts and table
- [ ] Line chart renders with correct daily data
- [ ] Top products charts sort correctly
- [ ] Summary table scrolls and shows all days in range
- [ ] All charts handle empty data gracefully (show "No data" state)
- [ ] Charts use design system colors

---

## Module 13 — Receipt Generation & Printing

### Goal
Generate a thermal-printer-compatible receipt and/or PDF after each order. Triggered from the cart (after Place Order) and from the Orders detail view.

### Receipt layout
```
         [SHOP NAME]
      [Address line 1]
      [Phone number]
  ———————————————————————
  Order: ORD-20240615-003
  Date: 15 Jun 2024  14:35
  Type: Dine In | Table 5
  ———————————————————————
  Burger            x2
                PKR 400
  Fries (L)         x1
                PKR 120
  Deal: Meal Deal   x1
    ∟ Burger, Drink
                PKR 350
  ———————————————————————
  Subtotal:     PKR 870
  Tax (0%):     PKR   0
  ———————————————————————
  TOTAL:        PKR 870
  ———————————————————————
     Thank you! Visit again
```

### ReceiptService
```dart
class ReceiptService {
  // Generate PDF receipt (for 80mm thermal paper size)
  Future<Uint8List> generateReceiptPdf(OrderWithItems order, ShopSettings settings);
  
  // Print using 'printing' package
  Future<void> printReceipt(OrderWithItems order, ShopSettings settings);
  
  // Show print preview dialog
  Future<void> showPreview(BuildContext context, OrderWithItems order);
}
```

### PDF spec (pdf package)
- Page size: 80mm × auto height (thermal roll paper)
- Font: Courier (monospace, thermal-printer compatible)
- Shop name: 14pt bold, center
- Sections separated by dashed lines
- TOTAL line: 14pt bold
- Thank-you message: 10pt italic, center

### Auto-print setting
In settings, allow toggling "Auto-print after order". If enabled, `ReceiptService.printReceipt()` is called automatically after `CartNotifier.placeOrder()`.

### Acceptance criteria
- [ ] Receipt PDF generates correctly for dine-in, takeaway, and delivery orders
- [ ] Delivery receipt includes customer name and address
- [ ] Deal items show deal name and component items indented
- [ ] Print preview dialog opens and shows correct layout
- [ ] Printing sends to system default printer
- [ ] Auto-print setting is respected

---

## Module 14 — Settings Module

### Goal
Shop configuration: business info, tax rate, receipt settings, printer selection.

### Screens
Single screen: `SettingsScreen` with left category list + right content panel

### Settings categories and fields

**Shop Info**
- Shop name (used on receipts)
- Address line
- Phone number
- Currency symbol (default: PKR)

**Tax & Billing**
- Tax rate percentage (0–30%, default 0)
- Tax label (e.g., "GST", "VAT", "Tax")
- Include tax in price display toggle

**Receipt**
- Auto-print after order (toggle)
- Thank-you message (custom text, default: "Thank you! Visit again")
- Show order type on receipt (toggle)
- Show table number on receipt (toggle)

**Printer**
- Default printer (dropdown, populated from system printers via `printing` package)
- Test print button

**Data**
- Export orders to CSV (date range picker → generates CSV file → save dialog)
- Clear today's data (danger zone, requires confirmation)
- About: app version, database size

### Storage
Use `shared_preferences` package to store settings as JSON. Expose via a `SettingsNotifier` (Riverpod).

```dart
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  Future<void> updateShopName(String name) async { ... }
  Future<void> updateTaxRate(double rate) async { ... }
  // etc.
}

@riverpod
ShopSettings shopSettings(Ref ref) {
  return ref.watch(settingsNotifierProvider).valueOrNull ?? ShopSettings.defaults();
}
```

### Acceptance criteria
- [ ] All settings persist across app restarts
- [ ] Tax rate from settings is applied in cart totals
- [ ] Shop name/address appears on generated receipts
- [ ] Test print sends a sample receipt to the selected printer
- [ ] CSV export generates a valid file with all orders in the date range
- [ ] Auto-print setting is read by ReceiptService

---

## Module 15 — Polish, Error Handling & Performance

### Goal
Harden the app for production use: error states, loading states, empty states, keyboard shortcuts, and performance validation.

### Empty states
Every list/grid must have an `EmptyState` widget:
```dart
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;        // e.g., "Add First Product" button
}
```
Define empty states for: products (no products yet), categories, deals, orders (no orders today / in range), tables.

### Loading states
Every `AsyncValue` must handle all 3 states:
```dart
return provider.when(
  data: (data) => DataWidget(data),
  loading: () => const ShimmerLoader(),   // skeleton cards, not a spinner
  error: (e, st) => ErrorCard(message: e.toString(), onRetry: () => ref.invalidate(provider)),
);
```

### Keyboard shortcuts
| Shortcut | Action |
|---|---|
| `Ctrl+N` | New order (navigate to Menu) |
| `Ctrl+P` | Print last receipt |
| `Escape` | Close any open dialog/panel |
| `F1` | Navigate to Dashboard |
| `F2` | Navigate to Menu |
| `F3` | Navigate to Orders |
| `Ctrl+Shift+S` | Navigate to Settings |

Implement via `HardwareKeyboard` listener in `MainLayout`.

### Performance checklist
- [ ] Menu screen products loaded from memory cache, not DB per interaction
- [ ] Order query with date filter uses the `idx_orders_created_at` index (verify with `EXPLAIN QUERY PLAN`)
- [ ] Product search is debounced (300ms) to avoid excessive DB hits
- [ ] Images are displayed with `cacheWidth`/`cacheHeight` to avoid decoding full-res images into memory
- [ ] No `setState` calls that rebuild the entire screen — use Riverpod selects

### Error handling
- Wrap all DB operations in try/catch; surface user-friendly messages via `ScaffoldMessenger`
- Network errors: N/A (fully offline)
- File not found (image): handle gracefully with placeholder
- DB locked: surface error with retry option

### Shimmer loading
Install `shimmer` package. Create `ShimmerCard` and `ShimmerTable` variants matching the actual card/table layouts.

### Acceptance criteria
- [ ] Every screen has an empty state
- [ ] Every screen has a loading state (shimmer, not spinner)
- [ ] Every screen has an error state with retry
- [ ] All keyboard shortcuts work
- [ ] App does not crash when an image file is missing
- [ ] `EXPLAIN QUERY PLAN` on the orders date-range query shows "USING INDEX"
- [ ] App window can be resized from 1280px to 1920px without overflow errors
- [ ] Memory usage is stable after 100 orders placed in a session (no leaks)

---

## Appendix A — Domain Models

```dart
// Use these domain models in UI/providers, not raw Drift data classes

class Product {
  final int id;
  final String name;
  final String? description;
  final int priceInPaisa;
  final int categoryId;
  final String categoryName;
  final String? imagePath;
  final bool isAvailable;

  double get priceInRupees => priceInPaisa / 100;
  String get formattedPrice => 'PKR ${NumberFormat('#,##0').format(priceInRupees)}';
}

class DealWithItems {
  final int id;
  final String name;
  final int priceInPaisa;
  final List<DealItemDetail> items;
  final String? imagePath;
  final bool isAvailable;

  int get originalTotalInPaisa => items.fold(0, (s, i) => s + i.product.priceInPaisa * i.quantity);
  int get savingsInPaisa => originalTotalInPaisa - priceInPaisa;
}

class OrderWithItems {
  final Order order;
  final List<OrderItemDetail> items;
  final String? tableName;

  int get itemCount => items.fold(0, (s, i) => s + i.quantity);
}
```

---

## Appendix B — Seeding Initial Data

Run on first app launch (detect via a `didSeedData` flag in SharedPreferences):

```dart
Future<void> seedInitialData(AppDatabase db) async {
  // Categories
  final catIds = await Future.wait([
    db.categoriesDao.insertCategory(CategoriesCompanion.insert(name: 'Burgers', color: '#FF6B35', icon: 'burger', sortOrder: Value(1))),
    db.categoriesDao.insertCategory(CategoriesCompanion.insert(name: 'Drinks', color: '#3B82F6', icon: 'cup', sortOrder: Value(2))),
    db.categoriesDao.insertCategory(CategoriesCompanion.insert(name: 'Fries', color: '#F59E0B', icon: 'french_fries', sortOrder: Value(3))),
    db.categoriesDao.insertCategory(CategoriesCompanion.insert(name: 'Desserts', color: '#EC4899', icon: 'ice_cream', sortOrder: Value(4))),
    db.categoriesDao.insertCategory(CategoriesCompanion.insert(name: 'Extras', color: '#22C55E', icon: 'plus', sortOrder: Value(5))),
  ]);

  // Sample products per category
  // (insert 2-3 products per category with realistic PKR prices)
  
  // Sample tables
  for (int i = 1; i <= 8; i++) {
    await db.tablesDao.insertTable(RestaurantTablesCompanion.insert(name: 'Table $i', capacity: Value(4)));
  }
}
```

---

## Appendix C — Order Number Generation

```dart
String generateOrderNumber(int dailyCount) {
  final now = DateTime.now();
  final date = DateFormat('yyyyMMdd').format(now);
  final seq = (dailyCount + 1).toString().padLeft(3, '0');
  return 'ORD-$date-$seq';
}

// Get today's order count before generating:
Future<int> getTodayOrderCount(AppDatabase db) async {
  final today = DateTime.now();
  final from = DateTime(today.year, today.month, today.day);
  final to = from.add(const Duration(days: 1));
  return db.ordersDao.countOrdersInRange(from, to);
}
```

---

## Appendix D — Currency Formatting

```dart
class CurrencyFormatter {
  static final NumberFormat _format = NumberFormat('#,##0', 'en_PK');

  static String format(int paisa) {
    final rupees = paisa / 100;
    return 'PKR ${_format.format(rupees)}';
  }

  static String formatCompact(int paisa) {
    final rupees = paisa / 100;
    if (rupees >= 100000) return 'PKR ${(rupees / 100000).toStringAsFixed(1)}L';
    if (rupees >= 1000)   return 'PKR ${(rupees / 1000).toStringAsFixed(1)}K';
    return format(paisa);
  }
  
  static int parseTopaisa(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9.]'), '');
    final value = double.tryParse(cleaned) ?? 0;
    return (value * 100).round();
  }
}
```

---

*End of Cursor Build Document — Fast Food POS*  
*15 Modules · Flutter Desktop · Drift SQLite · Riverpod*
