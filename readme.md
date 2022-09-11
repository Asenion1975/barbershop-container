# A Note About Deployment Keys

    -- The github remote url must not end in ".git" otherwise Cloudways won't be able to authenticate the repo.
    
# Installing Laravel Breeze

    -- Go into the Laravel container.
    -- Run `composer require laravel/breeze --dev`
    -- NOTE: Run `composer require laravel/breeze:1.9.4` with Laravel 8.
    -- Run `php artisan breeze:install`
    -- Run `npm install` to build your assets.
    -- Run `npm run dev` to build your assets.

# Making Changes to Laravel .env Config File

    Run `php artisan config:clear` on the server so the new config picks up.