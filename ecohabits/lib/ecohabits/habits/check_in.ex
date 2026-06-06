defmodule Ecohabits.Habits.CheckIn do
  use Ecto.Schema
  import Ecto.Changeset

  schema "check_ins" do
    field(:date, :date)

    belongs_to(
      :user,
      Ecohabits.Accounts.User
    )

    timestamps()
  end

  def changeset(check_in, attrs) do
    check_in
    |> cast(attrs, [:date, :user_id])
    |> validate_required([:date, :user_id])
    |> unique_constraint([:user_id, :date])
  end
end

# |> unique_constraint(
#       [:user_id, :date],
#       name: :check_ins_user_id_date_index
#     )
