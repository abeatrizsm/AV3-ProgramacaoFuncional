defmodule Ecohabits.Habits do
  import Ecto.Query

  alias Ecohabits.Repo
  alias Ecohabits.Habits.CheckIn
  alias Ecohabits.Habits.Habit
  alias Ecohabits.Accounts.User

  def create_check_in(user) do
    attrs = %{
      date: Date.utc_today(),
      user_id: user.id
    }

    %CheckIn{}
    |> CheckIn.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, check_in} = result ->

        habit_points =
          total_habit_points(user)

        IO.inspect(habit_points, label: "PONTOS DOS HÁBITOS")
        IO.inspect(user.points, label: "PONTOS ATUAIS")

        new_points =
        user.points + Decimal.to_integer(habit_points)

      IO.inspect(new_points, label: "NOVA PONTUACAO")

      user
      |> Ecto.Changeset.change(points: new_points)
      |> Repo.update()

        Phoenix.PubSub.broadcast(
          Ecohabits.PubSub,
          "community_feed",
          {:new_check_in, user.name, check_in.date}
        )

        result

      error ->
        error
    end
  end

  def total_habit_points(user) do
  total =
    Repo.aggregate(
      from(h in Habit,
        where: h.user_id == ^user.id
      ),
      :sum,
      :score
    ) || 0

  IO.inspect(total, label: "TOTAL HABITS POINTS")

  total
end

  def list_recent_check_ins do
    Repo.all(
      from c in CheckIn,
        join: u in assoc(c, :user),
        preload: [user: u],
        order_by: [desc: c.inserted_at],
        limit: 20
    )
  end

  def list_user_check_ins(user) do
    Repo.all(
      from(c in CheckIn,
        where: c.user_id == ^user.id,
        order_by: [desc: c.date]
      )
    )
  end

  def weekly_points(user) do
    user.points
  end
end
