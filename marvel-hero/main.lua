altura=love.graphics.getHeight()
largura=love.graphics.getWidth()
local startmenu=true
local startinstrucoes=false
local startexit=false
local startcenario1=false
local checaleftcima=false
local checaleftbaixo=false

local contiron=0
local contspider=0

local pause=false
local ligado=true
local fimjogo=false

local ironcampeao=false
local spidercampeao=false
local empate=false

placar={spider=0,iron=0,gol=false}	

function love.load()
---------------------------carrega menu, cenario e musica-----------------------
	menu=love.graphics.newImage("img/menu1.png")
	inicial=love.audio.newSource("som/inicial.mp3","stream")
	inicial : setLooping(true)
	love.audio.play(inicial)
	love.audio.setVolume(1)
---------------------------fim menu----------------------------

-------------inicializa o tempo do jogo------------------
	tempo=100
	-----------------------aqui carrego a musica do fim------------------------
	win=love.audio.newSource("som/win.mp3","stream")
	love.audio.setVolume(1)
	win : setLooping(false)
---------------------------aqui carrego a musica do gol------------------------------
	gol=love.audio.newSource("som/gol.mp3","stream")
	gol : setLooping(false)
	love.audio.setVolume(1)
-----------------------------musica do apito final------------------
	apito=love.audio.newSource("som/apito.mp3","stream")
	apito : setLooping(false)
	love.audio.setVolume(1)
-------------------------------aqui finalizo as musicas------------------------

-----------------aqui faz a fonte e a pintuacao------------------------
	fonte=love.graphics.newFont("font/ocr.ttf")
----------------------ainda do menu, aqui carrega play, exit e instrucoes------------
	play={}
		play.img=love.graphics.newImage("img/play.png")
		play.x=600
		play.y=225
		play.w=play.img:getWidth()
		play.h=play.img:getHeight()
		-----instrucoes botao-------
	instrucoesbutton={}
		instrucoesbutton.img=love.graphics.newImage("img/instrucoesbutton.png")
		instrucoesbutton.x=600
		instrucoesbutton.y=300
		instrucoesbutton.w=instrucoesbutton.img:getWidth()
		instrucoesbutton.h=instrucoesbutton.img:getHeight()
	----------exit-------------
	exit={}
		exit.img=love.graphics.newImage("img/exit.png")
		exit.x=600
		exit.y=375
		exit.w=exit.img:getWidth()
		exit.h=exit.img:getHeight()

	-----------fim-----------
	--------------carrega graficos do game===============
	----------------------------carrega instrucoes--------------------
	instrucoes=love.graphics.newImage("img/instrucoes.png")
	----------------carrega cenario1------------------
	cenario1=love.graphics.newImage("img/cenario1.png")
	-------------------carrega som do jogo e dados do audio----------------
	one=love.audio.newSource("som/one.mp3" , "stream")
	one : setLooping(true)  -----reiniciar apos fim-----
	love.audio.setVolume( 1 )
	---------------------------------------------------------------
	love.physics.setMeter(62)
	mundo = love.physics.newWorld(0, 0, true)   ----------(gravidade em x, gravidade em y, se os corpos podem dormir)
	-----------carrega dados do personagem iron man-------------
	iron={}
		ironman=love.graphics.newImage("img/ironman.png")
		iron.x=100
		iron.y=300
		iron.r=0
		speediron=600
		speedironx=speediron* math.cos(math.pi/4) ----------correcao da parada da velocidade-----------
		speedirony=speediron* math.sin(math.pi/4) -----------rt------------
		iron.w=ironman:getWidth()           ----detecta a largura-------
		iron.h=ironman:getHeight() -----detecta a altura--------------

		---------------carrega biblioteca de fisica do spider----------------
     	iron.b = love.physics.newBody(mundo, iron.x , iron.y , "dynamic")  
        iron.b:setMass(10)                                   
        iron.s = love.physics.newCircleShape(46)                 
        iron.f = love.physics.newFixture(iron.b, iron.s)         
        iron.f:setRestitution(0.1)                            
        iron.f:setUserData("Iron")  
--oi
------------carrega dados do personagem spiderman-----------
	spider={}
		spiderman=love.graphics.newImage("img/spiderman.png")
		spider.x=800
		spider.y=300
		spider.r=0
		speedspider=600
		speedspiderx=speedspider* math.cos(math.pi/4) ----------correcao da parada da velocidade-----------
		speedspidery=speedspider* math.sin(math.pi/4) -----------rt------------
		spider.w=spiderman:getWidth()           ----detecta a largura-------
		spider.h=spiderman:getHeight() -----detecta a altura--------------
