abstract class AIModule<Input, Output> {
  load();
  Output calculate(Input data);
}