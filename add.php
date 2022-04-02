<!DOCTYPE html>
<html lang="en">
<!-- Author: Dmitri Popov, dmpop@linux.com
         License: GPLv3 https://www.gnu.org/licenses/gpl-3.0.txt -->

<head>
    <title>Readiculous</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://classless.de/classless.css">
</head>

<body>
    <div class="card">
        <div class="text-center">
            <h1 style="letter-spacing: 3px;">Add to Readiculuos</h1>
            <hr style="margin-bottom: 2em;">
            <form action="" method="POST">
                <label>URL:
                    <input type='text' name='url'>
                </label>
                <button type="submit" name="add">Add</button>
            </form>
            <?php
            if (isset($_POST["add"])) {
                file_put_contents('links.txt', $_POST['url'] . PHP_EOL, FILE_APPEND);
            }
            ?>
            <div style="margin-top: 0.5em; margin-bottom: 1em;">
                This is <a href="https://github.com/dmpop/readiculuos">Readiculous</a>
            </div>
        </div>
    </div>
</body>

</html>