-----------------carrega biblioteca de fisia do spider----------------
     	spider.b = love.physics.newBody(mundo, spider.x , spider.y , "dynamic")  
        spider.b:setMass(10)                                   
        spider.s = love.physics.newCircleShape(46)                 
        spider.f = love.physics.newFixture(spider.b, spider.s)         
        spider.f:setRestitution(0.1)                            
        spider.f:setUserData("spider")     


-----------------carrega biblioteca de fisica da bola e tals--------------
 
	ball={}
		bola=love.graphics.newImage("img/bola.png") ----------------carrega bola==------------
		ball.w=bola:getWidth() ------detecta a largura-----
		ball.h=bola:getHeight()-------detecta a altura-------
		ball.x=490 --- ball.w/2
		ball.y=400
		ball.r=0	
		--speedball=100
		ball.b = love.physics.newBody(mundo, 490 , 400 , "dynamic")  --  x,y posicao, e dinamico para acertar outros objetos
	    ball.b:setMass(10)                                        -- deixa leve
	    ball.s = love.physics.newCircleShape(22.5)                  --raio
	    ball.f = love.physics.newFixture(ball.b, ball.s)          -- conecta
	    ball.f:setRestitution(0.2)     --------isso daqui eh a velocidade da bola(se trata de fisica)
	    ball.f:setUserData("Ball")	




    -----------------------------vamo ver o que limite as bordas e tal-------
	 bordascima={}
	 	bordascima.b=love.physics.newBody(mundo, 500,14, "static") 
        bordascima.s = love.physics.newRectangleShape(1000,0)
        bordascima.f = love.physics.newFixture(bordascima.b, bordascima.s)
        bordascima.f:setUserData("bordascima")

    bordasbaixo={}
    	bordasbaixo.b=love.physics.newBody(mundo, 500 ,586, "static") 
        bordasbaixo.s = love.physics.newRectangleShape(1000,0)
        bordasbaixo.f = love.physics.newFixture(bordasbaixo.b, bordasbaixo.s)
        bordasbaixo.f:setUserData("bordasbaixo")
    
	 ---------------------------------------------------------esquerda parte de cima--------------
	 leftcima={}
	 	leftcima.b = love.physics.newBody(mundo, 14 , 65, "static")       -------------USEI 14 COMO BORDAAAAAAAAA------
        leftcima.s = love.physics.newRectangleShape(0,80)
        leftcima.f = love.physics.newFixture(leftcima.b, leftcima.s)
        leftcima.f:setUserData("leftcima")
   ---------------------------------esquerda parte de baixo-------
  	 leftbaixo={}
	 	leftbaixo.b = love.physics.newBody(mundo, 14 ,542, "static") 
        leftbaixo.s = love.physics.newRectangleShape(0,80)
        leftbaixo.f = love.physics.newFixture(leftbaixo.b, leftbaixo.s)
        leftbaixo.f:setUserData("leftbaixo")
   ---------------------- direita parte de cima-------------------
   	rightcima={} 
	 	rightcima.b = love.physics.newBody(mundo, 986 , 55, "static") 
        rightcima.s = love.physics.newRectangleShape(0,97)
        rightcima.f = love.physics.newFixture(rightcima.b, rightcima.s)
        rightcima.f:setUserData("rightcima")
   -------------------------direita parte de baixo--------------------------
    rightbaixo={}
	 	rightbaixo.b =  love.physics.newBody(mundo, 986 ,545, "static") 
        rightbaixo.s = love.physics.newRectangleShape(0,85)
        rightbaixo.f = love.physics.newFixture(rightbaixo.b, rightbaixo.s)
        rightbaixo.f:setUserData("rightbaixo")

-------------------------carrega as imagens de empate e vitorias-----------------------
	ironcampeaoimg=love.graphics.newImage("img/ironcampeao.png")
	spidercampeaoimg=love.graphics.newImage("img/ironcampeao.png")
	empateimg=love.graphics.newImage("img/empate.png")
---------------------------------------------------------------------------------------


end

