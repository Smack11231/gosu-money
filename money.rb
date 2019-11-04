require 'gosu'

class Tutorial < Gosu::Window
    def initialize
        super 640, 480
        self.caption = "Tutorial Game"
  
        @background_image = Gosu::Image.new("media/download.jpg", :tileable => true)
  
        @player = Player.new
        @player.warp(320, 240)
        @stars = Array.new
        @font = Gosu::Font.new(20)
    end
  
    def update
        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
            @player.turn_left
        end
        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
            @player.turn_right
        end
        if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
            @player.accelerate
        end
        @player.move
        @player.collect_stars(@stars)

        if @stars.size < 1000 and rand(100) < 1 and 
            @stars.push(Star.new)
        end
    end
  
    def draw
        @player.draw
        @background_image.draw(0, 0, 0)
        @stars.each { |star| 
        star.draw
        star.move
        }
        @font.draw_text("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    end
  
    def button_down(id)
        if id == Gosu::KB_ESCAPE
            close
        else
            super
        end
    end
end

module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
end

class Player
    attr_reader :score

    def initialize

        @image = Gosu::Image.new("media/starfighter.bmp")
        @beep = Gosu::Sample.new("media/beep.wav")
        @x = @y = @vel_x = @vel_y = @angle = 0.0
        @score = 0
    end
    
    def warp (x, y)
        @x, @y = x, y
    end

    def turn_left
        @x -= 8
    end

    def turn_right
        @x += 8
    end

    def accelerate
        @vel_x += Gosu.offset_x(@angle, 1)
    end

    def move
        @x += @vel_x
       # @y = @vel_y
        @x %= 640
        @y = 450

        @vel_x *= 0.95
        #@vel_y *= 0.0000005
    end

    def draw
        @image.draw_rot(@x, @y, 1, @angle)
    end

    def score
        @score
    end

    def collect_stars(stars)
        stars.reject! do |star|
            if Gosu.distance(@x, @y, star.x, star.y) < 35
                @score += 10
                @beep.play
                true
            else
                false
            end
        end
    end
end

class Star
    attr_reader :x, :y

    def initialize
        @image = Gosu::Image.new("media/money.png")
        @x = rand * 640
        @y = 0.0
    end

    def move
        @y += 1
    end
    def draw
        @image.draw(@x, @y, ZOrder::STARS)
    end
end

Tutorial.new.show