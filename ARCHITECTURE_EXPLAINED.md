# 📚 Complete Architecture Guide - Step by Step

## 🎯 What is Clean Architecture?

**Simple Explanation:**
Imagine building a house. You don't mix the electrical wiring with the plumbing, right? Same with code - we separate different responsibilities into different layers.

**Why?**
- ✅ Easy to find things
- ✅ Easy to test
- ✅ Easy to change one part without breaking others
- ✅ Easy for teams to work together

---

## 📁 The 4 Main Layers

```
lib/
├── app/        → Application layer (UI config, routes, theme)
├── data/       → Data layer (where data comes from)
├── modules/    → Feature layer (each feature is separate)
└── core/       → Infrastructure layer (tools everyone uses)
```

Let me explain each one...

---

## 1️⃣ APP LAYER (`lib/app/`)

### 📍 Purpose
Contains **application-wide** configurations that the whole app uses.

### 📂 Structure
```
app/
├── routes/           # Where to go (navigation)
├── theme/           # How it looks (colors, fonts)
└── utils/           # Helper tools (validators, formatters)
```

### 🤔 Why?

#### **A. Routes** (`app/routes/`)
```dart
// app/routes/app_pages.dart
GetPage(
  name: '/login',
  page: () => LoginScreen(),
  binding: AuthBinding(),
)
```

**What it does:** Defines all pages in your app  
**Why we need it:** 
- One place to see all screens
- Easy navigation: `Get.toNamed('/login')`
- Organized route management

**Real example:**
```dart
// Instead of:
Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));

// We do:
Get.toNamed('/login');  // Much cleaner!
```

---

#### **B. Theme** (`app/theme/`)

**Files:**
1. `app_colors.dart` - All colors
2. `app_text_styles.dart` - All text styles
3. `app_theme.dart` - Complete theme

**Why separated?**

```dart
// app_colors.dart
class AppColors {
  static const Color primary = Color(0xFF667EEA);
  static const Color secondary = Color(0xFF764BA2);
}

// Now anywhere in app:
Container(color: AppColors.primary)  // ✅ Consistent!
```

**Benefits:**
- Change color once, updates everywhere
- No magic colors scattered in code
- Easy to create dark mode later

---

#### **C. Utils** (`app/utils/`)

**Files:**
1. `constants.dart` - Fixed values
2. `validators.dart` - Check if input is valid
3. `helpers.dart` - Useful functions
4. `extensions.dart` - Add features to existing types

**Why each one?**

**1. Constants:**
```dart
// constants.dart
class Constants {
  static const String appName = 'eNews';
  static const String baseUrl = 'https://api.example.com';
}

// Use everywhere:
Text(Constants.appName)
```
**Why?** Change once, updates everywhere. No typos!

**2. Validators:**
```dart
// validators.dart
class Validators {
  static bool isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }
}

// In your form:
if (!Validators.isValidEmail(email)) {
  showError('Invalid email');
}
```
**Why?** Reuse validation logic. Write once, use everywhere!

**3. Helpers:**
```dart
// helpers.dart
class Helpers {
  static String formatNumber(int number) {
    if (number >= 1000) return '${number ~/ 1000}K';
    return '$number';
  }
}

// Usage:
Text(Helpers.formatNumber(1500))  // Shows "1K"
```
**Why?** Common tasks become simple one-liners!

**4. Extensions:**
```dart
// extensions.dart
extension DateTimeExtensions on DateTime {
  String toTimeAgo() {
    final diff = DateTime.now().difference(this);
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// Usage:
Text(article.publishedAt.toTimeAgo())  // "2h ago"
```
**Why?** Makes code read like English! Super clean!

---

## 2️⃣ DATA LAYER (`lib/data/`)

### 📍 Purpose
Handles **ALL data** - where it comes from, where it goes, how it's stored.

### 📂 Structure
```
data/
├── models/          # What data looks like
├── services/        # Get data from API/Auth
├── repositories/    # Organize data access
└── local/          # Save data locally
```

