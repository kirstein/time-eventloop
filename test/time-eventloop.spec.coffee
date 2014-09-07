mod   = require "#{process.cwd()}/src/time-eventloop"
util  = require 'util'
sinon = require 'sinon'
range = require 'data-range'

describe 'time-eventloop', ->
  it 'should exist', -> mod.should.be.ok

  describe 'api', ->

    # Silence the log for each test
    # Hacky way
    log = null
    beforeEach ->
      log = util.log
      util.log = ->
    afterEach -> util.log = log

    describe '#start', ->

      it 'should exist', -> mod.start.should.be.ok
      it 'should be chainable', sinon.test ->
        @stub global, 'setTimeout'
        mod.start().should.be.eql mod

      it 'should set the range with colors', sinon.test ->
        @stub range, 'set'
        mod.start()
        range.set.called.should.be.ok

      it 'should start interval', sinon.test ->
        @stub global, 'setTimeout'
        mod.start()
        global.setTimeout.called.should.be.ok

      it 'should stop the previous interval', sinon.test ->
        @spy mod, 'stop'
        mod.start()
        mod.stop.called.should.be.ok

    describe '#stop', ->
      it 'should exist', -> mod.stop.should.be.ok
      it 'should be chainable', -> mod.stop().should.be.eql mod
      it 'should stop the interval', sinon.test ->
        @stub global, 'clearTimeout'
        mod.stop()
        global.clearTimeout.called.should.be.ok

      it 'should clear the range', sinon.test ->
        @stub range, 'clear'
        mod.stop()
        range.clear.called.should.be.ok

  describe 'time tracking', ->
    it 'should pipe to log if there is delay', sinon.test ->
      callCount = 0
      @stub util, 'log'
      @stub global, 'setTimeout', (cb) -> cb() if ++callCount < 2
      dateStub = @stub global.Date, 'now'
      dateStub.onFirstCall().returns 2
      dateStub.onSecondCall().returns 200
      mod.start()
      util.log.called.should.be.ok

    it 'should not pipe to log if there is no delay', sinon.test ->
      callCount = 0
      @stub util, 'log'
      @stub global, 'setTimeout', (cb) -> cb() if ++callCount < 2
      dateStub = @stub global.Date, 'now'
      dateStub.onFirstCall().returns 2
      dateStub.onSecondCall().returns 2
      mod.start()
      util.log.called.should.not.be.ok

    it 'should pipe to log if timeout time is in not factor range', sinon.test ->
      callCount = 0
      @stub util, 'log'
      @stub global, 'setTimeout', (cb) -> cb() if ++callCount < 2
      dateStub = @stub global.Date, 'now'
      dateStub.onFirstCall().returns 2
      dateStub.onSecondCall().returns 4
      mod.start factor: .5, interval: .9
      util.log.called.should.be.ok

    it 'should not pipe to log if timeout time is in factor range', sinon.test ->
      callCount = 0
      @stub util, 'log'
      @stub global, 'setTimeout', (cb) -> cb() if ++callCount < 2
      dateStub = @stub global.Date, 'now'
      dateStub.onFirstCall().returns 2
      dateStub.onSecondCall().returns 4
      mod.start factor: .5, interval: 1
      util.log.called.should.not.be.ok
