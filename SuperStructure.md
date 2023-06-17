# Super Structure

Designed By: [Seyon Anko](https://github.com/DrDejaVuNG)

- /lib
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
# This is where all main application directories will be contained 

    - /config
    # Directory containing all configuration files
    
        - /core
            
            - assets.dart

            - colors.dart
            # colors that can be reused throughout the application
            
            - enums.dart

            - exceptions.dart
            # error handling and classes
            
            - theme.dart  

            - strings.dart
            # globally reusable strings
            # example : String failMessage = "Something Went Wrong";
            
            - dependencies.dart
            # Could contain dependencies to be initialized on app start
            # e.g void init() async {await Hive.initFlutter(); await Hive.openBox('Box');}
            # all dependencies would be placed in the init method, then used in main function 
            # e.g main() async {init(); runApp();}
            
        - /locales
        # Directory containing language translation files
            - en-AU.dart
            - en-GB.dart

        - /plugins
        # Here you can add plugin files for your application e.g notifications.dart

        - /routes
        # In this repository we will deposit our routes and paths.
        
    - /data
    # Directory containing everything related to the app's data

        - /api
        # Directory for api services e.g firebase, 

            - /firebase

                - /client
                # Directory for initializing connection to the api
                    - firebase_client.dart
        
        - /database
        # Directory for our local databases e.g states, files
        
            - document_db.dart
            # Here the database is initialized
            # e.g var box = Hive.box('Box');
            # it would also contain functions to perform operations on the database instance.
    
        - /json
        # Directory containing local json data
        # For example,
            - enDictionary.json
            # An english dictionary json file containing words and definition.

    - /interface
    # The interface is the bridge between the user and the data, it enables the user to interact with the app.
    # For example if a user wanted to access a list of products, they could click a button on a view 
    # which fires an event in a controller which then fetches the data and displays it on the view.
        
        - /modules
        # A module is a bundle of tools required to create an interface, this includes views, components, controllers, etc.
        # You can think of a module as a section of our app, which could have several views, components etc which are all
        # related to each other like an e.g an account module could have a bookmarks view, friends view, notifications view, 
        # etc, all things related to an account. Here's an example for authentication:

            - /auth
            # Using auth as an example, the views it could contain include, login, signup, forgot password, enter otp etc.
                
                - /components
                # Directory for local widgets (widgets for only this module) and other components such as enums

                - /controllers
                # Directory for local controllers
                # This is used to store all controllers which are related to only the module it is in.
                # Here we write all functions/events for interacting with the app data and updating the module states.

                - /models

                - /notifiers (optional)
                # For local notifiers

                - /repositories
                # Directory for api services e.g auth
                    - auth_repo.dart
                    # Here our repositories are just classes that will mediate the communication between our controller and our services.
                    # Inside it will contain all functions that will request data from the api client.
                    # For example, using firebase auth service, it will contain functions to login/sign up with email and password etc.
        
                -/views
                # Assuming it contains two files, login and signup
                    - login_view.dart
                    - signup_view.dart
                    # This is useful as they could interact with a single controller which will contain the functions to 
                    # update our state e.g currentUser, however we can also have different controllers for each.
                    
        - /shared
            - /notifiers
            # Directory for global notifiers
            # This is useful for parts of our app which require global state for things like themes, settings etc.

            - /models

            - /repositories
            
            - /widgets
            # Contains widgets to be used by multiple modules.  

- main.dart  
# Entry point to the application
```