### 🤔 Why Each Part?

---

#### **A. Models** (`data/models/`)

**What:** Describes what your data looks like

```dart
// article_model.dart
class ArticleModel {
  final String id;
  final String title;
  final String author;
  final DateTime publishedAt;
  
  ArticleModel({
    required this.id,
    required this.title,
    required this.author,
    required this.publishedAt,
  });
  
  // Convert from JSON (from API)
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }
  
  // Convert to JSON (to save)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }
}
```

**Why?**
- ✅ Type safety (compiler catches errors)
- ✅ Easy to convert API data to objects
- ✅ Easy to save objects to storage
- ✅ Autocomplete in IDE

**Example of benefit:**
```dart
// WITHOUT model (BAD):
var title = data['title'];  // Might be null? Might crash?

// WITH model (GOOD):
ArticleModel article = ArticleModel.fromJson(data);
var title = article.title;  // ✅ Always String, safe!
```

---

#### **B. Services** (`data/services/`)

**What:** Talk to external things (API, Auth system)

**Example: API Service**
```dart
// api_service.dart
class ApiService {
  Future<List<ArticleModel>> fetchArticles() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    
    // Return sample data
    return [
      ArticleModel(
        id: '1',
        title: 'Breaking News',
        author: 'John Doe',
        publishedAt: DateTime.now(),
      ),
    ];
  }
}
```

**Why separate service?**
- ✅ All API calls in one place
- ✅ Easy to switch from fake data to real API
- ✅ Easy to test

**Example: Auth Service**
```dart
// auth_service.dart
class AuthService {
  final StorageService _storage = StorageService();
  
  Future<bool> login(String email, String password) async {
    // Check credentials
    final users = _storage.read('users');
    // Validate...
    return true;
  }
}
```

---

#### **C. Repositories** (`data/repositories/`)

**What:** Middle layer between Controllers and Services

**This is IMPORTANT! Let me explain with a story:**

**WITHOUT Repository (Bad):**
```dart
// In LoginController
class LoginController {
  final AuthService _authService = AuthService();
  
  Future<void> login() async {
    // Talk directly to service
    final success = await _authService.login(email, password);
    
    if (success) {
      // Also save user
      await StorageService().saveUser(user);
      
      // Also log analytics
      await AnalyticsService().logLogin();
    }
  }
}














```

**Problem:** Controller does TOO MUCH! Hard to test, hard to change.

**WITH Repository (Good):**
```dart
// auth_repository.dart
class AuthRepository {
  final AuthService _authService = AuthService();
  final StorageService _storage = StorageService();
  
  Future<UserModel?> login(String email, String password) async {
    // 1. Validate credentials
    final userData = _authService.validateLogin(email, password);
    
    if (userData != null) {
      // 2. Save user
      await _storage.saveCurrentUser(userData);
      
      // 3. Return user model
      return UserModel.fromLegacyMap(userData);
    }
    
    return null;
  }
}

// In LoginController (Clean!)
class LoginController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  
  Future<void> login() async {
    final user = await _authRepo.login(email, password);
    
    if (user != null) {
      Get.toNamed('/home');  // Simple!
    }
  }
}
```

**Benefits:**
- ✅ Controller is simple (just calls repository)
- ✅ Repository handles complex logic
- ✅ Easy to test (mock repository)
- ✅ Easy to change data source

**Real-world example:**
```dart
// Want to switch from local storage to Firebase?
// Just change AuthRepository, controllers stay the same!

class AuthRepository {
  // Before:
  final AuthService _authService = AuthService();
  
  // After:
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  // Controllers don't need to change!
}
```

---

#### **D. Local Storage** (`data/local/`)

**Files:**
1. `storage_service.dart` - Simple read/write
2. `cache_manager.dart` - Smart caching with expiry

**Why?**

