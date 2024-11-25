<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- ===== CSS ===== -->
    <link rel="stylesheet" href="/public/css/style.css">

    <!-- ===== BOX ICONS ===== -->
    <link href='https://cdn.jsdelivr.net/npm/boxicons@2.0.5/css/boxicons.min.css' rel='stylesheet'>

    <title>Workplace</title>
</head>

<body>
    <div class="l-form">
        <div class="shape1"></div>
        <div class="shape2"></div>

        <div class="form">
            <img src="/public/images/frame1.png" alt="" class="form__img">
            <div class="form_btn">
                <form action="CreateMeeting.jsp" class="form__contentW">
                    <h1 class="form__title">Room Dashboard</h1>
                    <input type="submit" class="form__buttonmeeting" value="Create a meeting" action="JoinMeeting.html">
                </form>

                <form action="JoinMeeting.jsp" class="form__contentW">
                    <input type="submit" class="form__btnjoin" value="Join a meeting" action="JoinMeeting.html">
                </form>
            </div>
        </div>
    </div>
    
    <!-- <!-- ===== MAIN JS ===== -->
    <script src="/public/js/main.js"></script>
</body>

</html>