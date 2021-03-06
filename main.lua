function love.load()

	Inspect = require "lib.inspect"
	Class = require "lib.hump.class"
	Gamestate = require "lib.hump.gamestate"

	window={}
	window.w=800
	window.h=650
	game={}
	game.w=4000
	game.h=650
  love.window.setTitle("Crabventure")
  love.window.setMode( window.w, window.h)

  imgs={}
  imgs.crabBod=love.graphics.newImage("img/crabBod.png")
  imgs.crabBodBack=love.graphics.newImage("img/crabBodBack.png")
  imgs.crabRClaw=love.graphics.newImage("img/crabClaw.png")
  imgs.crabRClawC=love.graphics.newImage("img/crabClawC.png")
  imgs.crabLClaw=love.graphics.newImage("img/crabClaw2.png")
  imgs.crabLClawC=love.graphics.newImage("img/crabClaw2C.png")
  imgs.crabEye=love.graphics.newImage("img/crabEye.png")
  imgs.crabEyeTop=love.graphics.newImage("img/crabEyeTop.png")


  imgs.knife=love.graphics.newImage("img/knife.png")
	love.physics.setMeter(64)
	world=love.physics.newWorld(0,9.8*64,true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  text=""
	persisting = 0
	hitboxes=true

	objects={}
	ObjectRect=Class{
		init=function(self,x,y,mass,restitution,w,h,img,userData,pickUp)
			self.b=love.physics.newBody(world,x,y,"dynamic")
		  self.b:setMass(mass)
			self.s=love.physics.newRectangleShape(w, h)
		  self.f=love.physics.newFixture(self.b,self.s)
		  self.f:setRestitution(restitution)
		  self.f:setUserData(userData)
		  self.f:setGroupIndex(5)
			self.img=img
			self.pickUp=pickUp

		end;
		update=function(self,dt)

		end;
		draw=function(self)
			love.graphics.draw(self.img,self.b:getX(),self.b:getY(),self.b:getAngle(),1,1,self.img:getWidth()/2,self.img:getHeight()/2)
		end;
		drawHitBox=function(self)
			love.graphics.polygon("line",self.b:getWorldPoints(self.s:getPoints()))
		end;
	}
	function newObjectRect(x,y,mass,restitution,w,h,img,userData,pickUp)
		objects[#objects+1]=ObjectRect(x,y,mass,restitution,w,h,img,userData,pickUp)
	end;


	Crab=Class{
		init=function(self,x,y)
			--body setup
			self.body={}
		  self.body.b=love.physics.newBody(world,x,y,"dynamic")
		  self.body.b:setMass(12)
		  self.body.s=love.physics.newRectangleShape(100, 50)
		  self.body.f=love.physics.newFixture(self.body.b,self.body.s)
		  self.body.f:setRestitution(0.9)
		  self.body.f:setUserData("crab")
		  self.body.f:setFilterData(1,1,-1)


			--CLAWS SETUP
			self.claws={}
			self.claws.l={}
			self.claws.l.b=love.physics.newBody(world,x+150,y-20,"dynamic")
 		  self.claws.l.b:setMass(8)
 		  self.claws.l.s=love.physics.newRectangleShape(80, 40)
 		  self.claws.l.f=love.physics.newFixture(self.claws.l.b, self.claws.l.s)
 		  self.claws.l.f:setRestitution(0.4)
 		  self.claws.l.f:setUserData("crab.claws.l")
 		  self.claws.l.f:setFilterData(1,1,-1)

			self.claws.l.rope=love.physics.newRopeJoint(self.body.b, self.claws.l.b, x+50, y-20, x+120, y-20, 40, true)
			self.claws.l.mouse=love.physics.newMouseJoint(self.claws.l.b, x+150,y-20)
			self.claws.l.mouse:setMaxForce(1500)
			self.claws.l.mouse:setDampingRatio(5)

			self.claws.r={}
			self.claws.r.b=love.physics.newBody(world,x-150,y-20,"dynamic")
 		  self.claws.r.b:setMass(8)
 		  self.claws.r.s=love.physics.newRectangleShape(80, 40)
 		  self.claws.r.f=love.physics.newFixture(self.claws.r.b, self.claws.r.s)
 		  self.claws.r.f:setRestitution(0.4)
 		  self.claws.r.f:setUserData("crab.claws.r")
 		  self.claws.r.f:setFilterData(1,1,-1)

			self.claws.r.rope=love.physics.newRopeJoint(self.body.b, self.claws.r.b, x-50, y-20, x-120, y-20, 40, true)

			--EYE SETUP
			--left eye setup
			self.eyes={}
			self.eyes.l={}
			--left eye base stalk setup
			self.eyes.l.stalk1={}
			self.eyes.l.stalk1.b=love.physics.newBody(world,x+25,y-30,"dynamic")
		  self.eyes.l.stalk1.b:setMass(4)
		  self.eyes.l.stalk1.s=love.physics.newRectangleShape(10, 30)
		  self.eyes.l.stalk1.f=love.physics.newFixture(self.eyes.l.stalk1.b, self.eyes.l.stalk1.s)
		  self.eyes.l.stalk1.f:setUserData("crab.eyes.l.stalk1")
		  self.eyes.l.stalk1.f:setFilterData(1,1,-1)
			--left eye base stalk joint setup
		  self.eyes.l.stalk1.joint=love.physics.newRevoluteJoint(self.body.b,self.eyes.l.stalk1.b,x+25,y-20,false)
		  self.eyes.l.stalk1.joint:setLimits(-0.1,0.1)
		  self.eyes.l.stalk1.joint:setLimitsEnabled(true)
			--left eye top stalk setup
			self.eyes.l.stalk2={}
			self.eyes.l.stalk2.b=love.physics.newBody(world,x+25,y-50,"dynamic")
			self.eyes.l.stalk2.b:setMass(4)
			self.eyes.l.stalk2.s=love.physics.newRectangleShape(10, 25)
			self.eyes.l.stalk2.f=love.physics.newFixture(self.eyes.l.stalk2.b, self.eyes.l.stalk2.s)
			self.eyes.l.stalk2.f:setUserData("crab.eyes.l.stalk2")
			self.eyes.l.stalk2.f:setFilterData(1,1,-1)
			--left eye top stalk joint setup
			self.eyes.l.stalk2.joint=love.physics.newRevoluteJoint(self.eyes.l.stalk1.b,self.eyes.l.stalk2.b,x+25,y-45,false)
			self.eyes.l.stalk2.joint:setLimits(-0.4,0.4)
			self.eyes.l.stalk2.joint:setLimitsEnabled(true)
			--left eye ball setup
			self.eyes.l.ball={}
			self.eyes.l.ball.b=love.physics.newBody(world,x+25,y-65,"dynamic")
			self.eyes.l.ball.b:setMass(3)
			self.eyes.l.ball.s=love.physics.newRectangleShape(20, 20)
			self.eyes.l.ball.f=love.physics.newFixture(self.eyes.l.ball.b, self.eyes.l.ball.s)
			self.eyes.l.ball.f:setUserData("crab.eyes.l.ball")
			self.eyes.l.ball.f:setFilterData(1,1,-1)
			--left eye ball joint setup
			self.eyes.l.ball.joint=love.physics.newWeldJoint(self.eyes.l.stalk2.b,self.eyes.l.ball.b,x+25,y-65,false)


			--right eye setup
			self.eyes.r={}
			--right eye base stalk setup
			self.eyes.r.stalk1={}
			self.eyes.r.stalk1.b=love.physics.newBody(world,x-25,y-30,"dynamic")
		  self.eyes.r.stalk1.b:setMass(4)
		  self.eyes.r.stalk1.s=love.physics.newRectangleShape(10, 30)
		  self.eyes.r.stalk1.f=love.physics.newFixture(self.eyes.r.stalk1.b, self.eyes.r.stalk1.s)
		  self.eyes.r.stalk1.f:setUserData("crab.eyes.r.stalk1")
		  self.eyes.r.stalk1.f:setFilterData(1,1,-1)
			--right eye base stalk joint setup
		  self.eyes.r.stalk1.joint=love.physics.newRevoluteJoint(self.body.b,self.eyes.r.stalk1.b,x-25,y-20,false)
		  self.eyes.r.stalk1.joint:setLimits(-0.1,0.1)
		  self.eyes.r.stalk1.joint:setLimitsEnabled(true)
			--right eye top stalk setup
			self.eyes.r.stalk2={}
			self.eyes.r.stalk2.b=love.physics.newBody(world,x-25,y-50,"dynamic")
			self.eyes.r.stalk2.b:setMass(4)
			self.eyes.r.stalk2.s=love.physics.newRectangleShape(10, 25)
			self.eyes.r.stalk2.f=love.physics.newFixture(self.eyes.r.stalk2.b, self.eyes.r.stalk2.s)
			self.eyes.r.stalk2.f:setUserData("crab.eyes.r.stalk2")
			self.eyes.r.stalk2.f:setFilterData(1,1,-1)
			--left eye top stalk joint setup
			self.eyes.r.stalk2.joint=love.physics.newRevoluteJoint(self.eyes.r.stalk1.b,self.eyes.r.stalk2.b,x-25,y-45,false)
			self.eyes.r.stalk2.joint:setLimits(-0.4,0.4)
			self.eyes.r.stalk2.joint:setLimitsEnabled(true)
			--left eye ball setup
			self.eyes.r.ball={}
			self.eyes.r.ball.b=love.physics.newBody(world,x-25,y-65,"dynamic")
			self.eyes.r.ball.b:setMass(3)
			self.eyes.r.ball.s=love.physics.newRectangleShape(20, 20)
			self.eyes.r.ball.f=love.physics.newFixture(self.eyes.r.ball.b, self.eyes.r.ball.s)
			self.eyes.r.ball.f:setUserData("crab.eyes.r.ball")
			self.eyes.r.ball.f:setFilterData(1,1,-1)
			--left eye ball joint setup
			self.eyes.r.ball.joint=love.physics.newWeldJoint(self.eyes.r.stalk2.b,self.eyes.r.ball.b,x-25,y-65,false)


			self.color={}
			self.color.primary={}
			--self.color.primary[1]=255
			--self.color.primary[2]=127
			--self.color.primary[3]=39
			self.color.primary[1]=102
			self.color.primary[2]=205
			self.color.primary[3]=170
			self.color.secondary={}
			self.color.secondary[1]=240
			self.color.secondary[2]=240
			self.color.secondary[3]=230
			self.grounded=false;
			self.grab=false;
			self.grabjoint=nil;

		end;
		draw=function(self)

				love.graphics.setColor(self.color.primary[1], self.color.primary[2], self.color.primary[3], 255)
				love.graphics.setLineWidth(5)
				eyeStalkLPoints={}
				eyeStalkLPoints[1],eyeStalkLPoints[2]=self.eyes.l.stalk1.joint:getAnchors()
				eyeStalkLPoints[3],eyeStalkLPoints[4]=self.eyes.l.stalk2.joint:getAnchors()
				eyeStalkLPoints[5],eyeStalkLPoints[6]=self.eyes.l.ball.joint:getAnchors()
				eyeStalkL=love.math.newBezierCurve(eyeStalkLPoints)
				love.graphics.line(eyeStalkL:render())

				eyeStalkRPoints={}
				eyeStalkRPoints[1],eyeStalkRPoints[2]=self.eyes.r.stalk1.joint:getAnchors()
				eyeStalkRPoints[3],eyeStalkRPoints[4]=self.eyes.r.stalk2.joint:getAnchors()
				eyeStalkRPoints[5],eyeStalkRPoints[6]=self.eyes.r.ball.joint:getAnchors()
				eyeStalkR=love.math.newBezierCurve(eyeStalkRPoints)
				love.graphics.line(eyeStalkR:render())

				love.graphics.setColor(self.color.secondary[1], self.color.secondary[2], self.color.secondary[3], 255)
				love.graphics.draw(imgs.crabBodBack,self.body.b:getX(),self.body.b:getY(),self.body.b:getAngle(),1,1,imgs.crabBodBack:getWidth()/2,imgs.crabBodBack:getHeight()/2)

				love.graphics.setColor(self.color.primary[1], self.color.primary[2], self.color.primary[3], 255)
				love.graphics.draw(imgs.crabBod,self.body.b:getX(),self.body.b:getY(),self.body.b:getAngle(),1,1,imgs.crabBod:getWidth()/2,imgs.crabBod:getHeight()/2)

				love.graphics.setColor(255,255,255,255)
			  love.graphics.draw(imgs.crabEye,self.eyes.l.ball.b:getX(),self.eyes.l.ball.b:getY(),self.eyes.l.ball.b:getAngle(),1,1,imgs.crabEye:getWidth()/2,imgs.crabEye:getHeight()/2)
				love.graphics.draw(imgs.crabEye,self.eyes.r.ball.b:getX(),self.eyes.r.ball.b:getY(),self.eyes.r.ball.b:getAngle(),1,1,imgs.crabEye:getWidth()/2,imgs.crabEye:getHeight()/2)

				love.graphics.setColor(self.color.primary[1], self.color.primary[2], self.color.primary[3], 255)
				love.graphics.draw(imgs.crabEyeTop,self.eyes.l.ball.b:getX(),self.eyes.l.ball.b:getY(),self.eyes.l.ball.b:getAngle(),1,1,imgs.crabEyeTop:getWidth()/2,imgs.crabEyeTop:getHeight()/2)
				love.graphics.draw(imgs.crabEyeTop,self.eyes.r.ball.b:getX(),self.eyes.r.ball.b:getY(),self.eyes.r.ball.b:getAngle(),1,1,imgs.crabEyeTop:getWidth()/2,imgs.crabEyeTop:getHeight()/2)
				if(crab.grab) then
					love.graphics.draw(imgs.crabLClawC,self.claws.l.b:getX(),self.claws.l.b:getY(),self.claws.l.b:getAngle(),1,1,imgs.crabLClawC:getWidth()/2,imgs.crabLClawC:getHeight()/2)
				else
					love.graphics.draw(imgs.crabLClaw,self.claws.l.b:getX(),self.claws.l.b:getY(),self.claws.l.b:getAngle(),1,1,imgs.crabLClaw:getWidth()/2,imgs.crabLClaw:getHeight()/2)
				end
				love.graphics.draw(imgs.crabRClaw,self.claws.r.b:getX(),self.claws.r.b:getY(),self.claws.r.b:getAngle(),1,1,imgs.crabRClaw:getWidth()/2,imgs.crabRClaw:getHeight()/2)

				if(hitboxes)then

					love.graphics.setLineWidth(1)
					love.graphics.setColor(255,255,255,255)

					--draw bod
					love.graphics.polygon("line",self.body.b:getWorldPoints(self.body.s:getPoints()))
					--draw arms
					--love.graphics.polygon("line",self.arms.l.b:getWorldPoints(self.arms.l.s:getPoints()))
					--love.graphics.polygon("line",self.arms.r.b:getWorldPoints(self.arms.r.s:getPoints()))
					--draw eyes
					love.graphics.polygon("line",self.eyes.l.stalk1.b:getWorldPoints(self.eyes.l.stalk1.s:getPoints()))
					love.graphics.polygon("line",self.eyes.l.stalk2.b:getWorldPoints(self.eyes.l.stalk2.s:getPoints()))
					love.graphics.polygon("line",self.eyes.l.ball.b:getWorldPoints(self.eyes.l.ball.s:getPoints()))


					love.graphics.polygon("line",self.eyes.r.stalk1.b:getWorldPoints(self.eyes.r.stalk1.s:getPoints()))
					love.graphics.polygon("line",self.eyes.r.stalk2.b:getWorldPoints(self.eyes.r.stalk2.s:getPoints()))
					love.graphics.polygon("line",self.eyes.r.ball.b:getWorldPoints(self.eyes.r.ball.s:getPoints()))

					--draw claws

					love.graphics.polygon("line",self.claws.l.b:getWorldPoints(self.claws.l.s:getPoints()))
					love.graphics.polygon("line",self.claws.r.b:getWorldPoints(self.claws.r.s:getPoints()))
				end
		end;
		update=function(self,dt)
			self.body.b:setAngle(0)
			self.claws.r.b:setAngle(0)
			mouseX=love.mouse.getX()
			mouseY=love.mouse.getY()
			--maxX=self.claws.l.b:getX()+80/4
			--minX=self.claws.l.b:getX()-80/4
			--mouseY=love.mouse.getY()
			--maxY=self.claws.l.b:getY()+40/4
			--minY=self.claws.l.b:getY()-40/4
			--if(mouseX>maxX)then mouseX=maxX
			--elseif(mouseX<minX)then mouseX=minX end;
			--if(mouseY>maxY)then mouseY=maxY
			--elseif(mouseY<minY)then mouseY=minY end;

			self.claws.l.mouse:setTarget(mouseX,mouseY)
		end;
	}

	crab=Crab(400,200)
	--crab2=Crab(400,0)



  ground={}
  ground.b=love.physics.newBody(world,0,600,"static")
  ground.s=love.physics.newRectangleShape(1500,50)
  ground.f=love.physics.newFixture(ground.b,ground.s)
  ground.f:setRestitution(0.4)
  ground.f:setUserData("ground")
  ground.f:setFilterData(1,1,1)

	newObjectRect(600,100,2,0.2,20,80,imgs.knife,"knife",true)
end

function love.update(dt)
	crab:update(dt)
	if(crab.grabjointQ~=nil)then
		crab.grabjointQ()
		crab.grabjointQ=nil
	end
	for n,obj in ipairs(objects) do
		if(obj)then
			obj:update(dt)
		end
	end;
  world:update(dt)
  x,y=crab.body.b:getLinearVelocity()
		if love.keyboard.isDown("d") then
			if x<600 then
				crab.body.b:applyForce(3000,0)
			end
		elseif love.keyboard.isDown("a") then
			if x>-600 then
				crab.body.b:applyForce(-3000,0)
			end
		end
		if love.keyboard.isDown("w") then
			if y>-300 and crab.grounded==true then
				crab.body.b:applyForce(0,-25000)
			end
		elseif love.keyboard.isDown("s") then
			if y<300 then
				crab.body.b:applyForce(0,3000)
			end
		end
end
function love.mousepressed(x, y, button, isTouch)
	if(crab.grab)then
		if(crab.grabjoint~=nil)then
			crab.grabjoint:destroy()
			crab.grabjoint=nil
		end
		crab.grab=false
	else crab.grab=true end
end
function love.keyreleased(key)
	--debug
	if key=="q" then
		if(hitboxes)then
			hitboxes=false
		else
			hitboxes=true
		end
	elseif key=="r" then
		love.load()
	end
end

function love.draw()
	crab:draw()
	--crab2:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setLineWidth(1)
	for n,obj in ipairs(objects) do
		if(obj)then
			obj:draw()
		end
	end;
	if(hitboxes) then
		for n,obj in ipairs(objects) do
			if(obj)then
				obj:drawHitBox()
			end
		end;
	end;
  love.graphics.polygon("line",ground.b:getWorldPoints(ground.s:getPoints()))
	if(hitboxes)then
  	love.graphics.print(text,10,10)
  	love.graphics.print("DEBUG MODE",window.w/2+50,0)
	end
end


function str(st)
  return string.format("%s",st)
end


--collision functions
function collide(a,b,obj1,obj2)
  return ((a:getUserData()==obj1 and b:getUserData()==obj2)or(a:getUserData()==obj2 and b:getUserData()==obj1))
end
function collideGroup(a,b,obj1,obj2)
  return ((a:getGroupIndex()==obj1 and b:getGroupIndex()==obj2)or(a:getGroupIndex()==obj2 and b:getGroupIndex()==obj1))
end
function beginContact(a, b, coll)
  text=string.format("%s touching %s",a:getUserData(),b:getUserData())
	--text=string.format("%s",Inspect(getmetatable(coll:getFixtures():getBody())))
  if(collide(a,b,"crab","ground"))then
    crab.grounded=true
	elseif(collideGroup(a,b,-1,5)) then
		if(crab.grabjoint==nil and crab.grab and (a:getUserData()=="crab.claws.l" or b:getUserData()=="crab.claws.l")) then
			if(a:getUserData()=="crab.claws.l")then objectCentre=b
			else objectCentre=a end;
			crab.grabjointQ=function() crab.grabjoint=love.physics.newWeldJoint(a:getBody(), b:getBody(), objectCentre:getBody():getX(), objectCentre:getBody():getY(), false)end
		end
  end
end

function endContact(a, b, coll)
  text=""
  if(collide(a,b,"crab","ground"))then
    crab.grounded=false
  end
end

function preSolve(a, b, coll)

end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end
