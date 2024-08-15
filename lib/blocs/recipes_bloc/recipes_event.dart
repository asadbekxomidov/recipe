sealed class RecipesEvent {}

class GetRecipesEvent extends RecipesEvent {}

class DeleteRecipeEvent extends RecipesEvent {
  String id;

  DeleteRecipeEvent({required this.id});
}

class GetRecipeById extends RecipesEvent {
  String userId;

  GetRecipeById({required this.userId});
}
