module UsersController
using Users
using SearchLight
using SearchLight.QueryBuilder
using Genie.Renderer.Json
using Genie.Sessions
using Genie
  function register(json_load::Dict)
    uid, nickname, password = get.(Ref(json_load), ["id", "name", "password"], "")
    println(uid, nickname, password)

    if uid == "" || nickname == "" || password == ""
      println(uid)
      println(password)
      println(nickname)
      return Dict("code" => 1, "msg" => "信息不全!") |> json
    elseif any(length.([uid, nickname, password]) .> [20, 16, 16])
      return Dict("code" => 1, "msg" => "字符过长!") |> json
    elseif length(find(User, where("uid = ?", uid))) != 0 
      return Dict("code" => 1, "msg" => "用户名已存在！") |> json
    else
      User(uid = uid, nickname = nickname, password = password) |> SearchLight.save!
      return Dict("code" => 0, "msg" => "成功") |> json
    end
  end
  
  function checkLogin(uid, password, params)
    user = find(User, where("uid = ?", uid) + where("password = ?", password))
    sess = Genie.Sessions.session(params)
    if length(user) != 0
      return Dict("code" => 1, "msg" => "用户名或密码错误！") |> json
    else
      Genie.Sessions.set!(sess, :uid, uid)
      # println(params[:SESSION])
      return Dict("code" => 0, "msg" => "登录成功！") |> json
    end
  end

  function logout(params)
    sess = params[Genie.PARAMS_SESSION_KEY]
    # println(typeof(sess))
    # println(Genie.Sessions.get(Sessions.session(params), :uid))
    Genie.Sessions.unset!(Sessions.session(params), :uid)
    "成功" |> json
  end
end

