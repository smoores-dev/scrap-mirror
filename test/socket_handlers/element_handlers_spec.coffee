chai = require 'chai'
expect = chai.expect
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai

pg = require '../../server/adapters/db'
db = require '../../models/'

ElementHandlers = require '../../server/socket_handlers/element_handlers'

describe 'ElementHandlers', ->

  describe '#newElement', ->

    before (done) =>
      @emit = sinon.stub()
      @sio =
        to: (id) =>
          emit: @emit
      db.sequelize.sync({ force: true }).complete (err) =>
        return done err if err?
        db.Column.create(SpaceId: 1).complete (err, @column) =>
          return done err if err?
          done()

    it 'should create a new Element in the db with the given name', (done) =>
      data =
        spaceId: 1
        columnId: @column.id
        contentType: "text"
        content: "content"
      ElementHandlers.newElement @sio, null, data, (err, res) =>
        return done err if err?
        query = 'SELECT * FROM "Elements" WHERE "ColumnId"=$1'
        pg.query query, [data.columnId], (err, res) =>
          return done err if err?
          element = res.rows[0]
          expect(element).to.be.ok
          expect(element.id).to.be.a "number"
          expect(element.contentType).to.eql data.contentType
          expect(element.content).to.eql data.content

          expect(@emit).to.have.been.calledOnce
          done()

  describe '#removeElement', ->

    beforeEach (done) =>
      @emit = sinon.stub()
      @sio =
        to: (id) =>
          emit: @emit
      # create a column with one element
      db.sequelize.sync({ force: true }).complete (err) =>
        db.Column.create( SpaceId: 1 ).complete (err, @column) =>
          return done err if err?
          db.Element.create( ColumnId: @column.id, contentType: "text", content: "content" ).complete (err, @element) =>
            return done err if err?
            # associate the element with the column
            @column.updateAttributes(
                elementSorting: [@element.id]
              ).complete (err, space) ->
                return done err if err?
                done()

    it 'should remove the specified Element', (done) =>
      data =
        spaceId: 1
        elementId: @element.id
      ElementHandlers.removeElement @sio, null, data, (err, res) =>
        return done err if err?
        query = 'SELECT * FROM "Elements" WHERE id=$1'
        pg.query query, [@element.id], (err, res) =>
          return done err if err?
          element = res.rows[0]
          expect(element).to.be.not.ok

          expect(@emit).to.have.been.calledOnce
          done()

    context 'there was only one element in the column', =>

      it 'should remove the column', (done) =>
        data =
          spaceId: 1
          elementId: @element.id
        ElementHandlers.removeElement @sio, null, data, (err, res) =>
          return done err if err?
          query = 'SELECT * FROM "Columns" WHERE id=$1'
          pg.query query, [@column.id], (err, res) =>
            return done err if err?
            column = res.rows[0]
            expect(column).to.be.not.ok

            expect(@emit).to.have.been.calledOnce
            done()

    context 'there were multiple elements in the column', =>

      it 'should remove the column', (done) =>
        data =
          spaceId: 1
          elementId: @element.id

        # add another element
        db.Element.create( ColumnId: @column.id, contentType: "text", content: "content" ).complete (err, @element2) =>
            return done err if err?
            # associate the element with the column
            @column.updateAttributes(
                elementSorting: [@element.id, @element2.id]
              ).complete (err, space) ->
                return done err if err?
        # remove first element       
        ElementHandlers.removeElement @sio, null, data, (err, res) =>
          return done err if err?
          query = 'SELECT * FROM "Columns" WHERE id=$1'
          pg.query query, [@column.id], (err, res) =>
            return done err if err?
            column = res.rows[0]
            expect(column).to.be.ok

            expect(@emit).to.have.been.calledOnce
            done()


  describe.skip '#moveElement', ->

    before (done) =>
      @emit = sinon.stub()
      @sio =
        to: (id) =>
          emit: @emit
      # make two columns and one element so it can be transferred
      db.sequelize.sync({ force: true }).complete (err) =>
        return done err if err?
        db.Column.create(SpaceId: 1).complete (err, @column1) =>
          return done err if err?
          db.Column.create( SpaceId: 1 ).complete (err, @column2) =>
            return done err if err?
            db.Element.create( ColumnId: @column1.id, contentType: "text", content: "content" ).complete (err, @element) =>
              return done err if err?
              done()

    it 'should move the element to another column', (done) =>
      data =
        spaceId: 1
        oldColumnId: @column1.id
        newColumnId: @column2.id
        newIndex: 1
        elementId: @element.id
      ElementHandlers.moveElement @sio, null, data, (err, res) =>
        return done err if err?

        # check that the first one doesn't have the element
        query = 'SELECT * FROM "Columns" WHERE id=$1'
        pg.query query, [@column1.id], (err, res) =>
          return done err if err?
          column = res.rows[0]
          expect(column).to.be.ok
          expect(column.elementSorting).to.eql []

          # check that the second one has the element
          query = 'SELECT * FROM "Columns" WHERE id=$1'
          pg.query query, [@column2.id], (err, res) =>
            return done err if err?
            column = res.rows[0]
            expect(column).to.be.ok
            expect(column.elementSorting).to.eql [@element.id]
            expect(@emit).to.have.been.calledOnce
            done()
