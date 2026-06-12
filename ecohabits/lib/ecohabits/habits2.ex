defmodule Ecohabits.Habits2 do
  import Ecto.Query

  alias Ecohabits.Repo
  alias Ecohabits.Habits.Habit

  def list_habits(user_id) do
    Repo.all(
      from h in Habit,
      where: h.user_id == ^user_id
    )
  end

  def list_habits_by_category(user_id, category) do
    Repo.all(
      from h in Habit,
      where:
        h.user_id == ^user_id and
        h.category == ^category
    )
  end

  def get_habit!(id, user_id) do
    Repo.get_by!(
      Habit,
      id: id,
      user_id: user_id
    )
  end

  def create_habit(attrs) do
    %Habit{}
    |> Habit.changeset(attrs)
    |> Repo.insert()
  end

  def update_habit(habit, attrs) do
    habit
    |> Habit.changeset(attrs)
    |> Repo.update()
  end

  def delete_habit(habit) do
    Repo.delete(habit)
  end
end