**1. Storage Service:**
```dart
// storage_service.dart
class StorageService {
  final GetStorage _storage = GetStorage();
  
  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }
  
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }
}
```

**Why?** Wraps GetStorage, easy to switch to another storage later!

**2. Cache Manager:**
```dart
// cache_manager.dart
class CacheManager {
  Future<void> cacheData(String key, dynamic data, {Duration? expiry}) async {
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
      'expiry': expiry?.inSeconds,
    };
    await storage.write(key, cacheData);
  }
  
  T? getCachedData<T>(String key) {
    final cacheData = storage.read(key);
    
    // Check if expired
    if (isExpired(cacheData)) {
      return null;  // Cache expired, fetch fresh data
    }
    
    return cacheData['data'];
  }
}
```

**Why?**
- ✅ Save API calls (use cached data if fresh)
- ✅ Work offline
- ✅ Faster app (no waiting for network)

**Example:**
```dart
// First load - fetches from API (slow)
final articles = await repository.getArticles();

// Second load - uses cache (instant!)
final articles = await repository.getArticles();
```

---

## 3️⃣ MODULES LAYER (`lib/modules/`)

### 📍 Purpose
Each **feature** is a separate, self-contained module.

### 📂 Structure
```
modules/
├── auth/
│   ├── controllers/      # Login logic
│   ├── views/           # Login screens
│   ├── bindings/        # Setup dependencies
│   └── models/          # Auth-specific models
│
└── home/
    ├── controllers/      # Home logic
    ├── views/           # Home screen
    └── bindings/        # Setup dependencies
```

### 🤔 Why Feature Modules?

**OLD WAY (All mixed together):**
```
app/
├── controllers/
│   ├── login_controller.dart
│   ├── register_controller.dart
│   ├── home_controller.dart
│   ├── profile_controller.dart
│   └── ... (15 files mixed)
```

**Problem:** Hard to find related files!

**NEW WAY (Organized by feature):**
```
modules/
├── auth/                    # Everything auth-related
│   ├── controllers/
│   │   └── auth_controller.dart
│   ├── views/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   └── bindings/
│       └── auth_binding.dart
```

**Benefits:**
- ✅ All auth code in one folder
- ✅ Easy to find
- ✅ Can work on auth without touching home
- ✅ Can delete entire feature easily
- ✅ Perfect for teams (one person = one module)

---

### 🔍 Inside a Module

Let's understand each part:

#### **A. Controllers** (`controllers/auth_controller.dart`)

**What:** Contains business logic (what happens when user clicks login)

```dart
class AuthController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;  // Observable (UI updates automatically)
  
  Future<void> login() async {
    // 1. Validate
    if (email.isEmpty) {
      showError('Email required');
      return;
    }
    
    // 2. Show loading
    isLoading.value = true;
    
    // 3. Try to login
    final user = await _authRepo.login(email, password);
    
    // 4. Hide loading
    isLoading.value = false;
    
    // 5. Handle result
    if (user != null) {
      Get.toNamed('/home');
    } else {
      showError('Login failed');
    }
  }
}
```

**Why controller?**
- ✅ Separates logic from UI
- ✅ Easy to test (no UI needed)
- ✅ Reusable logic

---

#### **B. Views** (`views/login_screen.dart`)

**What:** The UI that users see

```dart
class LoginScreen extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: controller.emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          
          TextField(
            controller: controller.passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          
          Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value 
              ? null 
              : controller.login,
            child: controller.isLoading.value
              ? CircularProgressIndicator()
              : Text('Login'),
          )),
        ],
      ),
    );
  }
}
```

**Why separate view?**
- ✅ UI code is clean
- ✅ No business logic mixed in
- ✅ Easy to redesign UI without touching logic

---

#### **C. Bindings** (`bindings/auth_binding.dart`)

**What:** Sets up dependencies (creates controller when needed)

```dart
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
```

**Why?**
- ✅ Controller is created automatically when you open the screen
- ✅ Controller is disposed automatically when you leave the screen
- ✅ No memory leaks!

