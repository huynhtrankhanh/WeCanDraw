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
            font-family: sans-serif;
        }

        .container {
            background-color: rgba(255, 255, 255, 0.8);
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
            max-width: 400px;
            margin: 0 auto;
        }

        h1 {
            color: #333;
            margin-bottom: 20px;
        }

        #meetingIDContainer {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        #meetingID, #meetingIDPlaceholder {
            font-size: 18px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            flex-grow: 1;
            margin-right: 10px;
        }

        #meetingIDPlaceholder {
            font-style: italic;
            color: #888;
            display: inline-block; /* initially visible */
        }

        #meetingID {
            display: none; /* initially hidden */
        }

        .copy-button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        .copy-button:hover {
            background-color: #0069d9;
        }

        .copy-button i {
            margin-right: 5px;
        }

        .error-message {
            color: red;
        }

        button {
            padding: 10px 20px;
            margin: 0 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Meeting ID</h1>
        <div id="meetingIDContainer">
            <span id="meetingIDPlaceholder">Fetching Meeting ID...</span>
            <span id="meetingID"></span>
            <button class="copy-button" id="copyMeetingID">
                <i class="fas fa-copy"></i>Copy
            </button>
        </div>
        <button id="joinNow">Join</button>
        <button id="cancelBtn">Cancel</button>
    </div>

    <script>
        fetch('CreateMeetingServlet')
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.text();
            })
            .then(meetingId => {
                const meetingIDElement = document.getElementById('meetingID');
                const placeholderElement = document.getElementById('meetingIDPlaceholder');

                meetingIDElement.textContent = meetingId;
                meetingIDElement.style.display = 'inline';
                placeholderElement.style.display = 'none';
            })
            .catch(error => {
                const meetingIDContainer = document.getElementById('meetingIDContainer');
                const errorMessage = document.createElement('span');
                errorMessage.classList.add('error-message');
                errorMessage.textContent = `Error: ${error.message}`;
                meetingIDContainer.appendChild(errorMessage);
                document.getElementById('meetingIDPlaceholder').style.display = 'none';
            });

        document.getElementById('joinNow').addEventListener('click', () => {
            const meetingId = document.getElementById('meetingID').textContent;
            if (meetingId && meetingId !== 'Error fetching ID') {
                window.location.href = 'JoinMeeting.jsp?meetingID=' + meetingId;
            } else {
                alert('Failed to join the meeting. Please try again.');
            }
        });

        document.getElementById('cancelBtn').addEventListener('click', () => {
            window.location.href = '/';
        });

        document.getElementById('copyMeetingID').addEventListener('click', () => {
            const meetingId = document.getElementById('meetingID').textContent;
            if (meetingId) {
                navigator.clipboard.writeText(meetingId)
                    .then(() => alert('Meeting ID copied!'))
                    .catch(err => alert('Copy failed!'));
            } else {
                alert('Meeting ID not yet available.');
            }
        });
    </script>
    <script src="https://kit.fontawesome.com/a076d05399.js"></script> </body>
</html>