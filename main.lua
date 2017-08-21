function love.load()
	window={}
	window.w=800
	window.h=650
	game={}
	game.w=4000
	game.h=650

	world=love.physics.newWorld(0,200,true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  text=""
	persisting = 0

  crab={}
  crab.b=love.physics.newBody(world,400,200,"dynamic")
  crab.b:setMass(10)
  crab.s=love.physics.newRectangleShape(100, 50)
  crab.f=love.physics.newFixture(crab.b, crab.s)
  crab.f:setRestitution(0.1)
  crab.f:setUserData("crab")

  crabLArm={}
  crabLArm.b=love.physics.newBody(world,470,180,"dynamic")
  crabLArm.b:setMass(10)
  crabLArm.s=love.physics.newRectangleShape(90, 25)
  crabLArm.f=love.physics.newFixture(crabLArm.b, crabLArm.s)
  crabLArm.f:setRestitution(0.1)
  crabLArm.f:setUserData("crabLArm")

  crabLArmJoint=love.physics.newRevoluteJoint(crab.b,crabLArm.b,450,180,false)
  crabLArmJoint:setLimits(-math.pi/3.3,-math.pi/4.6)
  crabLArmJoint:setLimitsEnabled(true)

  crabRArm={}
  crabRArm.b=love.physics.newBody(world,330,180,"dynamic")
  crabRArm.b:setMass(10)
  crabRArm.s=love.physics.newRectangleShape(90, 25)
  crabRArm.f=love.physics.newFixture(crabRArm.b, crabRArm.s)
  crabRArm.f:setRestitution(0.1)
  crabRArm.f:setUserData("crabRArm")

  crabRArmJoint=love.physics.newRevoluteJoint(crab.b,crabRArm.b,350,180,false)
  crabRArmJoint:setLimits(math.pi/4.6,math.pi/3.3)
  crabRArmJoint:setLimitsEnabled(true)

  ground={}
  ground.b=love.physics.newBody(world,0,600,"static")
  ground.s=love.physics.newRectangleShape(1500,50)
  ground.f=love.physics.newFixture(ground.b,ground.s)
  ground.f:setUserData("ground")
end

function love.update(dt)
  world:update(dt)

  x,y=crab.b:getLinearVelocity()
		if love.keyboard.isDown("d") then
			if x<600 then
				crab.b:applyForce(3000,0)
			end
		elseif love.keyboard.isDown("a") then
			if x>-600 then
				crab.b:applyForce(-3000,0)
			end
		end
		if love.keyboard.isDown("w") then
			if y>-300 then
				crab.b:applyForce(0,-3000)
			end
		elseif love.keyboard.isDown("s") then
			if y<300 then
				crab.b:applyForce(0,3000)
			end
		end

end

function love.draw()
  love.graphics.polygon("line",crab.b:getWorldPoints(crab.s:getPoints()))
  love.graphics.polygon("line",crabLArm.b:getWorldPoints(crabLArm.s:getPoints()))
  love.graphics.polygon("line",crabRArm.b:getWorldPoints(crabRArm.s:getPoints()))
  love.graphics.polygon("line",ground.b:getWorldPoints(ground.s:getPoints()))
end

function beginContact(a, b, coll)

end

function endContact(a, b, coll)

end

function preSolve(a, b, coll)

end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end