**How it works:**
```dart
// In routes
GetPage(
  name: '/login',
  page: () => LoginScreen(),
  binding: AuthBinding(),  // ← Creates controller automatically
)

// When user opens /login:
// 1. AuthBinding runs
// 2. Creates AuthController
// 3. LoginScreen can use controller
// 4. When user leaves, controller is disposed
```

---

#### **D. Models** (`models/login_model.dart`)

**What:** Feature-specific data structures

```dart
class LoginModel {
  final String email;
  final String password;
  
  LoginModel({required this.email, required this.password});
  
  bool get isValid => email.isNotEmpty && password.isNotEmpty;
}
```

**Why?** Sometimes a feature needs its own models that don't belong in `data/models/`

---

## 4️⃣ CORE LAYER (`lib/core/`)

### 📍 Purpose
Infrastructure that **everyone** uses across the entire app.

### 📂 Structure
```
core/
├── network/          # API client, error handling
├── bindings/         # Global dependency injection
└── localization/     # Multi-language support
```

---

### 🤔 Why Each Part?

#### **A. Network** (`core/network/`)

**Files:**
1. `api_client.dart` - HTTP client wrapper
2. `network_exceptions.dart` - Handle errors nicely

**Why?**

**Without API Client (Bad):**
```dart
// Repeated everywhere:
final response = await http.get('https://api.example.com/articles');
if (response.statusCode == 200) {
  return json.decode(response.body);
} else if (response.statusCode == 401) {
  // Handle unauthorized
} else if (response.statusCode == 404) {
  // Handle not found
}
// ... same code everywhere!
```

**With API Client (Good):**
```dart
// api_client.dart
class ApiClient {
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get('$baseUrl$endpoint');
      return _handleResponse(response);  // Handles all status codes
    } catch (e) {
      throw NetworkExceptions.handleException(e);
    }
  }
  
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200: return json.decode(response.body);
      case 401: throw NetworkExceptions.unauthorised();
      case 404: throw NetworkExceptions.notFound();
      default: throw NetworkExceptions.serverError();
    }
  }
}

// Now in services (Simple!):
final data = await apiClient.get('/articles');
```

**Benefits:**
- ✅ Write error handling once
- ✅ Consistent across app
- ✅ Easy to add authentication headers
- ✅ Easy to add logging

---

#### **B. Bindings** (`core/bindings/`)

**File:** `initial_bindings.dart`

**What:** Creates global services when app starts

```dart
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Services used everywhere
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    
    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<ArticleRepository>(() => ArticleRepository(), fenix: true);
  }
}
```

**Why?**
- ✅ Services created once (not recreated every screen)
- ✅ Available everywhere with `Get.find<AuthRepository>()`
- ✅ `fenix: true` = recreated if disposed and needed again

**How it works:**
```dart
// main.dart
GetMaterialApp(
  initialBinding: InitialBindings(),  // ← Runs on app start
  home: SplashScreen(),
)

// Anywhere in app:
class LoginController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();  // ✅ Works!
}
```

---

#### **C. Localization** (`core/localization/`)

**Files:**
1. `app_localization.dart` - Setup
2. `en_us.dart` - English translations
3. `km_kh.dart` - Khmer translations

**Why?**

**Without localization:**
```dart
Text('Login')  // Hard-coded English only
```

**With localization:**
```dart
// en_us.dart
const Map<String, String> enUs = {
  'login': 'Login',
  'email': 'Email',
};

// km_kh.dart
const Map<String, String> kmKh = {
  'login': 'ចូលប្រើ',
  'email': 'អ៊ីមែល',
};

// In UI:
Text('login'.tr)  // Shows "Login" or "ចូលប្រើ" based on language
```

**Benefits:**
- ✅ Support multiple languages
- ✅ Change language without rebuilding app
- ✅ All translations in one place

---

## 🔄 How Everything Works Together

Let's trace a **Login** action from start to finish:

