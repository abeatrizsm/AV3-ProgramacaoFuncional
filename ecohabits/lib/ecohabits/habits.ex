defmodule Ecohabits.Habits do
  import Ecto.Query

  alias Ecohabits.Repo
  alias Ecohabits.Habits.CheckIn

  def create_check_in(user) do
    today = Date.utc_today()

    %CheckIn{}
    |> CheckIn.changeset(%{
      date: today,
      user_id: user.id
    })
    |> Repo.insert()
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
