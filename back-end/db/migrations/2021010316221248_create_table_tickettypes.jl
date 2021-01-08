module CreateTableTickettypes

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:tickettypes) do
    [
      primary_key()
      column(:typeName, :string, limit = 12)
      column(:fatherName, :string, limit = 12, not_null = false)
    ]
  end

  add_index(:tickettypes, :typeName)
end

function down()
  drop_table(:tickettypes)
end

end
