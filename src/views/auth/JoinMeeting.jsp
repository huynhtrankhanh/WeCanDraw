<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join Meeting</title>
    <style>
        body {
            margin: 0;
            overflow: hidden;
            background-image: url('frame1.png'); /* Replace with your image path */
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            font-family: 'Arial', sans-serif; /* Or a similar sans-serif font */
        }

        .container {
            background-color: rgba(255, 255, 255, 0.8); /* Semi-transparent white */
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
            text-align: center;
            max-width: 400px;
            margin: 0 auto;
        }

        h1 {
            color: #333;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            color: #555; /* Darker gray */
            font-weight: bold;
        }

        input[type="text"] {
            width: calc(100% - 20px); /* Adjust width as needed */
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            color: #333;
            outline: none;
        }
        input[type="text"]:valid + .placeholder,
        input[type="text"]:invalid + .placeholder{
            display: none;
        }

        .placeholder{
            font-style: italic;
            color: #888;
            display: block; /*Make placeholder display as block*/
            font-size: 14px; /*Smaller font size for placeholder*/
        }

        button {
            padding: 10px 20px;
            margin: 0 10px;
            background-color: #4CAF50; /* Green */
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover {
            background-color: #45a049; /* Darker green on hover */
        }

        .error-message {
            color: red;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Join Meeting</h1>
        <form id="joinForm" action="JoinMeetingServlet" method="post">
            <div class="form-group">
                <label for="meetingID">Meeting ID:</label>
                <input type="text" id="meetingID" name="meetingID" required>
                <span class="placeholder">Insert Meeting ID</span>
            </div>
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
                <span class="placeholder">Insert Username</span>
            </div>
            <button type="submit">Join</button>
            <button type="button" onclick="window.location.href='Homepage.jsp'">Cancel</button>
        </form>
    </div>

    <script>
      const meetingIDInput = document.getElementById('meetingID');
      const usernameInput = document.getElementById('username');

      meetingIDInput.addEventListener('input', function() {
        this.nextElementSibling.style.display = this.value ? 'none' : 'inline';
      });

      usernameInput.addEventListener('input', function() {
        this.nextElementSibling.style.display = this.value ? 'none' : 'inline';
      });
    </script>
</body>
</html>