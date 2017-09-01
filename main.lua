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
	love.physics.setMeter(64)
	world=love.physics.newWorld(0,9.8*64,true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  text=""
	persisting = 0
	hitboxes=true


	Crab=Class{
		init=function(self,x,y)
			self.body={}
		  self.body.b=love.physics.newBody(world,x,y,"dynamic")
		  self.body.b:setMass(12)
		  self.body.s=love.physics.newRectangleShape(100, 50)
		  self.body.f=love.physics.newFixture(self.body.b,self.body.s)
		  self.body.f:setRestitution(0.9)
		  self.body.f:setUserData("crab")

		  self.arms={}
		  self.arms.l={}
		  self.arms.l.b=love.physics.newBody(world,x+70,y-20,"dynamic")
		  self.arms.l.b:setMass(6)
		  self.arms.l.s=love.physics.newRectangleShape(90, 25)
		  self.arms.l.f=love.physics.newFixture(self.arms.l.b, self.arms.l.s)
		  self.arms.l.f:setRestitution(0.4)
		  self.arms.l.f:setUserData("crab.arms.l")

		  self.arms.l.joint=love.physics.newRevoluteJoint(self.body.b,self.arms.l.b,x+50,y-20,false)
		  self.arms.l.joint:setLimits(-math.pi/3.3,-math.pi/4.6)
		  self.arms.l.joint:setLimitsEnabled(true)

		  self.arms.r={}
		  self.arms.r.b=love.physics.newBody(world,x-70,y-20,"dynamic")
		  self.arms.r.b:setMass(6)
		  self.arms.r.s=love.physics.newRectangleShape(90, 25)
		  self.arms.r.f=love.physics.newFixture(self.arms.r.b, self.arms.r.s)
		  self.arms.r.f:setRestitution(0.4)
		  self.arms.r.f:setUserData("crab.arms.r")

		  self.arms.r.joint=love.physics.newRevoluteJoint(self.body.b,self.arms.r.b,x-50,y-20,false)
		  self.arms.r.joint:setLimits(math.pi/4.6,math.pi/3.3)
		  self.arms.r.joint:setLimitsEnabled(true)
		end;
		grounded=false;
		draw=function(self)
			  love.graphics.draw(imgs.crabLArm,self.arms.l.b:getX(),self.arms.l.b:getY(),self.arms.l.b:getAngle(),1,1,imgs.crabLArm:getWidth()/2,imgs.crabLArm:getHeight()/2)
			  love.graphics.draw(imgs.crabRArm,self.arms.r.b:getX(),self.arms.r.b:getY(),self.arms.r.b:getAngle(),1,1,imgs.crabRArm:getWidth()/2,imgs.crabRArm:getHeight()/2)
			  love.graphics.draw(imgs.crabBod,self.body.b:getX(),self.body.b:getY(),self.body.b:getAngle(),1,1,imgs.crabBod:getWidth()/2,imgs.crabBod:getHeight()/2)
				if(hitboxes)then
					love.graphics.polygon("line",self.arms.l.b:getWorldPoints(self.arms.l.s:getPoints()))
					love.graphics.polygon("line",self.arms.r.b:getWorldPoints(self.arms.r.s:getPoints()))
					love.graphics.polygon("line",self.body.b:getWorldPoints(self.body.s:getPoints()))
				end
		end;
	}

	crab=Crab(400,200)
	crab2=Crab(400,0)



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

function love.draw()
	crab:draw()
	crab2:draw()
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
