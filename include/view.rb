require 'fox16'
require 'observer'
require 'generic_observer'

def FXRGB(*args)
  Fox::FXRGB(*args)
end

class View < Fox::FXMainWindow
    include Observable
    include GenericObserver
    def initialize(app)
        super(app, "Soduku Sweeper", nil, nil, Fox::DECOR_ALL, 0, 0, 640, 480)
        @cell = Array.new
        @icon = Array.new
        loadIcons(app)
        main = Fox::FXVerticalFrame.new(self, Fox::LAYOUT_FILL_X |
                                              Fox::LAYOUT_FILL_Y)
        @layout = Fox::LAYOUT_CENTER_X | Fox::LAYOUT_CENTER_Y
        body = Fox::FXMatrix.new(main, 2, Fox::MATRIX_BY_COLUMNS |
                                          Fox::FRAME_GROOVE | @layout)
        Fox::FXLabel.new(body, "Level:")
        @levels = Fox::FXComboBox.new(body, 20, nil, 0, Fox::LAYOUT_FILL_X)
        @levels.editable = false
        @levels.connect(Fox::SEL_COMMAND) { selectLevel }
        Fox::FXLabel.new(body, "Game:")
        @games = Fox::FXSpinner.new(body, 2)
        @games.connect(Fox::SEL_COMMAND) { selectGame }
        Fox::FXLabel.new(body, "Next:")
        Fox::FXLabel.new(body, "")
        Fox::FXLabel.new(body, "Score:")
        Fox::FXLabel.new(body, "")
        Fox::FXLabel.new(body, "Time:")
        Fox::FXLabel.new(body, "")
        Fox::FXLabel.new(body, "Cleared:")
        grid = Fox::FXMatrix.new(body, 2, Fox::MATRIX_BY_ROWS | @layout |
                                          Fox::FRAME_LINE)
        @display = Array.new
        @count = Array.new
        (1..9).each do |a|
            @display[a] = Fox::FXButton.new(grid, "", nil, nil, 0,
                                            Fox::BUTTON_NORMAL | @layout)
            @count[a] = Fox::FXLabel.new(grid, "0")
            @display[a].connect(Fox::SEL_COMMAND) do
                changed ; notify_observers(:flagAll, a)
            end
        end
        game = Fox::FXMatrix.new(main, 3, Fox::MATRIX_BY_COLUMNS |
                                          Fox::FRAME_RAISED |
                                          @layout, *Array.new(10, 1))
        @layout |= Fox::LAYOUT_FILL_ROW | Fox::LAYOUT_FILL_COLUMN
        (0..8).each { |a| newGrid(game, a) }
    end
    def create
        super
        show(Fox::PLACEMENT_SCREEN)
        changed ; notify_observers(:loadLevels)
#       (1..9).each { |a| @display[a].icon = @icon[a] }
#       selectLevel
    end
  protected
    def addLevel(name, size)
        @levels.appendItem(name, size)
        @levels.numVisible = @levels.numItems
    end
    def setBlank(x, y)
        cell(x, y).icon = @icon[0]
    end
    def setNumber(x, y, num)
        cell(x, y).icon = @icon[num]
        @count[num].text = (@count[num].text.to_i + 1).to_s
    end
    def setFlag(x, y)
        cell(x, y).icon = @icon[10]
    end
    def setBomb(x, y)
        cell(x, y).icon = @icon[11]
    end
  private
    def setLabel(x, y, text)
        cell(x, y).text = text
    end
    def newGrid(game, a)
        grid = Fox::FXMatrix.new(game, 3, Fox::MATRIX_BY_COLUMNS |
                                          Fox::FRAME_SUNKEN |
                                          @layout, *Array.new(10, 0))
        (0..8).each { |b| newCell(grid, a, b) }
    end
    def newCell(grid, a, b)
        cell = Fox::FXButton.new(grid, "", nil, nil, 0, Fox::BUTTON_NORMAL |
                                                        @layout)
        x = b % 3 + (a % 3) * 3
        y = b / 3 + (a / 3) * 3
        cell.connect(Fox::SEL_COMMAND) { click(x, y) }
        @cell << cell
    end
    def click(x, y)
        changed ; notify_observers(:selectCell, x, y)
    end
    def cell(x, y)
        @cell[(x / 3) * 9 + x % 3 + y * 3 + (y / 3) * 18]
    end
    def loadIcons(app)
        @icon << loadIcon(app, "blank")
        @icon << loadIcon(app, "one")
        @icon << loadIcon(app, "two")
        @icon << loadIcon(app, "three")
        @icon << loadIcon(app, "four")
        @icon << loadIcon(app, "five")
        @icon << loadIcon(app, "six")
        @icon << loadIcon(app, "seven")
        @icon << loadIcon(app, "eight")
        @icon << loadIcon(app, "nine")
        @icon << loadIcon(app, "flag")
        @icon << loadIcon(app, "bomb")
    end
    def loadIcon(app, name)
        path = File.join("images", "#{name}.bmp")
        icon = nil
        File.open(path, "rb") do |file|
            icon = Fox::FXBMPIcon.new(app, file.read)
            icon.create
        end
        icon
    end
    def selectLevel
        puts @levels
        @games.range = (0...@levels.getItemData(@levels.currentItem))
        selectGame
    end
    def selectGame
        (1..9).each { |num| @count[num].text = "0" }
        changed ; notify_observers(:newGame, @levels.text, @games.value)
    end
end
