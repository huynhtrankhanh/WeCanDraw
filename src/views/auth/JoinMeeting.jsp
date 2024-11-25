<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- ===== CSS ===== -->
    <link rel="stylesheet" href="/public/css/style.css">

    <!-- ===== BOX ICONS ===== -->
    <link href='https://cdn.jsdelivr.net/npm/boxicons@2.0.5/css/boxicons.min.css' rel='stylesheet'>

    <title>Join meeting</title>
</head>

<body>
    <div class="l-form">
        <div class="shape1"></div>
        <div class="shape2"></div>

        <div class="form">
            <img src="/public/images/frame1.png" alt="" class="form__img">

            <form action="" class="form__content">
                <h1 class="form__title">Join meeting</h1>

                <div class="form__div form__div-one">
                    <div class="form__icon">
                        <i class='bx bxs-keyboard'></i>
                    </div>

                    <div class="form__div-input">
                        <label for="" class="form__label">Meeting ID</label>
                        <input type="text" class="form__input" required>
                    </div>
                </div>

                <div class="form__div">
                    <div class="form__icon">
                        <i class='bx bx-user-circle'></i>
                    </div>

                    <div class="form__div-input">
                        <label for="" class="form__label">Username</label>
                        <input type="text" class="form__input" required>
                    </div>
                </div>
                <div class="btn-field">
                    <button type="button">Join</button>
                    <button type="button">Cancel</button>

                </div>
            </form>
        </div>

    </div>

    <!-- ===== MAIN JS ===== -->
    <script src="/public/js/main.js"></script>
</body>

</html>