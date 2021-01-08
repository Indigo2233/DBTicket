## 2021/01/03-04 

新增Julia后端

由于需要预编译，前几次操作可能会很慢

运行方式为：

- 启动`backend-jl/bin/repl`

- ```
  julia> using SearchLight
  
  julia> SearchLight.Migrations.all_up!!() #迁移数据表
  
  julia> up(8080) #在80端口运行服务
  ```

- ```shell
  mysql < spider/data.sql #插入数据
  ```

- 至此，应用启动成功

# 如何在你的本机上运行这个web服务？

## 前端

**`Front-end`文件夹中的是前端代码。**

首先pull前端代码，前端是用npm包管理的，运行命令：`npm run build`，你会发现目录下多了一个`build`文件夹。

把`build`文件夹下所有文件拷贝到你的nginx的html目录，并在`nginx.conf`中增加一条代理：

```yaml
...
http {
	...
	...
	server {
        listen       你喜欢的端口;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html目录;
            try_files $uri /index.html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }
        
        location /api/ {          # /api 代理到下面 地址  就是修改成你后台的uri
            proxy_pass http://localhost:后端的端口/;
        }
        
    }
}
```

一般，Spring Boot 的默认端口为8080。

配置好之后保存，重新启动一下nginx，就可以愉快的访问网页了。