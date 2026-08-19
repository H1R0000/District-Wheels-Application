# 🏎️ District Wheels

**District Wheels** is a dedicated mobile marketplace built specifically for diecast car collectors. It provides a centralized platform for enthusiasts to buy, sell, and manage their collections with ease. 

Built with a seamless dual-role architecture, users can instantly toggle between a Buyer's feed to hunt for rare finds, and a Seller's dashboard to manage their own hobby shop inventory—all from a single account.

---

## ✨ Core Features

### For Buyers
* **Dynamic Home Feed:** Discover active diecast listings with an auto-sliding promotional banner.
* **Smart Cart Engine:** Cart items are automatically grouped by the Seller's shop. Real-time stock validation prevents adding out-of-stock items.
* **Favorites System:** Save specific models to a wishlist for quick access later.
* **Streamlined Checkout:** Automatic subtotal computation, flat-rate shipping application, and integrated profile data for one-tap ordering.

### For Sellers
* **Inventory Management:** Full CRUD (Create, Read, Update, Delete) capabilities for shop listings.
* **Multi-Asset Uploads:** Upload multiple angles of a diecast car directly from the device gallery.
* **Categorization:** Standardized scale tags (e.g., 1:64, 1:43) and condition grading (e.g., Mint in Box, Custom).
* **Live Notifications:** Receive instant in-app alerts when a buyer purchases an item.

---

## 🛠️ Tech Stack

* **Frontend:** [Flutter](https://flutter.dev/) (Dart)
* **State Management:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
* **Backend as a Service (BaaS):** [Supabase](https://supabase.com/)
  * **Authentication:** Secure email/password login.
  * **Database:** PostgreSQL for relational data storage (Users, Products, Orders, Cart, Favorites).
  * **Storage:** Supabase Storage buckets for multi-image product galleries.

---

## 📱 Project Structure

The project follows a feature-based architecture separating UI, core logic, and models:

```text
lib/
├── core/
│   └── providers/       # Riverpod state managers (Cart, Products, Auth, Notifications)
├── models/              # Dart data classes (Product, User, CartItem, Order)
├── services/            # Backend integration (DatabaseService, AuthService)
├── theme/               # App-wide constants (Brand Yellow, Helvetica/Garet typography)
└── ui/
    ├── auth/            # Login and Registration flows
    ├── buyer/           # Buyer feed, cart, checkout, and favorites screens
    ├── seller/          # Seller dashboard, add/edit listing screens
    └── shared/          # Reusable components, Profile management, Role Toggle wrapper
