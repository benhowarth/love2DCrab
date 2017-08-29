function love.load()
	window={}
	window.w=800
	window.h=650
	game={}
	game.w=4000
	game.h=650
  love.window.setTitle("Crabventure")
  love.window.setMode( window.w, window.h)

  imgs={}
  imgs.crabBod=love.graphics.newImage("crabBod.png")
  imgs.crabRArm=love.graphics.newImage("crabArm.png")
  imgs.crabLArm=love.graphics.newImage("crabArm2.png")
	love.physics.setMeter(64)
	world=love.physics.newWorld(0,9.8*64,true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  text=""
	persisting = 0

  crab={}
  crab.grounded=false;

  crab.body={}
  crab.body.b=love.physics.newBody(world,400,200,"dynamic")
  crab.body.b:setMass(12)
  crab.body.s=love.physics.newRectangleShape(100, 50)
  crab.body.f=love.physics.newFixture(crab.body.b,crab.body.s)
  crab.body.f:setRestitution(0.9)
  crab.body.f:setUserData("crab")

  crab.arms={}
  crab.arms.l={}
  crab.arms.l.b=love.physics.newBody(world,470,180,"dynamic")
  crab.arms.l.b:setMass(6)
  crab.arms.l.s=love.physics.newRectangleShape(90, 25)
  crab.arms.l.f=love.physics.newFixture(crab.arms.l.b, crab.arms.l.s)
  crab.arms.l.f:setRestitution(0.4)
  crab.arms.l.f:setUserData("crab.arms.l")

  crab.arms.l.joint=love.physics.newRevoluteJoint(crab.body.b,crab.arms.l.b,450,180,false)
  crab.arms.l.joint:setLimits(-math.pi/3.3,-math.pi/4.6)
  crab.arms.l.joint:setLimitsEnabled(true)

  crab.arms.r={}
  crab.arms.r.b=love.physics.newBody(world,330,180,"dynamic")
  crab.arms.r.b:setMass(6)
  crab.arms.r.s=love.physics.newRectangleShape(90, 25)
  crab.arms.r.f=love.physics.newFixture(crab.arms.r.b, crab.arms.r.s)
  crab.arms.r.f:setRestitution(0.4)
  crab.arms.r.f:setUserData("crab.arms.r")

  crab.arms.r.joint=love.physics.newRevoluteJoint(crab.body.b,crab.arms.r.b,350,180,false)
  crab.arms.r.joint:setLimits(math.pi/4.6,math.pi/3.3)
  crab.arms.r.joint:setLimitsEnabled(true)

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
  --love.graphics.polygon("line",crab.arms.l.b:getWorldPoints(crab.arms.l.s:getPoints()))
  love.graphics.draw(imgs.crabLArm,crab.arms.l.b:getX(),crab.arms.l.b:getY(),crab.arms.l.b:getAngle(),1,1,imgs.crabLArm:getWidth()/2,imgs.crabLArm:getHeight()/2)
  --love.graphics.polygon("line",crab.arms.r.b:getWorldPoints(crab.arms.r.s:getPoints()))
  love.graphics.draw(imgs.crabRArm,crab.arms.r.b:getX(),crab.arms.r.b:getY(),crab.arms.r.b:getAngle(),1,1,imgs.crabRArm:getWidth()/2,imgs.crabRArm:getHeight()/2)
  --love.graphics.polygon("line",crab.body.b:getWorldPoints(crab.body.s:getPoints()))
  love.graphics.draw(imgs.crabBod,crab.body.b:getX()-100/2,crab.body.b:getY()-50/2,crab.body.b:getAngle())
  love.graphics.polygon("line",ground.b:getWorldPoints(ground.s:getPoints()))
  love.graphics.print(text,10,10)
end


function str(st)
  return string.format("%s",st)
end

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
