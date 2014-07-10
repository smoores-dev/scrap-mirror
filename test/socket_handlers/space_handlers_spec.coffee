chai = require 'chai'
expect = chai.expect
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai

pg = require '../../server/adapters/db'
db = require '../../models/'

SpaceHandlers = require '../../server/socket_handlers/space_handlers'

describe 'SpaceHandlers', ->

  describe '#newSpace', ->

    before (done) =>
      @socket =
        emit: sinon.stub()
      db.sequelize.sync({ force: true }).complete (err) ->
        return done err if err?
        done()

    it 'should create a new Space in the db with the given name', (done) =>
      data =
        name: 'test_space'
      SpaceHandlers.newSpace null, @socket, data, (err, res) =>
        return done err if err?
        query = 'SELECT * FROM "Spaces" WHERE name=$1'
        pg.query query, [data.name], (err, res) =>
          return done err if err?
          expect(res.rows[0]).to.be.truthy
          expect(res.rows[0].name).to.eql data.name
          expect(@socket.emit).to.have.been.calledOnce
          done()

  describe '#reorderSpace', ->

    before (done) =>
      @emit = sinon.stub()
      @sio =
        to: (id) =>
          emit: @emit
      db.sequelize.sync({ force: true }).complete (err) =>
        return done err if err?
        db.Space.create(name: 'space1').complete (err, @space) =>
          return done err if err?
          db.Column.create( SpaceId: @space.id ).complete (err, @column1) =>
            return done err if err?
            db.Column.create( SpaceId: @space.id ).complete (err, @column2) =>
              return done err if err?
              @space.updateAttributes(
                columnSorting: [@column1.id, @column2.id]
              ).complete (err, space) ->
                return done err if err?
                done()

    it 'should reorder the columnSorting in the given space', (done) =>
      data =
        spaceId : @space.id
        columnSorting : [@column2.id, @column1.id]
      SpaceHandlers.reorderSpace @sio, null, data, (err, res) =>
        return done err if err?
        query = 'SELECT * FROM "Spaces" WHERE id=$1'
        pg.query query, [@space.id], (err, res) =>
          expect(res.rows[0]).to.be.truthy
          expect(res.rows[0].columnSorting).to.eql data.columnSorting
          expect(@emit).to.have.been.calledOnce
          done()
