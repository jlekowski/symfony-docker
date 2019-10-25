Run composer:
```bash
composer install
```

Build container:
```bash
# build container
docker build -t symfony-docker .
```

Check container env vars inside docker with `.env` file being passed:
```bash
docker run -it --rm -v "$PWD":/app --env-file=.env -w "/app" symfony-docker sh -c "bin/console debug:container --env-vars"
```
> In EnvVarProcessor.php line 183:
>                                                     
>   Invalid JSON in env var "APP_JSON": Syntax error  

and without passing `.env` file:
```bash
docker run -it --rm -v "$PWD":/app -w "/app" symfony-docker sh -c "bin/console debug:container --env-vars"
```
> Symfony Container Environment Variables
> =======================================
> 
>  ------------ --------------- ------------------------------------ 
>   Name         Default value   Real value                          
>  ------------ --------------- ------------------------------------ 
>   APP_JSON     n/a             "{"a":1}"                           
>   APP_SECRET   n/a             "cb4b2a7cbe10bc3d00659f42c67955f7"  
>  ------------ --------------- ------------------------------------ 

The problem is parsing `.env` by docker, so making `APP_JSON='{"a":1}'` to be `APP_JSON={"a":1}` works for docker, but wouldn't work in console:
```bash
docker run -it --rm -v "$PWD":/app --env-file=.env -p 8000:8000 -w "/app" symfony-docker sh -c "echo \$APP_JSON"
```
> '{"a":1}'

When replacing `APP_JSON='{"a":1}'` with `APP_JSON={"a":1}` it is the opposite - no error when passing `.env`, error if `.env` is ready by Symfony.
```bash
sed -i -e 's/APP_JSON=.*/APP_JSON={"a":1}/' .env
```

(OPTIONAL) Uncomment lines in `Dockerfile` and run the below to see WEB errors:
```bash
# run symfony
docker run -it --rm -v "$PWD":/app --env-file=.env -p 8000:8000 -w "/app" symfony-docker sh -c "/root/.symfony/bin/symfony server:start"
```
Now check http://127.0.0.1:8000/ and see the following error:
> Cannot resolve argument $appJson of "App\Controller\DefaultController::index()": Invalid JSON in env var "APP_JSON": Syntax error

But when avoiding setting env vars in docker from `.env`, file is parsed by `DotEnv` and all works fine:
```bash
docker run -it --rm -v "$PWD":/app -p 8000:8000 -w "/app" symfony-docker sh -c "/root/.symfony/bin/symfony server:start"
```