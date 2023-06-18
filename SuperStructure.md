# Super Structure

Designed By: [Seyon Anko](https://github.com/DrDejaVuNG)

- /lib:
    - /app:  This directory contains all the main application directories.
        - /config:  Directory containing all configuration files.
            - /core:  Core configuration directory.
            - /locales:  Directory containing language translation files.
            - /plugins:  Directory for adding plugin files for the application.
            - /routes:  Directory for storing routes and paths.
            
        - /data:  Directory containing everything related to the app's data.
            - /api:  Directory for API services.
            - /database:  Directory for local databases.
            - /json:  Directory containing local JSON data.
              
        - /interface:  Directory for the interface, which enables user interaction with the app's data.
            - /modules:  Directory for modules, which are bundles of tools required to create an interface.
                - /moduleName:  Directory for a specific module.
                    - /components:  Directory for local widgets and other components specific to the module.
                    - /controllers:  Directory for module-specific controllers.
                    - /models:  Directory for module-specific models.
                    - /notifiers:  Directory for local notifiers. (optional)
                    - /repositories:  Directory for module-specific repositories.
                    - /views:  Directory for module-specific views.
                    
            - /shared:  Directory for shared resources.
                - /notifiers:  Directory for global notifiers.
                - /models:  Directory for shared models.
                - /repositories:  Directory for shared repositories.
                - /widgets:  Directory for reusable widgets used by multiple modules.

    - main.dart: Entry point to the application.

```yaml
- /lib/app  
# This directory contains the main application files and directories.

    - /config
    # Contains configuration files for the application.
    
        - /core
        # Core configuration files and utilities.

            - assets.dart
            # File defining the assets used in the application.

            - colors.dart
            # File containing reusable color constants used throughout the application.

            - enums.dart
            # File defining enums used in the application.

            - exceptions.dart
            # File containing classes for handling exceptions and errors.

            - theme.dart
            # File defining the application's theme.

            - strings.dart
            # File containing globally reusable strings used in the application.
            # For example: String failMessage = "Something Went Wrong";

            - dependencies.dart
            # File for initializing dependencies on app start.
            # For example: void init() async {await Hive.initFlutter(); await Hive.openBox('Box');}
            # All dependencies should be placed in the init method and then used in the main function.
            # For example: main() async {init(); runApp();}

        - /locales
        # Contains language translation files.
            - en-AU.dart
            # English (Australia) translation file.
            - en-GB.dart
            # English (United Kingdom) translation file.

        - /plugins
        # Contains plugin files for the application, such as notifications.dart.

        - /routes
        # Contains routes and paths for navigation within the application.
        
    - /data
    # Contains files related to the application's data.

        - /api
        # Directory for API services, such as Firebase.

            - /firebase

                - firebase_client.dart
                    # File for initializing the connection to the Firebase API client.

        - /database
        # Directory for local databases, such as states and files.
        
            - document_db.dart
            # File for initializing the document database.
            # For example: var box = Hive.box('Box');
            # It may also contain functions to perform operations on the database instance.

        - /json
        # Contains local JSON data.
        # For example:
            - enDictionary.json
            # JSON file containing an English dictionary with words and definitions.

    - /interface
    # The interface acts as a bridge between the user and the data, enabling user interaction with the app.

        - /modules
        # Modules bundle the tools required to create an interface, including views, components, and controllers.
        # Each module represents a section of the app that may have multiple related views, components, etc.
        # For example, an account module could have views like bookmarks, friends, notifications, etc.

            - /auth
            # Contains authentication-related views, such as login, signup, forgot password, and enter OTP.

                - /components
                # Contains local widgets and other components specific to this module.

                - /controllers
                # Contains local controllers that handle app data interaction and state updates.

                - /models
                # Contains models specific to the authentication module.

                - /notifiers (optional)
                # Contains local notifiers for the authentication module.

                - /repositories
                # Contains API service repositories, such as auth_repo.dart.
                # Repositories mediate the communication between controllers and services.
                # They contain functions that request data from the API client.
                # For example, using Firebase Auth service, it would contain functions for email/password login and signup.

                - /views
                # Contains view files for the authentication module.
                # Assuming it contains two files: login_view.dart and signup_view.dart.
                # These views can interact with a single controller that updates the module state.
                # However, separate controllers for each view can also be used.
                    
        - /shared
        # Contains files shared across multiple modules.

            - /notifiers
            # Contains global notifiers used for parts of the app that require global state, like themes and settings.

            - /models
            # Contains shared models.

            - /repositories
            # Contains shared repositories.

            - /widgets
            # Contains widgets shared across multiple modules.  

- main.dart  
# Entry point of the application.
```

