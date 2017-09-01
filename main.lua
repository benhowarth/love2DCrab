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
  imgs.crabRArm=love.graphics.newImage("img/crabArm.png")
  imgs.crabLArm=love.graphics.newImage("img/crabArm2.png")
  imgs.crabEye=love.graphics.newImage("img/crabEye.png")
	love.physics.setMeter(64)
	world=love.physics.newWorld(0,9.8*64,true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  text=""
	persisting = 0
	hitboxes=false


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

			--left arm setup
		  self.arms={}
		  self.arms.l={}
		  self.arms.l.b=love.physics.newBody(world,x+80,y-20,"dynamic")
		  self.arms.l.b:setMass(6)
		  self.arms.l.s=love.physics.newRectangleShape(90, 25)
		  self.arms.l.f=love.physics.newFixture(self.arms.l.b, self.arms.l.s)
		  self.arms.l.f:setRestitution(0.4)
		  self.arms.l.f:setUserData("crab.arms.l")

			--left arm joint setup
		  self.arms.l.joint=love.physics.newRevoluteJoint(self.body.b,self.arms.l.b,x+65,y-20,false)
		  self.arms.l.joint:setLimits(-math.pi/3.3,-math.pi/4.6)
		  self.arms.l.joint:setLimitsEnabled(true)

			--right arm setup
		  self.arms.r={}
		  self.arms.r.b=love.physics.newBody(world,x-80,y-20,"dynamic")
		  self.arms.r.b:setMass(6)
		  self.arms.r.s=love.physics.newRectangleShape(90, 25)
		  self.arms.r.f=love.physics.newFixture(self.arms.r.b, self.arms.r.s)
		  self.arms.r.f:setRestitution(0.4)
		  self.arms.r.f:setUserData("crab.arms.r")

			--right arm joint setup
		  self.arms.r.joint=love.physics.newRevoluteJoint(self.body.b,self.arms.r.b,x-65,y-20,false)
		  self.arms.r.joint:setLimits(math.pi/4.6,math.pi/3.3)
		  self.arms.r.joint:setLimitsEnabled(true)

			--left eye setup
			self.eyes={}
			self.eyes.l={}
			--left eye base stalk setup
			self.eyes.l.stalk1={}
			self.eyes.l.stalk1.b=love.physics.newBody(world,x+25,y-30,"dynamic")
		  self.eyes.l.stalk1.b:setMass(2)
		  self.eyes.l.stalk1.s=love.physics.newRectangleShape(10, 30)
		  self.eyes.l.stalk1.f=love.physics.newFixture(self.eyes.l.stalk1.b, self.eyes.l.stalk1.s)
		  self.eyes.l.stalk1.f:setUserData("crab.eyes.l.stalk1")
			--left eye base stalk joint setup
		  self.eyes.l.stalk1.joint=love.physics.newRevoluteJoint(self.body.b,self.eyes.l.stalk1.b,x+25,y-20,false)
		  self.eyes.l.stalk1.joint:setLimits(-0.3,0.3)
		  self.eyes.l.stalk1.joint:setLimitsEnabled(true)
			--left eye top stalk setup
			self.eyes.l.stalk2={}
			self.eyes.l.stalk2.b=love.physics.newBody(world,x+25,y-50,"dynamic")
			self.eyes.l.stalk2.b:setMass(2)
			self.eyes.l.stalk2.s=love.physics.newRectangleShape(10, 25)
			self.eyes.l.stalk2.f=love.physics.newFixture(self.eyes.l.stalk2.b, self.eyes.l.stalk2.s)
			self.eyes.l.stalk2.f:setUserData("crab.eyes.l.stalk2")
			--left eye top stalk joint setup
			self.eyes.l.stalk2.joint=love.physics.newRevoluteJoint(self.eyes.l.stalk1.b,self.eyes.l.stalk2.b,x+25,y-45,false)
			self.eyes.l.stalk2.joint:setLimits(-0.3,0.3)
			self.eyes.l.stalk2.joint:setLimitsEnabled(true)
			--left eye ball setup
			self.eyes.l.ball={}
			self.eyes.l.ball.b=love.physics.newBody(world,x+25,y-65,"dynamic")
			self.eyes.l.ball.b:setMass(2)
			self.eyes.l.ball.s=love.physics.newRectangleShape(20, 20)
			self.eyes.l.ball.f=love.physics.newFixture(self.eyes.l.ball.b, self.eyes.l.ball.s)
			self.eyes.l.ball.f:setUserData("crab.eyes.l.ball")
			--left eye ball joint setup
			self.eyes.l.ball.joint=love.physics.newRevoluteJoint(self.eyes.l.stalk2.b,self.eyes.l.ball.b,x+25,y-65,false)
			self.eyes.l.ball.joint:setLimits(-0.1,0.1)



			--right eye setup
			self.eyes.r={}
			--right eye base stalk setup
			self.eyes.r.stalk1={}
			self.eyes.r.stalk1.b=love.physics.newBody(world,x-25,y-30,"dynamic")
		  self.eyes.r.stalk1.b:setMass(2)
		  self.eyes.r.stalk1.s=love.physics.newRectangleShape(10, 30)
		  self.eyes.r.stalk1.f=love.physics.newFixture(self.eyes.r.stalk1.b, self.eyes.r.stalk1.s)
		  self.eyes.r.stalk1.f:setUserData("crab.eyes.r.stalk1")
			--right eye base stalk joint setup
		  self.eyes.r.stalk1.joint=love.physics.newRevoluteJoint(self.body.b,self.eyes.r.stalk1.b,x-25,y-20,false)
		  self.eyes.r.stalk1.joint:setLimits(-0.3,0.3)
		  self.eyes.r.stalk1.joint:setLimitsEnabled(true)
			--right eye top stalk setup
			self.eyes.r.stalk2={}
			self.eyes.r.stalk2.b=love.physics.newBody(world,x-25,y-50,"dynamic")
			self.eyes.r.stalk2.b:setMass(2)
			self.eyes.r.stalk2.s=love.physics.newRectangleShape(10, 25)
			self.eyes.r.stalk2.f=love.physics.newFixture(self.eyes.r.stalk2.b, self.eyes.r.stalk2.s)
			self.eyes.r.stalk2.f:setUserData("crab.eyes.r.stalk2")
			--left eye top stalk joint setup
			self.eyes.r.stalk2.joint=love.physics.newRevoluteJoint(self.eyes.r.stalk1.b,self.eyes.r.stalk2.b,x-25,y-45,false)
			self.eyes.r.stalk2.joint:setLimits(-0.3,0.3)
			self.eyes.r.stalk2.joint:setLimitsEnabled(true)
			--left eye ball setup
			self.eyes.r.ball={}
			self.eyes.r.ball.b=love.physics.newBody(world,x-25,y-65,"dynamic")
			self.eyes.r.ball.b:setMass(2)
			self.eyes.r.ball.s=love.physics.newRectangleShape(20, 20)
			self.eyes.r.ball.f=love.physics.newFixture(self.eyes.r.ball.b, self.eyes.r.ball.s)
			self.eyes.r.ball.f:setUserData("crab.eyes.r.ball")
			--left eye ball joint setup
			self.eyes.r.ball.joint=love.physics.newRevoluteJoint(self.eyes.r.stalk2.b,self.eyes.r.ball.b,x-25,y-65,false)
			self.eyes.r.ball.joint:setLimits(-0.1,0.1)


			self.color={}
			self.color.primary={}
			self.color.primary[1]=255
			self.color.primary[2]=127
			self.color.primary[3]=39
			self.grounded=false;

		end;
		draw=function(self)
				--love.graphics.setColor(self.color.primary[1], self.color.primary[2], self.color.primary[3], 255)
				love.graphics.setColor(255,255,255,255)
			  love.graphics.draw(imgs.crabLArm,self.arms.l.b:getX(),self.arms.l.b:getY(),self.arms.l.b:getAngle(),1,1,imgs.crabLArm:getWidth()/2,imgs.crabLArm:getHeight()/2)
			  love.graphics.draw(imgs.crabRArm,self.arms.r.b:getX(),self.arms.r.b:getY(),self.arms.r.b:getAngle(),1,1,imgs.crabRArm:getWidth()/2,imgs.crabRArm:getHeight()/2)


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

				love.graphics.setColor(255,255,255,255)
				love.graphics.draw(imgs.crabBod,self.body.b:getX(),self.body.b:getY(),self.body.b:getAngle(),1,1,imgs.crabBod:getWidth()/2,imgs.crabBod:getHeight()/2)

			  love.graphics.draw(imgs.crabEye,self.eyes.l.ball.b:getX(),self.eyes.l.ball.b:getY(),self.eyes.l.ball.b:getAngle(),1,1,imgs.crabEye:getWidth()/2,imgs.crabEye:getHeight()/2)


			  love.graphics.draw(imgs.crabEye,self.eyes.r.ball.b:getX(),self.eyes.r.ball.b:getY(),self.eyes.r.ball.b:getAngle(),1,1,imgs.crabEye:getWidth()/2,imgs.crabEye:getHeight()/2)
				if(hitboxes)then

					love.graphics.setLineWidth(1)
					love.graphics.setColor(255,255,255,255)

					--draw bod
					love.graphics.polygon("line",self.body.b:getWorldPoints(self.body.s:getPoints()))
					--draw arms
					love.graphics.polygon("line",self.arms.l.b:getWorldPoints(self.arms.l.s:getPoints()))
					love.graphics.polygon("line",self.arms.r.b:getWorldPoints(self.arms.r.s:getPoints()))
					--draw eyes
					love.graphics.polygon("line",self.eyes.l.stalk1.b:getWorldPoints(self.eyes.l.stalk1.s:getPoints()))
					love.graphics.polygon("line",self.eyes.l.stalk2.b:getWorldPoints(self.eyes.l.stalk2.s:getPoints()))
					love.graphics.polygon("line",self.eyes.l.ball.b:getWorldPoints(self.eyes.l.ball.s:getPoints()))


					love.graphics.polygon("line",self.eyes.r.stalk1.b:getWorldPoints(self.eyes.r.stalk1.s:getPoints()))
					love.graphics.polygon("line",self.eyes.r.stalk2.b:getWorldPoints(self.eyes.r.stalk2.s:getPoints()))
					love.graphics.polygon("line",self.eyes.r.ball.b:getWorldPoints(self.eyes.r.ball.s:getPoints()))
				end
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
end

function love.update(dt)
  world:update(dt)
  crab.body.b:setAngle(0)
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

function love.keyreleased(key)
	--debug
	if key=="q" then
		if(hitboxes)then
			hitboxes=false
		else
			hitboxes=true
		end
	end
end

function love.draw()
	crab:draw()
	--crab2:draw()
  love.graphics.polygon("line",ground.b:getWorldPoints(ground.s:getPoints()))
  love.graphics.print(text,10,10)
end


function str(st)
  return string.format("%s",st)
end




--collision functions
function collide(a,b,obj1,obj2)
  return ((a:getUserData()==obj1 and b:getUserData()==obj2)or(a:getUserData()==obj2 and b:getUserData()==obj1))
end
function beginContact(a, b, coll)
  text=string.format("%s touching %s",a:getUserData(),b:getUserData())
  if(collide(a,b,"crab","ground"))then
    crab.grounded=true
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
