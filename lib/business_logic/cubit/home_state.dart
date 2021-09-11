part of 'home_cubit.dart';

@immutable
abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class ChangeBottomSheetState extends HomeStates {}

class AddTaskToFirebaseSuccessState extends HomeStates {}

class AddTaskToFirebaseErrorState extends HomeStates {}

class CreateLocalDatabaseState extends HomeStates {}

class InsertToLocalDatabaseState extends HomeStates {}

class GetFromLocalDatabaseLoadingState extends HomeStates {}

class GetFromLocalDatabaseSuccessState extends HomeStates {}

class DeleteFromLocalDatabaseState extends HomeStates {}
