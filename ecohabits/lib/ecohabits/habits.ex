defmodule Ecohabits.Habits do
  import Ecto.Query

  alias Ecohabits.Repo
  alias Ecohabits.Habits.CheckIn
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
    start_of_week =
      Date.beginning_of_week(Date.utc_today())

    Repo.aggregate(
      from(c in CheckIn,
        where:
          c.user_id == ^user.id and
            c.date >= ^start_of_week
      ),
      :count
    ) * 10
  end
end
