# Wazeet - Flutter Business Setup App

A comprehensive Flutter application for business setup and trade license management in the UAE. Wazeet simplifies the process of company formation, document management, service booking, and payment processing.

## 🚀 Features

- **Company Formation**: Complete business setup workflow
- **Trade License Management**: Track and manage trade license applications
- **Document Management**: Upload, view, and organize business documents
- **Service Booking**: Book various business services and consultations
- **Payment Integration**: Stripe integration for secure payments
- **Multi-language Support**: English and Arabic localization
- **Admin Dashboard**: Comprehensive admin panel for managing users and services
- **Real-time Notifications**: Stay updated with application status
- **Role-based Access Control**: Different access levels for users and admins

## 📱 App Structure

### Core Features
- **Authentication**: Sign up, sign in, password recovery
- **Dashboard**: Home screen with quick actions and recent activities
- **Profile Management**: User profile and settings
- **Community**: Community features and interactions
- **Growth Services**: Business growth and consultation booking

### Business Services
- **Company Setup**: Business setup wizard with step-by-step guidance
- **Trade License**: Trade license application and tracking
- **Document Services**: Document upload, management, and viewing
- **Service Categories**: Various business services organized by categories

### Admin Features
- **User Management**: Manage users and their permissions
- **Content Management**: Manage app content and services
- **Analytics**: Business analytics and reporting
- **Package Management**: Manage service packages and pricing
- **Audit Logs**: Track all admin activities

## 🛠 Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase
- **Database**: PostgreSQL (via Supabase)
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage
- **Payments**: Stripe
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Internationalization**: Flutter i18n

## 📦 Dependencies

Key packages used in this project:

```yaml
dependencies:
  flutter: ^3.24.5
  supabase_flutter: ^2.8.2
  riverpod: ^2.5.1
  flutter_riverpod: ^2.5.1
  go_router: ^14.6.1
  stripe_android: ^12.0.0
  stripe_ios: ^13.0.0
  image_picker: ^1.1.2
  file_picker: ^8.1.4
  shared_preferences: ^2.3.3
  url_launcher: ^6.3.1
```

## 🏗 Project Structure

```
lib/
├── app.dart                 # Main app configuration
├── main.dart               # Entry point
├── router.dart             # App routing configuration
├── core/                   # Core utilities and services
│   ├── env.dart           # Environment configuration
│   ├── supabase_client.dart # Supabase configuration
│   ├── theme.dart         # App theming
│   └── widgets/           # Reusable widgets
├── features/              # Feature modules
│   ├── auth/              # Authentication
│   ├── dashboard/         # Home dashboard
│   ├── company_setup/     # Business setup
│   ├── trade/             # Trade license
│   ├── services/          # Service management
│   ├── admin/             # Admin panel
│   └── profile/           # User profile
├── models/                # Data models
├── data/                  # Data repositories
└── l10n/                  # Localization files
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.24.5)
- Dart SDK
- Android Studio / VS Code
- Supabase account
- Stripe account (for payments)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Aman2711shah/wazeet-flutter-app.git
   cd wazeet-flutter-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Environment Setup**
   
   Create a `.env` file in the root directory:
   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Building APK

To build a release APK:

```bash
flutter build apk
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

## 🔧 Configuration

### Supabase Setup

1. Create a new Supabase project
2. Run the SQL schema from `supabase/schema.sql`
3. Apply RLS policies from `supabase/policies.sql`
4. Deploy cloud functions from `supabase/functions/`

### Stripe Setup

1. Create a Stripe account
2. Get your publishable and secret keys
3. Configure webhook endpoints for payment processing

## 🌐 Localization

The app supports multiple languages:
- English (en)
- Arabic (ar)

Localization files are located in:
- `assets/i18n/` - JSON translation files
- `lib/l10n/` - Generated localization classes

## 🎨 Design System

The app follows Material Design principles with:
- Custom color schemes
- Consistent typography
- Responsive layouts
- Dark/Light theme support

## 📊 Admin Features

Administrators have access to:
- User management and role assignment
- Content and service management
- Application status tracking
- Analytics and reporting
- System settings and configuration

## 🔐 Security

- Row Level Security (RLS) with Supabase
- Role-based access control
- Secure payment processing with Stripe
- Environment-based configuration
- API key protection

## 🚀 Deployment

### Android
- Configure signing in `android/app/build.gradle.kts`
- Build release APK or AAB for Play Store

### iOS
- Configure signing in Xcode
- Build for App Store distribution

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Contact the development team

## 🔄 Version History

- **v1.0.0** - Initial release with core features
  - Company formation workflow
  - Trade license management
  - Document handling
  - Payment integration
  - Admin dashboard

---

**Built with ❤️ using Flutter**