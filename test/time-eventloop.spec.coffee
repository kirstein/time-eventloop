mod   = require("#{process.cwd()}/src/time-eventloop").start()
sinon = require 'sinon'
clock = null

i = 0
while i < 200
  i++

describe 'time-eventloop', ->
  #beforeEach -> clock = sinon.useFakeTimers()
  #afterEach -> clock.restore()

  it 'should exist', -> mod.should.be.ok

  describe '#start', ->
    it 'should exist', -> mod.start.should.be.ok
    it 'should be chainable', -> mod.start().should.be.eql mod
    it 'should start interval', sinon.test ->
      @stub global, 'setInterval'
      mod.start()
      global.setInterval.called.should.be.ok

  describe '#stop', ->
    it 'should exist', -> mod.stop.should.be.ok
    it 'should be chainable', -> mod.stop().should.be.eql mod
    it 'should stop the interval', sinon.test ->
      @stub global, 'clearInterval'
      mod.stop()
      global.clearInterval.called.should.be.ok

