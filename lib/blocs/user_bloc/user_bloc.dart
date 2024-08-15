// ignore_for_file: avoid_print
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_event.dart';
import 'package:recipe_app/blocs/user_bloc/user_state.dart';
import 'package:recipe_app/data/services/recipes_dio_service.dart';
import 'package:recipe_app/utils/current_user.dart';
import 'package:user_repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserStateInitial()) {
    on<GetUserEvent>(_getUser);
    on<UpdateUserName>(_updateName);
    on<UpdateUserBio>(_updateBio);
    on<UpdateUserPhoto>(_updatePhoto);
    on<AddSavedRecipe>(_addSavedRecipe);
    on<AddLikedRecipe>(_addLikedRecipe);
  }

  Future<void> _getUser(GetUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserStateLoading());

      final userModel = await userRepository.getUserById(event.userId);

      if (userModel != null) {
        emit(UserStateLoaded(userModel: userModel));
      } else {
        emit(UserStateError(message: "User not found"));
      }
    } catch (e) {
      print("Get user event Error: $e");
      emit(UserStateError(message: e.toString()));
    }
  }

  Future<void> _addSavedRecipe(
      AddSavedRecipe event, Emitter<UserState> emit) async {
    try {
      emit(UserStateLoading());

      await userRepository.addSavedRecipe(event.userId, event.savedRecipe);
      add(GetUserEvent(CurrentUser.currentUser!.localId));
    } catch (e) {
      print("Add saved reciept event Error: $e");
      emit(UserStateError(message: e.toString()));
    }
  }

  Future<void> _addLikedRecipe(
      AddLikedRecipe event, Emitter<UserState> emit) async {
    try {
      emit(UserStateLoading());

      await userRepository.addLikedRecipe(event.userId, event.savedRecipe);
      final RecipesDioService recipesDioService = RecipesDioService();
      await recipesDioService.changeLike(event.recipeId, event.likeCheck);
      add(GetUserEvent(CurrentUser.currentUser!.localId));
    } catch (e) {
      print("Add saved reciept event Error: $e");
      emit(UserStateError(message: e.toString()));
    }
  }

  Future<void> _updateBio(UpdateUserBio event, Emitter<UserState> emit) async {
    try {
      emit(UserStateLoading());

      await userRepository.updateUserBio(event.userId, event.newBio);

      final userModel = await userRepository.getUserById(event.userId);
      emit(UserStateLoaded(userModel: userModel!));
    } catch (e) {
      print("Update Bio user event Error: $e");
      emit(UserStateError(message: e.toString()));
    }
  }

  Future<void> _updateName(
      UpdateUserName event, Emitter<UserState> emit) async {
    try {
      emit(UserStateLoading());

      await userRepository.updateUserName(event.userId, event.newName);

      final userModel = await userRepository.getUserById(event.userId);
      emit(UserStateLoaded(userModel: userModel!));
    } catch (e) {
      print("Update Name User event Error: $e");
      emit(UserStateError(message: e.toString()));
    }
  }

  Future<void> _updatePhoto(
      UpdateUserPhoto event, Emitter<UserState> emit) async {
    try {
      emit(UserStateLoading());

      await userRepository.updateUserPhoto(event.userId, event.image);

      final userModel = await userRepository.getUserById(event.userId);
      emit(UserStateLoaded(userModel: userModel!));
    } catch (e) {
      print("Update Photo user event Error: $e");
      emit(UserStateError(message: e.toString()));
    }
  }
}
