abstract class Mapper<Entity, Model> {
  Model toModel(Entity entity);

  Entity toEntity(Model model);

  List<Model> toModels(List<Entity> entities) {
    return entities.map(toModel).toList();
  }

  List<Entity> toEntities(List<Model> models) {
    return models.map(toEntity).toList();
  }
}