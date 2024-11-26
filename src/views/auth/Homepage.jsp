<!DOCTYPE html>
<html>
<head>
<title>Room Dashboard</title>
<style>
body {
    margin: 0;
    overflow: hidden;
    background-image: url('frame1.png'); /* Path to your background image */
    background-size: cover;
    background-position: center;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    font-family: sans-serif;
}

.container {
    background-color: rgba(255, 255, 255, 0.8); /* Semi-transparent white */
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
    text-align: center;
    max-width: 400px; /* Added for responsiveness */
    margin: 0 auto;    /* Center the form */
}

h1 {
    color: #333; /* Darker text for better contrast */
    margin-bottom: 20px;
}

button {
    padding: 10px 20px;
    margin: 10px; /* Add some spacing between buttons */
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
        <h1>Room Dashboard</h1>
        <button id="createMeeting">Create a Meeting</button>
        <button id="joinMeeting">Join a Meeting</button>
    </div>

    <script>
        document.getElementById('createMeeting').addEventListener('click', () => {
            window.location.href = 'CreateMeeting.jsp';
        });
        document.getElementById('joinMeeting').addEventListener('click', () => {
            window.location.href = 'JoinMeeting.jsp';
        });
    </script>
</body>
</html>
