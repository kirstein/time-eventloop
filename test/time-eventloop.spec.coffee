mod   = require("#{process.cwd()}/src/time-eventloop")
util  = require('util')
sinon = require 'sinon'
clock = null

describe 'time-eventloop', ->
  beforeEach -> clock = sinon.useFakeTimers 'setInterval','clearInterval'
  afterEach -> clock.restore()

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

  #describe 'time tracking', ->
    #it 'should not pipe if there is no delay', sinon.test ->
      #@stub util, 'log'
      #mod.start interval: 400
      #clock.tick 800
      #util.log.called.should.not.be.ok
