module TicketTypesController
using Genie.Renderer.Html, SearchLight, Genie.Renderer.Json
using SearchLight
using SearchLight.QueryBuilder
using TicketTypes
function getParentTypes()
  parentTypes = SearchLight.find(TicketType, where("fatherName is null"))
  Dict("code" => 0, "data" => vcat([Dict("type_name" => "全部")],
                                  [Dict("type_name" => tp.typeName) for tp in parentTypes]
                                  )) |> json
end

function getSonTypes(map)
  fType = map["fType"]
  sonTypes = SearchLight.find(TicketType, where("fatherName = ?", fType))
  Dict("code" => 0, "data" => vcat([Dict("type_name" => "全部")],
                                  [Dict("type_name" => tp.typeName) for tp in sonTypes]
                                  )) |> json
end
end
