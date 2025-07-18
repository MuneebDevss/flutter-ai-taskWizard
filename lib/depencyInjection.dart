import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:task_wizard/Features/Auth/Domain/Repository/auth_repository.dart';
import 'package:task_wizard/Features/Auth/data/auth_remote_data_source.dart';
import 'package:task_wizard/Features/Auth/data/user.dart';
import 'package:task_wizard/Features/Landing/Presentation/FetchTaskBlocs/fetch_task_bloc.dart';
import 'package:task_wizard/Features/Profile/Data/user_firebase_remote_data.dart';
import 'package:task_wizard/Features/Profile/Data/user_remote_data_source.dart';
import 'package:task_wizard/Features/Profile/Domain/user_repository.dart';
import 'package:task_wizard/Features/Profile/Presentation/UserBloc/user_bloc.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';
import 'package:task_wizard/Features/Shared/Data/remote_data_sources.dart/firebase_task__rep_impl.dart';
import 'package:task_wizard/Features/Shared/Data/remote_data_sources.dart/isar_remote_data_source.dart';
import 'package:task_wizard/Features/CreateTask/Domain/task_repos.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/CreateTaskBlocs/create_task_bloc.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/Services/notifications_controller.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:task_wizard/Features/Shared/Utils/connectivity.dart';
import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';
import 'Features/Auth/Presentation/AuthBloc/auth_bloc.dart';
import 'firebase_options.dart' show DefaultFirebaseOptions;

late final Isar isar;
final injector = GetIt.instance;
Future<void> initialize() async {
  Get.put(NetworkManager());
  await firebaseInitialize();
  await initializeNotifications();
  await hiveAndIsarIntialization();
  await syncIfEmpty();
  auth();
  task();
  setupDependencyInjection();
}

Future<void> hiveAndIsarIntialization() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(UserModelAdapter());
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open([NormalTaskSchema], directory: dir.path);
}

Future<void> initializeNotifications() async {
  await NotificationsController.initializeNotifications();
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationsController.handleNotificationAction,
    onNotificationCreatedMethod:
        NotificationsController.onNotificationCreatedMethod,
    onNotificationDisplayedMethod:
        NotificationsController.onNotificationDisplayedMethod,
    onDismissActionReceivedMethod:
        NotificationsController.onDismissActionReceivedMethod,
  );
}

void setupDependencyInjection() {
  // Data Sources
  injector.registerLazySingleton<UserRemoteDataSource>(
    () => UserFirebaseRemoteDataSource(),
  );

  // Repositories
  injector.registerLazySingleton<UserRepository>(
    () => UserRepository(remoteDataSource: injector<UserRemoteDataSource>()),
  );

  // Blocs
  injector.registerFactory<UserBloc>(
    () => UserBloc(userRepository: injector<UserRepository>()),
  );
}

Future<void> syncIfEmpty() async {
  final user = HelpingFunctions.getCurrentUser();
  if (user != null) {
    final count = await isar.normalTasks.count();
    if (count == 0) {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('tasks')
              .get();

      final tasks =
          snapshot.docs.map((doc) => NormalTask.fromMap(doc.data())).toList();
      await isar.writeTxn(() async {
        await isar.normalTasks.putAll(tasks);
      });
    }
  }
}

Future<void> firebaseInitialize() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void auth() {
  //auth RemoteData
  injector.registerFactory(() => FirebaseRemoteDataSourceImpl(isar: isar));
  injector.registerFactory(() => AuthRepository(impl: injector()));
  injector.registerSingleton(AuthBloc(rep: injector()));
}

void task() {
  injector.registerFactory<FirebaseTaskRemoteImplementaion>(
    () => FirebaseTaskRemoteImplementaion(),
  );
  injector.registerFactory<IsarTaskRepository>(() => IsarTaskRepository(isar));

  injector.registerFactory(
    () => TaskRepos(
      taskRemoteDataSource: injector<FirebaseTaskRemoteImplementaion>(),
      offlineTaskRemoteDataSource: injector<IsarTaskRepository>(),
    ),
  );

  injector.registerSingleton(AddTaskBloc(taskRepository: injector()));
  injector.registerSingleton(FetchTaskBloc(taskRepository: injector()));

  NetworkManager.instance.startConnectivityListener(
    isar,
    injector<FirebaseTaskRemoteImplementaion>(),
  );
}
