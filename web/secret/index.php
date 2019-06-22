<!DOCTYPE html>
<html>
    <head>
        <title>Secret test page ♥</title>
    </head>
    <body>
        <p>
            <?php require __DIR__ . '/../menu.php' ?>
        </p>
        <div>
            This is a password protected page in my container.
        </div>
        <p>
            Credentials (retrieved by PHP) are
            user: <?php echo $_SERVER['PHP_AUTH_USER'] ?>,
            password: <?php echo $_SERVER['PHP_AUTH_PW'] ?>
        </p>
        <p>
            <?php require __DIR__ . '/../guid.php' ?>
        </p>
    </body>
</html>

