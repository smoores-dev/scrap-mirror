chai = require 'chai'
expect = chai.expect
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai

pg = require '../../server/adapters/db'
db = require '../../models/'

ColumnHandlers = require '../../server/socket_handlers/column_handlers'

describe 'ColumnHandlers', ->

  describe '#newColumn', ->

    before (done) =>
      @emit = sinon.stub()
      @sio =
        to: (id) =>
          emit: @emit
      db.sequelize.sync({ force: true }).complete (err) =>
        return done err if err?
        db.Space.create(name: 'Test').complete (err, @space) =>
          return done err if err?
          done()

    it 'should create a new Column in the db with the given name', (done) =>
      data =
        spaceId: @space.id
        contentType: "text"
        content: "content"
      ColumnHandlers.newColumn @sio, null, data, (err, res) =>
        return done err if err?
        query = 'SELECT * FROM "Columns" WHERE "SpaceId"=$1'
        pg.query query, [data.spaceId], (err, res) =>
          return done err if err?
          # check the column
          column = res.rows[0]
          expect(column).to.be.ok
          expect(column.id).to.be.a "number"
          expect(column.SpaceId).to.eql data.spaceId

          # also expect an element to have been created
          query = 'SELECT * FROM "Elements" WHERE "ColumnId"=$1'
          pg.query query, [column.id], (err, res) =>
            return done err if err?
            element = res.rows[0]
            expect(element).to.be.ok
            expect(element.id).to.be.a "number"
            expect(element.contentType).to.eql data.contentType
            expect(element.content).to.eql data.content

            expect(@emit).to.have.been.calledOnce
            done()

  describe '#reorderColumn', ->

    before (done) =>
      @emit = sinon.stub()
      @sio =
        to: (id) =>
          emit: @emit
      # make a column with two elements so they can be reordered
      db.sequelize.sync({ force: true }).complete (err) =>
        return done err if err?
        db.Column.create(SpaceId: 1).complete (err, @column) =>
          return done err if err?
          db.Element.create( ColumnId: @column.id, contentType: "text", content: "content" ).complete (err, @element1) =>
            return done err if err?
            db.Element.create( ColumnId: @column.id, contentType: "text", content: "content" ).complete (err, @element2) =>
              return done err if err?
              @column.updateAttributes(
                elementSorting: [@element1.id, @element2.id]
              ).complete (err, space) ->
                return done err if err?
                done()

    it 'should reorder the elementSorting in the given column', (done) =>
      data =
        spaceId: 1
        columnId: @column.id
        elementSorting : [@element2.id, @element2.id]
      ColumnHandlers.reorderColumn @sio, null, data, (err, res) =>
        return done err if err?
        query = 'SELECT * FROM "Columns" WHERE id=$1'
        pg.query query, [@column.id], (err, res) =>
          return done err if err?
          column = res.rows[0]
          expect(column).to.be.ok
          expect(column.elementSorting).to.eql data.elementSorting
          expect(@emit).to.have.been.calledOnce
          done()
