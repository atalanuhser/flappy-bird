<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="FlappyBirdWebApp.Default" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Flappy Bird Game</title>
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #87CEEB, #98FB98);
        }
        
        #gameCanvas {
            position: absolute;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            display: block;
            background: #87CEEB;
        }
        
        .game-ui {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
            pointer-events: none;
        }
        
        .game-controls {
            position: absolute;
            top: 20px;
            left: 20px;
            z-index: 10;
            pointer-events: all;
        }
        
        .start-btn {
            background: linear-gradient(145deg, #2E8B57, #228B22);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 25px;
            cursor: pointer;
            font-size: 18px;
            font-weight: bold;
            box-shadow: 0 4px 8px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            margin-right: 10px;
        }
        
        .start-btn:hover {
            background: linear-gradient(145deg, #228B22, #1E7B1E);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.4);
        }
        
        .start-btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        
        .score-display {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 10px 20px;
            border-radius: 15px;
            font-size: 18px;
            font-weight: bold;
            pointer-events: all;
        }
        
        .game-over-panel {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(0, 0, 0, 0.9);
            color: white;
            padding: 30px;
            border-radius: 20px;
            text-align: center;
            display: none;
            z-index: 1000;
            pointer-events: all;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }
        
        .game-over-panel h2 {
            color: #FF6B6B;
            margin: 0 0 20px 0;
            font-size: 36px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }
        
        .score-info {
            margin: 20px 0;
            font-size: 20px;
        }
        
        .restart-btn {
            background: linear-gradient(145deg, #4ECDC4, #45B7B8);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            margin: 10px;
            transition: all 0.3s ease;
        }
        
        .restart-btn:hover {
            background: linear-gradient(145deg, #45B7B8, #3D9EA0);
            transform: translateY(-2px);
        }
        
        .instructions {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 10px 20px;
            border-radius: 15px;
            font-size: 14px;
            text-align: center;
            pointer-events: all;
        }
        
        @media (max-width: 768px) {
            .game-controls {
                top: 10px;
                left: 10px;
            }
            
            .score-display {
                top: 10px;
                right: 10px;
                padding: 8px 15px;
                font-size: 16px;
            }
            
            .instructions {
                bottom: 10px;
                padding: 8px 15px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
    <form runat="server">
        <canvas id="gameCanvas"></canvas>
        
        <div class="game-ui">
            <div class="game-controls">
                <button type="button" class="start-btn" id="startBtn">🎮 Oyunu Başlat</button>
            </div>
            
            <div class="score-display">
                <div>Skor: <span id="currentScore">0</span></div>
                <div>En Yüksek: <span id="highScore">0</span></div>
            </div>
            
            <div class="instructions">
                🖱️ Mouse ile tıklayın veya ⌨️ Boşluk tuşuna basın
            </div>
        </div>
        
        <div class="game-over-panel" id="gameOverPanel">
            <h2>🎯 OYUN BİTTİ!</h2>
            <div class="score-info">
                <div>Skorunuz: <span id="finalScore">0</span></div>
                <div>En Yüksek Skor: <span id="finalHighScore">0</span></div>
            </div>
            <button type="button" class="restart-btn" onclick="restartGame()">🔄 Tekrar Oyna</button>
        </div>
        
        <!-- Hidden fields for backend integration -->
        <asp:HiddenField ID="hdnCurrentScore" runat="server" Value="0" />
    </form>

    <script>
        // Canvas and context
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');

        // UI elements
        const startBtn = document.getElementById('startBtn');
        const gameOverPanel = document.getElementById('gameOverPanel');
        const currentScoreEl = document.getElementById('currentScore');
        const highScoreEl = document.getElementById('highScore');
        const finalScoreEl = document.getElementById('finalScore');
        const finalHighScoreEl = document.getElementById('finalHighScore');

        // Game variables - Initialize everything first
        let gameRunning = false;
        let gameInitialized = false;
        let score = 0;
        let highScore = parseInt(localStorage.getItem('flappyHighScore')) || 0;
        let animationId;

        // Game objects - Initialize with safe defaults
        const bird = {
            x: 50,
            y: 300,
            width: 30,
            height: 25,
            velocity: 0,
            gravity: 0.4,
            jumpPower: -8
        };

        // Initialize empty arrays
        let pipes = [];
        const pipeWidth = 40;
        const pipeGap = 200;

        // Canvas resize function
        function resizeCanvas() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;

            // Reset bird position on resize
            if (!gameRunning) {
                bird.y = canvas.height / 2;
            }

            // Only draw if game is initialized
            if (gameInitialized) {
                draw();
            } else {
                drawWaitingScreen();
            }
        }

        // Initialize game
        function initializeGame() {
            gameInitialized = true;
            highScoreEl.textContent = highScore;
            resizeCanvas();
        }

        // Draw waiting screen
        function drawWaitingScreen() {
            ctx.fillStyle = '#87CEEB';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // Draw clouds
            drawClouds();

            // Draw title
            ctx.fillStyle = 'white';
            ctx.font = 'bold 48px Arial';
            ctx.textAlign = 'center';
            ctx.strokeStyle = '#2E8B57';
            ctx.lineWidth = 3;
            ctx.strokeText('🐦 FLAPPY BIRD', canvas.width / 2, canvas.height / 2);
            ctx.fillText('🐦 FLAPPY BIRD', canvas.width / 2, canvas.height / 2);

            ctx.font = '24px Arial';
            ctx.fillStyle = '#2E8B57';
            ctx.fillText('Oyunu başlatmak için butona tıklayın!', canvas.width / 2, canvas.height / 2 + 60);
            ctx.textAlign = 'left';
        }

        // Draw clouds
        function drawClouds() {
            ctx.fillStyle = 'white';

            // Cloud 1
            ctx.beginPath();
            ctx.arc(100, 60, 25, 0, Math.PI * 2);
            ctx.arc(120, 55, 30, 0, Math.PI * 2);
            ctx.arc(140, 60, 25, 0, Math.PI * 2);
            ctx.fill();

            // Cloud 2
            ctx.beginPath();
            ctx.arc(canvas.width - 150, 80, 20, 0, Math.PI * 2);
            ctx.arc(canvas.width - 135, 75, 25, 0, Math.PI * 2);
            ctx.arc(canvas.width - 120, 80, 20, 0, Math.PI * 2);
            ctx.fill();

            // Cloud 3 (if screen is wide enough)
            if (canvas.width > 800) {
                ctx.beginPath();
                ctx.arc(canvas.width / 2, 100, 18, 0, Math.PI * 2);
                ctx.arc(canvas.width / 2 + 15, 95, 22, 0, Math.PI * 2);
                ctx.arc(canvas.width / 2 + 30, 100, 18, 0, Math.PI * 2);
                ctx.fill();
            }
        }

        // Start game
        function startGame() {
            if (gameRunning) return;

            gameRunning = true;
            score = 0;
            bird.y = canvas.height / 2;
            bird.velocity = 0;
            pipes = [];

            // Update UI
            startBtn.textContent = '🎮 Oyun Devam Ediyor...';
            startBtn.disabled = true;
            gameOverPanel.style.display = 'none';
            currentScoreEl.textContent = '0';

            // Hide score from backend
            updateBackendScore(0);

            createPipe();
            gameLoop();
        }

        // Create pipe
        function createPipe() {
            const minHeight = 50;
            const maxHeight = canvas.height - pipeGap - minHeight;
            const topHeight = Math.random() * (maxHeight - minHeight) + minHeight;

            pipes.push({
                x: canvas.width,
                topHeight: topHeight,
                bottomY: topHeight + pipeGap,
                bottomHeight: canvas.height - (topHeight + pipeGap),
                passed: false
            });
        }

        // Jump function
        function jump() {
            if (gameRunning) {
                bird.velocity = bird.jumpPower;

                // Add some visual feedback
                canvas.style.transform = 'scale(1.01)';
                setTimeout(() => {
                    canvas.style.transform = 'scale(1)';
                }, 100);
            }
        }

        // Game loop
        function gameLoop() {
            if (!gameRunning) return;

            update();
            draw();
            animationId = requestAnimationFrame(gameLoop);
        }

        // Update game state
        function update() {
            // Update bird
            bird.velocity += bird.gravity;
            bird.y += bird.velocity;

            // Check boundaries
            if (bird.y < 0 || bird.y + bird.height > canvas.height) {
                gameOver();
                return;
            }

            // Update pipes
            for (let i = pipes.length - 1; i >= 0; i--) {
                const pipe = pipes[i];
                pipe.x -= 2;

                // Remove pipes that are off screen
                if (pipe.x + pipeWidth < 0) {
                    pipes.splice(i, 1);
                    continue;
                }

                // Check collision
                if (bird.x < pipe.x + pipeWidth &&
                    bird.x + bird.width > pipe.x &&
                    (bird.y < pipe.topHeight || bird.y + bird.height > pipe.bottomY)) {
                    gameOver();
                    return;
                }

                // Check if passed
                if (!pipe.passed && bird.x > pipe.x + pipeWidth) {
                    pipe.passed = true;
                    score++;
                    currentScoreEl.textContent = score;
                    updateBackendScore(score);
                }
            }

            // Add new pipe
            if (pipes.length === 0 || pipes[pipes.length - 1].x < canvas.width - 200) {
                createPipe();
            }
        }

        // Draw game
        function draw() {
            // Clear canvas
            ctx.fillStyle = '#87CEEB';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // Draw clouds
            drawClouds();

            // Draw pipes
            ctx.fillStyle = '#228B22';
            pipes.forEach(pipe => {
                // Main pipe bodies
                ctx.fillRect(pipe.x, 0, pipeWidth, pipe.topHeight);
                ctx.fillRect(pipe.x, pipe.bottomY, pipeWidth, pipe.bottomHeight);

                // Pipe caps
                ctx.fillStyle = '#2E8B57';
                ctx.fillRect(pipe.x - 5, pipe.topHeight - 20, pipeWidth + 10, 20);
                ctx.fillRect(pipe.x - 5, pipe.bottomY, pipeWidth + 10, 20);
                ctx.fillStyle = '#228B22';
            });

            // Draw bird
            drawBird();
        }

        // Draw bird with more details
        function drawBird() {
            const birdCenterX = bird.x + bird.width / 2;
            const birdCenterY = bird.y + bird.height / 2;

            // Bird body
            ctx.fillStyle = '#FFD700';
            ctx.fillRect(bird.x, bird.y, bird.width, bird.height);

            // Bird wing
            ctx.fillStyle = '#FFA500';
            ctx.fillRect(bird.x + 5, bird.y + 8, 15, 10);

            // Bird beak
            ctx.fillStyle = '#FF6347';
            ctx.fillRect(bird.x + bird.width, bird.y + 10, 8, 5);

            // Bird eye
            ctx.fillStyle = 'white';
            ctx.beginPath();
            ctx.arc(bird.x + 22, bird.y + 8, 3, 0, Math.PI * 2);
            ctx.fill();

            ctx.fillStyle = 'black';
            ctx.beginPath();
            ctx.arc(bird.x + 23, bird.y + 7, 2, 0, Math.PI * 2);
            ctx.fill();
        }

        // Game over
        function gameOver() {
            gameRunning = false;
            cancelAnimationFrame(animationId);

            // Update high score
            if (score > highScore) {
                highScore = score;
                localStorage.setItem('flappyHighScore', highScore);
                highScoreEl.textContent = highScore;
            }

            // Update UI
            startBtn.textContent = '🎮 Oyunu Başlat';
            startBtn.disabled = false;

            finalScoreEl.textContent = score;
            finalHighScoreEl.textContent = highScore;
            gameOverPanel.style.display = 'block';

            // Update backend
            updateBackendScore(score);
        }

        // Restart game
        function restartGame() {
            gameOverPanel.style.display = 'none';
            startGame();
        }

        // Update backend score
        function updateBackendScore(newScore) {
            const hiddenField = document.getElementById('<%= hdnCurrentScore.ClientID %>');
            if (hiddenField) {
                hiddenField.value = newScore.toString();
            }
        }

        // Event listeners
        window.addEventListener('resize', resizeCanvas);

        document.addEventListener('keydown', function (e) {
            if (e.code === 'Space' || e.code === 'ArrowUp') {
                e.preventDefault();
                jump();
            }
        });

        canvas.addEventListener('click', jump);
        canvas.addEventListener('touchstart', function (e) {
            e.preventDefault();
            jump();
        });

        startBtn.addEventListener('click', startGame);

        // Initialize when page loads
        window.addEventListener('load', function () {
            initializeGame();
        });

        // Initialize immediately if DOM is ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initializeGame);
        } else {
            initializeGame();
        }
    </script>
</body>
</html>