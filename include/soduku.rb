class Soduku
  private
    class Cell
        attr_accessor :x, :y, :constraint
        def initialize
            @x, @y, @constraint = 0, 0, Array.new
        end
    end
  public
    def initialize
        @grid = Array.new(9) { Array.new(9, 0) }
        @valid = Array.new(9) { Array.new(9, 0) }
        @cell = Array.new(81) { Cell.new }
        (0..8).each do |x|
            (0..8).each do |y|
                @cell[x + y * 9].x = x
                @cell[x + y * 9].y = y
            end
        end
    end
    def init(data)
        data.gsub!(/ /, "")
        raise unless data.length == 81
        (0..8).each do |y|
            (0..8).each do |x|
                num = data[x + y * 9].to_i
                @grid[x][y] = 0
                @grid[x][y] = num if (1..9).include?(num)
            end
        end
        @cell.each { |cell| cell.constraint.clear }
    end
    def [](index)
        (index < 0 or index > 8) ? nil : @grid[index]
    end
    def solution(x, y)
        mark
        sweep
        @valid[x][y]
    end
  private
    def cell(x, y)
        @cell[x + y * 9]
    end
    def cube(x, y, i)
        @grid[(x / 3) * 3 + i % 3][(y / 3) * 3 + i / 3]
    end
    def each_row
        (0..8).each do |y|
            row = (0..8).inject(Array.new) { |row, x| row << cell(x, y) }
            yield row
        end
    end
    def each_col
        (0..8).each do |x|
            col = (0..8).inject(Array.new) { |col, y| col << cell(x, y) }
            yield col
        end
    end
    def each_box
        (0..8).each do |b|
            x = (b % 3) * 3
            y = (b / 3) * 3
            box = (0..8).inject(Array.new) do |box, i|
                box << cell(x + i % 3, y + i / 3)
            end
            yield box            
        end
    end
    def mark
        (0..8).each do |y|
            (0..8).each do |x|
                cell(x, y).constraint.clear
                next if @grid[x][y] != 0
                cell(x, y).constraint << (1..9).to_a
                cell(x, y).constraint.flatten!
                (0..8).each do |i|
                    cell(x, y).constraint.delete(@grid[x][i])
                    cell(x, y).constraint.delete(@grid[i][y])
                    cell(x, y).constraint.delete(cube(x, y, i))
                end
            end
        end
        (0..8).each do |y|
            (0..8).each do |x|
                @valid[x][y] = 0
                if cell(x, y).constraint.length == 1
                    @valid[x][y] = cell(x, y).constraint[0]
                end
            end
        end
    end
    def sweep
        each_row { |row| collect(row) }
        each_col { |col| collect(col) }
        each_box { |box| collect(box) }
    end
    def collect(cells)
        cross = Array.new
        solve = Array.new
        cells.each do |cell|
            cell.constraint.each do |num|
                if solve.include?(num)
                    solve.delete(num)
                    cross << num
                end
                solve << num unless cross.include?(num)
            end
        end
        cells.each do |cell|
            solve.each do |num|
                next if cell.constraint.length <= 1
                next unless cell.constraint.include?(num)
                @valid[cell.x][cell.y] = num
            end
        end
    end
end