### Step 1: User Opens Login Screen
```
User taps "Login" button
    ↓
Routes system (app/routes/app_pages.dart)
    ↓
AuthBinding creates AuthController
    ↓
LoginScreen displays
```

### Step 2: User Enters Email & Password
```
User types in TextFields
    ↓
Stored in AuthController's emailController & passwordController
```

### Step 3: User Taps "Login" Button
```
LoginScreen calls controller.login()
    ↓
AuthController.login() method runs:

    1. Validates input (using Validators from app/utils/)
    2. Sets isLoading = true (UI shows spinner)
    3. Calls AuthRepository.login()
       ↓
       AuthRepository calls AuthService.validateLogin()
           ↓
           AuthService checks credentials in StorageService
           ↓
           Returns user data or null
       ↓
       AuthRepository converts to UserModel
       ↓
       Returns to Controller
    4. Sets isLoading = false
    5. If success: Navigate to home
       If fail: Show error message
```

**The Flow:**
```
UI (View)
    ↓
Controller (Business Logic)
    ↓
Repository (Data Orchestration)
    ↓
Service (External Communication)
    ↓
Storage (Local Data)
```

---

## 📊 Summary: Why This Structure?

### **1. Separation of Concerns**
Each layer has ONE job:
- **UI** = Show data
- **Controller** = Handle logic
- **Repository** = Organize data
- **Service** = Get data
- **Model** = Structure data

### **2. Easy to Find Things**
```
Need to change login UI? → modules/auth/views/
Need to change login logic? → modules/auth/controllers/
Need to change API? → data/services/
Need to change colors? → app/theme/
```

### **3. Easy to Test**
```dart
// Test controller without UI
test('login should fail with empty email', () {
  final controller = AuthController();
  controller.emailController.text = '';
  
  expect(controller.login(), throwsException);
});

// Test repository with mock service
test('login should return user', () async {
  final mockService = MockAuthService();
  final repository = AuthRepository(service: mockService);
  
  final user = await repository.login('test@test.com', 'password');
  
  expect(user, isNotNull);
});
```

### **4. Easy to Change**
Want to switch from local storage to Firebase?
```dart
// Only change AuthService, everything else stays same!
class AuthService {
  // Before:
  final StorageService storage = StorageService();
  
  // After:
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
}
```

### **5. Team-Friendly**
- Person A works on Auth module
- Person B works on Home module
- No conflicts!

---

## 💡 Quick Reference

### **When to use each layer:**

| Need to... | Use... | Location |
|------------|--------|----------|
| Add a color | AppColors | `app/theme/app_colors.dart` |
| Validate email | Validators | `app/utils/validators.dart` |
| Format date | Helpers | `app/utils/helpers.dart` |
| Add route | AppPages | `app/routes/app_pages.dart` |
| Create model | Models | `data/models/` |
| Call API | Service | `data/services/` |
| Get/Save data | Repository | `data/repositories/` |
| Cache data | CacheManager | `data/local/cache_manager.dart` |
| Add feature | Module | `modules/feature_name/` |
| Handle errors | NetworkExceptions | `core/network/network_exceptions.dart` |
| Add translation | Localization | `core/localization/` |

---

## 🎓 Final Notes

### **Remember:**
1. **UI** talks to **Controller**
2. **Controller** talks to **Repository**
3. **Repository** talks to **Service**
4. **Service** talks to **API/Storage**

### **Never:**
- ❌ UI directly calling Service
- ❌ Controller directly calling Storage
- ❌ Mixing business logic in UI

### **Always:**
- ✅ Each file has ONE responsibility
- ✅ Each layer talks only to the layer below
- ✅ Use models for type safety
- ✅ Use repositories to abstract data access

---

## 🚀 You're Ready!

This architecture will help you build:
- ✅ Clean, organized code
- ✅ Testable applications
- ✅ Scalable projects
- ✅ Maintainable systems

**Happy coding!** 🎉
