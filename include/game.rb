require 'observer'
require 'generic_observer'
require 'soduku'

class Game
    include Observable
    include GenericObserver
    def initialize
        @soduku = Soduku.new
        @levels = Hash.new
        @flags = Array.new(9) { Array.new(9, 0) }
        @bombs = Array.new(9) { Array.new(9, false) }
        @flag = 0
    end
  protected
    def newGame(level, game)
        @soduku.init(@levels[level][game])
        (0..8).each do |x|
            (0..8).each do |y|
                if @soduku[x][y] != 0
                    changed ; notify_observers(:setNumber, x, y, @soduku[x][y])
                else
                    changed ; notify_observers(:setBlank, x, y)
                end
            end
        end
    end
    def loadLevels
        Dir.entries("levels").each do |name|
            path = File.join("levels", name)
            next unless File.file?(path)
            @levels[name] = loadFile(path)
            changed ; notify_observers(:addLevel, name, @levels[name].length)
        end
    end
    def loadFile(path)
        data = nil
        File.open(path, "rb") { |file| data = file.read }
        data.gsub!(/./m) { |char| "123456789.".include?(char) ? char : "" }
        raise "Invalid level: '#{path}'" unless data.length % 81 == 0
        level = Array.new
        while data.length > 0
            level << data[0..80]
            data = data[81..-1]
        end
        level
    end
    def selectCell(x, y)
        if @soduku[x][y] > 0
            flagCell(x, y)
            return
        end
        if @flags[x][y] > 0
            clearBoard(true)
            return
        end
        num = @soduku.solution(x, y)
        if num == 0
            @bombs[x][y] = true
            changed ; notify_observers(:setBomb, x, y)
        else
            @soduku[x][y] = num
            changed ; notify_observers(:setNumber, x, y, num)
            clearBoard
        end
    end
    def flagAll(flag)
        if @flag == flag
            clearBoard
            return
        end
        (0..8).each do |x|
            (0..8).each do |y|
                flagCell(x, y) if @soduku[x][y] == flag
            end
        end
    end
  private
    def clearBoard(bomb = false)
        @flag = 0
        (0..8).each do |x|
            (0..8).each do |y|
                @flags[x][y] = 0
                next if @soduku[x][y] != 0
                next if bomb and @bombs[x][y]
                @bombs[x][y] = false
                changed ; notify_observers(:setBlank, x, y)
            end
        end
    end
    def flagCell(x, y)
        clearBoard(true) if @flag != @soduku[x][y]
        @flag = @soduku[x][y]
        (0..8).each do |i|
            setFlag(x, i) if @soduku[x][i] == 0
            setFlag(i, y) if @soduku[i][y] == 0
            a = (x / 3) * 3 + i % 3
            b = (y / 3) * 3 + i / 3
            setFlag(a, b) if @soduku[a][b] == 0
        end
    end
    def setFlag(x, y)
        return if @bombs[x][y]
        @flags[x][y] = @flag
        changed ; notify_observers(:setFlag, x, y)
    end
end
