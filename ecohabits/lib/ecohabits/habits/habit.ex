defmodule Ecohabits.Habits.Habit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "habits" do
    field :name, :string
    field :description, :string
    field :category, :string
    field :score, :integer

    belongs_to :user, Ecohabits.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(habit, attrs) do
    habit
    |> cast(attrs, [
      :name,
      :description,
      :category,
      :score,
      :user_id
    ])
    |> validate_required([
      :name,
      :category,
      :score,
      :user_id
    ])
  end
end