function love.update(dt)
------------------UPDATE DE TEMPO------------------------
	----------------------TEMPO:RODAR DE 1 EM 1-------------------
	if ligado==true and startcenario1==true then
		tempo=tempo+1
	else 
		tempo=0
	end
	---------------FAZ O JOGO TER FIM NO 60 SEGUNDOS---------------------
	if 	tempo==6000 then
		ligado=false
		fimjogo=true
		win:play()
		one:pause()
	end
------------------atualizacao da fisica----------------
	mundo:update(dt)

------------------------------------------AQUI CARREGO O NUMERO DE GOLS----------------------------------------
---------------carrega o numero de gols do iron--------------------------
	if ball.b:getX() <= 12 and ball.b:getY()>=65 and ball.b:getY()<=542 then
		placar.spider= placar.spider + 1
    	resetaBola()
	end
---------------carrega o numero de gols do spider--------------------------
	if ball.b:getX() >= 986 and ball.b:getY()>=55 and ball.b:getY()<=545 then
   		placar.iron = placar.iron + 1
		resetaBola()
	end
--------------------------------------------------------------------
--------------------------------- FIM LOAD GOLS----------------------------------------------------
----------------------funcao pra reiniciar a bola----------------------
function resetaBola()
	ball.b:setX(490)--coloca a bola na metade da largura e nessa distancia
	ball.b:setY(400)--coloca a bola na metade da altura da tela
	ball.b:setLinearVelocity(0,0)--zera o momento da bola
	gol:play()

end

-------------------aqui faz o teste da direita e esquerda----------------------------------
	if iron.b:getX()<50  then  ----------esquerda
		resetaironleft()
	elseif iron.b:getX()>450 then ---------------meio----------------
		resetaironmeio()
	end
-----------------aqui faz para o spider----------------
	if spider.b:getX()>950 then  ------------direita
		resetaspiderright()
	end
	if spider.b:getX()<540 then ----------meio------
		resetaspidermeio()
	end

-------------------------------------------------------AQ COMECA AS FUNCOES QUE REINICIAM OS PLAYERS--------------------------------
-----------------------ETAPA1: RESETA NA ESQUERDA---------------------------------
function resetaironleft()
	iron.b:setX(50)--coloca a iron na metade da largura e nessa distancia
	iron.b:setY(iron.b:getY())--coloca a bola na metade da altura da tela
	iron.b:setLinearVelocity(0,0)--zera o momento da bola
end 
------------------------ETAPA2: RESETA No meio-------------------------------
function resetaironmeio()
	iron.b:setX(450)--coloca a iron na metade da largura e nessa distancia
	iron.b:setY(iron.b:getY())--coloca a bola na metade da altura da tela
	iron.b:setLinearVelocity(0,0)--zera o momento da bola
end 
-------------------------ETAPA 3: RESETA O spider NA DIREITA------------------------
function resetaspiderright()
	spider.b:setX(950)--coloca a iron na metade da largura e nessa distancia
	spider.b:setY(spider.b:getY())--coloca a bola na metade da altura da tela
	spider.b:setLinearVelocity(0,0)--zera o momentum da bola
end 
------------------------ETAPA 3: RESETA O spider NO MEIO------------------------
function resetaspidermeio()
	spider.b:setX(540)--coloca a iron na metade da largura e nessa distancia
	spider.b:setY(spider.b:getY())--coloca a bola na metade da altura da tela
	spider.b:setLinearVelocity(0,0)--zera o momentum da bola
end 

	---------------------------pra nao deixar a bolinha meio que bugar: aplica força assim que ela fica nos cantos-------------
if ball.b:getY()<39 then        --------------- em cima-----------------
	ball.b:applyForce(0,700)
end
if ball.b:getY()>560 then        --------------- em cima-----------------
	ball.b:applyForce(0,-700)
end


