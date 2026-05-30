# ⚡ District Wheels

A modern multi-vendor marketplace application for die-cast collectors, automotive enthusiasts, and hobbyists. Built with Flutter and Supabase, District Wheels provides a seamless platform for buying, selling, and managing collectible cars, wheels, and automotive accessories in real time.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge\&logo=flutter\&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=for-the-badge\&logo=supabase\&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-State_Management-02569B?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Web-FFD301?style=for-the-badge)

---

## 🚀 Overview

District Wheels is a full-stack marketplace solution that connects buyers and sellers through an intuitive and responsive mobile experience. The platform supports product listings, inventory management, shopping carts, favorites, notifications, and order tracking powered by Supabase's real-time infrastructure.

---

## ✨ Key Features

### 🛒 Buyer Experience

* Browse products with detailed descriptions and images
* Add products to cart and wishlist
* Secure checkout workflow
* Real-time order tracking and notifications
* User profile management

### 📦 Seller Experience

* Create and manage product listings
* Upload multiple product images
* Track inventory and stock levels
* Receive purchase notifications instantly
* Manage pricing and product information

### 🔄 Real-Time Functionality

* Live database synchronization
* Automatic inventory updates
* Instant notification system
* Real-time order management

---

## 🏗️ Tech Stack

### Frontend

* Flutter
* Material Design 3
* Riverpod

### Backend

* Supabase
* PostgreSQL
* Authentication
* Storage Buckets
* Real-time Database Events

### Development Tools

* Dart
* Git & GitHub
* Flutter Launcher Icons

---

## 📂 Project Structure

```text
lib/
├── core/
│   └── providers/
├── models/
├── services/
├── theme/
└── ui/
    ├── auth/
    ├── buyer/
    ├── seller/
    └── shared/
```

---

## 🛠️ Installation

### Prerequisites

* Flutter SDK
* Dart SDK
* Supabase Project

### Clone Repository

```bash
git clone https://github.com/your-username/District-Wheels-Application.git
cd district-wheels
```

### Install Dependencies

```bash
flutter pub get
```

### Configure Supabase

Initialize your Supabase project in `main.dart`:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### Run Application

```bash
flutter run
```

---

## 🗄️ Core Features Powered by Supabase

* User Authentication & Session Management
* Product Listings & Inventory Management
* Shopping Cart System
* Favorites/Wishlist Functionality
* Order Tracking
* Real-Time Notifications
* Cloud Storage for Product Images
* PostgreSQL Database Integration

---

## 🎨 Design System

District Wheels uses a bold and modern design language featuring:

* Signature Yellow (#FFD301)
* Clean Black & White Contrast
* Helvetica Now Typography
* Garet Typography
* Minimalist Marketplace Interface
* Responsive Mobile-First Design
* Consistent Material Design 3 Components

---

## 🔐 Security

* Supabase Authentication
* Secure Session Management
* Database Row-Level Security (RLS)
* Protected User Data
* Secure Storage Integration

---

## 📈 Future Improvements

* In-app messaging
* Product reviews and ratings
* Online payment gateway integration
* Advanced search and filtering
* Push notifications
* Seller analytics dashboard
* Product recommendations
* AI-powered search capabilities

---

## 👨‍💻 Development Team

### Lead Developer

**Hero Park**
Computer Science Student | Flutter Developer | Full-Stack Application Developer

Responsible for:

* System Architecture
* Flutter Development
* Supabase Integration
* Database Design
* Authentication System
* State Management (Riverpod)
* Product & Inventory Management
* Order Processing
* Application Deployment
* Overall Project Development

### UI/UX Designer

**Maria Christine Lourdes Ramos Dizon**
UI/UX Designer

Responsible for:

* User Experience Design
* User Interface Design
* Design System Development
* User Flow Planning
* Wireframing & Prototyping
* Visual Consistency
* Brand Identity Implementation

---

District Wheels was developed as a collaborative project showcasing modern mobile development, real-time database integration, scalable marketplace architecture, and user-centered design principles.

---

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for details.
