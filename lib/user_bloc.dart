// lib/presentation/bloc/user/user_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_assignment_1/user_model.dart';
import 'package:project_assignment_1/user_repository_interface.dart';


// Events
abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserEvent {
  final int page;
  
  LoadUsers({required this.page});
  
  @override
  List<Object?> get props => [page];
}

class LoadUserDetails extends UserEvent {
  final int userId;
  
  LoadUserDetails({required this.userId});
  
  @override
  List<Object?> get props => [userId];
}

class AddNewUser extends UserEvent {
  final UserModel user;
  
  AddNewUser({required this.user});
  
  @override
  List<Object?> get props => [user];
}

class UpdateExistingUser extends UserEvent {
  final int userId;
  final UserModel user;
  
  UpdateExistingUser({required this.userId, required this.user});
  
  @override
  List<Object?> get props => [userId, user];
}

class SearchUsers extends UserEvent {
  final String query;
  
  SearchUsers({required this.query});
  
  @override
  List<Object?> get props => [query];
}

// States
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserModel> users;
  final bool hasReachedMax;
  final int currentPage;
  
  UsersLoaded({
    required this.users, 
    required this.hasReachedMax,
    required this.currentPage,
  });
  
  @override
  List<Object?> get props => [users, hasReachedMax, currentPage];
}

class UserDetailsLoaded extends UserState {
  final UserModel user;
  
  UserDetailsLoaded({required this.user});
  
  @override
  List<Object?> get props => [user];
}

class UserAdded extends UserState {
  final UserModel user;
  
  UserAdded({required this.user});
  
  @override
  List<Object?> get props => [user];
}

class UserUpdated extends UserState {
  final UserModel user;
  
  UserUpdated({required this.user});
  
  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;
  
  UserError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class UsersSearched extends UserState {
  final List<UserModel> users;
  final String query;
  
  UsersSearched({required this.users, required this.query});
  
  @override
  List<Object?> get props => [users, query];
}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  
  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadUserDetails>(_onLoadUserDetails);
    on<AddNewUser>(_onAddNewUser);
    on<UpdateExistingUser>(_onUpdateExistingUser);
    on<SearchUsers>(_onSearchUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      
      final users = await userRepository.getPaginatedUsers(event.page);
      
      // Assume we've reached max if less than 10 users are returned
      final hasReachedMax = users.length < 10;
      
      emit(UsersLoaded(
        users: users,
        hasReachedMax: hasReachedMax,
        currentPage: event.page,
      ));
    } catch (e) {
      emit(UserError(message: 'Failed to load users: $e'));
    }
  }

  Future<void> _onLoadUserDetails(LoadUserDetails event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      
      final user = await userRepository.getUserById(event.userId);
      
      emit(UserDetailsLoaded(user: user));
    } catch (e) {
      emit(UserError(message: 'Failed to load user details: $e'));
    }
  }

  Future<void> _onAddNewUser(AddNewUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      
      final user = await userRepository.addUser(event.user);
      
      emit(UserAdded(user: user));
    } catch (e) {
      emit(UserError(message: 'Failed to add user: $e'));
    }
  }

  Future<void> _onUpdateExistingUser(UpdateExistingUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      
      final user = await userRepository.updateUser(event.userId, event.user);
      
      emit(UserUpdated(user: user));
    } catch (e) {
      emit(UserError(message: 'Failed to update user: $e'));
    }
  }

  Future<void> _onSearchUsers(SearchUsers event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      
      final users = await userRepository.searchUsers(event.query);
      
      emit(UsersSearched(users: users, query: event.query));
    } catch (e) {
      emit(UserError(message: 'Failed to search users: $e'));
    }
  }
}