----------------------------------------------------------AQUI COMECA OS CODIGOS QUE APLICAM FORCA E FAZEM MOVER----------------------------
--------------------------PARA O IRON------------------
	if  love.keyboard.isDown("w") and love.keyboard.isDown("a") and startcenario1==true then
			iron.b:setLinearVelocity(-550,-550)
		elseif love.keyboard.isDown("a") and love.keyboard.isDown("s") and startcenario1==true then
			iron.b:setLinearVelocity(-550,550)
		elseif love.keyboard.isDown("s") and love.keyboard.isDown("d") and startcenario1==true then
			iron.b:setLinearVelocity(550,550)
		elseif love.keyboard.isDown("w") and love.keyboard.isDown("d") and startcenario1==true then
			iron.b:setLinearVelocity(550,-550)		
		elseif love.keyboard.isDown("a") and startcenario1==true then
			iron.b:setLinearVelocity(-550, 0)
		elseif love.keyboard.isDown("d") and startcenario1==true then
			iron.b:setLinearVelocity(550, 0)
		elseif love.keyboard.isDown("w") and startcenario1==true then
			iron.b:setLinearVelocity(0, -550)
		elseif love.keyboard.isDown("s") and startcenario1==true then
			iron.b:setLinearVelocity(0, 550)
		else
			iron.b:setLinearVelocity(0,0)
	end




	-----------------------------PARA O spider----------------------------
	--diagonal
	if  love.keyboard.isDown("up") and love.keyboard.isDown("left") and startcenario1==true then
		spider.b:setLinearVelocity(-550,-550)
	--diagonal
	elseif love.keyboard.isDown("left") and love.keyboard.isDown("down") and startcenario1==true then
		spider.b:setLinearVelocity(-550,550)
	--diagonal
	elseif love.keyboard.isDown("down") and love.keyboard.isDown("right") and startcenario1==true then
		spider.b:setLinearVelocity(550,550)
	--diagonal
	elseif love.keyboard.isDown("up") and love.keyboard.isDown("right") and startcenario1==true then
		spider.b:setLinearVelocity(550,-550)
	--esquerda
	elseif love.keyboard.isDown("left") and startcenario1==true then
		spider.b:setLinearVelocity(-550, 0)
	--direita
	elseif love.keyboard.isDown("right") and startcenario1==true then
		spider.b:setLinearVelocity(550, 0)
	--cima
	elseif love.keyboard.isDown("up") and startcenario1==true then
		spider.b:setLinearVelocity(0, -550)
	--baixo
	elseif love.keyboard.isDown("down") and startcenario1==true then
		spider.b:setLinearVelocity(0, 550)
	else
		spider.b:setLinearVelocity(0,0)
	end

--------------------FIM COMANDOS DO TECLADO-----------------------------------------------------------------------------

------------ caso nao queira utilizar som teclar "0" OU OUTROS AI-----------
	if love.keyboard.isDown("1") then         
		love.audio.setVolume("1")
	elseif love.keyboard.isDown("2") then
		love.audio.setVolume("0.5")
	elseif love.keyboard.isDown("0") then
		love.audio.setVolume("0")
	end

end
--------uma funcao pra facilitar o draw do menu------------
function drawmenu( )
		love.graphics.draw(menu, 0, 0)
		love.graphics.draw(play.img, play.x, play.y) 
		love.graphics.draw(instrucoesbutton.img,instrucoesbutton.x,instrucoesbutton.y)
		love.graphics.draw(exit.img, exit.x, exit.y) 
end
------------------draw instruc--------------------------
function drawinstrucoes( )
		love.graphics.draw(instrucoes,0,0)
end

function drawcenario1()
		love.graphics.draw(cenario1,0,0)
-------------desenha personagens----------------
		love.graphics.draw(ironman,iron.b:getX() - 50,iron.b:getY() - 50)
		love.graphics.circle("line", iron.b:getX(),iron.b:getY(), iron.s:getRadius() ,50, 30 )
			---------------------------------------------------
		love.graphics.draw(spiderman,spider.b:getX() - 50 ,spider.b:getY() - 50 )
		love.graphics.circle("line", spider.b:getX(),spider.b:getY(), spider.s:getRadius(),50, 30)
		------------------------------
-------------desenha bola-----------
		love.graphics.draw(bola, ball.b:getX() - 39 , ball.b:getY() - 22)
		love.graphics.circle("line", ball.b:getX(),ball.b:getY(), ball.s:getRadius(), 22.5, 20)----------criacao do objeto de fisica---

--------- desneha borda de cima=---------------
		love.graphics.polygon("line", bordascima.b:getWorldPoints(bordascima.s:getPoints()))
------------------------desenha borda de baixo----------------
		love.graphics.polygon("line", bordasbaixo.b:getWorldPoints(bordasbaixo.s:getPoints()))

------------------desenha leftcima------

		love.graphics.polygon("line", leftcima.b:getWorldPoints(leftcima.s:getPoints()))

