/// Super is a state management framework for Flutter that aims to simplify
/// and streamline the development of reactive and scalable applications.
/// It provides a set of tools and abstractions to manage state, handle
/// side effects, and build UI components in a declarative and efficient
/// manner.
///
/// Key Features:
/// - Reactive state management
/// - Effective dependency injection
/// - Lifecycle management for widget controllers
/// - Widget builders for building reactive UI components
/// - Intuitive testing (no setup/teardown required), dedicated testing library super_test
///
/// With Super, you can build robust and scalable Flutter applications
/// while maintaining clean and organized code.
/// The framework strives to adhere to the high standards set by
/// the Flutter Team in terms of readability, documentation, and usability.
///
/// Give Super a try and experience a streamlined approach to
/// state management in Flutter!
///
/// Dev Note:
///
/// Hi there, DrDejaVu here! I have put in considerable effort to
/// structure and document the Super framework in a readable and
/// understandable manner. I wanted to create a framework that aligns
/// with the high standards set by the Flutter Team, who have done an
/// incredible job of documenting the Flutter framework.
///
/// While developing with Super, you may notice similarities in syntax,
/// API names, code practices and more with other state management solutions
/// such as Bloc, GetX, Riverpod, and others. This is because I have drawn
/// inspiration from these solutions and leveraged my previous experience
/// with them to create Super. By adopting familiar concepts and naming
/// conventions, I aimed to make the learning curve smoother for developers
/// already familiar with these state management solutions.
///
/// I hope you find the Super framework as pleasing and easy to work with
/// as I intended it to be. If you have any feedback or suggestions for
/// improvement, please don't hesitate to reach out. Happy coding!
///
/// Best regards,
/// DrDejaVu
library flutter_super;

export 'src/controller.dart';
export 'src/core/interface.dart' show Super;
export 'src/framework.dart';
export 'src/model.dart';
export 'src/rx/rx.dart';
export 'src/utilities/context.dart';
export 'src/utilities/future.dart';
export 'src/utilities/rx.dart';
export 'src/utilities/super.dart';
export 'src/widgets/async_builder.dart';
export 'src/widgets/super_builder.dart';
export 'src/widgets/super_consumer.dart';
export 'src/widgets/super_listener.dart';
export 'src/widgets/super_widget.dart' show SuperWidget;
