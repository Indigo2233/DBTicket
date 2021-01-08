module TicketTypes

import SearchLight: AbstractModel, DbId, save!
import Base: @kwdef

export TicketType

@kwdef mutable struct TicketType <: AbstractModel
  id::DbId = DbId()
  typeName::String = ""
  fatherName::String = ""
end

function seed()
  father_class = ["音乐会", "话剧歌剧", "演唱会", "曲苑杂坛", "展览休闲", "舞蹈芭蕾", "体育"]
  son_class = [
      ["室内乐及古乐", "独奏"],
      ["话剧", "音乐剧"],
      ["livehouse", "流行", "音乐节"],
      ["戏曲", "相声", "魔术"],
      ["展会","特色体验"],
      ["舞蹈"],
      ["球类运动","田径","电竞","篮球"]
  ]
  for (idx, f_cls) in enumerate(father_class)
    TicketType(typeName = f_cls) |> save!
    for s_cls in son_class[idx] 
      TicketType(typeName = s_cls, fatherName = f_cls) |> save!
    end
  end
end
end
