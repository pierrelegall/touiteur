defmodule Touiteur.Repo.Migrations.AddSupposedLanguageToMessage do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :supposed_language, :string, null: true
    end

    create index(:messages, [:supposed_language])
  end
end
