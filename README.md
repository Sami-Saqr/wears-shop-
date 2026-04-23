# Stylish - E-Commerce Flutter App

A fully functional e-commerce mobile application built with Flutter, featuring a modern UI design with complete shopping functionality.

## Features

### Authentication
- Welcome/Landing screen
- Login with email and password
- Registration with full form validation

### Home & Browsing
- Featured categories (Beauty, Fashion, Kids, Mens, Womens)
- Promotional banner carousel
- Product grid with search functionality
- Product cards with favorites toggle

### Product Details
- Full product view with images
- Rating display
- Quantity selector
- Add to cart functionality
- Favorite toggle

### Cart & Checkout
- Shopping cart with item management
- Quantity adjustment
- Order summary with subtotal, tax, and delivery fee
- Delivery address input
- Place order functionality

### Orders Management
- My Orders screen with tabs (Active, Completed, Cancelled)
- Empty state for no orders
- Order details view
- Cancel order functionality
- Track driver button

### Profile
- User profile display
- Edit profile (name, phone)
- Settings with language toggle (AR/EN)
- Logout functionality

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── data/
│   └── mock_data.dart           # Sample data for products and categories
├── models/
│   ├── product.dart             # Product model
│   ├── cart_item.dart           # Cart item model
│   ├── order.dart               # Order model
│   └── user.dart                # User model
├── providers/
│   ├── auth_provider.dart       # Authentication state
│   ├── cart_provider.dart       # Cart state management
│   ├── favorites_provider.dart  # Favorites state
│   ├── orders_provider.dart     # Orders state
│   └── settings_provider.dart   # App settings
├── screens/
│   ├── welcome_screen.dart      # Landing page
│   ├── login_screen.dart        # Login form
│   ├── register_screen.dart     # Registration form
│   ├── main_navigation_screen.dart  # Bottom navigation
│   ├── home_screen.dart         # Home with products
│   ├── items_screen.dart        # All products
│   ├── search_screen.dart       # Search functionality
│   ├── product_detail_screen.dart   # Product details
│   ├── cart_screen.dart         # Shopping cart
│   ├── checkout_screen.dart     # Checkout process
│   ├── profile_screen.dart      # User profile menu
│   ├── edit_profile_screen.dart # Edit profile form
│   ├── settings_screen.dart     # App settings
│   ├── my_orders_screen.dart    # Orders list
│   └── order_details_screen.dart    # Order details
├── widgets/
│   ├── product_card.dart        # Product grid item
│   ├── category_item.dart       # Category circle
│   ├── promo_banner.dart        # Promotional banner
│   ├── search_bar_widget.dart   # Search input
│   ├── quantity_selector.dart   # +/- quantity control
│   ├── cart_item_card.dart      # Cart list item
│   ├── checkout_item_card.dart  # Checkout list item
│   └── order_card.dart          # Order list item
└── utils/
    └── constants.dart           # Colors and styles
```

## Getting Started

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. Clone the repository or copy the flutter_stylish_app folder

2. Navigate to the project directory:
```bash
cd flutter_stylish_app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Dependencies

- **provider**: State management
- **intl**: Date formatting and internationalization
- **cupertino_icons**: iOS-style icons

## Design System

### Colors
- Primary: `#F83758` (Coral/Pink)
- Primary Light: `#FFE4E9`
- Secondary: `#4392F9` (Blue)
- Text Primary: `#1D1D1D`
- Text Secondary: `#8A8A8A`
- Star Color: `#EDB310` (Gold)

### Typography
Uses system fonts with various weights (400, 500, 600, 700)

## Customization

### Adding Real Backend
Replace the mock implementations in the providers with actual API calls:

1. **AuthProvider**: Connect to your authentication service
2. **CartProvider**: Sync with backend cart storage
3. **OrdersProvider**: Connect to order management API
4. **Products**: Replace MockData with API calls

### Adding Local Storage
Consider adding `shared_preferences` or `hive` for persistent local storage.

### Adding Images
Uncomment the assets section in `pubspec.yaml` and add your local images.

## License

This project is for educational purposes. Feel free to use and modify as needed.