--------desenha left baicxo------------
		love.graphics.polygon("line", leftbaixo.b:getWorldPoints(leftbaixo.s:getPoints()))

--------desenha right cima----------------
		love.graphics.polygon("line", rightcima.b:getWorldPoints(rightcima.s:getPoints()))

-------desenha right baixo-------------
		love.graphics.polygon("line", rightbaixo.b:getWorldPoints(rightbaixo.s:getPoints()))
------------------ continuacao do teste---------------------------------
--[[
	if checaleftcima==true then
		love.graphics.polygon("line",leftcima.b:getWorldPoints(leftcima.s:getPoints()))
	end
	--]]

----------------------------------AQUI COMECO A DESENHR gols IRON-------------------
	if startcenario1==true then
		
		love.graphics.setColor(0,0,0)
		love.graphics.print(placar.iron,480,30,0,2,3)
		love.graphics.setColor(255,255,255)
	end
	---------------------------------------------------------------------------
------------------------------AQUI DESENHO DO spider---------------------
	if startcenario1==true then
		
		love.graphics.setColor(0,0,0)
		love.graphics.print(placar.spider,480,530,0,2,3)
		love.graphics.setColor(255,255,255)
	end
	-------------------------------------------------------------------
	-------------------tempo do jogo---------------------
	if ligado==true and startcenario1==true and startmenu==false then
		love.graphics.setFont(fonte)
		love.graphics.setColor( 0 , 0 , 0)			
		love.graphics.print( tempo, 450,330,0,2.5,2.5)
		love.graphics.setColor( 255 , 255 , 255)		
	end


end

function love.mousepressed(px,py,button)
	--------------------- comandos para o play---------------------
	if button==1 and px>=play.x and px < play.x + play.w and py >=play.y and py < play.y + play.h then
		startmenu=false
		startinstrucoes=false
		startcenario1=true
		startexit=false
		one : play()
		inicial : pause()
	end
	--------------para instrucoes-------------------
 	if button==1 and px>=instrucoesbutton.x and px < instrucoesbutton.x + instrucoesbutton.w and py >=instrucoesbutton.y and py < instrucoesbutton.y + instrucoesbutton.h then
		startmenu=false
		startcenario1=false
		startinstrucoes=true
		startexit=false
		inicial:pause()
	end
	---------------para o exit--------------
	if button==1 and px>=exit.x and px < exit.x + exit.w and py >=exit.y and py < exit.y + exit.h then
		startmenu=false
		startexit=true
		startcenario1=false
	end
end

function love.draw()
	if startmenu==true and startcenario1==false then
		drawmenu()
		
		
	elseif startinstrucoes==true and startexit==false and startcenario1==false then
		drawinstrucoes()
		

	elseif startexit==true  then
		love.event.quit() ----------funcao que da quit no jogo--------------

	elseif startcenario1==true and startexit==false and startmenu==false and startinstrucoes==false then
		drawcenario1()
		

	end
------------------se estiver na instrucao e quiser voltar ao menu-------------
	if startinstrucoes==true and love.keyboard.isDown("return") then
		startinstrucoes=false
		startmenu=true
		inicial:play()

	end
---------------------caso ele esteja no meio do jogo e queira voltar--------
--[[
	if startcenario1==true and love.keyboard.isDown("m") then
		startmenu=false
		one:pause()
		inicial:play()
		tempo:pause()
		fimjogo=false
	end
	-------------pra sair no meio do jogo---------------------
	--[[
	if startcenario1==true and love.keyboard.isDown("return") then
		startmenu=true 
		startcenario1=false
		one:pause()
		inicial:play()
		ligado=false

	end
	--]]
	-----------------------aqui eu desenho o you win e o you loser----------------------
	if placar.iron>placar.spider and fimjogo==true  then
		ironcampeao=true
		startcenario1=false
	elseif  placar.iron<placar.spider and fimjogo==true  then
		spidercampeao=true
		startcenario1=false
		
	elseif placar.iron==placar.spider and fimjogo==true  then
		empate=true
		startcenario1=false
	end
	if ironcampeao==true and startcenario1==false then
		love.graphics.draw(ironcampeaoimg,0,0)
	elseif spidercampeao==true and startcenario1==false then
		love.graphics.draw(spidercampeaoimg,0,0)
	elseif empate==true and startcenario1==false then
		love.graphics.draw(empateimg,0,0)
	end


end









